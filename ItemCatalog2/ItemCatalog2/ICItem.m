//
//  ICItem.m
//  ItemCatalogApp
//
//  Created by m3tr0n0m3 on 11/4/14.
//  Copyright (c) 2014 Shujinko. All rights reserved.
//

#import "ICItem.h"
#import <Parse/PFObject+Subclass.h>

@implementation ICItem

@dynamic info;
@dynamic itemImage;
@dynamic name;
@dynamic warranty;
@dynamic seller;
@dynamic price;



+ (void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName{
    return @"ICItem";
}



@end
