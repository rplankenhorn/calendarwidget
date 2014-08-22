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

@interface CalendarWidget ()

@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIButton *dateTabButton;
@property (strong, nonatomic) UIButton *timeTabButton;
@property (strong, nonatomic) UIView *pickerContainerView;
@property (strong, nonatomic) DatePickerView *datePickerView;
@property (strong, nonatomic) TimePickerView *timePickerView;
@property (strong, nonatomic) UIButton *clearAllButton;

@property (strong, nonatomic) BasePickerView *selectedPicker;

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
        [_dateTabButton setTitle:@"Select Date" forState:UIControlStateHighlighted];
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
        [_timeTabButton setTitle:@"Select Time" forState:UIControlStateHighlighted];
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
        _datePickerView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _datePickerView;
}

- (TimePickerView *)timePickerView {
    if (!_timePickerView) {
        _timePickerView = [[TimePickerView alloc] init];
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

@end