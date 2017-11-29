//
//  UIColor+Hex.h
//  把十六进制的颜色值转化为RGB格式
//
//  Created by Laison on 14-5-13.
//  Copyright (c) 2014年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString *)color;

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
