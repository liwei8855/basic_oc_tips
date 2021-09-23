//
//  TouchEventsViewController.m
//  demo
//
//  Created by lee on 2017/12/21.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "TouchEventsViewController.h"
#import "HitTestView.h"

@interface TouchEventsViewController ()
@property (assign, nonatomic) NSInteger count;
@property (strong, nonatomic) HitTestView *viewA;
@property (strong, nonatomic) HitTestView *viewB;
@end

@implementation TouchEventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    HitTestView *viewA = [[HitTestView alloc] initWithFrame:CGRectMake(50, 100, 200, 200)];
    viewA.backgroundColor = [UIColor redColor];
//    viewA.hitTestBlock = ^UIView *(CGPoint point, UIEvent *event, BOOL *returnSuper) {
//        NSLog(@"%@===%@===%d",NSStringFromCGPoint(point),event,*returnSuper);
//        return weakSelf.viewB;
//    };
    self.viewA = viewA;
    [self.view addSubview:self.viewA];
    
    HitTestView *viewB = [[HitTestView alloc] initWithFrame:CGRectMake(50, 350, 200, 200)];
    viewB.backgroundColor = [UIColor greenColor];
//    viewB.hitTestBlock = ^UIView *(CGPoint point, UIEvent *event, BOOL *returnSuper) {
//        NSLog(@"%@===%@===%d",NSStringFromCGPoint(point),event,*returnSuper);
//        return weakSelf.viewA;
//    };
    self.viewB = viewB;
    [self.view addSubview:self.viewB];
    
}


@end
