//
//  EOCRectangle.m
//  demo
//
//  Created by lee on 17/3/2.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "EOCRectangle.h"

@implementation EOCRectangle

- (instancetype)initWithWidth:(float)width andHeight:(float)height {

    if (self = [super init]) {
        _width = width;
        _height = height;
    }
    return self;
}

//using default values
- (instancetype)init {
    return [self initWithWidth:5.0f andHeight:10.0f];
}

//throwing an exception
//- (instancetype)init {
//    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Must use initWithWidth: andHeight: instead." userInfo:nil];
//}

//Initializer from NSCoding
- (instancetype)initWithCoder:(NSCoder *)decoder {

    if (self = [super init]) {
        _width = [decoder decodeFloatForKey:@"width"];
        _height = [decoder decodeFloatForKey:@"height"];
    }
    return self;
}

@end
