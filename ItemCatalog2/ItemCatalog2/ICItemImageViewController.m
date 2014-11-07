//
//  ICItemImageViewController.m
//  ItemCatalogApp
//
//  Created by m3tr0n0m3 on 11/5/14.
//  Copyright (c) 2014 Shujinko. All rights reserved.
//

#import "ICItemImageViewController.h"
#import <UIKit/UIKit.h>

@interface ICItemImageViewController ()

@end

@implementation ICItemImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.delegate = self;
    
    PFFile *userImageFile = self.itemObject.itemImage;
    
    NSData *imageData=[userImageFile getData];
    
    UIImage *image = [UIImage imageWithData:imageData];
    
//    UIGraphicsBeginImageContext(self.view.frame.size);
//    [image drawInRect:self.view.bounds];
//    UIImage *loginBg = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    
    [self.imageView setImage:image];
    
    [self.scrollView setMinimumZoomScale:0.1f];
    [self.scrollView setMaximumZoomScale:5.0f];
    
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    
    [doubleTap setNumberOfTapsRequired:2];
    
    [self.scrollView addGestureRecognizer:doubleTap];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    
    if(self.scrollView.zoomScale > self.scrollView.minimumZoomScale)
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    else
        [self.scrollView setZoomScale:self.scrollView.maximumZoomScale animated:YES];
    
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

@end
