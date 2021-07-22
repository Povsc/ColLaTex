//
//  Attachment.m
//  ColLaTeX
//
//  Created by felipeccm on 7/22/21.
//

#import "Attachment.h"

@implementation Attachment

@dynamic docID;
@dynamic name;
@dynamic picture;

+ (void) newAttachmentNamed: (NSString *)name withFile: ( PFFileObject *) file withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    // Set properties
    Attachment *newAttachment = [Attachment new];
    newAttachment.name = name;
    newAttachment.picture = file;
    
    [newAttachment saveInBackgroundWithBlock: completion];
}

@end
