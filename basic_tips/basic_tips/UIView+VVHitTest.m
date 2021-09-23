//
//  UIView+VVHitTest.m
//  demo
//
//  Created by lee on 2017/12/21.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UIView+VVHitTest.h"
#import <objc/runtime.h>

@implementation UIView (VVHitTest)

const static NSString *VVHitTestViewBlockKey = @"VVHitTestViewBlockKey";
const static NSString *VVPointInsideBlockKey = @"VVPointInsideBlockKey";

+ (void)load {
//    method_exchangeImplementations(class_getInstanceMethod(self, @selector(hitTest:withEvent:)), class_getInstanceMethod(self, @selector(vv_hitTest:withEvent:)));
//    method_exchangeImplementations(class_getInstanceMethod(self, @selector(pointInside:withEvent:)), class_getInstanceMethod(self, @selector(vv_pointInside:withEvent:)));
}

- (UIView *)vv_hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSMutableString *spaces = [NSMutableString stringWithCapacity:20];
    UIView *superView = self.superview;//最外层view
    while (superView) {
        [spaces appendString:@";---"];
        superView = superView.superview;
    }
    NSLog(@"%@%@:[hitTest:withEvent:]",spaces,NSStringFromClass(self.class));
    UIView *deliveredView = nil;
    if (self.hitTestBlock) {
        BOOL returnSuper = NO;
        deliveredView = self.hitTestBlock(point, event, &returnSuper);
        if (returnSuper) {
            deliveredView = [self vv_hitTest:point withEvent:event];
        }
    } else {
        deliveredView = [self vv_hitTest:point withEvent:event];
    }
    return deliveredView;
}

- (BOOL)vv_pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    NSMutableString *spaces = [NSMutableString stringWithCapacity:20];
    UIView *superView = self.superview;
    while (superView) {
        [spaces appendString:@";---"];
        superView = superView.superview;
    }
    NSLog(@"%@%@:[pointInside:withEvent:]",spaces, NSStringFromClass(self.class));
    BOOL pointInside = NO;
    if (self.pointInsideBlock) {
        BOOL returnSuper = NO;
        pointInside = self.pointInsideBlock(point, event, &returnSuper);
        if (returnSuper) {
            pointInside = [self vv_pointInside:point withEvent:event];
        }
    } else {
        pointInside = [self vv_pointInside:point withEvent:event];
    }
    return pointInside;
}

- (void)setHitTestBlock:(VVHitTestViewBlock)hitTestBlock {
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(VVHitTestViewBlockKey), hitTestBlock, OBJC_ASSOCIATION_COPY);
}

- (VVHitTestViewBlock)hitTestBlock {
    return objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(VVHitTestViewBlockKey));
}

- (void)setPointInsideBlock:(VVPointInsideBlock)pointInsideBlock {
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(VVPointInsideBlockKey), pointInsideBlock, OBJC_ASSOCIATION_COPY);
}

- (VVPointInsideBlock)pointInsideBlock {
    return objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(VVPointInsideBlockKey));
}
@end
