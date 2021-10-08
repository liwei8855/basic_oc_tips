//
//  GCDTimerController.m
//  basic_tips
//
//  Created by 李威 on 2021/10/8.
//

#import "GCDTimerController.h"
#import "GCDTimer.h"

@interface GCDTimerController ()
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, copy) NSString *taskName;
@end

@implementation GCDTimerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button setTitle:@"dismiss" forState:UIControlStateNormal];
    [self.button setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    [self.view addSubview:self.button];
    [self.button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
//    [self gcdTimerTest];
    [self test];
}

- (void)dismiss {
//    [GCDTimer cancelTask:self.taskName];
    [self dismissViewControllerAnimated:YES completion:^{
            
    }];
}

- (void)dealloc {
    [GCDTimer cancelTask:self.taskName];
}

- (void)viewWillLayoutSubviews {
    self.button.frame = CGRectMake(100, 200, 100, 50);
}


///测试封装的gcd定时器

- (void)test {
    //必须手动cancelTask否则内存泄漏：需要timer内部优化一下
//    self.taskName = [GCDTimer execTask:self selector:@selector(doTask) start:2.0 interval:1.0 repeats:YES async:NO];
    
    //不需要手动cancelTask
    self.taskName = [GCDTimer execTask:^{
        NSLog(@"aaaaa - %@", [NSThread currentThread]);
    } start:2.0 interval:1.0 repeats:YES async:NO];
}

- (void)doTask {
    NSLog(@"doTask - %@", [NSThread currentThread]);
}

///cd定时器核心代码

- (void)gcdTimerTest {
    dispatch_queue_t queue = dispatch_queue_create("timer", DISPATCH_QUEUE_SERIAL);//串行队列
    // 创建定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 设置时间
    uint64_t start = 2.0;// 2秒后开始执行
    uint64_t interval = 1.0;// 每隔1秒执行
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, start*NSEC_PER_SEC), interval*NSEC_PER_SEC, 0);
    // 设置回调
//    dispatch_source_set_event_handler(timer, ^{
//        NSLog(@"aaaa");
//    });
    dispatch_source_set_event_handler_f(timer, timerHandler);
    // 启动定时器
    dispatch_resume(timer);
    self.timer = timer;
}

void timerHandler(void *param){
    NSLog(@"aaaa - %@",[NSThread currentThread]);
}

@end
