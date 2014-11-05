//
//  ICItemImageViewController.h
//  ItemCatalogApp
//
//  Created by m3tr0n0m3 on 11/5/14.
//  Copyright (c) 2014 Shujinko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICItem.h"

@interface ICItemImageViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) ICItem *itemObject;

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer;

@end
