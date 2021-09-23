//
//  BlockViewController.m
//  demo
//
//  Created by lw on 17/2/25.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "BlockViewController.h"
#import "TestView.h"
typedef void(^captureBlk)();
captureBlk capture2;

@interface BlockViewController ()

@property(nonatomic,strong) TestView *testView;

@end

@implementation BlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self blockTest];
    //    [self paramBlockTest];
    //    [self typedefDemo];
    //    [self queryOutParam];
    //    [self changeOutParam];
    //    [self testBlockAsParam];
//    self.testView = [TestView createTestView];
    
    [self cap];
    capture2();
//    [self block];
}

- (void)block {
    __block int num = 10;
    NSLog(@"%p",&num);
    void (^blo)() = ^() {
        sleep(3);
        NSLog(@"==%d==%p==%@",num,&num,[NSThread currentThread]);
        num = 1000;
    };
    num = 20;
    blo();
    NSLog(@"==%d===%p==%@",num,&num,[NSThread currentThread]);
}

- (void)cap {
    int cap = 1;
    NSLog(@"%p",&cap);
    capture2 = ^(){
        NSLog(@"num=%d==%p",cap,&cap);
    };
    cap = 2;
    NSLog(@"num=%d==%p",cap,&cap);
}



//测试控制器与testView间blok调用
//此方法调用一次 testview中block执行一次
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//
//    [self.testView testButtonClick:^{
//        NSLog(@"test view button click");
//    }];
//}

#pragma mark - block递归
/*
 block必须是全局变量或者静态变量
 保证程序启动的时候代码块变量就初始化了，可以递归
*/
static void (^const blocks)(int) = ^(int i) {
    if (i) {
        blocks(i-1);
    }
};

/*六、block作为参数传递*/

- (void)blockAsParam:(void(^)())param {
    param();
}

- (void)testBlockAsParam {
    
    [self blockAsParam:^{
        NSLog(@"block as param");
    }];
}

/*五、修改block外部变量，利用__block*/

- (void)changeOutParam {
    
    __block int i = 1;
    //i的值可以在block中修改，忽略校验，（相当于全局变量，可以修改）
    //注意地址变化：__block修饰后的i，使用的都是堆中变量
    NSLog(@"i=%d,addr=%p",i,&i);
    
    void (^test)() = ^() {
        
        NSLog(@"i=%d,addr=%p",i,&i);
        //地址不一样说明：block把外部变量以const形式copy到堆
        //const形式：为了不在block中修改外部变量
        i = 5;
        /*block内部修改外部变量*/
        
        
    };
    test();
    
    NSLog(@"i=%d,addr=%p",i,&i);
    
}

/*四、访问block外部变量*/
- (void)queryOutParam {
    
    int i = 1;
    NSLog(@"i=%d,addr=%p",i,&i);
    
    void (^test)() = ^() {
        
        NSLog(@"i=%d,addr=%p",i,&i);
        //地址不一样说明：block把外部变量以const形式copy到堆
        //const形式：为了不在block中修改外部变量
        //i = 2; 报错 无法直接修改
        
    };
    test();
    
    i = 2;
    NSLog(@"i=%d,addr=%p",i,&i);
    
}


/*三、typedef定义block变量*/
- (void)typedefDemo {
    
    //typedef 起别名
    //typedef int INT; // 给int起别名
    //typedef int ARR[4]; // 定义一个长度为4的数组
    
    //无参数
    typedef void(^test)(); //给返回值是void 没有参数策代码块起别名test
    //test = ^() {}; //test 是一个类型 不是变量 赋值报错
    test block1; // 用类型定义变量  test：类型 block1：变量，可以存储代码块，可赋值
    block1 = ^() {
        NSLog(@"typedef block1");
    };
    block1();
    
    //有参数
    typedef void(^paramBlock)(int a);
    paramBlock testParam;
    testParam = ^(int a) {
        NSLog(@"typedef test papram a = %d",a);
    };
    testParam(10);
    
    //有参数返回值
    typedef int(^max)(int sum1,int sum2);
    max maxValue;
    maxValue = ^(int value1,int value2) {
        return value1 > value2 ? value1 : value2;
    };
    int maxV = maxValue(3,5);
    NSLog(@"max = %d",maxV);
    
}

/*二、带参数block*/
- (void)paramBlockTest {
    
    //无返回值
    void (^test)(int a);
    test = ^(int a) {
        NSLog(@"a=%d",a);
    };
    //有返回值
    int (^sum)(int a, int b) = ^(int a, int b) {
        return a + b;
    };
    
    int value = sum(1,3); //＊＊要一个参数接收返回值 记录住 (控制器间传值 易犯 不记录错误 导致接受不到)
    NSLog(@"sum = %d",value);
    
}

/*一、初始化*/
- (void)blockTest {
    
    //定义
    // 返回值类型 (^block变量名)(形参列表)=^(形参列表){ //code };
    
    void (^testBlock)();  //定义变量
    void (^test1)() = ^() {
        NSLog(@"test1");
    };
    
    /*没有初始化，掉用报错*/
    testBlock();
    //正常初始化 掉用没问题
    test1();
    
}

@end
