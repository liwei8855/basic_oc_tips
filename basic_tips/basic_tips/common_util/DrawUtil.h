//
//  DrawUtil.h
//  basic_tips
//
//  Created by 李威 on 2022/3/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DrawUtil : NSObject
+ (void)drawText:(NSString *)text InRect:(CGRect)rect withFont:(UIFont *)font inContext:(CGContextRef)context alignment:(NSTextAlignment)alignment;
@end

NS_ASSUME_NONNULL_END
