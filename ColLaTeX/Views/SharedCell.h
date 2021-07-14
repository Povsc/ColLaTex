//
//  SharedCell.h
//  ColLaTeX
//
//  Created by felipeccm on 7/14/21.
//

#import <UIKit/UIKit.h>
@import Parse;
#import "Document.h"

NS_ASSUME_NONNULL_BEGIN

@interface SharedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ownerLabel;
@property (weak, nonatomic) IBOutlet UILabel *modifiedLabel;
@property (strong, nonatomic) Document *document;

@end

NS_ASSUME_NONNULL_END
