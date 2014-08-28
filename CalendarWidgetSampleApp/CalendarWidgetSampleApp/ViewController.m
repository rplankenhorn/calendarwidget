//
//  ViewController.m
//  CalendarWidgetSampleApp
//
//  Created by Robbie Plankenhorn on 8/17/14.
//  Copyright (c) 2014 Plankenhorn,net. All rights reserved.
//

#import "ViewController.h"
#import "CalendarWidget.h"
#import "DatePickerView.h"
#import "UIView+AutoLayout.h"
#import "NSDate+Reporting.h"
#import "CalDataModel.h"

@interface ViewController () <CalendarWidgetDataSource, CalendarWidgetDelegate>
@property (strong, nonatomic) NSArray *availableDates;
@property (strong, nonatomic) CalDataModel *dataModel;
@property (strong, nonatomic) CalendarWidget *calendarWidget;
@end

@implementation ViewController

#pragma mark - Getters

- (NSArray *)availableDates {
    if (!_availableDates) {
        NSMutableArray *dates = [[NSMutableArray alloc] init];
        NSDate *currentDate = [NSDate date];
        
        for(int i=0; i<30; i++) {
            if (i % 2 != 0) {
                [dates addObject:currentDate];
            }
            currentDate = [NSDate oneDayAfter:currentDate];
        }
        _availableDates = [NSArray arrayWithArray:dates];
    }
    return _availableDates;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"cal-data" ofType:@"json"];
    
    self.dataModel = [[CalDataModel alloc] initWithFilePath:dataPath];
    
//    CalendarWidget *calendarWidget = [[CalendarWidget alloc] init];
    self.calendarWidget = (CalendarWidget *)[[[NSBundle mainBundle] loadNibNamed:@"CalendarWidget" owner:nil options:nil] lastObject];
    self.calendarWidget.dataSource = self;
    self.calendarWidget.delegate = self;
    [self.view addSubview:self.calendarWidget];
    
    self.calendarWidget.translatesAutoresizingMaskIntoConstraints = NO;
    
//    [calendarWidget centerInView:self.view];
//    [calendarWidget constrainToSize:CGSizeMake(312, 112)];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[calendarWidget]" options:0 metrics:nil views:@{@"calendarWidget": self.calendarWidget}]];
    [self.calendarWidget centerInContainerOnAxis:NSLayoutAttributeCenterX];
    [self.calendarWidget constrainToWidth:312];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CalendarWidgetDataSource

- (NSArray *)availableDatesForCalendarWidget:(CalendarWidget *)calendarWidget {
//    return self.availableDates;
    return self.dataModel.days;
}

#pragma mark - CalendarWidgetDelegate

- (void)calendarWidget:(CalendarWidget *)calendarWidget didSelectDate:(NSDate *)date {
    
}

@end
