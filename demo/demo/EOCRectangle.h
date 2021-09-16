//
//  EOCRectangle.h
//  demo
//
//  Created by lee on 17/3/2.
//  Copyright © 2017年 lee. All rights reserved.
/*
 全能初始化方法：可为对象提供必要信息以便其能完成工作的初始化方法
 一个矩形类，把属性声明为只读，所以需要初始化方法设置属性
 */

#import <Foundation/Foundation.h>

@interface EOCRectangle : NSObject

@property (assign, nonatomic, readonly) float width;
@property (assign, nonatomic, readonly) float height;

- (instancetype)initWithWidth:(float)width andHeight:(float)height;
- (instancetype)initWithCoder:(NSCoder *)decoder;

@end
