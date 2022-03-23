//
//  DrawUtil.m
//  basic_tips
//
//  Created by 李威 on 2022/3/17.
//

#import "DrawUtil.h"

#define smallWidth 0.3

@implementation DrawUtil

//居右画文本
+ (void)drawText:(NSString *)text InRect:(CGRect)rect withFont:(UIFont *)font inContext:(CGContextRef)context alignment:(NSTextAlignment)alignment {
    
    if(!text || [@"" isEqualToString:text]) return;
    if (![text isKindOfClass:[NSString class]]) {
        text = [NSString stringWithFormat:@"%@", text];
    }
    CGContextSetLineWidth(context, smallWidth);
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = alignment;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *dic = @{NSFontAttributeName: font,NSParagraphStyleAttributeName: paragraphStyle};
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(1000, rect.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    CGRect textRect = CGRectMake(rect.origin.x,rect.origin.y+(rect.size.height-font.pointSize-2)/2,textSize.width>rect.size.width?textSize.width:rect.size.width,font.pointSize+2);
    [text drawInRect:textRect withAttributes:dic];
}


@end
