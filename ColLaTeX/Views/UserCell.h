//
//  UserCell.h
//  ColLaTeX
//
//  Created by felipeccm on 7/27/21.
//

#import <UIKit/UIKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface UserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) PFUser *user;

@end

NS_ASSUME_NONNULL_END
