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
@property (nonatomic) float price;
@property (strong, nonatomic) NSString *seller;
@property (nonatomic) int warranty;
@property (strong, nonatomic) NSString *info;

@property (strong,nonatomic) PFFile *itemImage;


-(instancetype)initWithData:(NSDictionary *)data andImage:(PFFile *)image;

@end
