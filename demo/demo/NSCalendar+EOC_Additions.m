//
//  NSCalendar+EOC_Additions.m
//  demo
//
//  Created by lee on 17/3/7.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "NSCalendar+EOC_Additions.h"

@implementation NSCalendar (EOC_Additions)

- (NSArray *)eoc_allMonths {

    if ([self.calendarIdentifier isEqualToString:NSCalendarIdentifierGregorian]) {
        return @[@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August",
                 @"September", @"October", @"November", @"December"];
    }
    
    return nil;

}

@end
