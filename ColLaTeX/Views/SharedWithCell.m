//
//  SharedWithCell.m
//  ColLaTeX
//
//  Created by felipeccm on 7/27/21.
//

#import "SharedWithCell.h"
#import "UserCell.h"

@implementation SharedWithCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.usernameField.delegate = self;
    self.userTableView.delegate = self;
    self.userTableView.dataSource = self;
}

- (bool)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(self.timer != nil){
        [self.timer invalidate];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(filter) userInfo:nil repeats:false];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];

    return true;
}

- (void)filter{
    if (self.usernameField.text.length > 0){
        PFQuery *userQuery = [PFUser query];
        [userQuery whereKey:@"username" containsString:self.usernameField.text];
        userQuery.limit = 5;
        
        [userQuery findObjectsInBackgroundWithBlock:^(NSArray <PFUser *> *users, NSError * _Nullable error){
            if (error){
                NSLog(@"Error: %@", error.localizedDescription);
            }
            else {
                self.arrayOfUsers = users;
                [self.userTableView reloadData];
            }
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    
    // Set labels and parameters
    cell.user = self.arrayOfUsers[indexPath.row];
    cell.nameLabel.text = cell.user.username;
    
    // Configure Profile pic
    cell.imageView.file = [cell.user objectForKey:@"profilePicture"];
    [cell.imageView loadInBackground];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfUsers.count;
}

- (IBAction)didBeginEditing:(id)sender {
    self.bottomConstraint.constant += self.userTableView.frame.size.height;
    CGRect frame = self.frame;
    frame.size.height += self.userTableView.frame.size.height;
    self.frame = frame;
    [self updateConstraints];
    [self updateConstraints];
    [self.superview updateConstraints];
    [self.userTableView setHidden:false];
    [self.userTableView didMoveToSuperview];
}

- (IBAction)didEndEditing:(id)sender {
    self.bottomConstraint.constant -= self.userTableView.frame.size.height;
    CGRect frame = self.frame;
    frame.size.height += self.userTableView.frame.size.height;
    self.frame = frame;
    [self updateConstraints];
    [self reloadInputViews];
    [self.superview updateConstraints];
    [self.superview reloadInputViews];
    [self.userTableView setHidden:true];
}

@end
