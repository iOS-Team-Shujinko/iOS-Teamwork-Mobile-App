//
//  ViewController.m
//  ItemCatalog2
//
//  Created by Admin on 11/6/14.
//  Copyright (c) 2014 TeamShujinko. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFQuery *query = [PFQuery queryWithClassName:@"ICItem"];
    NSLog(@"%@",query);
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            NSLog(@"%@",objects);
        }else{
            NSLog(@"greshka");
        }
    }];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
