//
//  TestView.h
//  block
//
//  Created by lee on 16/11/30.
//  Copyright © 2016年 mjsfax. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestView : UIView
- (void)testButtonClick:(void(^)())click;
+ (TestView *)createTestView;

@end
