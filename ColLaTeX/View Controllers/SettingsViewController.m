//
//  SettingsViewController.m
//  ColLaTeX
//
//  Created by felipeccm on 7/15/21.
//

#import "SettingsViewController.h"
@import Parse;

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *shareField;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set title label
    self.titleField.text = self.document.name;
    
    // Set share label
    self.shareField.text = [self stringWithArray];
    
    // Round delete button's edges
    self.deleteButton.layer.cornerRadius = 15;
    self.deleteButton.layer.masksToBounds = true;
}

- (IBAction)didTapSave:(id)sender {
    [self.document updateNameWithString:self.titleField.text];
    [self.document updateSharedArrayWithString:self.shareField.text];
}

- (NSString *)stringWithArray{
    NSArray <PFUser *> *arrayOfUsers = self.document.sharedWith;
    NSMutableArray <NSString *> *arrayOfNames = [NSMutableArray new];
    
    // Append each username to array
    for (PFUser *user in arrayOfUsers){
        [user fetch];
        [arrayOfNames addObject:user.username];
    }
    
    // Join all names in one string
    NSString *stringOfNames = [arrayOfNames componentsJoinedByString:@", "];
    
    return stringOfNames;
}
- (IBAction)didTapDelete:(id)sender {
    [self showDeleteAlert];
}

- (void) showDeleteAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete document?"
                                                                               message:@"Once deleted, all data will be lost. Do you want to continue?"
                                                                        preferredStyle:(UIAlertControllerStyleAlert)];

    // create an Continue action
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"Continue"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
        [self.document deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error){
            [self.navigationController popToRootViewControllerAnimated:true];
        }];
                                                     }];
    // add the Continue action to the alert controller
    [alert addAction:continueAction];
    
    // create an Cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                     }];
    // add the Cancel action to the alert controller
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
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
