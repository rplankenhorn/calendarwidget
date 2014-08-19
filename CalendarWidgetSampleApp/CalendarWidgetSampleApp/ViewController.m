//
//  ViewController.m
//  CalendarWidgetSampleApp
//
//  Created by Robbie Plankenhorn on 8/17/14.
//  Copyright (c) 2014 Plankenhorn,net. All rights reserved.
//

#import "ViewController.h"
#import "DatePickerView.h"

@interface ViewController ()

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    DatePickerView *datePickerView = [[[NSBundle mainBundle] loadNibNamed:@"DatePickerView" owner:nil options:nil] lastObject];
    [self.view addSubview:datePickerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
