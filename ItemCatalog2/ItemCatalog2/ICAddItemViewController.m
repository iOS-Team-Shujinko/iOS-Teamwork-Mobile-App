//
//  ICAddItemViewController.m
//  ItemCatalogApp
//
//  Created by m3tr0n0m3 on 11/6/14.
//  Copyright (c) 2014 Shujinko. All rights reserved.
//

#import "ICAddItemViewController.h"
#import <Parse/Parse.h>
#import <MobileCoreServices/UTCoreTypes.h>

@interface ICAddItemViewController ()

@end

@implementation ICAddItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addButtonTap:(UIButton *)sender {
    ICItem *newItem = [self newItemObject];
    [self.delegate addObject:newItem];
}

- (IBAction)cancelButtonTap:(UIButton *)sender {
    [self.delegate didCancel];
}

- (IBAction)addImageTap:(UIButton *)sender {
    [self showPhotoLibary];
}


- (void)showPhotoLibary
{
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)) {
        return;
    }
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // Displays saved pictures from the Camera Roll album.
    mediaUI.mediaTypes = @[(NSString*)kUTTypeImage];
    
    // Hides the controls for moving & scaling pictures
    mediaUI.allowsEditing = NO;
    
    mediaUI.delegate = self;
   
    [self.navigationController presentModalViewController: mediaUI animated: YES];
}

- (ICItem *)newItemObject{
    ICItem *addedItemObject = [[ICItem alloc]init];
    
    NSData *imageData = UIImageJPEGRepresentation(_itemImageView.image, 0.8);
    NSString *filename = [NSString stringWithFormat:@"%@.png", _nameField.text];
    PFFile *imageFile = [PFFile fileWithName:filename data:imageData];
    
    NSLog(@"%@",imageFile);
    
    addedItemObject.name = self.nameField.text;
    addedItemObject.price = [self.priceField.text floatValue];
    addedItemObject.seller = self.sellerFIeld.text;
    addedItemObject.warranty = [self.warrantyField.text floatValue];
    addedItemObject.info = self.infoField.text;
    addedItemObject.itemImage = imageFile;
   [addedItemObject saveInBackground];
    return addedItemObject;
}

- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    UIImage *originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    self.itemImageView.image = originalImage;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


@end
;