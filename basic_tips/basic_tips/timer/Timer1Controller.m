//
//  Timer1Controller.m
//  basic_tips
//
//  Created by 李威 on 2021/10/8.
//

#import "Timer1Controller.h"
#import "TimerProxy.h"

@interface Timer1Controller ()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIButton *button;
@end

@implementation Timer1Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button setTitle:@"dismiss" forState:UIControlStateNormal];
    [self.button setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    [self.view addSubview:self.button];
    [self.button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self setup];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:^{
            
    }];
}

- (void)viewWillLayoutSubviews {
    self.button.frame = CGRectMake(100, 200, 100, 50);
}
- (void)setup {
//一、block形式
    //block形式不会产生循环引用，因为block没有被持有
    //不用self.timer持有timer，timer也不会释放，只有持有timer后invalidate才能正常释放
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        NSLog(@"aaaaa");
//    }];
//二、非block形式
    //timer不能正常释放
    // vc -> timer -> vc(以target形式持有vc)
    //由于不能释放可推断出NSTimer内部对target:self传入的target进行了持有导致内存不能释放
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(start) userInfo:nil repeats:YES];
    //对于上述内存泄漏问题 解决：通过代理proxy
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:[TimerProxy proxyWithTarget:self] selector:@selector(start) userInfo:nil repeats:YES];
}

- (void)start {
    NSLog(@"%s",__func__);
}

- (void)dealloc {
    NSLog(@"%s",__func__);
    [self.timer invalidate];
}

@end
