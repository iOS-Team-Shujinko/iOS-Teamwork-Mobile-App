//
//  ICAddItemViewController.h
//  ItemCatalogApp
//
//  Created by m3tr0n0m3 on 11/6/14.
//  Copyright (c) 2014 Shujinko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICItem.h"

@protocol ICAddItemViewControllerDelegate <NSObject>

@required

- (void)addObject:(ICItem *)itemObject;
- (void)didCancel;

@end


@interface ICAddItemViewController : UIViewController

@property (weak, nonatomic) id <ICAddItemViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *priceField;
@property (strong, nonatomic) IBOutlet UITextField *sellerFIeld;
@property (strong, nonatomic) IBOutlet UITextField *warrantyField;
@property (strong, nonatomic) IBOutlet UITextField *infoField;
- (IBAction)addButtonTap:(UIButton *)sender;
- (IBAction)cancelButtonTap:(UIButton *)sender;

@end
