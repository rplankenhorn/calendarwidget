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

/**
 *  The first date of the current calendar view.
 */
@property (strong, nonatomic) NSDate *firstDateOfCurrentCalendarView;

/**
 *  The currently selected date.
 */
@property (strong, nonatomic) NSDate *currentDate;

@end

@protocol DatePickerViewDataSource <NSObject>

@optional
/**
 *  Configuration method for the available days.
 *
 *  @param datePickerView datePickerView
 *  @param date           date of current month
 *
 *  @return An array of Day objects
 */
- (NSArray *)datePickerView:(DatePickerView *)datePickerView availableDatesForMonthOfDate:(NSDate *)date;

@end

@protocol DatePickerViewDelegate <NSObject>

@optional
/**
 *  Called when both a day and time have been selected.
 *
 *  @param datePickerView datePickerView
 *  @param date           date
 */
- (void)datePickerView:(DatePickerView *)datePickerView didSelectDate:(NSDate *)date;

@end