//
//  CreateViewController.m
//  ColLaTeX
//
//  Created by felipeccm on 7/13/21.
//

#import "CreateViewController.h"
#import "Parse/Parse.h"
#import "Document.h"
#import "SharedWithCell.h"
#import "AddUserViewController.h"

@interface CreateViewController () <UITableViewDelegate, UITableViewDataSource, AddUserViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleLabel;
@property (strong, nonatomic) NSMutableArray <PFUser *> *arrayOfUsers;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set tableView delegate and data source
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Initialize user Array
    self.arrayOfUsers = [NSMutableArray new];
    
    // Begin editing titleField
    [self.titleLabel becomeFirstResponder];
}

- (IBAction)didTapCreate:(id)sender {

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
    SharedWithCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SharedWithCell"];
    
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
