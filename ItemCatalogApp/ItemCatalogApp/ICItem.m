//
//  ICItem.m
//  ItemCatalogApp
//
//  Created by m3tr0n0m3 on 11/4/14.
//  Copyright (c) 2014 Shujinko. All rights reserved.
//

#import "ICItem.h"
#import "ItemsData.h"
#import <Parse/PFObject+Subclass.h>

@implementation ICItem

@dynamic info;
@dynamic itemImage;
@dynamic name;
@dynamic warranty;
@dynamic size;
@dynamic price;

-(instancetype)init{
    self = [self initWithData:nil andImage:nil];
    return self;
}

+ (void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName{
    return @"ICItem";
}

-(instancetype)initWithData:(NSDictionary *)data andImage:(PFFile *)image{
    self = [super init];
    
    
    self.name = data[ITEM_NAME];
    self.price = [data[ITEM_PRICE] floatValue];
    self.seller = data[ITEM_SELLER];
    self.warranty = [data[ITEM_WARRANTY] floatValue];
    self.info = data[ITEM_INFO];
//    self.itemImage = data[ITEM_IMAGE];
    
    self.itemImage = image;
    
    return self;
}


@end
