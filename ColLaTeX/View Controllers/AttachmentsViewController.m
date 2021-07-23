//
//  AttachmentsViewController.m
//  ColLaTeX
//
//  Created by felipeccm on 7/23/21.
//

#import "AttachmentsViewController.h"
#import "Attachment.h"

@interface AttachmentsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray <Attachment *> *arrayOfAttachments;

@end

@implementation AttachmentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

@end
