//
//  DatePickerView.h
//  CalendarWidgetSampleApp
//
//  Created by Robbie Plankenhorn on 8/17/14.
//  Copyright (c) 2014 Plankenhorn,net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePickerView.h"

@protocol DatePickerViewDataSource;
@protocol DatePickerViewDelegate;

@interface DatePickerView : BasePickerView

@property (weak, nonatomic) id<DatePickerViewDataSource> dataSource;
@property (weak, nonatomic) id<DatePickerViewDelegate> delegate;

@property (strong, nonatomic) NSDate *defaultDate;

- (void)clear;

@end

@protocol DatePickerViewDataSource <NSObject>

@optional
- (NSArray *)datePickerView:(DatePickerView *)datePickerView availableDatesForMonthOfDate:(NSDate *)date;

@end

@protocol DatePickerViewDelegate <NSObject>

@optional
- (void)datePickerView:(DatePickerView *)datePickerView didSelectDate:(NSDate *)date;

@end