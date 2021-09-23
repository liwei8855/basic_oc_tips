//
//  TestView.m
//  block
//
//  Created by lee on 16/11/30.
//  Copyright © 2016年 mjsfax. All rights reserved.
//

#import "TestView.h"

@interface TestView()
@property (weak, nonatomic) IBOutlet UIButton *testButton;

@end

@implementation TestView

+ (TestView *)createTestView {
    UINib *nib = [UINib nibWithNibName:@"TestView" bundle:nil];
    TestView *view = [nib instantiateWithOwner:nil options:nil].lastObject;
    return view;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.testButton addTarget:self action:@selector(testButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)testButtonClick:(void(^)())click {
        click();
}

@end
