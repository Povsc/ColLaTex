//
//  PDFViewController.h
//  ColLaTeX
//
//  Created by felipeccm on 7/14/21.
//

#import <UIKit/UIKit.h>
#import "Document.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContentViewController : UIViewController

@property (strong, nonatomic) Document *document;

@end

NS_ASSUME_NONNULL_END
