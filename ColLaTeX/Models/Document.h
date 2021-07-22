//
//  Document.h
//  ColLaTeX
//
//  Created by felipeccm on 7/13/21.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Attachment.h"

@interface Document : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *docID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) PFUser *owner;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSMutableArray <Attachment *> *attachments;
@property (nonatomic, strong) NSMutableArray *sharedWith;
@property (nonatomic, strong) NSString *compiler;

+ (void) newDocumentNamed: (NSString *)name withUsersArray: ( NSArray <PFUser *> *) arrayOfUsers withCompletion: (PFBooleanResultBlock  _Nullable)completion;

- (NSString *)stringWithDate;

- (void)updateContentWithString:(NSString *)string;

- (void)updateNameWithString:(NSString *)string;

+ (NSMutableArray <PFUser *> *)arrayOfUsersFromString:(NSString *)names;

- (void)updateSharedArrayWithString:(NSString *)string;

@end
