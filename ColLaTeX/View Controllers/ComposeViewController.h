//
//  ComposeViewController.h
//  ColLaTeX
//
//  Created by felipeccm on 7/14/21.
//

#import <UIKit/UIKit.h>
#import "Document.h"

NS_ASSUME_NONNULL_BEGIN

@interface ComposeViewController : UIViewController

@property (strong, nonatomic) Document *document;
@property (nonatomic) BOOL owner;

@end

NS_ASSUME_NONNULL_END
