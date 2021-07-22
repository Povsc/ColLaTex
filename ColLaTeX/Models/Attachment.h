//
//  Attachment.h
//  ColLaTeX
//
//  Created by felipeccm on 7/22/21.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Attachment : PFObject

@property (nonatomic, strong) NSString *docID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) PFFileObject *picture;

+ (void) newAttachmentNamed: (NSString *)name withFile: (PFFileObject *) file withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
