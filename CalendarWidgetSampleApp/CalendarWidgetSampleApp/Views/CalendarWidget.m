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

@interface CalendarWidget () <DatePickerViewDataSource, DatePickerViewDelegate, TimePickerViewDataSource, TimePickerViewDelegate>

@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIButton *dateTabButton;
@property (strong, nonatomic) UIButton *timeTabButton;
@property (strong, nonatomic) UIView *pickerContainerView;
@property (strong, nonatomic) DatePickerView *datePickerView;
@property (strong, nonatomic) TimePickerView *timePickerView;
@property (strong, nonatomic) UIButton *clearAllButton;

@property (strong, nonatomic) BasePickerView *selectedPicker;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (strong, nonatomic, readonly) NSArray *availableDates;

@end

@implementation CalendarWidget

#pragma mark - Getters

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _containerView;
}

- (UIButton *)dateTabButton {
    if (!_dateTabButton) {
        _dateTabButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _dateTabButton.backgroundColor = [UIColor headerBackgroundColor];
        _dateTabButton.titleLabel.font = [UIFont titleFont];
        [_dateTabButton setTitle:@"Select Date" forState:UIControlStateNormal];
        [_dateTabButton setTitleColor:[UIColor titleLabelColor] forState:UIControlStateNormal];
        [_dateTabButton setTitleColor:[UIColor titleLabelColor] forState:UIControlStateHighlighted];
        [_dateTabButton addTarget:self action:@selector(dateTabTapped:) forControlEvents:UIControlEventTouchUpInside];
        _dateTabButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _dateTabButton;
}

- (UIButton *)timeTabButton {
    if (!_timeTabButton) {
        _timeTabButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _timeTabButton.backgroundColor = [UIColor whiteColor];
        _timeTabButton.titleLabel.font = [UIFont titleFont];
        [_timeTabButton setTitle:@"Select Time" forState:UIControlStateNormal];
        [_timeTabButton setTitleColor:[UIColor titleLabelColor] forState:UIControlStateNormal];
        [_timeTabButton setTitleColor:[UIColor titleLabelColor] forState:UIControlStateHighlighted];
        [_timeTabButton addTarget:self action:@selector(timeTabTapped:) forControlEvents:UIControlEventTouchUpInside];
        _timeTabButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _timeTabButton;
}

- (UIView *)pickerContainerView {
    if (!_pickerContainerView) {
        _pickerContainerView = [[UIView alloc] init];
        _pickerContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _pickerContainerView;
}

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

- (UIButton *)clearAllButton {
    if (!_clearAllButton) {
        _clearAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _clearAllButton.backgroundColor = [UIColor headerBackgroundColor];
        _clearAllButton.titleLabel.font = [UIFont titleFont];
        [_clearAllButton setTitle:@"Clear All" forState:UIControlStateNormal];
        [_clearAllButton setTitleColor:[UIColor titleLabelColor] forState:UIControlStateNormal];
        [_clearAllButton addTarget:self action:@selector(clearAllButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        _clearAllButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _clearAllButton;
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
    
    if (!_selectedDate) {
        [self clearAllButtonPressed:nil];
    }
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

- (void)commonInit {
    self.backgroundColor = [UIColor headerBackgroundColor];
    
    [self addSubview:self.containerView];
    
    [self.containerView addSubview:self.dateTabButton];
    [self.containerView addSubview:self.timeTabButton];
    [self.containerView addSubview:self.pickerContainerView];
    [self.containerView addSubview:self.clearAllButton];
    
    [self.pickerContainerView addSubview:self.datePickerView];
    
    self.selectedPicker = self.datePickerView;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsDictionary = @{@"containerView": self.containerView};
    NSDictionary *metrics = @{@"margin": @10};
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[containerView]-margin-|" options:0 metrics:metrics views:viewsDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[containerView]-margin-|" options:0 metrics:metrics views:viewsDictionary]];
    
    [self setupContainerViewConstraints];
    [self setupPickerContainerViewContraintsForPicker:self.selectedPicker];
}

- (void)setupContainerViewConstraints {
    NSDictionary *viewsDictionary = @{@"dateTabButton": self.dateTabButton,
                                      @"timeTabButton": self.timeTabButton,
                                      @"pickerContainerView": self.pickerContainerView,
                                      @"clearAllButton": self.clearAllButton};
    NSDictionary *metrics = @{@"margin": @2,
                              @"tabButtonHeight": @50};
    
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[dateTabButton(==timeTabButton)]-margin-[timeTabButton]-margin-|" options:0 metrics:metrics views:viewsDictionary]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[pickerContainerView]-margin-|" options:0 metrics:metrics views:viewsDictionary]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[clearAllButton]-margin-|" options:0 metrics:metrics views:viewsDictionary]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[dateTabButton(==tabButtonHeight)]-margin-[pickerContainerView]-margin-[clearAllButton]-margin-|" options:0 metrics:metrics views:viewsDictionary]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[timeTabButton(==tabButtonHeight)]-margin-[pickerContainerView]-margin-[clearAllButton]-margin-|" options:0 metrics:metrics views:viewsDictionary]];
}

- (void)setupPickerContainerViewContraintsForPicker:(BasePickerView *)picker {
    NSDictionary *viewsDictionary = @{@"picker": picker};
    
    picker.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.pickerContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[picker]-0-|" options:0 metrics:nil views:viewsDictionary]];
    [self.pickerContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[picker]-0-|" options:0 metrics:nil views:viewsDictionary]];
}

#pragma mark - Actions

- (void)clearAllButtonPressed:(id)sender {
    [self.datePickerView clear];
    [self.timePickerView clear];
    [self.dateTabButton setTitle:@"Select Date" forState:UIControlStateNormal];
    [self.timeTabButton setTitle:@"Select Time" forState:UIControlStateNormal];
}

- (void)dateTabTapped:(id)sender {
    if (![self.selectedPicker isKindOfClass:[DatePickerView class]]) {
        [self.selectedPicker removeFromSuperview];
        [self.pickerContainerView addSubview:self.datePickerView];
        [self setupPickerContainerViewContraintsForPicker:self.datePickerView];
        self.selectedPicker = self.datePickerView;
        [self setButton:self.dateTabButton enabled:YES];
        [self setButton:self.timeTabButton enabled:NO];
    }
}

- (void)timeTabTapped:(id)sender {
    if (![self.selectedPicker isKindOfClass:[TimePickerView class]]) {
        [self.selectedPicker removeFromSuperview];
        [self.pickerContainerView addSubview:self.timePickerView];
        [self setupPickerContainerViewContraintsForPicker:self.timePickerView];
        self.selectedPicker = self.timePickerView;
        [_dateTabButton setTitleColor:[UIColor titleLabelColor] forState:UIControlStateNormal];
        [_dateTabButton setTitleColor:[UIColor titleLabelColor] forState:UIControlStateHighlighted];
        [self setButton:self.dateTabButton enabled:NO];
        [self setButton:self.timeTabButton enabled:YES];
    }
}

- (void)setButton:(UIButton *)button enabled:(BOOL)enabled {
    if (enabled) {
        button.backgroundColor = [UIColor headerBackgroundColor];
    } else {
        button.backgroundColor = [UIColor whiteColor];
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
    self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    self.dateFormatter.timeStyle = NSDateFormatterNoStyle;
    [self.dateTabButton setTitle:[self.dateFormatter stringFromDate:date] forState:UIControlStateNormal];
}

#pragma mark - TimePickerViewDataSource

- (NSArray *)availableTimesForTimePickerView:(TimePickerView *)timePickerView {
    if (self.selectedDate &&
        self.availableDates) {
        NSInteger selectedMonth = [self.datePickerView.calendar component:NSCalendarUnitMonth fromDate:self.selectedDate];
        NSInteger selectedDay = [self.datePickerView.calendar component:NSCalendarUnitDay fromDate:self.selectedDate];
        NSInteger selectedYear = [self.datePickerView.calendar component:NSCalendarUnitYear fromDate:self.selectedDate];
        NSMutableArray *times = [[NSMutableArray alloc] init];
        for (NSDate *date in self.availableDates) {
            NSInteger month = [self.datePickerView.calendar component:NSCalendarUnitMonth fromDate:date];
            NSInteger day = [self.datePickerView.calendar component:NSCalendarUnitDay fromDate:date];
            NSInteger year = [self.datePickerView.calendar component:NSCalendarUnitYear fromDate:date];
            if (month == selectedMonth &&
                day == selectedDay &&
                year == selectedYear) {
                [times addObject:date];
            }
        }
        return [NSArray arrayWithArray:times];
    } else {
        return nil;
    }
}

#pragma mark - TimePickerViewDelegate

- (void)timePickerView:(TimePickerView *)timePickerView didSelectDate:(NSDate *)date {
    self.dateFormatter.dateStyle = NSDateFormatterNoStyle;
    self.dateFormatter.timeStyle = NSDateFormatterShortStyle;
    [self.timeTabButton setTitle:[self.dateFormatter stringFromDate:date] forState:UIControlStateNormal];
}

@end