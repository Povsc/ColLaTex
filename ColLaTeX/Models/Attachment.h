//
//  Attachment.h
//  ColLaTeX
//
//  Created by felipeccm on 7/22/21.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Document.h"

NS_ASSUME_NONNULL_BEGIN

@interface Attachment : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *docID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) PFFileObject *picture;
@property (nonatomic, strong) Document *document;

+ (void) newAttachmentNamed: (NSString *)name withFile:  (PFFileObject *) file withDocument: (Document *) document withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
