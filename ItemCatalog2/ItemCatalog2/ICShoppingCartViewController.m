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

@interface ICShoppingCartViewController ()

@end

@implementation ICShoppingCartViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self
                            action:@selector(getDataFromServer)
                  forControlEvents:UIControlEventValueChanged];
    
    
    [self getDataFromServer];
    
}



- (void)getDataFromServer{
    
    PFQuery *query = [PFQuery queryWithClassName:@"ICItem"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            self.itemsInCart = [[NSMutableArray alloc] initWithArray:objects];
            [self.tableView reloadData];
            
            [self.refreshControl endRefreshing];
        }else{
            NSLog(@"%@ %@",error, [error userInfo]);
        }
    }];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        if ([segue.destinationViewController isKindOfClass:[ICItemImageViewController class]]) {
            ICItemImageViewController * nextImageViewController = segue.destinationViewController;
            NSIndexPath *path = [self.tableView indexPathForCell:sender];
            ICItem *selectedObject = self.itemsInCart[path.row];
            nextImageViewController.itemObject = selectedObject;
        }
    }
    
    if ([sender isKindOfClass:[NSIndexPath class]]) {
        if ([segue.destinationViewController isKindOfClass:[ICItemDataViewController class]]) {
            ICItemDataViewController *targetViewController = segue.destinationViewController;
            NSIndexPath *path = sender;
            ICItem *selectedObject = self.itemsInCart[path.row];
            targetViewController.itemObject = selectedObject;
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
        return self.itemsInCart.count;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
    
    if (indexPath.section == 1) {
        // todo
    } else {
        ICItem *item = [self.itemsInCart objectAtIndex:indexPath.row];
        
        PFFile *userImageFile = item.itemImage;
        
        NSData *imageData=[userImageFile getData];
        
        UIImage *image = [UIImage imageWithData:imageData];
        
        cell.textLabel.text = item.name;
        cell.detailTextLabel.text = item.info;
        cell.imageView.image = image;
    }
    
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

