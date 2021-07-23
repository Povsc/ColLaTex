//
//  AttachmentCreationViewController.m
//  ColLaTeX
//
//  Created by felipeccm on 7/23/21.
//

#import "AttachmentCreationViewController.h"
@import Parse;
#import "ImageHelper.h"
#import "Attachment.h"

@interface AttachmentCreationViewController () <UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet PFImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIView *smallerView;

@end

@implementation AttachmentCreationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Round corners of view
    self.smallerView.layer.cornerRadius = 15;
    self.smallerView.layer.masksToBounds = true;
    
    // Start setting picture
    [self didTapSetPicture:nil];
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

//    // Resize image
//    editedImage = [ImageHelper resizeImage:editedImage withSize:CGSizeMake(1800, 1800)];
    
    // Save image and file
    self.imageView.file = [ImageHelper getPFFileFromImage:editedImage];
    self.imageView.image = editedImage;
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapScreen:(id)sender {
    [self.view endEditing:true];
}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapCreate:(id)sender {
    [Attachment newAttachmentNamed:self.nameField.text withFile:self.imageView.file withDocument:self.document withCompletion:^(BOOL succeeded, NSError * _Nullable error){
        if (succeeded){
            [self dismissViewControllerAnimated:YES completion:nil];
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
