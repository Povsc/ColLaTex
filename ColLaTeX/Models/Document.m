//
//  Document.m
//  ColLaTeX
//
//  Created by felipeccm on 7/13/21.
//

#import "Document.h"

@implementation Document
    
@dynamic docID;
@dynamic owner;
@dynamic content;
@dynamic name;
@dynamic attachments;
@dynamic sharedWith;

+ (nonnull NSString *)parseClassName {
    return @"Document";
}

+ (void) newDocumentNamed: (NSString *)name withUsersArray: ( NSMutableArray <PFUser *> *) arrayOfUsers withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    // Set document metadata
    Document *newDoc = [Document new];
    newDoc.name = name;
    newDoc.owner = [PFUser currentUser];
    newDoc.sharedWith = arrayOfUsers;
    
    // Create an empty document with title
    NSString *beginning = [NSString stringWithFormat: @"\\documentclass[12pt]{article}\n"
                           "\n"
                           "\\usepackage[utf8]{inputenc}\n"
                           "\\usepackage[spanish,activeacute]{babel}\n"
                           "\n"
                           "\\title{%@}\n", name];
    NSString *end = [NSString stringWithFormat: @"\\author{%@}\n"
    "\n"
    "\\begin{document}\n"
    "\n"
    "\\maketitle\n"
    "\n"
    "\n"
    "\n"
    "\\end{document}", PFUser.currentUser.username];
    
    // Set content and attachments
    newDoc.content = [beginning stringByAppendingFormat: @"%@", end];
    newDoc.attachments = [NSMutableArray new];
    
    [newDoc saveInBackgroundWithBlock: completion];
}

@end
