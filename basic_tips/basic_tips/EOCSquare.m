//
//  EOCSquare.m
//  demo
//
//  Created by lee on 17/3/2.
//  Copyright © 2017年 lee. All rights reserved.


#import "EOCSquare.h"

@implementation EOCSquare

/*
 调用超类的全能初始化方法，来实现本类的全能初始化方法
 */
- (instancetype)initWithDimension:(float)dimension {
    return [super initWithWidth:dimension andHeight:dimension];
}

//全能初始化方法的调用链一定要维系。
//问题：继承者可能会调用超类的initWithWidth: andHeight:方法创建出长宽不等的正方形
//子类的全能初始化方法与超类方法名称不同，应覆写超类的全能初始化方法
- (instancetype)initWithWidth:(float)width andHeight:(float)height {
    float dimension = MAX(width, height);
    return [self initWithWidth:dimension andHeight:dimension];
}


//不想默认最大值初始化，想抛出异常
//- (instancetype)initWithWidth:(float)width andHeight:(float)height {
//    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"must use initWithDimension instead." userInfo:nil];
//}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        // EOCSquare's specific initializer
    }
    return self;
}

@end
