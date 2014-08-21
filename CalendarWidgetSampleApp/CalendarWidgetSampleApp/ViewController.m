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
    
//    DatePickerView *datePickerView = [[[NSBundle mainBundle] loadNibNamed:@"DatePickerView" owner:nil options:nil] lastObject];
    CalendarWidget *datePickerView = [[CalendarWidget alloc] init];
    [self.view addSubview:datePickerView];
    
    datePickerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [datePickerView centerInView:self.view];
    [datePickerView constrainToSize:CGSizeMake(312, 408)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
