//
//  ImageHelper.h
//  ColLaTeX
//
//  Created by felipeccm on 7/13/21.
//

#import <Foundation/Foundation.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface ImageHelper : NSObject

+ (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size;

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image;

@end

NS_ASSUME_NONNULL_END
