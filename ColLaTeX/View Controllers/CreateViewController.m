//
//  CreateViewController.m
//  ColLaTeX
//
//  Created by felipeccm on 7/13/21.
//

#import "CreateViewController.h"
#import "Parse/Parse.h"
#import "Document.h"

@interface CreateViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *sharedLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.contentView.layer.cornerRadius = 30;
    self.contentView.layer.masksToBounds = true;
}

- (IBAction)didTapCreate:(id)sender {
    NSMutableArray <PFUser *> *arrayOfUsers = [self arrayOfUsersFromString:self.sharedLabel.text];
    [Document newDocumentNamed:self.titleLabel.text
                withUsersArray:arrayOfUsers
                withCompletion:^(BOOL succeeded, NSError * error) {
       if (error != nil) {
           NSLog(@"Error: %@", error.localizedDescription);
           
       } else {
           NSLog(@"Document created successfully");
       }
    }];
}

- (NSMutableArray <PFUser *> *) arrayOfUsersFromString:(NSString *)names {
    NSMutableArray *arrayOfNames = [[names componentsSeparatedByString:@", "] mutableCopy];
    NSMutableArray <PFUser *> *arrayOfUsers = [NSMutableArray new];
    for (NSString *name in arrayOfNames){
        // Create a new query
        PFQuery *userQuery = [PFUser query];
        [userQuery whereKey:@"username" equalTo:name];
        userQuery.limit = 1;

        [userQuery findObjectsInBackgroundWithBlock:^(NSArray<PFUser *> * _Nullable user, NSError * _Nullable error) {
           if (user && user.count >0) {
                 [arrayOfUsers addObject:user[0]];
           }
           else {
               NSLog(@"User not found: Error: %@", error.localizedDescription);
           }
        }];
    }
    return arrayOfUsers;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
