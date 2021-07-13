//
//  MyDocumentCell.h
//  ColLaTeX
//
//  Created by felipeccm on 7/13/21.
//

#import <UIKit/UIKit.h>
#import "Document.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyDocumentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *modifiedLabel;
@property (strong, nonatomic) Document *document;

@end

NS_ASSUME_NONNULL_END
