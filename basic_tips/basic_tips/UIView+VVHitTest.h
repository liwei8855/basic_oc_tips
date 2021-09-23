//
//  UIView+VVHitTest.h
//  demo
//
//  Created by lee on 2017/12/21.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 * @abstract hitTestBlock
 *
 * @param otherparams 参考UIView hitTest:withEvent:
 * @param returnSuper 是否返回Super的值。如果*returnSuper=YES,则代表会返回 super hitTest:withEvent:, 否则则按照block的返回值(即使是nil)
 *
 * @discussion 切记，千万不要在这个block中调用self hitTest:withPoint,否则则会造成递归调用。这个方法就是hitTest:withEvent的一个代替。
 */
typedef UIView * (^VVHitTestViewBlock)(CGPoint point, UIEvent *event, BOOL *returnSuper);
typedef BOOL (^VVPointInsideBlock)(CGPoint point, UIEvent *event, BOOL *returnSuper);
@interface UIView (VVHitTest)
@property (copy, nonatomic) VVHitTestViewBlock hitTestBlock;
@property (copy, nonatomic) VVPointInsideBlock pointInsideBlock;
@end
