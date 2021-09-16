//
//  Person.m
//  demo
//
//  Created by lee on 2018/6/8.
//  Copyright © 2018年 lee. All rights reserved.
//

#import "Person.h"

@implementation Person
- (void)eat {
    NSLog(@"吃了");
}

- (void)eatWith:(NSString *)food {
    NSLog(@"%@",food);
}

@end
