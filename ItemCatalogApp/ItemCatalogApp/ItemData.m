
#import "ItemsData.h"

@implementation ItemsData


+ (NSArray *)allItems
{
    NSMutableArray *itemInformation = [@[] mutableCopy];
    
    NSDictionary *item1Dictionary = @{ITEM_NAME : @"Beer", ITEM_PRICE : @3.7, ITEM_SELLER : @"Pesho", ITEM_WARRANTY : @12, ITEM_INFO : @"Beer - good for drinking..."};
    [itemInformation addObject:item1Dictionary];
    
    NSDictionary *item2Dictionary = @{ITEM_NAME : @"Coca-Cola", ITEM_PRICE : @8.9, ITEM_SELLER : @"Gosho", ITEM_WARRANTY : @12, ITEM_INFO : @"Coca Cola baby"};
    [itemInformation addObject:item2Dictionary];
    
    NSDictionary *item3Dictionary = @{ITEM_NAME : @"Bubblegum", ITEM_PRICE : @9.8, ITEM_SELLER : @"Kiro", ITEM_WARRANTY : @24, ITEM_INFO : @"For chewing"};
    [itemInformation addObject:item3Dictionary];
    
    NSDictionary *item4Dictionary = @{ITEM_NAME : @"Coffee", ITEM_PRICE : @3.7, ITEM_SELLER : @"Misho", ITEM_WARRANTY : @12, ITEM_INFO : @"Mmmmm"};
    [itemInformation addObject:item4Dictionary];
        
    return [itemInformation copy];
}

@end
