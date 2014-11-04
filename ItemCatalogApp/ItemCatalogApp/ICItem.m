//
//  ICItem.m
//  ItemCatalogApp
//
//  Created by m3tr0n0m3 on 11/4/14.
//  Copyright (c) 2014 Shujinko. All rights reserved.
//

#import "ICItem.h"
#import "ItemsData.h"

@implementation ICItem

-(instancetype)init{
    self = [self initWithData:nil andImage:nil];
    return self;
}

-(instancetype)initWithData:(NSDictionary *)data andImage:(UIImage *)image{
    self = [super init];
    
    
    self.name = data[ITEM_NAME];
    self.price = [data[ITEM_PRICE] floatValue];
    self.size = [data[ITEM_SIZE] floatValue];
    self.warranty = [data[ITEM_WARRANTY] floatValue];
    self.info = data[ITEM_INFO];
    self.itemImage = data[ITEM_IMAGE];
    
    self.itemImage = image;
    
    return self;
}


@end
