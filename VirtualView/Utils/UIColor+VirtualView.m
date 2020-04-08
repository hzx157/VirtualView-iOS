//
//  UIColor+VirtualView.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "UIColor+VirtualView.h"

@implementation UIColor (VirtualView)

///设置动态颜色，主要适配暗黑模式的dict
static  NSDictionary *providerDict;
void VVSetColorWithDynamicProvider(NSDictionary * _Nonnull dict){
    providerDict = dict;
}

+ (UIColor *)vv_colorWithRGB:(NSUInteger)rgb
{
    CGFloat red = ((rgb & 0xFF0000) >> 16) / 255.0;
    CGFloat green = ((rgb & 0xFF00) >> 8) / 255.0;
    CGFloat blue = (rgb & 0xFF) / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}
- (NSString *)HEXString{
    UIColor* color = self;
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    return [NSString stringWithFormat:@"#%02X%02X%02X", (int)((CGColorGetComponents(color.CGColor))[0]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}

+ (UIColor *)vv_colorWithARGB:(NSUInteger)argb
{
    CGFloat alpha = ((argb & 0xFF000000) >> 24) / 255.0;
    if (alpha == 0) {
        return [UIColor clearColor];
    }
    
//
   
    CGFloat red = ((argb & 0xFF0000) >> 16) / 255.0;
    CGFloat green = ((argb & 0xFF00) >> 8) / 255.0;
    CGFloat blue = (argb & 0xFF) / 255.0;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
//    NSLog(@"HEXString--------%@",[color HEXString]);
    
    if (@available(iOS 13.0, *)) {
           return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
               if(traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark){
                   NSString *string = [providerDict objectForKey:[color HEXString]];
                   unsigned int rgb = 0;
                          NSScanner *scanner = [NSScanner scannerWithString:string];
                          if ([scanner scanHexInt:&rgb]) {
                              return [UIColor vv_colorWithRGB:rgb];
                          }
                   
               }
               return color;
           }];
       }
    return color;
}

+ (UIColor *)vv_colorWithString:(NSString *)string
{
    if (!string || string.length == 0) {
        return nil;
    }
    
    if ([string hasPrefix:@"0x"]) {
        string = [string substringFromIndex:2];
    } else if ([string hasPrefix:@"#"]) {
        string = [string substringFromIndex:1];
    }
    if (string.length == 8) {
        unsigned int argb = 0;
        NSScanner *scanner = [NSScanner scannerWithString:string];
        if ([scanner scanHexInt:&argb]) {
            return [UIColor vv_colorWithARGB:argb];
        }
    } else if (string.length == 6) {
        unsigned int rgb = 0;
        NSScanner *scanner = [NSScanner scannerWithString:string];
        if ([scanner scanHexInt:&rgb]) {
            return [UIColor vv_colorWithRGB:rgb];
        }
    }
    return nil;
}

@end
