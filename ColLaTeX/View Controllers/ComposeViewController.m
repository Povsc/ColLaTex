//
//  ComposeViewController.m
//  ColLaTeX
//
//  Created by felipeccm on 7/14/21.
//

#import "ComposeViewController.h"
#import "ContentViewController.h"
#import "PDFKit/PDFKit.h"
@import Parse;
#import "SettingsViewController.h"

@interface ComposeViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomConstraint;
@property (nonatomic) int keyboardOffset;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contentLabel.delegate = self;
    
    // Set keyboardOffset
    self.keyboardOffset = 240;
    
    // Bring button to front of view
    [self.view bringSubviewToFront:self.buttonView];
    
    // Make button view circular
    self.buttonView.layer.cornerRadius =
    self.buttonView.frame.size.height /2;
    self.buttonView.layer.masksToBounds = true;
    
    // Give text view rounded corners
    self.contentLabel.layer.cornerRadius = 20;
    self.contentLabel.layer.masksToBounds = true;
    
    // Configure labels
    self.titleLabel.text = self.document.name;
    self.contentLabel.text = self.document.content;
    
    // Remove settings if not owner
    if (!self.owner){
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (IBAction)didTapScreen:(id)sender {
    [self.view endEditing:true];
}


- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.contentViewBottomConstraint.constant += self.keyboardOffset;
    [self.contentLabel updateConstraints];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    self.contentViewBottomConstraint.constant -= self.keyboardOffset;
    [self.contentLabel updateConstraints];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [self.document updateContentWithString:self.contentLabel.text];
    if ([segue.identifier isEqual:@"toPDF"]){
        UINavigationController *navigationController = segue.destinationViewController;
        ContentViewController *pdfViewController = navigationController.topViewController;
        pdfViewController.document = self.document;
    }
    else{
        SettingsViewController *settingsViewController = [segue destinationViewController];
        settingsViewController.document = self.document;
    }
}

- (void) viewWillDisappear:(BOOL)animated{
    [self.document updateContentWithString:self.contentLabel.text];
}


@end
