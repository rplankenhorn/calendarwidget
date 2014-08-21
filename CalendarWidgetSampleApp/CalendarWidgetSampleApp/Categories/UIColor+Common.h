//
//  UIColor+Common.h
//  CalendarWidgetSampleApp
//
//  Created by Robbie Plankenhorn on 8/20/14.
//  Copyright (c) 2014 Plankenhorn,net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Common)

+ (UIColor *)calendarWidgetBackground;
+ (UIColor *)titleLabelColor;

// DatePickerCollectionViewCell Colors
+ (UIColor *)dateSlashColor;
+ (UIColor *)dateEnabledColor;
+ (UIColor *)dateDisabledColor;
+ (UIColor *)dateSelectedBackgroundColor;
+ (UIColor *)dateDeselectedBackgroundColor;

+ (UIColor *)headerBackgroundColor;
+ (UIColor *)dayLabelTextColor;

@end