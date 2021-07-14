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
    
    // Create URL
    NSString *urlString = [self.document URLString];
    NSURL *url = [NSURL URLWithString:urlString];
    
    // Create request
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    // Retireve data from url
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"Error: %@", error.localizedDescription);
           }
           else {
               // Convert data to pdf
               PDFDocument *pdf = [[PDFDocument alloc] initWithData:data];
               self.pdf = pdf;
               
               // Create PDFView
               PDFView *pdfView = [[PDFView alloc] initWithFrame:frame];
               [self.view insertSubview:pdfView atIndex:1];
               
               // Configure PDFView
               pdfView.document = self.pdf;
               pdfView.displayMode = kPDFDisplaySinglePageContinuous;
               pdfView.autoScales = true;
               pdfView.layer.borderWidth = 2;
               pdfView.layer.borderColor = [UIColor blueColor].CGColor;
               
               [pdfView reloadInputViews];
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
