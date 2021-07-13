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

- (NSString *)stringWithDate{
    // Instantiate formatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // Configure the input format to parse the date string
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    // Compute how much time has passed
    NSTimeInterval secondsSince = [self.createdAt timeIntervalSinceNow];
    int seconds = secondsSince * (-1);
    int minutes = seconds / 60;
    int hours = minutes / 60;
    int days = hours / 24;
    // Convert Date to String
    if (minutes < 1){
        return [NSString stringWithFormat:@"%ds ago", seconds];
    }
    else if (hours < 1){
        return [NSString stringWithFormat:@"%dm ago", minutes];
    }
    else if (days < 7){
        return [NSString stringWithFormat:@"%dd ago", days];
    }
    else {
        return [formatter stringFromDate:self.createdAt];
    }
}

@end
