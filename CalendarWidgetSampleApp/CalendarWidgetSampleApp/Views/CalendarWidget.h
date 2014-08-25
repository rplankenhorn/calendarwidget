//
//  CalendarWidget.h
//  CalendarWidgetSampleApp
//
//  Created by Robbie Plankenhorn on 8/17/14.
//  Copyright (c) 2014 Plankenhorn,net. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CalendarWidgetDataSource;
@protocol CalendarWidgetDelegate;

@interface CalendarWidget : UIView

@property (weak, nonatomic) id<CalendarWidgetDataSource> dataSource;
@property (weak, nonatomic) id<CalendarWidgetDelegate> delegate;

@property (strong, nonatomic) NSDate *selectedDate;

@end

@protocol CalendarWidgetDataSource <NSObject>

@optional
- (NSArray *)availableDatesForCalendarWidget:(CalendarWidget *)calendarWidget;

@end

@protocol CalendarWidgetDelegate <NSObject>

@end