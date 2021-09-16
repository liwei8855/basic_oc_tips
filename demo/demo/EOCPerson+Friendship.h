//
//  EOCPerson+Friendship.h
//  demo
//
//  Created by lee on 17/3/7.
//  Copyright © 2017年 lee. All rights reserved.
/*
   关联对象实现给categry添加属性
  （原因：类的实例变量布局已固定，故无法向固定的布局添加新的实例变量）
 
   注意：不建议将数据放在分类中，放在主接口里
*/

#import "EOCPerson.h"

@interface EOCPerson (Friendship)

@property(strong, nonatomic) NSArray *friends;

- (BOOL)isFriendsWith:(EOCPerson *)person;

@end
