//
//  SettingsViewController.m
//  ColLaTeX
//
//  Created by felipeccm on 7/15/21.
//

#import "SettingsViewController.h"
@import Parse;

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *shareField;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set title label
    self.titleField.text = self.document.name;
    
    // Set share label
    self.shareField.text = [self stringWithArray];
}

- (IBAction)didTapSave:(id)sender {
}

- (NSString *)stringWithArray{
    NSArray <PFUser *> *arrayOfUsers = self.document.sharedWith;
    NSMutableArray <NSString *> *arrayOfNames = [NSMutableArray new];
    
    // Append each username to array
    for (PFUser *user in arrayOfUsers){
        [arrayOfNames addObject:user.username];
    }
    
    // Join all names in one string
    NSString *stringOfNames = [arrayOfNames componentsJoinedByString:@", "];
    
    return stringOfNames;
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
