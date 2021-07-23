//
//  AttachmentCell.h
//  ColLaTeX
//
//  Created by felipeccm on 7/23/21.
//

#import <UIKit/UIKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface AttachmentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *attachmentImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

NS_ASSUME_NONNULL_END
