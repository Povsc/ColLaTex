//
//  Document.h
//  ColLaTeX
//
//  Created by felipeccm on 7/13/21.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Document : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *docID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) PFUser *owner;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSMutableArray <PFFileObject *> *attachments;
@property (nonatomic, strong) NSMutableArray <PFUser *> *sharedWith;

+ (void) newDocumentNamed: (NSString *)name withUsersArray: ( NSArray <PFUser *> *) arrayOfUsers withCompletion: (PFBooleanResultBlock  _Nullable)completion;

- (NSString *)stringWithDate;

@end
