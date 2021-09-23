//
//  LiveThreadViewController.m
//  basic_tips
//
//  Created by 李威 on 2021/9/23.
//

#import "LiveThreadViewController.h"
#import "LiveThread.h"
#import "PermenantThread.h"//封装好的保活线程

@interface LiveThreadViewController ()
@property (nonatomic, strong) LiveThread *thread;
@property (nonatomic, assign) BOOL isStop;
@property (nonatomic, strong) UIButton *stopButton;

@property (nonatomic, strong) PermenantThread *permenantThread;
@end

@implementation LiveThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.stopButton.frame = CGRectMake(100, 200, 80, 40);
}

- (void)setup {
    self.stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.stopButton setTitle:@"stop" forState:UIControlStateNormal];
    [self.stopButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.stopButton addTarget:self action:@selector(actionStop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.stopButton];
    
//    [self createThread];
    [self createPermenantThread];
    NSLog(@"aaaaa");
}
//封装的保活线程
- (void)createPermenantThread {
    self.permenantThread = [[PermenantThread alloc]init];
}
//未封装的线程
- (void)createThread {
    __weak typeof(self) weakSelf = self;
    self.isStop = NO;
    self.thread = [[LiveThread alloc]initWithBlock:^{
        NSLog(@"%@----begin----", [NSThread currentThread]);
        
        // 往RunLoop里面添加Source\Timer\Observer
        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc]init] forMode:NSDefaultRunLoopMode];
        
        while (weakSelf && !weakSelf.isStop) {
            //distantFuture 表示未来的某个不可达到的事件点 4001-01-01 00:00:00 +0000 公元4001年1月1日0点0分0秒
            //distantPast 表示过去的某个不可达到的事件点 0001-01-01 00:00:00 +0000 公元一年1月1日0点0分0秒
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        
        NSLog(@"%@----end----", [NSThread currentThread]);
    }];
//    [self.thread start];
    [self.thread main];//放到主线程执行,NSRunLoop操作会发生死锁
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self runThread];//执行未封装的线程
    [self runPthread];//执行封装的线程
}
- (void)runPthread {
    [self.permenantThread executeTask:^{
        NSLog(@"执行任务 - %@", [NSThread currentThread]);
    }];
}
- (void)runThread {
    if (!self.thread) {
        return;
    }
    [self performSelector:@selector(test) onThread:self.thread withObject:nil waitUntilDone:NO];
}

- (void)test {
    NSLog(@"%s %@", __func__, [NSThread currentThread]);
}
- (void)actionStop {
    [self.permenantThread stop];//停止封装的线程
//    [self stopThread];//停止未封装的线程
}

- (void)stopThread {
    if (!self.thread) {
        return;
    }
    // 在子线程调用stop（waitUntilDone设置为YES，代表子线程的代码执行完毕后，这个方法才会往下走）
    [self performSelector:@selector(customStopThread) onThread:self.thread withObject:nil waitUntilDone:YES];
}

- (void)customStopThread {
    self.isStop = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    NSLog(@"%s %@", __func__, [NSThread currentThread]);
    self.thread = nil;
}

- (void)dealloc {
    [self actionStop];
}

@end
