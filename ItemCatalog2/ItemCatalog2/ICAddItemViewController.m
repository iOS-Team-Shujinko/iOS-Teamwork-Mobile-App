//
//  ICAddItemViewController.m
//  ItemCatalogApp
//
//  Created by m3tr0n0m3 on 11/6/14.
//  Copyright (c) 2014 Shujinko. All rights reserved.
//

#import "ICAddItemViewController.h"
#import <Parse/Parse.h>

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

- (ICItem *)newItemObject{
    ICItem *addedItemObject = [[ICItem alloc]init];
    
    addedItemObject.name = self.nameField.text;
    addedItemObject.price = [self.priceField.text floatValue];
    addedItemObject.seller = self.sellerFIeld.text;
    addedItemObject.warranty = [self.warrantyField.text floatValue];
    addedItemObject.info = self.infoField.text;
   [addedItemObject saveInBackground];
    return addedItemObject;
}



@end
;