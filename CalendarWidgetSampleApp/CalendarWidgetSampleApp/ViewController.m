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

@interface ViewController ()

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CalendarWidget *calendarWidget = [[CalendarWidget alloc] init];
    [self.view addSubview:calendarWidget];
    
    calendarWidget.translatesAutoresizingMaskIntoConstraints = NO;
    
    [calendarWidget centerInView:self.view];
    [calendarWidget constrainToSize:CGSizeMake(312, 444)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
