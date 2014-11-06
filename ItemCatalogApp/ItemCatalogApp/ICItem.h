//
//  ICItem.h
//  ItemCatalogApp
//
//  Created by m3tr0n0m3 on 11/4/14.
//  Copyright (c) 2014 Shujinko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ICItem : NSObject

@property (strong, nonatomic) NSString *name;
@property (nonatomic) float price;
@property (strong, nonatomic) NSString *seller;
@property (nonatomic) int warranty;
@property (strong, nonatomic) NSString *info;

@property (strong,nonatomic) UIImage *itemImage;


-(instancetype)initWithData:(NSDictionary *)data andImage:(UIImage *)image;

@end
