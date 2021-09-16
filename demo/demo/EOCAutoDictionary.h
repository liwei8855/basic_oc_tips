//
//  EOCAutoDictionary.h
//  demo
//
//  Created by lee on 17/2/28.
//  Copyright © 2017年 lee. All rights reserved.
/*
    动态方法解析来实现@dynamic属性
    类似字典的对象，可以容纳其他对象：直接通过属性来存取其中数据
 设计思路：有开发者添加属性定义，并将其声明为@dynamic，而类则会自动处理相关属性的存放与获取操作
 */

#import <Foundation/Foundation.h>

@interface EOCAutoDictionary : NSObject

@property (strong, nonatomic) NSString *string;
@property (strong, nonatomic) NSNumber *number;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) id opaqueObject;

@end
