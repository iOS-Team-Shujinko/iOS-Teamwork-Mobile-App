//
//  ICItemTableViewController.m
//  ItemCatalogApp
//
//  Created by m3tr0n0m3 on 11/4/14.
//  Copyright (c) 2014 Shujinko. All rights reserved.
//

#import "ICItemTableViewController.h"
#import "ItemsData.h"
#import "ICItem.h"
#import "ICItemImageViewController.h"
#import <Parse/Parse.h>
#import "ICItemDataViewController.h"

@interface ICItemTableViewController ()

@end

@implementation ICItemTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.items = [[NSMutableArray alloc] init];
    
//    PFQuery *query = [PFQuery queryWithClassName:@"ICItem"];
//    NSLog(@"%@",query);
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if(!error){
//            NSLog(@"tuk");
//        }else{
//            NSLog(@"greshka");
//        }
//    }];
    
    for (NSMutableDictionary *itemData in [ItemsData allItems]){
        NSString *imageName = [NSString stringWithFormat:@"%@.jpg", itemData[ITEM_NAME]];
        
        UIImage* imageToAdd = [UIImage imageNamed: imageName];
        NSData *imageData = UIImagePNGRepresentation(imageToAdd);
        PFFile *imageFile = [PFFile fileWithName:imageName data:imageData];
        
        ICItem *item = [[ICItem alloc]initWithData:itemData andImage: imageFile];
        [self.items addObject:item];
        [item saveInBackground];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        if ([segue.destinationViewController isKindOfClass:[ICItemImageViewController class]]) {
            ICItemImageViewController * nextImageViewController = segue.destinationViewController;
            NSIndexPath *path = [self.tableView indexPathForCell:sender];
            ICItem *selectedObject = self.items[path.row];
            nextImageViewController.itemObject = selectedObject;
        }
    }
    
    if ([sender isKindOfClass:[NSIndexPath class]]) {
        if ([segue.destinationViewController isKindOfClass:[ICItemDataViewController class]]) {
            ICItemDataViewController *targetViewController = segue.destinationViewController;
            NSIndexPath *path = sender;
            ICItem *selectedObject = self.items[path.row];
            targetViewController.itemObject = selectedObject;
        }
    }
    
    if ([segue.destinationViewController isKindOfClass:[ICAddItemViewController class]]) {
        ICAddItemViewController *addItemObject = segue.destinationViewController;
        addItemObject.delegate = self;
        
    }
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didCancel{
    NSLog(@"did cancel");
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addObject:(ICItem *)itemObject{
    
    if (!self.addedItems) {
        self.addedItems = [[NSMutableArray alloc] init];
        [self.addedItems addObject:itemObject];
        
    }
    NSLog(@"add items");
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if ([self.addedItems count]) {
        return 2;
    }else{
        return 1;    
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return self.addedItems.count;
    }else{
        return self.items.count;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
    
    if (indexPath.section == 1) {
        // todo
    } else {
        ICItem *item = [self.items objectAtIndex:indexPath.row];
    
        PFFile *userImageFile = item.itemImage;
   
        NSData *imageData=[userImageFile getData];
    
        UIImage *image = [UIImage imageWithData:imageData];
    
        cell.textLabel.text = item.name;
        cell.detailTextLabel.text = item.info;
        cell.imageView.image = image;
    }
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageView.clipsToBounds = YES;
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

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
