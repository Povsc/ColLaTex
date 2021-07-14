//
//  PDFViewController.m
//  ColLaTeX
//
//  Created by felipeccm on 7/14/21.
//

#import "PDFViewController.h"

@interface PDFViewController ()

@end

@implementation PDFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Get view dimensions
    CGRect frame = self.view.frame;
    
    // Create PDFView
    PDFView *pdfView = [[PDFView alloc] initWithFrame:frame];
    pdfView.document = self.pdf;
    pdfView.displayMode = kPDFDisplaySinglePageContinuous;
    pdfView.autoScales = true;
    pdfView.layer.borderWidth = 2;
    pdfView.layer.borderColor = [UIColor blueColor].CGColor;
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
