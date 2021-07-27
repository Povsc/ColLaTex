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
    //TODO: filter data
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}
@end
