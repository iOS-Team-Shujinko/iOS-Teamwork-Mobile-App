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
#import <QuartzCore/QuartzCore.h>
#import "UIView+Toast.h"

@interface ICAddItemViewController ()

@end

@implementation ICAddItemViewController {

    CLLocationManager* manager;
    CLGeocoder* geocoder;
    CLPlacemark* placemark;
    BOOL flag;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    manager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
}

- (void)didReceiveMemoryWarning
{
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

- (IBAction)addItemTap:(UIBarButtonItem *)sender {
<<<<<<< HEAD
    
    flag = 0;
    BOOL valid;
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    
    NSString *trimmedName = [self.nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *trimmedPrice = [self.priceField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *trimmedWarranty = [self.warrantyField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *trimmedAddress = [self.addressField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:self.priceField.text];
    valid = [alphaNums isSupersetOfSet:inStringSet];
    
    if (trimmedName.length == 0) {
        
        self.nameField.layer.borderWidth = 2.0f;
        self.nameField.layer.borderColor = [[UIColor redColor] CGColor];
        flag = 1;
        
    }else{
        self.nameField.layer.borderColor = [[UIColor clearColor] CGColor];
    }
    
    if (trimmedPrice.length == 0 || !valid) {
        
        self.priceField.layer.borderWidth = 2.0f;
        self.priceField.layer.borderColor = [[UIColor redColor] CGColor];
        flag = 1;
    }else{
        self.priceField.layer.borderColor = [[UIColor clearColor] CGColor];
    }
    
    inStringSet = [NSCharacterSet characterSetWithCharactersInString:self.warrantyField.text];
    valid = [alphaNums isSupersetOfSet:inStringSet];
    
    if (trimmedWarranty.length == 0 || !valid) {
        
        self.warrantyField.layer.borderWidth = 2.0f;
        self.warrantyField.layer.borderColor = [[UIColor redColor] CGColor];
        flag = 1;
    }else{
        self.warrantyField.layer.borderColor = [[UIColor clearColor] CGColor];
    }
    
    if (trimmedAddress.length == 0) {
        
        self.addressField.layer.borderWidth = 2.0f;
        self.addressField.layer.borderColor = [[UIColor redColor] CGColor];
        flag = 1;
    }else{
        self.addressField.layer.borderColor = [[UIColor clearColor] CGColor];
    }
    
    if (flag == 0) {
        ICItem* newItem = [self newItemObject];
        [self.delegate addObject:newItem];
    }
=======
    ICItem* newItem = [self newItemObject];
    [self.delegate addObject:newItem];
>>>>>>> 74d1b7deddc0b349efff2f84e26e7f3862636611
}


- (IBAction)addImageTap:(UIButton*)sender
{

    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Photos"
                                                    message:@"Choose upload option!"
                                                   delegate:self
                                          cancelButtonTitle:@"Library"
                                          otherButtonTitles:@"Camera", nil];
    [alert show];
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self showPhotoLibary];
    }
    else if (buttonIndex == 1) {
        [self startCamera];
    }
}

- (IBAction)addAddressButton:(UIButton*)sender
{
    manager.delegate = self;
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    [manager requestAlwaysAuthorization];
    [manager startUpdatingLocation];
}

#pragma CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error
{
    NSLog(@"error %@", error);
    NSLog(@"Failed to get location!");
}

- (void)locationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray*)locations
{

    CLLocation* currentLocation = [locations lastObject];

    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray* placemarks, NSError* error) {
        if (error == nil && [placemarks count] > 0 ) {
            placemark = [placemarks lastObject];
            
            self.addressField.text = [NSString stringWithFormat:@"%@ %@, %@",
                                      placemark.postalCode,
                                      placemark.locality,
                                      placemark.country];
        }else{
            
            NSLog(@"%@", error.debugDescription);
        }
    }];

    [manager stopUpdatingLocation];
}

- (void)showPhotoLibary
{
    UIImagePickerController* galleryPicker = [[UIImagePickerController alloc] init];
    galleryPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    // Displays saved pictures from the Camera Roll album.
    galleryPicker.mediaTypes = @[ (NSString*)kUTTypeImage ];

    // Hides the controls for moving & scaling pictures
    galleryPicker.allowsEditing = NO;

    galleryPicker.delegate = self;

    [self presentViewController:galleryPicker animated:YES completion:nil];
}

- (void)startCamera
{
    UIImagePickerController* cameraPicker = [[UIImagePickerController alloc] init];
    cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;

    cameraPicker.delegate = self;

    [self presentViewController:cameraPicker animated:YES completion:nil];
}

- (ICItem*)newItemObject
{
    ICItem* addedItemObject = [[ICItem alloc] init];

    NSData* imageData = UIImageJPEGRepresentation(_itemImageView.image, 0.8);
    NSString* filename = [NSString stringWithFormat:@"%@.png", _nameField.text];
    PFFile* imageFile = [PFFile fileWithName:filename data:imageData];

    PFUser* seller = [PFUser currentUser];
    NSString* sellerName = seller.username;
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * price = [f numberFromString:self.priceField.text];
    NSNumber * warranty = [f numberFromString:self.warrantyField.text];
    
    addedItemObject.name = self.nameField.text;
    addedItemObject.price = price;
    addedItemObject.seller = sellerName;
    addedItemObject.user = seller;
    addedItemObject.warranty = warranty;
    addedItemObject.info = self.infoField.text;
    addedItemObject.address = self.addressField.text;
    addedItemObject.itemImage = imageFile;
    
    [addedItemObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Item could not be saved to server - sorry :)" delegate:nil cancelButtonTitle:@"Ok i'll save it again" otherButtonTitles:nil, nil]show];
            
            NSLog(@"%@",error);
        }else{
            
         [self.delegate showToast];
            
            
        }
    }];
    
    return addedItemObject;
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{

    UIImage* originalImage = (UIImage*)[info objectForKey:UIImagePickerControllerOriginalImage];
    self.itemImageView.image = originalImage;

    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
;