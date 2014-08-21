//
//  UIColor+Common.m
//  CalendarWidgetSampleApp
//
//  Created by Robbie Plankenhorn on 8/20/14.
//  Copyright (c) 2014 Plankenhorn,net. All rights reserved.
//

#import "UIColor+Common.h"

@implementation UIColor (Common)

+ (UIColor *)dateSlashColor {
    return [UIColor colorWithRed:197.0f/255.0f green:198.0f/255.0f blue:195.0f/255.0f alpha:1.0f];
}

+ (UIColor *)dateEnabledColor {
    return [UIColor colorWithRed:87.0f/255.0f green:97.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
}

+ (UIColor *)dateDisabledColor {
    return [UIColor colorWithRed:201.0f/255.0f green:201.0f/255.0f blue:201.0f/255.0f alpha:1.0f];
}

+ (UIColor *)dateSelectedBackgroundColor {
    return [UIColor colorWithRed:129.0f/255.0f green:140.0f/255.0f blue:172.0f/255.0f alpha:1.0f];
}

+ (UIColor *)dateDeselectedBackgroundColor {
    return [UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:235.0f/255.0f alpha:1.0f];
}

+ (UIColor *)headerBackgroundColor {
    return [UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f  blue:235.0f/255.0f  alpha:1.0f];
}

+ (UIColor *)dayLabelTextColor {
    return [UIColor colorWithRed:201.0f/255.0f green:201.0f/255.0f blue:201.0f/255.0f alpha:1.0f];
}

@end