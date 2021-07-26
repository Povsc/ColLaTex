//
//  PDFViewController.m
//  ColLaTeX
//
//  Created by felipeccm on 7/14/21.
//

#import "ContentViewController.h"
#import "PDFKit/PDFKit.h"
#import "Attachment.h"

@interface ContentViewController ()

@property (strong, nonatomic) PDFDocument *pdf;
@property (strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) NSArray <Attachment *> *arrayOfAttachments;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Animate Activity indicator
    [self.activityIndicator startAnimating];
    
    // Create a new query
    PFQuery *attachmentQuery = [Attachment query];
    [attachmentQuery whereKey:@"document" equalTo:self.document];
    [attachmentQuery orderByDescending:@"updatedAt"];
    
    // Add attachments
    [attachmentQuery findObjectsInBackgroundWithBlock:^(NSArray<Attachment *> * _Nullable documents, NSError * _Nullable error) {
       if (documents) {
           self.arrayOfAttachments = [documents mutableCopy];
           [self postRequest];
       }
       else {
           NSLog(@"Error: %@", error.localizedDescription);
       }
    }];
}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
    
- (void) postRequest{
    // Set url
    self.urlString = @"https://latex.ytotech.com/builds/sync";
    
    // Get view dimensions
    CGRect frame = self.view.frame;
        
    //Create json dictionary
    NSDictionary *dict = @{
        @"compiler": self.document.compiler,
        @"resources": [@[
             @{
                @"main": @true,
                @"content": self.document.content
            }
        ] mutableCopy]
    };
    
    // Add pictures to dictionary
    for (Attachment *attachment in self.arrayOfAttachments){
        NSDictionary *newDict = @{
            @"path": attachment.name,
            @"url": attachment.picture.url
        };
        [dict[@"resources"] addObject:newDict];
    }
    
    // Convert to json
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    
    // Create POST request
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    request.HTTPMethod = @"POST";

    // Pass url and json parameters
    [request setURL:[NSURL URLWithString:self.urlString]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];

    // Configure session and task
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                          delegate:nil
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {

        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        else {
            // Convert data to pdf
            PDFDocument *pdf = [[PDFDocument alloc] initWithData:data];
            self.pdf = pdf;
            
            // Create PDFView
            PDFView *pdfView = [[PDFView alloc] initWithFrame:frame];
            // Configure PDFView
            pdfView.document = self.pdf;
            pdfView.displayMode = kPDFDisplaySinglePageContinuous;
            pdfView.autoScales = true;
            self.view = pdfView;
            
            [self.view reloadInputViews];
        }

                                            }];
    [task resume];
    
    // Stop Activity indicator
    [self.activityIndicator startAnimating];
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
