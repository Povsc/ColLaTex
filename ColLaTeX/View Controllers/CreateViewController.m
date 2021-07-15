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
    
    // Begin editing titleField
    [self.titleLabel becomeFirstResponder];
}

- (IBAction)didTapCreate:(id)sender {
    // Get array of users
    self.arrayOfUsers = [Document arrayOfUsersFromString:self.sharedLabel.text];
    
    // Create a new document
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
