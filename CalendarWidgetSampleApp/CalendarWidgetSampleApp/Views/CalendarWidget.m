//
//  CalendarWidget.m
//  CalendarWidgetSampleApp
//
//  Created by Robbie Plankenhorn on 8/17/14.
//  Copyright (c) 2014 Plankenhorn,net. All rights reserved.
//

#import "CalendarWidget.h"
#import "DatePickerView.h"
#import "UIColor+Common.h"
#import <QuartzCore/QuartzCore.h>
#import "UIFont+FontType.h"
#import "TimePickerView.h"
#import "Day.h"
#import "NSDate+Reporting.h"
#import "UIView+AutoLayout.h"

@interface CalendarWidget () <DatePickerViewDataSource, DatePickerViewDelegate, TimePickerViewDataSource, TimePickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *dateTabButton;
@property (weak, nonatomic) IBOutlet UIButton *timeTabButton;
@property (weak, nonatomic) IBOutlet UIView *pickerContainerView;
@property (strong, nonatomic) DatePickerView *datePickerView;
@property (strong, nonatomic) TimePickerView *timePickerView;
@property (weak, nonatomic) IBOutlet UIButton *clearAllButton;
@property (assign, nonatomic) BOOL pickerContainerViewHidden;

@property (strong, nonatomic) BasePickerView *selectedPicker;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (strong, nonatomic, readonly) NSArray *availableDates;

@end

@implementation CalendarWidget

#pragma mark - Getters

- (DatePickerView *)datePickerView {
    if (!_datePickerView) {
        _datePickerView = [[DatePickerView alloc] init];
        _datePickerView.dataSource = self;
        _datePickerView.delegate = self;
        _datePickerView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _datePickerView;
}

- (TimePickerView *)timePickerView {
    if (!_timePickerView) {
        _timePickerView = [[TimePickerView alloc] init];
        _timePickerView.dataSource = self;
        _timePickerView.delegate = self;
        _timePickerView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _timePickerView;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}

- (NSArray *)availableDates {
    if ([self.dataSource respondsToSelector:@selector(availableDatesForCalendarWidget:)]) {
        return [self.dataSource availableDatesForCalendarWidget:self];
    } else {
        return nil;
    }
}

#pragma mark - Setters

- (void)setSelectedDate:(NSDate *)selectedDate {
    _selectedDate = selectedDate;
    self.timeTabButton.enabled = (_selectedDate != nil);
}

#pragma mark - Init

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}

- (void)commonInit {
    self.backgroundColor = [UIColor headerBackgroundColor];
    
    [self configureViews];
    
    self.pickerContainerViewHidden = YES;
    
//    [self.pickerContainerView addSubview:self.datePickerView];
    
//    self.selectedPicker = self.datePickerView;
}

- (void)configureViews {
    self.datePickerView.alpha = 0.0f;
    self.timePickerView.alpha = 0.0f;
    
    [self.pickerContainerView addSubview:self.datePickerView];
    [self.datePickerView removeFromSuperview];
    
    self.dateTabButton.backgroundColor = [UIColor headerBackgroundColor];
    self.dateTabButton.titleLabel.font = [UIFont titleFont];
    [self.dateTabButton setTitle:@"Select Date" forState:UIControlStateNormal];
    [self.dateTabButton setTitleColor:[UIColor titleLabelColor] forState:UIControlStateNormal];
    [self.dateTabButton setTitleColor:[UIColor titleLabelColor] forState:UIControlStateHighlighted];
    [self.dateTabButton addTarget:self action:@selector(dateTabTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    self.timeTabButton.backgroundColor = [UIColor headerBackgroundColor];
    self.timeTabButton.titleLabel.font = [UIFont titleFont];
    [self.timeTabButton setTitle:@"Select Time" forState:UIControlStateNormal];
    [self.timeTabButton setTitleColor:[UIColor titleLabelColor] forState:UIControlStateNormal];
    [self.timeTabButton setTitleColor:[UIColor titleLabelColor] forState:UIControlStateHighlighted];
    [self.timeTabButton addTarget:self action:@selector(timeTabTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.timeTabButton.enabled = NO;
    
    self.clearAllButton.backgroundColor = [UIColor headerBackgroundColor];
    self.clearAllButton.titleLabel.font = [UIFont titleFont];
    [self.clearAllButton setTitle:@"Clear All" forState:UIControlStateNormal];
    [self.clearAllButton setTitleColor:[UIColor titleLabelColor] forState:UIControlStateNormal];
    [self.clearAllButton addTarget:self action:@selector(clearAllButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupPickerContainerViewContraintsForPicker:(BasePickerView *)picker {
    NSDictionary *viewsDictionary = @{@"picker": picker};
    
    picker.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.pickerContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[picker]-0-|" options:0 metrics:nil views:viewsDictionary]];
    [self.pickerContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[picker]-0-|" options:0 metrics:nil views:viewsDictionary]];
}

#pragma mark - Actions

- (void)clearAllButtonPressed:(id)sender {
    [self collapseView];
    [self.datePickerView clear];
    [self.timePickerView clear];
    [self.dateTabButton setTitle:@"Select Date" forState:UIControlStateNormal];
    [self.timeTabButton setTitle:@"Select Time" forState:UIControlStateNormal];
    self.selectedDate = nil;
}

- (void)dateTabTapped:(id)sender {
    if (![self.selectedPicker isKindOfClass:[DatePickerView class]] ||
        self.selectedPicker.superview == nil) {
        [self.selectedPicker removeFromSuperview];
        [self.pickerContainerView addSubview:self.datePickerView];
        [self setupPickerContainerViewContraintsForPicker:self.datePickerView];
        self.selectedPicker = self.datePickerView;
        self.selectedPicker.alpha = 0.0f;
        [self expandView];
    } else {
        [self collapseView];
    }
}

- (void)timeTabTapped:(id)sender {
    if (![self.selectedPicker isKindOfClass:[TimePickerView class]] ||
        self.selectedPicker.superview == nil) {
        [self.selectedPicker removeFromSuperview];
        [self.pickerContainerView addSubview:self.timePickerView];
        [self setupPickerContainerViewContraintsForPicker:self.timePickerView];
        self.selectedPicker = self.timePickerView;
        self.selectedPicker.alpha = 0.0f;
        [self expandView];
    } else {
        [self collapseView];
    }
}

- (void)expandView {
    self.pickerContainerViewHidden = NO;
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            [self invalidateIntrinsicContentSize];
                            self.selectedPicker.alpha = 1.0f;
                            [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)collapseView {
    self.pickerContainerViewHidden = YES;
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            self.selectedPicker.alpha = 0.0f;
                            [self invalidateIntrinsicContentSize];
                            [self.superview layoutIfNeeded];
                        } completion:^(BOOL finished) {
                            [self.selectedPicker removeFromSuperview];
                        }];
}

- (CGSize)intrinsicContentSize {
    if (self.pickerContainerViewHidden) {
        return CGSizeMake(312, 112);
    } else {
        return CGSizeMake(312, 444);
    }
}

#pragma mark - DatePickerViewDataSource

- (NSArray *)datePickerView:(DatePickerView *)datePickerView availableDatesForMonthOfDate:(NSDate *)date {
    if (self.availableDates) {
        NSInteger selectedMonth = [self.datePickerView.calendar component:NSCalendarUnitMonth fromDate:date];
        NSInteger selectedYear = [self.datePickerView.calendar component:NSCalendarUnitYear fromDate:date];
        NSMutableArray *dates = [[NSMutableArray alloc] init];
        for (Day *d in self.availableDates) {
            NSInteger month = [self.datePickerView.calendar component:NSCalendarUnitMonth fromDate:d.date];
            NSInteger year = [self.datePickerView.calendar component:NSCalendarUnitYear fromDate:d.date];
            if (month == selectedMonth &&
                year == selectedYear) {
                [dates addObject:d];
            }
        }
        return [NSArray arrayWithArray:dates];
    } else {
        return nil;
    }
}

#pragma mark - DatePickerViewDelegate

- (void)datePickerView:(DatePickerView *)datePickerView didSelectDate:(NSDate *)date {
    [self collapseView];
    if (![self.selectedDate isSameMonthDayYear:date]) {
        [self.timePickerView clear];
        self.selectedDate = date;
        self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        self.dateFormatter.timeStyle = NSDateFormatterNoStyle;
        [self.dateTabButton setTitle:[self.dateFormatter stringFromDate:date] forState:UIControlStateNormal];
        [self.timeTabButton setTitle:@"Select Time" forState:UIControlStateNormal];
    }
}

#pragma mark - TimePickerViewDataSource

- (NSArray *)availableTimesForTimePickerView:(TimePickerView *)timePickerView {
    if (self.selectedDate &&
        self.availableDates) {
        NSInteger selectedMonth = [self.datePickerView.calendar component:NSCalendarUnitMonth fromDate:self.selectedDate];
        NSInteger selectedDay = [self.datePickerView.calendar component:NSCalendarUnitDay fromDate:self.selectedDate];
        NSInteger selectedYear = [self.datePickerView.calendar component:NSCalendarUnitYear fromDate:self.selectedDate];
        NSMutableArray *times = [[NSMutableArray alloc] init];
        for (Day *date in self.availableDates) {
            NSInteger month = [self.datePickerView.calendar component:NSCalendarUnitMonth fromDate:date.date];
            NSInteger day = [self.datePickerView.calendar component:NSCalendarUnitDay fromDate:date.date];
            NSInteger year = [self.datePickerView.calendar component:NSCalendarUnitYear fromDate:date.date];
            if (month == selectedMonth &&
                day == selectedDay &&
                year == selectedYear) {
                [times addObjectsFromArray:date.timeslots];
            }
        }
        return [NSArray arrayWithArray:times];
    } else {
        return nil;
    }
}

#pragma mark - TimePickerViewDelegate

- (void)timePickerView:(TimePickerView *)timePickerView didSelectTimeslot:(Timeslot *)timeslot {
    [self collapseView];
    NSDateComponents *selectedDateComponents = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:self.selectedDate];
    NSDateComponents *timeslotComponents = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:timeslot.startTime];
    selectedDateComponents.hour = timeslotComponents.hour;
    selectedDateComponents.minute = timeslotComponents.minute;
    self.selectedDate = [[NSCalendar currentCalendar] dateFromComponents:selectedDateComponents];
    self.dateFormatter.dateStyle = NSDateFormatterNoStyle;
    self.dateFormatter.timeStyle = NSDateFormatterShortStyle;
    [self.timeTabButton setTitle:[self.dateFormatter stringFromDate:timeslot.startTime] forState:UIControlStateNormal];
    
    if ([self.delegate respondsToSelector:@selector(calendarWidget:didSelectDate:)]) {
        [self.delegate calendarWidget:self didSelectDate:self.selectedDate];
    }
}

@end