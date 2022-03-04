//
//  CrashUtilTest.m
//  basic_tipsTests
//
//  Created by 李威 on 2022/3/3.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>

@interface CrashUtilTest : XCTestCase

@end

@implementation CrashUtilTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}
//这里测试有bug，一些输出NSConstantArray，不是正确的类型
- (void)testArrayType {
    NSArray *arr = @[];//__NSArray0
    NSArray *arr1 = @[@"123"];//__NSSingleObjectArrayI
    NSArray *arr2 = @[@""];//__NSSingleObjectArrayI
    NSArray *arr3 = @[@"a",@"b"];//__NSArrayI
    NSArray *arr4 = @[@"",@""];//__NSArrayI
    NSArray *arr5 = @[@1];//__NSSingleObjectArrayI
    NSArray *arr6 = @[@1,@2];//__NSArrayI
    NSMutableArray *marr = NSMutableArray.array; //__NSArrayM
    NSLog(@"%s",class_getName(arr.class));
    NSLog(@"%s",class_getName(arr1.class));
    NSLog(@"%s",class_getName(arr2.class));
    NSLog(@"%s",class_getName(arr3.class));
    NSLog(@"%s",class_getName(arr4.class));
    NSLog(@"%s",class_getName(arr5.class));
    NSLog(@"%s",class_getName(arr6.class));
    NSLog(@"%s",class_getName(marr.class));
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
