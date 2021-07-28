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
@dynamic sharedWith;
@dynamic compiler;

+ (nonnull NSString *)parseClassName {
    return @"Document";
}

+ (void) newDocumentNamed: (NSString *)name withUsersArray: ( NSMutableArray <PFUser *> *) arrayOfUsers withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    // Set document metadata
    Document *newDoc = [Document new];
    newDoc.name = name;
    newDoc.owner = [PFUser currentUser];
    newDoc.sharedWith = arrayOfUsers;
    newDoc.compiler = @"xelatex";
    
    // Create an empty document with title
    NSString *beginning = [NSString stringWithFormat: @"\\documentclass[12pt]{article}\n"
                           "\n"
                           "\\usepackage{amsmath}\n"
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
    
    [newDoc saveInBackgroundWithBlock: completion];
}

- (NSString *)stringWithDate{
    // Instantiate formatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // Configure the input format to parse the date string
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    // Compute how much time has passed
    NSTimeInterval secondsSince = [self.updatedAt timeIntervalSinceNow];
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
    else if (hours < 24){
        return [NSString stringWithFormat:@"%dh ago", hours];
    }
    else {
        return [NSString stringWithFormat:@"%dd ago", days];
    }
}

- (void)updateContentWithString:(NSString *)string{
    
    // Check if it's different
    if(![string isEqual:self.content]){
        // Update content
        self.content = string;
        
        // Save in cloud
        [self saveInBackground];
    }
}

- (void)updateNameWithString:(NSString *)string{
    if (![string isEqual:self.name]){
        self.name = string;
        [self saveInBackground];
    }
}

+ (NSMutableArray <PFUser *> *) arrayOfUsersFromString:(NSString *)names {
    // Separate each username
    NSMutableArray *arrayOfNames = [[names componentsSeparatedByString:@", "] mutableCopy];
    
    // Create array of users
    NSMutableArray <PFUser *> *arrayOfUsers = [NSMutableArray new];
    
    for (NSString *name in arrayOfNames){
        // Create a new query for each name
        PFQuery *userQuery = [PFUser query];
        [userQuery whereKey:@"username" equalTo:name];
        userQuery.limit = 1;

        [arrayOfUsers addObjectsFromArray:[userQuery findObjects]];
    }
    
    return arrayOfUsers;
}

- (void)updateSharedArrayWithArray:(NSMutableArray <PFUser *> *)arrayOfUsers{
    self.sharedWith = arrayOfUsers;
    [self saveInBackground];
    
}
@end
