//
//  DrawView.m
//  basic_tips
//
//  Created by 李威 on 2022/3/17.
//

#import "DrawView.h"
#import "DrawUtil.h"

@implementation DrawView



- (void)drawRect:(CGRect)rect {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"%@",[NSThread currentThread]);
        NSString *text = @"abadgsg";
        CGContextRef context = UIGraphicsGetCurrentContext();
        [[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1] set];
        CGContextFillRect(context, rect);
//        [DrawUtil drawText:text InRect:rect withFont:[UIFont systemFontOfSize:16] inContext:context alignment:NSTextAlignmentCenter];
        NSLog(@"%@",[NSThread currentThread]);
    });
}

- (void)draw:(CGRect)rect {
    NSString *text = @"abadgsg";
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1] set];
    CGContextFillRect(context, rect);
    [DrawUtil drawText:text InRect:rect withFont:[UIFont systemFontOfSize:16] inContext:context alignment:NSTextAlignmentCenter];
}

@end
