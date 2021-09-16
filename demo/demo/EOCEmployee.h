//
//  EOCEmployee.h
//  demo
//
//  Created by lw on 17/2/25.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, EOCEmployeeType) {
    EOCEmployeeTypeDeveloper,
    EOCEmployeeTypeDesigner,
    EOCEmployeeTypeFinance,
};

@interface EOCEmployee : NSObject

//creating employee objects
+ (EOCEmployee *)employeeWithType:(EOCEmployeeType)type;

//make employees do their respective day's work
- (void)doADaysWork;

//异常处理测试方法
- (void)doSomethingThatMayThrow;

@end
