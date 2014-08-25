//
//  TimePickerView.m
//  CalendarWidgetSampleApp
//
//  Created by Robbie Plankenhorn on 8/21/14.
//  Copyright (c) 2014 Plankenhorn,net. All rights reserved.
//

#import "TimePickerView.h"

static UIEdgeInsets const kSectionInset                         = {10.0f, 20.0f, 10.0f, 10.0f};
static CGSize const kCollectionViewCellSize                     = {120.0f, 40.0f};
static CGFloat const kMinimumInteritemSpacing                   = 5.0f;
static CGFloat const kMinimumLineSpacing                        = 5.0f;
static CGFloat const kSecondsIn15Min                            = 900.0f;
static CGFloat const kSecondsInHalfHour                         = 1800.0f;
static CGFloat const kSecondsInHour                             = 3600.0f;

@interface TimePickerView ()
@property (strong, nonatomic) NSArray *times;
@property (assign, nonatomic, readonly) NSInteger appointmentLength;
@property (assign, nonatomic, readonly) NSInteger numberOfAppointmentsInDay;
@end

@implementation TimePickerView

#pragma mark - Getters

- (NSArray *)times {
    if (!_times) {
        if ([self.dataSource respondsToSelector:@selector(availableTimesForTimePickerView:)] &&
            [self.dataSource availableTimesForTimePickerView:self] != nil) {
            _times = [self.dataSource availableTimesForTimePickerView:self];
        } else {
            NSMutableArray *mutTimes = [[NSMutableArray alloc] init];
            
            NSDateComponents *components = [[NSDateComponents alloc] init];
            [components setHour:0];
            [components setMinute:0];
            
            NSDate *previousDate = [self.calendar dateFromComponents:components];
            [mutTimes addObject:previousDate];
            
            for (int i=1; i<self.numberOfAppointmentsInDay; i++) {
                NSDate *date = [NSDate dateWithTimeInterval:self.appointmentLength sinceDate:previousDate];
                [mutTimes addObject:date];
                previousDate = date;
            }
            
            _times = [NSArray arrayWithArray:mutTimes];
        }
    }
    return _times;
}

- (NSInteger)appointmentLength {
    if ([self.dataSource respondsToSelector:@selector(timeIntervalForTimePickerView:)]) {
        switch ([self.dataSource timeIntervalForTimePickerView:self]) {
            case TimePickerTimeInterval_15MIN:
                return kSecondsIn15Min;
            case TimePickerTimeInterval_30MIN:
                return kSecondsInHalfHour;
            case TimePickerTimeInterval_1HR:
            default:
                return kSecondsInHour;
        }
    } else {
        return kSecondsInHour;
    }
}

- (NSInteger)numberOfAppointmentsInDay {
    if ([self.dataSource respondsToSelector:@selector(timeIntervalForTimePickerView:)]) {
        return 24 * [self.dataSource timeIntervalForTimePickerView:self];
    } else {
        return 24;
    }
}

#pragma mark - Init

- (void)commonInit {
    [super commonInit];
    self.backgroundColor = [UIColor headerBackgroundColor];
    
    self.dateFormatter.timeStyle = NSDateFormatterShortStyle;
    self.calendarFlowLayout.maximumSpacing = 10.0f;
    
    [self addSubview:self.collectionView];
}

- (void)updateConstraints {
    [super updateConstraints];
    
    NSDictionary *viewsDictionary = @{@"collectionView": self.collectionView};
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collectionView]-0-|" options:0 metrics:nil views:viewsDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[collectionView]-0-|" options:0 metrics:nil views:viewsDictionary]];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.times.count;
}

- (DatePickerCollectionViewCell *)retrieveDatePickerCellWithCollectionView:(UICollectionView *)collectionView
                                                              andIndexPath:(NSIndexPath *)indexPath {
    DatePickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPickerCollectionViewCellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[DatePickerCollectionViewCell alloc] init];
    }
    
    cell.enabled = YES;
    [cell setDayLabelText:[self.dateFormatter stringFromDate:[self.times objectAtIndex:indexPath.row]]];
    
    if (self.selectedIndex != nil &&
        [self.selectedIndex isEqualToIndexPath:indexPath]) {
        [cell setIsSelected:YES];
    } else {
        [cell setIsSelected:NO];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DatePickerCollectionViewCell *cell = [self retrieveDatePickerCellWithCollectionView:collectionView andIndexPath:indexPath];
    if (cell.enabled &&
        !cell.booked) {
        self.selectedIndex = indexPath;
        [self.collectionView reloadData];
        
        if ([self.delegate respondsToSelector:@selector(timePickerView:didSelectDate:)]) {
            [self.delegate timePickerView:self didSelectDate:[self.times objectAtIndex:indexPath.row]];
        }
    }
}

#pragma mark Collection view layout

// Layout: Set cell size
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return kCollectionViewCellSize;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kMinimumInteritemSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kMinimumLineSpacing;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return kSectionInset;  // top, left, bottom, right
}

@end