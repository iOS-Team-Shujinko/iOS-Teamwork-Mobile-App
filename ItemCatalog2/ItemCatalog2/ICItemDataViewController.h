//
//  ICItemDataViewController.h
//  ItemCatalogApp
//
//  Created by m3tr0n0m3 on 11/6/14.
//  Copyright (c) 2014 Shujinko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICItem.h"

@interface ICItemDataViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) ICItem *itemObject;

@end
