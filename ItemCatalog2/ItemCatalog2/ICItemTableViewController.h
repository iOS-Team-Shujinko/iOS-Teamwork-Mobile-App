//
//  ICItemTableViewController.h
//  ItemCatalogApp
//
//  Created by m3tr0n0m3 on 11/4/14.
//  Copyright (c) 2014 Shujinko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICAddItemViewController.h"

@interface ICItemTableViewController : UITableViewController <ICAddItemViewControllerDelegate,PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSMutableArray *addedItems;
@end
