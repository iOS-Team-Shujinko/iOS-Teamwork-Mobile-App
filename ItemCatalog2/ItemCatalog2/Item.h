//
//  Item.h
//  ItemCatalog2
//
//  Created by Admin on 11/9/14.
//  Copyright (c) 2014 TeamShujinko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Item : NSManagedObject

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * cartOwner;
@property (nonatomic, retain) NSString * info;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDecimalNumber * price;
@property (nonatomic, retain) NSNumber * warranty;
@property (nonatomic, retain) NSString * seller;

@end
