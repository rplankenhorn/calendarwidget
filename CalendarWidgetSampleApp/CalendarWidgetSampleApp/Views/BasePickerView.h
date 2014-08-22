//
//  BasePickerView.h
//  CalendarWidgetSampleApp
//
//  Created by Robbie Plankenhorn on 8/21/14.
//  Copyright (c) 2014 Plankenhorn,net. All rights reserved.
//

#import "CalendarFlowLayout.h"
#import "DatePickerCollectionViewCell.h"
#import "UIColor+Common.h"

static NSString * const kPickerCollectionViewCellIdentifier = @"DatePickerCollectionViewCellIdentifier";
static NSString * const kPickerCollectionViewCellXib        = @"DatePickerCollectionViewCell";

@interface BasePickerView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) CalendarFlowLayout *calendarFlowLayout;
@property (strong, nonatomic) NSIndexPath *selectedIndex;

@property (strong, nonatomic) NSCalendar *calendar;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

- (void)commonInit;
- (void)clear;

@end