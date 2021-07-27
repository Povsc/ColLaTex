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

@interface CreateViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *titleLabel;
@property (strong, nonatomic) NSMutableArray <PFUser *> *arrayOfUsers;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) int counter;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set tableView delegate and data source
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Set counter
    self.counter = 1;
    
    // Begin editing titleField
    [self.titleLabel becomeFirstResponder];
}

- (IBAction)didTapCreate:(id)sender {
    // Get array of users
//    self.arrayOfUsers = [Document arrayOfUsersFromString:self.sharedLabel.text];

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

- (IBAction)didTapPlus:(id)sender {
    self.counter ++;
    [self.tableView reloadData];
    if (self.counter == 1){
        [self.minusButton setEnabled:true];
    }
}

- (IBAction)didTapMinus:(id)sender {
    self.counter --;
    [self.tableView reloadData];
    if (self.counter == 0){
        [self.minusButton setEnabled:false];
    }
}

- (IBAction)didTapScreen:(id)sender {
    [self.view endEditing:true];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SharedWithCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SharedWithCell"];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.counter;
}
@end
