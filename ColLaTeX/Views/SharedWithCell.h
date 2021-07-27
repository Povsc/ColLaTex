//
//  SharedWithCell.h
//  ColLaTeX
//
//  Created by felipeccm on 7/27/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SharedWithCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITableView *userTableView;

@end

NS_ASSUME_NONNULL_END
