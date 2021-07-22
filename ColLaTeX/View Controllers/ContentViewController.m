//
//  PDFViewController.m
//  ColLaTeX
//
//  Created by felipeccm on 7/14/21.
//

#import "ContentViewController.h"
#import "PDFKit/PDFKit.h"

@interface ContentViewController ()

@property (strong, nonatomic) PDFDocument *pdf;

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Get view dimensions
    CGRect frame = self.view.frame;
        
    //Create json dictionary
    NSDictionary *dict = @{
        @"compiler": @"xelatex",
        @"resources": @[
             @{
                @"main": @true,
                @"content": self.document.content
            }
        ]
    };
    
    // Add pictures to dictionary
    for (NSData *data in self.document.attachments){
        //TODO: Add url and name
    }
    
    // Convert to json
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    
    // Create POST request
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    request.HTTPMethod = @"POST";

    // Pass url and json parameters
    [request setURL:[NSURL URLWithString:@"https://latex.ytotech.com/builds/sync"]];
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
