//
//  PDFViewController.h
//  ColLaTeX
//
//  Created by felipeccm on 7/14/21.
//

#import <UIKit/UIKit.h>
#import "PDFKit/PDFKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface PDFViewController : UIViewController

@property (strong, nonatomic) PDFDocument *pdf;

@end

NS_ASSUME_NONNULL_END
