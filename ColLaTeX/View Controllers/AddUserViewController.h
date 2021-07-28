//
//  AddUserViewController.h
//  ColLaTeX
//
//  Created by felipeccm on 7/28/21.
//

#import <UIKit/UIKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@protocol AddUserViewControllerDelegate

- (void)didAddUser:(PFUser *)user;

@end

@interface AddUserViewController : UIViewController

@property (nonatomic, weak) id<AddUserViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
