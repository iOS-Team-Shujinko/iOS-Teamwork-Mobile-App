//
//  ICItemTableViewController.m
//  ItemCatalogApp
//
//  Created by m3tr0n0m3 on 11/4/14.
//  Copyright (c) 2014 Shujinko. All rights reserved.
//

#import "ICItemTableViewController.h"
#import "ICItem.h"
#import "ICItemImageViewController.h"
#import <Parse/Parse.h>
#import "ICItemDataViewController.h"

@interface ICItemTableViewController ()

@end

@implementation ICItemTableViewController

- (UILabel *) getTitle {
    UILabel *title = [[UILabel alloc] initWithFrame: CGRectMake (0, 0, 200, 30)];
    title.attributedText =[[NSAttributedString alloc] initWithString:@"Item Catalog"
                                                          attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
    title.backgroundColor = [UIColor whiteColor];
    //  [title setFont:[UIFont boldSystemFontOfSize:24]];
    title.textAlignment = NSTextAlignmentCenter;
    [title setFont:[UIFont fontWithName:@"Raleway" size:30]];
    return title;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        // set the colors of the placeholders
        UIColor *color = [UIColor blueColor];
        
        logInViewController.logInView.usernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Име" attributes:@{NSForegroundColorAttributeName: color}];
        logInViewController.logInView.usernameField.alpha = 0.8;
        logInViewController.logInView.usernameField.backgroundColor =[UIColor whiteColor];
        logInViewController.logInView.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Парола" attributes:@{NSForegroundColorAttributeName: color}];
        logInViewController.logInView.passwordField.alpha = 0.8;
        logInViewController.logInView.passwordField.backgroundColor =[UIColor whiteColor];
        [logInViewController.logInView.logInButton setTitle:@"Log In" forState:normal];
        [logInViewController.logInView.signUpButton setTitle:@"Sign Up" forState:normal];
        
        
        [logInViewController.logInView setLogo:[self getTitle]];
        
        logInViewController.logInView.signUpLabel.attributedText =[[NSAttributedString alloc] initWithString:@"Don't have an account?" attributes:@{NSForegroundColorAttributeName: color}];
        
        logInViewController.logInView.signUpButton.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Sign Up" attributes:@{NSForegroundColorAttributeName: color}];
        
        //[logInViewController.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]]];
        //
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        UIGraphicsBeginImageContext(logInViewController.view.frame.size);
        [[UIImage imageNamed:@"signupbg.png"] drawInRect:logInViewController.view.bounds];
        UIImage *signupBg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        [signUpViewController.signUpView setBackgroundColor:[UIColor colorWithPatternImage:signupBg]];
        signUpViewController.signUpView.usernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: color}];
        signUpViewController.signUpView.usernameField.alpha = 0.8;
        signUpViewController.signUpView.usernameField.backgroundColor =[UIColor whiteColor];
        signUpViewController.signUpView.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Passwprd" attributes:@{NSForegroundColorAttributeName: color}];
        signUpViewController.signUpView.passwordField.alpha = 0.8;
        signUpViewController.signUpView.passwordField.backgroundColor =[UIColor whiteColor];
        signUpViewController.signUpView.emailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"e-mail" attributes:@{NSForegroundColorAttributeName: color}];
        signUpViewController.signUpView.emailField.alpha = 0.8;
        signUpViewController.signUpView.emailField.backgroundColor =[UIColor whiteColor];
        [signUpViewController.signUpView.signUpButton setTitle:@"Sign me up!" forState:normal];
        
        [signUpViewController.signUpView setLogo: [self getTitle]];
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
        
    }else {
        NSLog(@"%@ logged in", [PFUser currentUser].username);
       // [self performSegueWithIdentifier: @"loginToTable" sender: self];
        
    }
    
    [self getDataFromServer];
    
}


- (void)getDataFromServer{
    
    PFQuery *query = [PFQuery queryWithClassName:@"ICItem"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            self.items = [[NSMutableArray alloc] initWithArray:objects];
            [self.tableView reloadData];
        }else{
            NSLog(@"%@ %@",error, [error userInfo]);
        }
    }];
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
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Грешка при вписването...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
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


-(void)viewWillLayoutSubviews{
    //[self.tableView reloadData];
 
    
}

- (IBAction)refreshButton:(UIBarButtonItem *)sender{
    [self getDataFromServer];
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

-(void)addObject:(ICItem *)itemObject{
    
//    if (!self.addedItems) {
//        self.addedItems = [[NSMutableArray alloc] init];
    [self.items addObject:itemObject];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
//    }
    NSLog(@"add items");
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if ([self.addedItems count]) {
        return 2;
    }else{
        return 1;    
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return self.addedItems.count;
    }else{
        return self.items.count;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
    
    if (indexPath.section == 1) {
        // todo
    } else {
        ICItem *item = [self.items objectAtIndex:indexPath.row];
    
        PFFile *userImageFile = item.itemImage;
   
        NSData *imageData=[userImageFile getData];
    
        UIImage *image = [UIImage imageWithData:imageData];
    
        cell.textLabel.text = item.name;
        cell.detailTextLabel.text = item.info;
        cell.imageView.image = image;
    }
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageView.clipsToBounds = YES;
    return cell;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"ItemData" sender:indexPath];
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
