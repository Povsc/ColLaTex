//
//  AttachmentsViewController.m
//  ColLaTeX
//
//  Created by felipeccm on 7/23/21.
//

#import "AttachmentsViewController.h"
#import "Attachment.h"
#import "AttachmentCell.h"
#import "AttachmentCreationViewController.h"

@interface AttachmentsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray <Attachment *> *arrayOfAttachments;

@end

@implementation AttachmentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
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
    PFQuery *attachmentQuery = [Attachment query];
    [attachmentQuery whereKey:@"document" equalTo:self.document];
    [attachmentQuery orderByDescending:@"updatedAt"];
    
    // Add attachments
    [attachmentQuery findObjectsInBackgroundWithBlock:^(NSArray<Attachment *> * _Nullable documents, NSError * _Nullable error) {
       if (documents) {
           self.arrayOfAttachments = [documents mutableCopy];
       }
       else {
           NSLog(@"Error: %@", error.localizedDescription);
       }
        // Tell the refreshControl to stop spinning
         [refreshControl endRefreshing];
        
        // Reload data
        [self.tableView reloadData];
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UINavigationController *navigationController = segue.destinationViewController;
    AttachmentCreationViewController *createViewController = navigationController.topViewController;
    createViewController.document = self.document;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    AttachmentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AttachmentCell"];
    
    // Set label
    Attachment *attachment = self.arrayOfAttachments[indexPath.row];
    cell.nameLabel.text = attachment.name;
    
    // Configure Profile pic
    cell.attachmentImage.file = attachment.picture;
    [cell.attachmentImage loadInBackground];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfAttachments.count;
}

@end
