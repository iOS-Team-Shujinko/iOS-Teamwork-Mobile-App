//
//  ICShoppingCartViewController.m
//  ItemCatalog2
//
//  Created by Admin on 11/8/14.
//  Copyright (c) 2014 TeamShujinko. All rights reserved.
//

#import "ICShoppingCartViewController.h"
#import "ICItemTableViewController.h"
#import "ICItem.h"
#import "ICItemImageViewController.h"
#import <Parse/Parse.h>
#import "ICItemDataViewController.h"
#import <CoreData/CoreData.h>
#import "Item.h"

@interface ICShoppingCartViewController ()

@end

@implementation ICShoppingCartViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self
                            action:@selector(getDataFromCoreData)
                  forControlEvents:UIControlEventValueChanged];
    
    
    [self getDataFromCoreData];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self getDataFromCoreData];
}

- (IBAction)buyAllButton:(UIBarButtonItem *)sender {
    
    id delegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    [fetchRequest setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * items = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject * item in items) {
        [context deleteObject:item];
    }
    NSError *saveError = nil;
    [context save:&saveError];
    
    [self getDataFromCoreData];
    
    [[[UIAlertView alloc] initWithTitle:@"YES!" message:@"You just bought all items in your cart :)" delegate:nil cancelButtonTitle:@"Yay !!!" otherButtonTitles:nil, nil]show];
}

- (void)getDataFromCoreData{
    
    id delegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    NSString *predicateText = [NSString stringWithFormat:@"(cartOwner LIKE[c] '%@')", [PFUser currentUser].username];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateText];
    
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *coreDataObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    self.itemsInCart = [[NSMutableArray alloc] initWithArray:coreDataObjects];
    
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];

}

-(ICItem*) convertToICItem: (Item*) fromCoreDataItem{
    
    ICItem* itemToReturn = [[ICItem alloc] init];
    
    itemToReturn.name = fromCoreDataItem.name;
    itemToReturn.price = fromCoreDataItem.price;
    itemToReturn.warranty = fromCoreDataItem.warranty;
    itemToReturn.info = fromCoreDataItem.info;
    itemToReturn.seller = fromCoreDataItem.seller;
    
    NSString* filename = [NSString stringWithFormat:@"%@.png", fromCoreDataItem.name];
    PFFile* imageFile = [PFFile fileWithName:filename data:fromCoreDataItem.image];
    
    itemToReturn.itemImage = imageFile;
    
    return itemToReturn;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        if ([segue.destinationViewController isKindOfClass:[ICItemImageViewController class]]) {
            ICItemImageViewController * nextImageViewController = segue.destinationViewController;
            NSIndexPath *path = [self.tableView indexPathForCell:sender];
            Item *selectedObject = self.itemsInCart[path.row];
            ICItem *convertedItem = [self convertToICItem:selectedObject];
            nextImageViewController.itemObject = convertedItem;
        }
    }
    
    if ([sender isKindOfClass:[NSIndexPath class]]) {
        if ([segue.destinationViewController isKindOfClass:[ICItemDataViewController class]]) {
            ICItemDataViewController *targetViewController = segue.destinationViewController;
            NSIndexPath *path = sender;
            Item *selectedObject = self.itemsInCart[path.row];
            ICItem *convertedItem = [self convertToICItem:selectedObject];
            targetViewController.itemObject = convertedItem;
        }
    }
   
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didCancel{
    NSLog(@"did cancel");
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return self.itemsInCart.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
    
    Item *item = [self.itemsInCart objectAtIndex:indexPath.row];
       
    UIImage  *image = [UIImage imageWithData:item.image];
    cell.imageView.image = image;
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = item.info;
    
    CGSize itemSize = CGSizeMake(40, 40);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return cell;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"ItemData" sender:indexPath];
}



/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
     if (editingStyle == UITableViewCellEditingStyleDelete) {
         
         Item *item = [self.itemsInCart objectAtIndex:indexPath.row];
         
         id delegate = [[UIApplication sharedApplication] delegate];
         NSManagedObjectContext *context = [delegate managedObjectContext];
         NSError *error = nil;
         [context deleteObject:item];
         [context save:&error];
         [self.itemsInCart removeObjectAtIndex:indexPath.row];
         [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
         
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
 }


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

