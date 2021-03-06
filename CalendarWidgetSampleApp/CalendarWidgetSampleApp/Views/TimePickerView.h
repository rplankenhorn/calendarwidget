//
//  TimePickerView.h
//  CalendarWidgetSampleApp
//
//  Created by Robbie Plankenhorn on 8/21/14.
//  Copyright (c) 2014 Plankenhorn,net. All rights reserved.
//

#import "BasePickerView.h"
#import "Timeslot.h"

typedef NS_ENUM(NSInteger, TimePickerTimeInterval) {
    TimePickerTimeInterval_15MIN = 4,
    TimePickerTimeInterval_30MIN = 2,
    TimePickerTimeInterval_1HR = 1
};

@protocol TimePickerViewDataSource;
@protocol TimePickerViewDelegate;

@interface TimePickerView : BasePickerView

@property (weak, nonatomic) id<TimePickerViewDataSource> dataSource;
@property (weak, nonatomic) id<TimePickerViewDelegate> delegate;

@end

@protocol TimePickerViewDataSource <NSObject>

@optional
/**
 *  The available times for the picker.
 *
 *  @param timePickerView timePickerView
 *
 *  @return An array of Timeslot objects
 */
- (NSArray *)availableTimesForTimePickerView:(TimePickerView *)timePickerView;

/**
 *  Implement this method to specify the time interval.  Implementing availableTimesForTimePickerView:
 *  will override this method.
 *
 *  @param timePickerView timePickerView
 *
 *  @return The TimePickverTimeInterval
 */
- (TimePickerTimeInterval)timeIntervalForTimePickerView:(TimePickerView *)timePickerView;

@end

@protocol TimePickerViewDelegate <NSObject>

@optional

/**
 *  Called when the user selects a time.
 *
 *  @param timePickerView timePickerView
 *  @param timeslot       The selected timeslot
 */
- (void)timePickerView:(TimePickerView *)timePickerView didSelectTimeslot:(Timeslot *)timeslot;

@end