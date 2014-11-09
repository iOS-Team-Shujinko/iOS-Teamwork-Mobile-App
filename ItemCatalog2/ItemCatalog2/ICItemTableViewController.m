//
//  ICItemTableViewController.m
//  ItemCatalogApp
//
//  Created by m3tr0n0m3 on 11/4/14.
//  Copyright (c) 2014 Shujinko. All rights reserved.
//

#import "ICItemTableViewController.h"
#import "ICItem.h"
#import "Item.h"
#import "ICItemImageViewController.h"
#import <Parse/Parse.h>
#import "ICItemDataViewController.h"
#import "UIView+Toast.h"

@interface ICItemTableViewController ()

@end

@implementation ICItemTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self
                            action:@selector(getDataFromServer)
                  forControlEvents:UIControlEventValueChanged];

    
    [self showLoginScreen];
    
    [self getDataFromServer];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //seconds
    [self.tableView addGestureRecognizer:lpgr];
    
    
}

- (IBAction)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        CGPoint p = [gestureRecognizer locationInView:self.tableView];
        
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
        
        ICItem *item = [self.items objectAtIndex:indexPath.row];
        
       
        if (indexPath == nil) {
            NSLog(@"long press on table view but not on a row");
        } else {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if (cell.isHighlighted) {
                [self saveItemToCoreData:item];
                NSLog(@"long press on table view at section %ld row %ld", (long)indexPath.section, (long)indexPath.row);
            }
        }
    }
}

-(void) saveItemToCoreData: (ICItem *) serverItem{
    id delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    Item *coreDataItem = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:context];
    coreDataItem.name = serverItem.name;
    coreDataItem.seller = serverItem.seller;
    coreDataItem.cartOwner = [PFUser currentUser].username;
    coreDataItem.price = serverItem.price;
    coreDataItem.info = serverItem.info;
    coreDataItem.address = serverItem.address;
    coreDataItem.warranty = serverItem.warranty;
    
    PFFile *itemImageFile = serverItem.itemImage;
    
    [itemImageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            coreDataItem.image = data;
            NSError *error = nil;
            if (![context save:&error]) {
                // error
                NSLog(@"%@",error);
            }else{
                
                [self.view makeToast:@"Item added to shopping cart!"
                            duration:3.0
                            position:CSToastPositionCenter
                               title:@"Added Item"];
                

            }
            
        }else{
            NSLog(@"save item to core data - could not get image");
        }
    }];
}


- (void)getDataFromServer{
    
    PFQuery *query = [PFQuery queryWithClassName:@"ICItem"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            self.items = [[NSMutableArray alloc] initWithArray:objects];
            [self.tableView reloadData];
            
            [self.refreshControl endRefreshing];
        }else{
            NSLog(@"%@ %@",error, [error userInfo]);
        }
    }];
}

-(void) showLoginScreen{
    if (![PFUser currentUser]) {
        // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        
        //[logInViewController.logInView setLogo:[self getTitle]];
        
        [logInViewController.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginLogo.png"]]];
        //logInViewController.logInView.backgroundColor = [UIColor whiteColor];
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        [signUpViewController.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginLogo.png"]]];
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
        
    }else {
        self.logInLogOutButton.title = @"LogOut";
        NSLog(@"%@ logged in", [PFUser currentUser].username);
        
    }
}

//
//// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing info!"
                                message:@"Please fill out every field!"
                               delegate:nil
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self.navigationItem.leftBarButtonItem setTitle:@"LogOut"];
    self.addButton.enabled = YES;
    [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:YES];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:@"Not logged in!"
                                message:@"Sorry but we could not log you in please try again!"
                               delegate:nil
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil] show];
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationItem.leftBarButtonItem setTitle:@"LogIn"];
    self.addButton.enabled = NO;
    [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:NO];
    [[[UIAlertView alloc] initWithTitle:@"Not logged in!"
                                message:@"You have to be logged in if you want to add items to the store or to your basket!"
                               delegate:nil
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil] show];
    
    [self.navigationController popViewControllerAnimated:YES];
}



// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing info!"
                                    message:@"Please fill out every field!"
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
        
    }
    
    return informationComplete;
}


- (IBAction)logInLogOutTap:(UIBarButtonItem *)sender {
    PFUser *currentUser = [PFUser currentUser];
    if (!currentUser) {
        [self showLoginScreen];
    } else {
        [PFUser logOut];
        [self showLoginScreen];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        if ([segue.destinationViewController isKindOfClass:[ICItemImageViewController class]]) {
            ICItemImageViewController * nextImageViewController = segue.destinationViewController;
            NSIndexPath *path = [self.tableView indexPathForCell:sender];
            ICItem *selectedObject = self.items[path.row];
            nextImageViewController.itemObject = selectedObject;
        }
    }
    
    if ([sender isKindOfClass:[NSIndexPath class]]) {
        if ([segue.destinationViewController isKindOfClass:[ICItemDataViewController class]]) {
            ICItemDataViewController *targetViewController = segue.destinationViewController;
            NSIndexPath *path = sender;
            ICItem *selectedObject = self.items[path.row];
            targetViewController.itemObject = selectedObject;
        }
    }
    
    if ([segue.destinationViewController isKindOfClass:[ICAddItemViewController class]]) {
        ICAddItemViewController *addItemObject = segue.destinationViewController;
        addItemObject.delegate = self;
        
    }
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didCancel{
    NSLog(@"did cancel");
    [self dismissViewControllerAnimated:YES completion:nil];
     [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)showToast{
    [self.view makeToast:@"Item successfully added!"
                duration:3.0
                position:CSToastPositionCenter
                   title:@"Added Item"];
    
}

-(void)addObject:(ICItem *)itemObject{

    [self.items addObject:itemObject];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];

    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    
        return 1;    
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
        return self.items.count;
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
    
        ICItem *item = [self.items objectAtIndex:indexPath.row];
    
        PFFile *userImageFile = item.itemImage;        
        
        [userImageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            
            if (!error) {
                UIImage  *image = [UIImage imageWithData:data];
                cell.imageView.image = image;
            }else{
                cell.imageView.image = [UIImage imageWithContentsOfFile:@"noimage.jpg"];
            }
            
        }];
           
    
        cell.textLabel.text = item.name;
        cell.detailTextLabel.text = item.info;
    
    
    CGSize itemSize = CGSizeMake(40, 40);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return cell;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"ItemData" sender:indexPath];
}




// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    PFUser *currentUser = [PFUser currentUser];
    NSString *currentUsername = currentUser.username;
    
    ICItem *currentItem = [self.items objectAtIndex:indexPath.row];
    PFUser *itemUser = currentItem.user;
    [itemUser fetchIfNeeded];
    NSString *username =itemUser.username;
    
    if ([currentUser.username isEqualToString:username]) {
        return YES;
    }else{
        return NO;
    }
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ICItem *currentItem = [self.items objectAtIndex:indexPath.row];
        [currentItem deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [self.view makeToast:@"Item deleted on server!"
                            duration:3.0
                            position:CSToastPositionCenter
                               title:@"Deleted Item"];
            }
        }];
        [self.items removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
