//
//  SharedWithMeViewController.m
//  ColLaTeX
//
//  Created by felipeccm on 7/14/21.
//

#import "SharedWithMeViewController.h"
#import "Document.h"
@import Parse;
#import "SharedCell.h"

@interface SharedWithMeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray <Document *> *arrayOfDocuments;

@end

@implementation SharedWithMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Set up tableView data source and delegate
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Instantiate refreshControl
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    
    // Load in data
    [self beginRefresh:refreshControl];
}

- (void)beginRefresh:(UIRefreshControl *) refreshControl {
    // Create array with only current user
    NSMutableArray *userArray = [NSMutableArray new];
    [userArray addObject:PFUser.currentUser];
    
    // Create a new query
    PFQuery *documentQuery = [Document query];
    [documentQuery whereKey:@"sharedWith" containsAllObjectsInArray:userArray];
    [documentQuery orderByDescending:@"updatedAt"];
    [documentQuery includeKey:@"owner"];
    documentQuery.limit = 20;

    [documentQuery findObjectsInBackgroundWithBlock:^(NSArray<Document *> * _Nullable documents, NSError * _Nullable error) {
       if (documents) {
             self.arrayOfDocuments = [documents mutableCopy];
           
           // Tell the refreshControl to stop spinning
            [refreshControl endRefreshing];
           
           // Reload data
           [self.tableView reloadData];
       }
       else {
           NSLog(@"Error: %@", error.localizedDescription);
       }
    }];
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
    SharedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SharedCell"];
    
    // Set labels and parameters
    cell.document = self.arrayOfDocuments[indexPath.row];
    cell.titleLabel.text = cell.document.name;
    cell.ownerLabel.text = cell.document.owner.username;
    
    // Configure date output
    NSString *date = [cell.document stringWithDate];
    
    // Set label
    cell.modifiedLabel.text = [NSString stringWithFormat:@"Modified: %@", date];
    
    // Configure Profile pic
    cell.profileImageView.file = [cell.document.owner objectForKey:@"profilePicture"];
    [cell.profileImageView loadInBackground];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfDocuments.count;
}

@end
