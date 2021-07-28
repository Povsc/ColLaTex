//
//  AddUserViewController.m
//  ColLaTeX
//
//  Created by felipeccm on 7/28/21.
//

#import "AddUserViewController.h"
@import Parse;
#import "UserCell.h"

@interface AddUserViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *smallerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSArray <PFUser *> *arrayOfUsers;

@end

@implementation AddUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Round corners of view
    self.smallerView.layer.cornerRadius = 15;
    self.smallerView.layer.masksToBounds = false;
    
    // Set delegates
    self.usernameField.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Start editing usernameField
    [self.usernameField becomeFirstResponder];
}

- (bool)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(self.timer != nil){
        [self.timer invalidate];
    }
    
    // Configure timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(filter) userInfo:nil repeats:false];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];

    return true;
}

- (void)filter{
    if (self.usernameField.text.length > 0){
        
        // Create new query
        PFQuery *userQuery = [PFUser query];
        [userQuery whereKey:@"username" containsString:self.usernameField.text];
        userQuery.limit = 5;
        
        // Search users
        [userQuery findObjectsInBackgroundWithBlock:^(NSArray <PFUser *> *users, NSError * _Nullable error){
            if (error){
                NSLog(@"Error: %@", error.localizedDescription);
            }
            else {
                self.arrayOfUsers = users;
                [self.tableView reloadData];
            }
        }];
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Add user to user array
    [self.delegate didAddUser:self.arrayOfUsers[indexPath.row]];
    
    // Dismiss view
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
