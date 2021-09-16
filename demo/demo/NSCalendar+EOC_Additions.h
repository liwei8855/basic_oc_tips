//
//  NSCalendar+EOC_Additions.h
//  demo
//
//  Created by lee on 17/3/7.
//  Copyright © 2017年 lee. All rights reserved.
/*
 返回包含各个月份名称的字符串数组
 只读属性，只需要实现一个方法即可
 */

#import <Foundation/Foundation.h>

@interface NSCalendar (EOC_Additions)

@property (nonatomic, strong, readonly) NSArray *eoc_allMonths;
- (NSArray *)eoc_allMonths;

@end
