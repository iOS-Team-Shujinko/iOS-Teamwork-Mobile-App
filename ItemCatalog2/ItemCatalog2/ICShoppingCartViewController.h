//
//  ICShoppingCartViewController.h
//  ItemCatalog2
//
//  Created by Admin on 11/8/14.
//  Copyright (c) 2014 TeamShujinko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICShoppingCartViewController : UITableViewController

- (IBAction)buyAllButton:(UIBarButtonItem *)sender;
@property (strong, nonatomic) NSMutableArray *itemsInCart;
@end
