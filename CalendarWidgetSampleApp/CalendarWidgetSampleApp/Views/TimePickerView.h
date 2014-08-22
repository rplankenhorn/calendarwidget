//
//  TimePickerView.h
//  CalendarWidgetSampleApp
//
//  Created by Robbie Plankenhorn on 8/21/14.
//  Copyright (c) 2014 Plankenhorn,net. All rights reserved.
//

#import "BasePickerView.h"

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
- (NSArray *)availableTimesForTimePickerView:(TimePickerView *)timePickerView;
- (TimePickerTimeInterval)timeIntervalForTimePickerView:(TimePickerView *)timePickerView;

@end

@protocol TimePickerViewDelegate <BasePickerDelegate>

@end