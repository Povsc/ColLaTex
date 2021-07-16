//
//  ProfileViewController.m
//  ColLaTeX
//
//  Created by felipeccm on 7/13/21.
//

#import "ProfileViewController.h"
@import Parse;
#import "SceneDelegate.h"
#import "ImageHelper.h"

@interface ProfileViewController () <UIImagePickerControllerDelegate>

@property (nonatomic) BOOL editing;
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextView *usernameField;
@property (weak, nonatomic) IBOutlet UITextView *emailField;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (strong, nonatomic) PFUser *user;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set to not editing
    self.editing = false;
    
    // Set uset to current user
    self.user = PFUser.currentUser;
    
    // Set fields
    self.usernameField.text = self.user.username;
    self.emailField.text = self.user.email;
    
    // Format and set createdAt label
    NSString *dateLabel = [self stringWithDate:self.user.createdAt];
    self.createdAtLabel.text = [NSString stringWithFormat:@"Created%@", dateLabel];
    
    // Load and set image
    self.profileImageView.file = [self.user objectForKey:@"profilePicture"];
    [self.profileImageView loadInBackground];
    
    // Make profile image circular
    self.profileImageView.layer.cornerRadius =
        self.profileImageView.frame.size.width /2;
    self.profileImageView.layer.masksToBounds = true;
}

- (IBAction)didTapLeftBarButton:(id)sender {
    if (!self.editing){
        [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
            // PFUser.current() will now be nil
            SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
            
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            myDelegate.window.rootViewController = loginViewController;
        }];
    }
    else{
        // Reload labels and image
        [self viewDidLoad];
        
        // Change button titles
        self.navigationItem.leftBarButtonItem.title = @"Log Out";
        self.navigationItem.rightBarButtonItem.title = @"Edit";
        
        // Make fields and pictures non-interactable
        self.usernameField.editable = false;
        self.emailField.editable = false;
        self.profileImageView.userInteractionEnabled = false;
        
    }
}

- (IBAction)didTapRightBarButton:(id)sender {
    if (self.editing){
        // Set user new data
        self.user.username = self.usernameField.text;
        self.user.email = self.emailField.text;
        self.user[@"profilePicture"] = self.profileImageView.file;
        
        // Save user data
        [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error){
            if (error){
                NSLog(@"Error: %@", error.localizedDescription);
            }
            else{
                // Change button titles
                self.navigationItem.leftBarButtonItem.title = @"Log Out";
                self.navigationItem.rightBarButtonItem.title = @"Edit";
                
                // Make fields and pictures non-interactable
                self.usernameField.editable = false;
                self.emailField.editable = false;
                self.profileImageView.userInteractionEnabled = false;
                
                // Set to not editing
                self.editing = false;
                
                // Refetch user data
                [PFUser.currentUser fetchInBackground];
            }
        }];
    }
    else{
        self.editing = true;
        
        // Change labels and image
        self.navigationItem.leftBarButtonItem.title = @"Cancel";
        self.navigationItem.rightBarButtonItem.title = @"Save";
        
        // Make fields and pictures interactable
        self.usernameField.editable = true;
        self.emailField.editable = true;
        self.profileImageView.userInteractionEnabled = true;
    }
}

- (NSString *)stringWithDate:(NSDate *)date{
    // Instantiate formatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // Configure the input format to parse the date string
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    // Compute how much time has passed
    NSTimeInterval secondsSince = [date timeIntervalSinceNow];
    int seconds = secondsSince * (-1);
    int minutes = seconds / 60;
    int hours = minutes / 60;
    int days = hours / 24;
    // Convert Date to String
    if (minutes < 1){
        return [NSString stringWithFormat:@" %ds second(s) ago", seconds];
    }
    else if (hours < 1){
        return [NSString stringWithFormat:@" %d minute(s) ago", minutes];
    }
    else if (hours < 24){
        return [NSString stringWithFormat:@" %d hour(s) ago", hours];
    }
    else if (days < 7){
        return [NSString stringWithFormat:@" %d day(s) ago", days];
    }
    else {
        NSString *dateString = [formatter stringFromDate:date];
        return [NSString stringWithFormat:@": %@", dateString];
    }
}

- (IBAction)didTapSetPicture:(id)sender {
    // Set up UIImagePickerController
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    // Set data source as library
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Resize image
    editedImage = [ImageHelper resizeImage:editedImage withSize:CGSizeMake(1800, 1800)];
    
    // Save image and file
    self.profileImageView.file = [ImageHelper getPFFileFromImage:editedImage];
    self.profileImageView.image = editedImage;
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapScreen:(id)sender {
    [self.view endEditing:true];
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
