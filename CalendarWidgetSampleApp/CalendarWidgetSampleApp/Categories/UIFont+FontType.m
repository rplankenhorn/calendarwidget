//
//  UIFont+FontType.m
//  CalendarWidgetSampleApp
//
//  Created by Robbie Plankenhorn on 8/20/14.
//  Copyright (c) 2014 Plankenhorn,net. All rights reserved.
//

#import "UIFont+FontType.h"

static NSString * const kDefaultFont                            = @"HelveticaNeue";
static NSString * const kDefaultFontBold                        = @"HelveticaNeue-Bold";

@implementation UIFont (FontType)

+ (UIFont *)titleFont {
    return [UIFont fontWithName:kDefaultFontBold size:17.0f];
}

@end