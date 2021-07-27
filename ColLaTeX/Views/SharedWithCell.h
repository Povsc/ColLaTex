//
//  SharedWithCell.h
//  ColLaTeX
//
//  Created by felipeccm on 7/27/21.
//

#import <UIKit/UIKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface SharedWithCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITableView *userTableView;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) NSArray <PFUser *> *arrayOfUsers;

@end

NS_ASSUME_NONNULL_END
