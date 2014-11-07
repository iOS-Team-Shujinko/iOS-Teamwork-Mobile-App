//
//  ViewController.m
//  ItemCatalogApp
//
//  Created by m3tr0n0m3 on 11/4/14.
//  Copyright (c) 2014 Shujinko. All rights reserved.
//

#import "ICLoginViewController.h"
#import <Parse/Parse.h>

@interface ICLoginViewController ()

@end

@implementation ICLoginViewController
- (UILabel *)getTitle {
    UILabel *title = [[UILabel alloc] initWithFrame: CGRectMake (0, 0, 200, 30)];
    title.attributedText =[[NSAttributedString alloc] initWithString:@"Храна за вкъщи"
                                                          attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
    title.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    //  [title setFont:[UIFont boldSystemFontOfSize:24]];
    title.textAlignment = NSTextAlignmentCenter;
    [title setFont:[UIFont fontWithName:@"Raleway" size:30]];
    return title;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
//        
//        UIGraphicsBeginImageContext(logInViewController.view.frame.size);
//        [[UIImage imageNamed:@"loginbg.png"] drawInRect:logInViewController.view.bounds];
//        UIImage *loginBg = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
       // [logInViewController.logInView setBackgroundColor:[UIColor colorWithPatternImage:loginBg]];
        
        // set the colors of the placeholders
        UIColor *color = [UIColor whiteColor];
        
        logInViewController.logInView.usernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Име" attributes:@{NSForegroundColorAttributeName: color}];
        logInViewController.logInView.usernameField.alpha = 0.8;
        logInViewController.logInView.usernameField.backgroundColor =[UIColor brownColor];
        logInViewController.logInView.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Парола" attributes:@{NSForegroundColorAttributeName: color}];
        logInViewController.logInView.passwordField.alpha = 0.8;
        logInViewController.logInView.passwordField.backgroundColor =[UIColor brownColor];
        [logInViewController.logInView.logInButton setTitle:@"Вход" forState:normal];
        [logInViewController.logInView.signUpButton setTitle:@"Създай нов" forState:normal];
        
        
        [logInViewController.logInView setLogo:[self getTitle]];
        
        logInViewController.logInView.signUpLabel.attributedText =[[NSAttributedString alloc] initWithString:@"Нямаш акаунт?" attributes:@{NSForegroundColorAttributeName: color}];
        
        logInViewController.logInView.signUpButton.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Създай нов" attributes:@{NSForegroundColorAttributeName: color}];
        
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
        signUpViewController.signUpView.usernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Име" attributes:@{NSForegroundColorAttributeName: color}];
        signUpViewController.signUpView.usernameField.alpha = 0.8;
        signUpViewController.signUpView.usernameField.backgroundColor =[UIColor brownColor];
        signUpViewController.signUpView.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Парола" attributes:@{NSForegroundColorAttributeName: color}];
        signUpViewController.signUpView.passwordField.alpha = 0.8;
        signUpViewController.signUpView.passwordField.backgroundColor =[UIColor brownColor];
        signUpViewController.signUpView.emailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"e-mail" attributes:@{NSForegroundColorAttributeName: color}];
        signUpViewController.signUpView.emailField.alpha = 0.8;
        signUpViewController.signUpView.emailField.backgroundColor =[UIColor brownColor];
        [signUpViewController.signUpView.signUpButton setTitle:@"Запиши ме!" forState:normal];
        
        [signUpViewController.signUpView setLogo: [self getTitle]];
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
        
    }else {
        NSLog(@"%@ logged in", [PFUser currentUser].username);
        [self performSegueWithIdentifier: @"loginToTable" sender: self];
        
    }
    
}

-(void)viewDidLayoutSubviews{
    // [self performSegueWithIdentifier: @"orderingSegue" sender: self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"loginToTable"])
    {
        // Get reference to the destination view controller
        //TableBarsViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        NSLog(@"Going to loginToTable");
    }
}


//
//// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Липсва информация!"
                                message:@"Попълненте всички полета, моля!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
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
        [[[UIAlertView alloc] initWithTitle:@"Липсва информация!"
                                    message:@"Попълненте всички полета, моля!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
