//
//  HitTestView.m
//  demo
//
//  Created by lee on 2017/12/21.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "HitTestView.h"
@interface HitTestView()
@property (strong, nonatomic) UIView *viewA;
@property (strong, nonatomic) UIView *viewB;
@end

@implementation HitTestView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIView *w = [[UIView alloc] initWithFrame:CGRectMake(30, 30, 100, 100)];
        w.backgroundColor = [UIColor orangeColor];
        [self addSubview:w];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    NSLog(@"%@",view);
    return view;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL touch = [super pointInside:point withEvent:event];
    NSLog(@"%d",touch);
    return touch;
}

/*
 * hit-Test是事件分发的第一步，就算你的app忽略了事件，也会发生hit-Test。确定了hit-TestView之后，才会开始进行下一步的事件分发
 */
//实现原理：
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
////    return [super hitTest:point withEvent:event];
//    if (self.alpha<=0.01 || !self.userInteractionEnabled || self.hidden) {
//        return nil;
//    }
//    BOOL inside = [self pointInside:point withEvent:event];
//    UIView *hitView = nil;
//    if (inside) {
//        NSEnumerator *enumerator = [self.subviews reverseObjectEnumerator];
//        for (UIView *subview in enumerator) {
//            hitView = [subview hitTest:point withEvent:event];
//            if (hitView) {
//                break;
//            }
//        }
//        if (!hitView) {
//            hitView = self;
//        }
//        return hitView;
//    }
//    return nil;
//}


//利用hit-test实现：点击了ViewA,让ViewB响应
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView *hitView = [super hitTest:point withEvent:event];
//    if (hitView == self.viewA) {
//        return self.viewB;
//    }
//    return hitView;
//}

/*
 * return YES:触摸事件发生在我自己内部,遍历自己的所有Subview去寻找最小单位
 * return NO:如果当前View.userInteractionEnabled = NO,enabled=NO(UIControl),或者alpha<=0.01, hidden等情况的时候
 *           hitTest就不会调用自己的pointInside了，直接返回nil，然后系统就回去遍历兄弟节点
 */
//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    return YES;
//}

@end
