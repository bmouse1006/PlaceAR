//
//  UIColor+NSString+Addition.m
//  BreezyReader2
//
//  Created by 金 津 on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIColor+Addition.h"

@implementation UIColor (addition)

- (CGColorSpaceModel) colorSpaceModel  
{  
    return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));  
}  

- (NSString *) colorSpaceString  
{  
    switch ([self colorSpaceModel])  
    {  
        case kCGColorSpaceModelUnknown:  
            return @"kCGColorSpaceModelUnknown";  
        case kCGColorSpaceModelMonochrome:  
            return @"kCGColorSpaceModelMonochrome";  
        case kCGColorSpaceModelRGB:  
            return @"kCGColorSpaceModelRGB";  
        case kCGColorSpaceModelCMYK:  
            return @"kCGColorSpaceModelCMYK";  
        case kCGColorSpaceModelLab:  
            return @"kCGColorSpaceModelLab";  
        case kCGColorSpaceModelDeviceN:  
            return @"kCGColorSpaceModelDeviceN";  
        case kCGColorSpaceModelIndexed:  
            return @"kCGColorSpaceModelIndexed";  
        case kCGColorSpaceModelPattern:  
            return @"kCGColorSpaceModelPattern";  
        default:  
            return @"Not a valid color space";  
    }  
}  

- (CGFloat) red  
{  
    const CGFloat *c = CGColorGetComponents(self.CGColor);  
    return c[0];  
}  

- (CGFloat) green  
{  
    const CGFloat *c = CGColorGetComponents(self.CGColor);  
    if ([self colorSpaceModel] == kCGColorSpaceModelMonochrome) return c[0];  
    return c[1];  
}  

- (CGFloat) blue  
{  
    const CGFloat *c = CGColorGetComponents(self.CGColor);  
    if ([self colorSpaceModel] == kCGColorSpaceModelMonochrome) return c[0];  
    return c[2];  
}  

- (CGFloat) alpha  
{  
    const CGFloat *c = CGColorGetComponents(self.CGColor);  
    return c[CGColorGetNumberOfComponents(self.CGColor)-1];  
}  

@end
