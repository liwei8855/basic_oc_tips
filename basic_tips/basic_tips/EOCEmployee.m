//
//  EOCEmployee.m
//  demo
//
//  Created by lw on 17/2/25.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "EOCEmployee.h"
#import "EOCEmployeeDesigner.h"
#import "EOCEmployeeFinance.h"
#import "EOCEmployeeDeveloper.h"

@interface EOCEmployee()

@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) NSUInteger salary;

@end

@implementation EOCEmployee

//父类统一通过type创建子类 使接口简单
+ (EOCEmployee *)employeeWithType:(EOCEmployeeType)type {
    switch (type) {
        case EOCEmployeeTypeDeveloper:{
            return [EOCEmployeeDeveloper new];
            break;
        }
        case EOCEmployeeTypeDesigner: {
            return [EOCEmployeeDesigner new];
            break;
        }
        case EOCEmployeeTypeFinance: {
            return [EOCEmployeeFinance new];
            break;
        }
    }
}

- (void)doADaysWork {

}

#pragma mark - exception test function
- (void)doSomethingThatMayThrow {
    NSLog(@"throw exception");
}

@end
