//
//  DatePickerView.h
//  CalendarWidgetSampleApp
//
//  Created by Robbie Plankenhorn on 8/17/14.
//  Copyright (c) 2014 Plankenhorn,net. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerViewDataSource;
@protocol DatePickerViewDelegate;

@interface DatePickerView : UIView

@property (weak, nonatomic) id<DatePickerViewDataSource> dataSource;
@property (weak, nonatomic) id<DatePickerViewDelegate> delegate;

@property (strong, nonatomic) NSDate *defaultDate;

- (void)clearSelectedDate;

@end

@protocol DatePickerViewDataSource <NSObject>

@optional
- (NSArray *)datePickerView:(DatePickerView *)datePickerView availableDatesForMonthOfDate:(NSDate *)date;

@end

@protocol DatePickerViewDelegate <NSObject>

@end