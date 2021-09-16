//
//  Teacher.m
//  demo
//
//  Created by lee on 2018/6/8.
//  Copyright © 2018年 lee. All rights reserved.
//

#import "Teacher.h"

@implementation Teacher
- (void)eatWith:(NSString *)food {
    [super eatWith:food];
    NSLog(@"子类方法：%@",food);
}
@end
