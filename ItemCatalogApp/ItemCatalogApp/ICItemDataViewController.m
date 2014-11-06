//
//  ICItemDataViewController.m
//  ItemCatalogApp
//
//  Created by m3tr0n0m3 on 11/6/14.
//  Copyright (c) 2014 Shujinko. All rights reserved.
//

#import "ICItemDataViewController.h"

@interface ICItemDataViewController ()

@end

@implementation ICItemDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"DataCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Item Name: ";
            cell.detailTextLabel.text = self.itemObject.name;
            break;
        case 1:
            cell.textLabel.text = @"Price: ";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%f", self.itemObject.price];
            break;
        case 2:
            cell.textLabel.text = @"Seller Name: ";
            cell.detailTextLabel.text = self.itemObject.seller;
            break;
        case 3:
            cell.textLabel.text = @"Item Warranty: ";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", self.itemObject.warranty];
            break;
        case 4:
            cell.textLabel.text = @"Item Info: ";
            cell.detailTextLabel.text = self.itemObject.info;
            break;
        default:
            break;
    }
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
