//
//  SettingsViewController.m
//  ColLaTeX
//
//  Created by felipeccm on 7/15/21.
//

#import "SettingsViewController.h"
@import Parse;
#import "AddUserViewController.h"
#import "SharedWithCell.h"

@interface SettingsViewController () <UITableViewDelegate, UITableViewDataSource, AddUserViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray <PFUser *> *arrayOfUsers;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set delegate and data source
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Instantiate array
    self.arrayOfUsers = [NSMutableArray new];
    
    // Fetch data and reload data
    for (PFUser *user in self.document.sharedWith){
        [user fetchInBackgroundWithBlock:^(PFObject * _Nullable user, NSError * _Nullable error){
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
            }
            else {
                [self.arrayOfUsers addObject:(PFUser *)user];
                [self.tableView reloadData];
            }
        }];
    }
    
    // Set title label
    self.titleField.text = self.document.name;
    
    // Round delete button's edges
    self.deleteButton.layer.cornerRadius = 15;
    self.deleteButton.layer.masksToBounds = true;
}

- (IBAction)didTapSave:(id)sender {
    [self.document updateNameWithString:self.titleField.text];
    [self.document updateSharedArrayWithArray:self.arrayOfUsers];
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

- (IBAction)didTapScreen:(id)sender {
    [self.view endEditing:true];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    AddUserViewController *addUserController = [segue destinationViewController];
    addUserController.delegate = self;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SharedWithCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SharedSettingsCell"];
    
    // Set labels and parameters
    cell.nameLabel.text = self.arrayOfUsers[indexPath.row].username;
    
    // Configure Profile pic
    cell.imageView.file = [self.arrayOfUsers[indexPath.row] objectForKey:@"profilePicture"];
    [cell.imageView loadInBackground];
    
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfUsers.count;
}
- (void)didAddUser:(nonnull PFUser *)user {
    [self.arrayOfUsers addObject:user];
    [self.tableView reloadData];
}

-(id)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self getRowActions:tableView indexPath:indexPath];
}
-(id)getRowActions:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    
    // Create new action
    UIContextualAction *delete = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive
                                                                             title:@"REMOVE"
                                                                           handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        // Remove selected user and reload
        [self.arrayOfUsers removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
                                                                               completionHandler(YES);
                                                                           }];
    
    // Configure button
    delete.backgroundColor = [UIColor redColor];
    delete.image = [UIImage imageNamed:@"Trash.fill"];
    
    UISwipeActionsConfiguration *swipeActionConfig = [UISwipeActionsConfiguration configurationWithActions:@[delete]];
    swipeActionConfig.performsFirstActionWithFullSwipe = NO;
    return swipeActionConfig;
}
@end
