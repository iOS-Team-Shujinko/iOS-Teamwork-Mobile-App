//
//  ICItem.h
//  ItemCatalogApp
//
//  Created by m3tr0n0m3 on 11/4/14.
//  Copyright (c) 2014 Shujinko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ICItem : PFObject<PFSubclassing>

@property (strong, nonatomic) NSString *name;
@property (nonatomic) NSNumber* price;
@property (strong, nonatomic) NSString *seller;
@property (nonatomic) NSNumber* warranty;
@property (strong, nonatomic) NSString *info;
@property (strong, nonatomic) NSString *address;
@property (strong,nonatomic) PFUser* user;
@property (strong,nonatomic) PFFile *itemImage;

@end
