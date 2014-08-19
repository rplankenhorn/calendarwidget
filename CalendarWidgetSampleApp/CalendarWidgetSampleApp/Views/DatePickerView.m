//
//  DatePickerView.m
//  CalendarWidgetSampleApp
//
//  Created by Robbie Plankenhorn on 8/17/14.
//  Copyright (c) 2014 Plankenhorn,net. All rights reserved.
//

#import "DatePickerView.h"
#import "DatePickerCollectionViewCell.h"
#import "CalendarFlowLayout.h"
#import "NSIndexPath+Utils.h"
#import "NSDate+Reporting.h"

static NSString * const kDatePickerCollectionViewCellIdentifier = @"DatePickerCollectionViewCellIdentifier";
static NSString * const kDatePickerCollectionViewCellXib        = @"DatePickerCollectionViewCell";

@interface DatePickerView () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *leftChevronButton;
@property (weak, nonatomic) IBOutlet UIButton *rightChevronButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSCalendar *calendar;
@property (assign, nonatomic, readonly) NSInteger offset;
@property (assign, nonatomic, readonly) NSInteger endPadding;
@property (strong, nonatomic) NSIndexPath *selectedIndex;

@property (strong, nonatomic, readonly) NSArray *daysOfWeekPrefixes;
@end

@implementation DatePickerView

#pragma mark - Getters

- (NSCalendar *)calendar {
    if (!_calendar) {
        _calendar = [NSCalendar currentCalendar];
    }
    return _calendar;
}

- (NSInteger)offset {
    return [self.calendar component:NSCalendarUnitWeekdayOrdinal fromDate:[NSDate lastDayOfCurrentMonth]];
}

- (NSInteger)endPadding {
    return (7 - [self.calendar component:NSCalendarUnitWeekday fromDate:[NSDate lastDayOfCurrentMonth]]);
}

- (NSArray *)daysOfWeekPrefixes {
    return @[@"S", @"M", @"T", @"W", @"T", @"F", @"S"];
}

#pragma mark - Init

- (instancetype)init {
    if (self = [super init]) {
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

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    
}

- (void)awakeFromNib {
    [self.collectionView registerNib:[UINib nibWithNibName:kDatePickerCollectionViewCellXib bundle:nil] forCellWithReuseIdentifier:kDatePickerCollectionViewCellIdentifier];
    CalendarFlowLayout *flowLayout = [[CalendarFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    [self.collectionView setCollectionViewLayout:flowLayout];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.calendar component:NSCalendarUnitDay fromDate:[NSDate lastDayOfCurrentMonth]] + self.offset + self.endPadding;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DatePickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDatePickerCollectionViewCellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[DatePickerCollectionViewCell alloc] init];
    }
    
    NSInteger currentDay = [self.calendar component:NSCalendarUnitDay fromDate:[NSDate date]];
    NSInteger current = indexPath.row - self.offset + 1;
    NSInteger lastDay = [self.calendar component:NSCalendarUnitDay fromDate:[NSDate lastDayOfCurrentMonth]];
    
    if (indexPath.row >= self.offset &&
        current <= lastDay) {
        [cell setDayLabelText:[NSString stringWithFormat:@"%lu", current]];
        [cell setEnabled:(current >= currentDay)];
        
        if (self.selectedIndex != nil &&
            [self.selectedIndex isEqualToIndexPath:indexPath]) {
            [cell setIsSelected:YES];
        } else if (self.selectedIndex == nil &&
                   current == currentDay) {
            [cell setIsSelected:YES];
        } else {
            [cell setIsSelected:NO];
        }
    } else {
        [cell setDayLabelText:@""];
        [cell setIsSelected:NO];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DatePickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDatePickerCollectionViewCellIdentifier
                                                                                   forIndexPath:indexPath];
    
    if (cell.enabled &&
        !cell.booked) {
        self.selectedIndex = indexPath;
        [self.collectionView reloadData];
    }
}

#pragma mark Collection view layout things

// Layout: Set cell size
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize mElementSize = CGSizeMake(44, 44);
    return mElementSize;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    return UIEdgeInsetsMake(1,1,1,1);  // top, left, bottom, right
}

@end
