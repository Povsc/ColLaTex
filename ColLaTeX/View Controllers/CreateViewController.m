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
@property (strong, nonatomic) NSMutableArray <PFUser *> *arrayOfUsers;

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.contentView.layer.cornerRadius = 30;
    self.contentView.layer.masksToBounds = true;
    
    // Initialize array of users
    self.arrayOfUsers = [NSMutableArray new];
    
    // Begin editing titleField
    [self.titleLabel becomeFirstResponder];
}

- (IBAction)didTapCreate:(id)sender {
    [self arrayOfUsersFromString:self.sharedLabel.text];
    [Document newDocumentNamed:self.titleLabel.text
                withUsersArray:self.arrayOfUsers
                withCompletion:^(BOOL succeeded, NSError * error) {
       if (error != nil) {
           NSLog(@"Error: %@", error.localizedDescription);
           
       } else {
           NSLog(@"Document created successfully");
           [self dismissViewControllerAnimated:YES completion:nil];
       }
    }];
}

- (void) arrayOfUsersFromString:(NSString *)names {
    // Separate each username
    NSMutableArray *arrayOfNames = [[names componentsSeparatedByString:@", "] mutableCopy];
    
    for (NSString *name in arrayOfNames){
        // Create a new query for each name
        PFQuery *userQuery = [PFUser query];
        [userQuery whereKey:@"username" equalTo:name];
        userQuery.limit = 1;

        [self.arrayOfUsers addObjectsFromArray:[userQuery findObjects]]; //:self.arrayOfUsers block:^(NSArray<PFUser *> * _Nullable
    }
}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
