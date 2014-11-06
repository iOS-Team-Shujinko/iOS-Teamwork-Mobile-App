
#import <Foundation/Foundation.h>

#define ITEM_NAME @"Item Name"
#define ITEM_PRICE @"Item Price"
#define ITEM_SELLER @"Item Seller"
#define ITEM_WARRANTY @"Item Warranty"
#define ITEM_INFO @"Item Info"
#define ITEM_IMAGE @"Image of the Item"

@interface ItemsData : NSObject

+ (NSArray *)allItems; 

@end
