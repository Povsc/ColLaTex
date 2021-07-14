//
//  MyDocumentsViewController.m
//  ColLaTeX
//
//  Created by felipeccm on 7/13/21.
//

#import "MyDocumentsViewController.h"
#import "Document.h"
#import "Parse/Parse.h"
#import "MyDocumentCell.h"

@interface MyDocumentsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray <Document *> *arrayOfDocuments;
@property (weak, nonatomic) IBOutlet UIButton *createButton;

@end

@implementation MyDocumentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set data source and delegate
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Fix create button
    [self.view bringSubviewToFront:self.createButton];
    self.createButton.layer.cornerRadius =
     self.createButton.frame.size.width /2;
    self.createButton.layer.masksToBounds = true;
    
    // Instantiate refreshControl
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    
    // Load in data
    [self beginRefresh:refreshControl];
}

- (void) beginRefresh:(UIRefreshControl *) refreshControl {
    // Create a new query
    PFQuery *documentQuery = [Document query];
    [documentQuery whereKey:@"owner" equalTo:PFUser.currentUser];
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
    MyDocumentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyDocumentCell"];
    
    // Set parameters
    cell.document = self.arrayOfDocuments[indexPath.row];
    cell.titleLabel.text = cell.document.name;
    
    
    // Configure date output
    NSString *date = [cell.document stringWithDate];
    
    // Set label
    cell.modifiedLabel.text = [NSString stringWithFormat:@"Modified: %@", date];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfDocuments.count;
}

@end
