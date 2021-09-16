//
//  UIView+ViewController.h
//  demo
//
//  Created by lee on 2017/12/21.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ViewController)

@property (strong, nonatomic, readonly) UIViewController *viewController;

- (UIViewController *)viewController;
- (UIResponder *)findFirstResponder;
@end
