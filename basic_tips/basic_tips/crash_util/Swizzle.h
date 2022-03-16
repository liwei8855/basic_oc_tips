//
//  NSObject+Swizzle.h
//  OPCategories
//
//  Created by 李威 on 2019/2/16.
//  Copyright © 2019年 Opera Software. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Swizzle)
+ (void)swizzleMethod:(SEL)method newMethod:(SEL)newMethod isClassMethod:(BOOL)classType;
@end

NS_ASSUME_NONNULL_END
