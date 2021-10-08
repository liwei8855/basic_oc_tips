//
//  TimerViewController.m
//  basic_tips
//
//  Created by 李威 on 2021/10/8.
//

#import "TimerViewController.h"
#import "Timer1Controller.h"

@interface TimerViewController ()

@end

@implementation TimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    Timer1Controller *vc = [Timer1Controller new];
    [self presentViewController:vc animated:YES completion:^{
            
    }];
}


@end
