//
//  APerson.h
//  objc
//
//  Created by 李威 on 2021/4/6.
//  Copyright © 2021 mjsfax. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APerson : NSObject
@property (nonatomic, strong) NSString *name;
-(void)print;
@end

NS_ASSUME_NONNULL_END
