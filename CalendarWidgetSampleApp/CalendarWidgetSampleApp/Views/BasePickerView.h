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
#import "NSIndexPath+Utils.h"

static NSString * const kPickerCollectionViewCellIdentifier = @"DatePickerCollectionViewCellIdentifier";
static NSString * const kPickerCollectionViewCellXib        = @"DatePickerCollectionViewCell";

@interface BasePickerView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

/**
 *  Collection view used to display the calendar or time options.
 */
@property (strong, nonatomic) UICollectionView *collectionView;

/**
 *  Layout for collection view.
 */
@property (strong, nonatomic) CalendarFlowLayout *calendarFlowLayout;

/**
 *  The selected index.
 */
@property (strong, nonatomic) NSIndexPath *selectedIndex;

/**
 *  The current calendar
 */
@property (strong, nonatomic) NSCalendar *calendar;

/**
 *  A date formatter.
 */
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

/**
 *  Common init method
 */
- (void)commonInit;

/**
 *  Refreshes the calendar
 */
- (void)refreshCalendar;

/**
 *  Clears the calendar.
 */
- (void)clear;

@end