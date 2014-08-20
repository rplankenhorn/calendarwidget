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
#import "UIView+AutoLayout.h"

static NSString * const kDatePickerCollectionViewCellIdentifier = @"DatePickerCollectionViewCellIdentifier";
static NSString * const kDatePickerCollectionViewCellXib        = @"DatePickerCollectionViewCell";
static NSUInteger const kDaysInWeek                             = 7;

@interface DatePickerView () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) NSMutableArray *dayLabels;
@property (strong, nonatomic) UIButton *leftChevronButton;
@property (strong, nonatomic) UILabel *monthTitleLabel;
@property (strong, nonatomic) UIButton *rightChevronButton;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) CalendarFlowLayout *calendarFlowLayout;
@property (strong, nonatomic) NSCalendar *calendar;
@property (assign, nonatomic, readonly) NSInteger offset;
@property (assign, nonatomic, readonly) NSInteger endPadding;
@property (strong, nonatomic) NSIndexPath *selectedIndex;

@property (strong, nonatomic, readonly) NSArray *daysOfWeekPrefixes;
@end

@implementation DatePickerView

#pragma mark - Getters

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f  blue:235.0f/255.0f  alpha:1.0f];
    }
    return _headerView;
}

- (NSMutableArray *)dayLabels {
    if (!_dayLabels) {
        _dayLabels = [[NSMutableArray alloc] init];
        
        for (int i=0; i<kDaysInWeek; i++) {
            UILabel *dayLabel = [[UILabel alloc] init];
            dayLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0f];
            dayLabel.textColor = [UIColor colorWithRed:201.0f/255.0f green:201.0f/255.0f blue:201.0f/255.0f alpha:1.0f];
            dayLabel.text = self.daysOfWeekPrefixes[i];
            dayLabel.textAlignment = NSTextAlignmentCenter;
            [_dayLabels addObject:dayLabel];
        }
    }
    return _dayLabels;
}

- (UIButton *)leftChevronButton {
    if (!_leftChevronButton) {
        _leftChevronButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftChevronButton setImage:[UIImage imageNamed:@"left_chevron"] forState:UIControlStateNormal];
    }
    return _leftChevronButton;
}

- (UILabel *)monthTitleLabel {
    if (!_monthTitleLabel) {
        _monthTitleLabel = [[UILabel alloc] init];
        _monthTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0f];
        _monthTitleLabel.textColor = [UIColor colorWithRed:87.0f/255.0f green:97.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
        _monthTitleLabel.textAlignment = NSTextAlignmentCenter;
        _monthTitleLabel.text = @"December 2013";
    }
    return _monthTitleLabel;
}

- (UIButton *)rightChevronButton {
    if (!_rightChevronButton) {
        _rightChevronButton = [[UIButton alloc] init];
        [_rightChevronButton setImage:[UIImage imageNamed:@"right_chevron"] forState:UIControlStateNormal];
    }
    return _rightChevronButton;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.calendarFlowLayout];
        _collectionView.backgroundColor = [UIColor colorWithRed:197.0f/255.0f green:198/255.0f  blue:195.0f/255.0f  alpha:1.0f];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

- (CalendarFlowLayout *)calendarFlowLayout {
    if (!_calendarFlowLayout) {
        _calendarFlowLayout = [[CalendarFlowLayout alloc] init];
        [_calendarFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _calendarFlowLayout.minimumInteritemSpacing = 0;
        _calendarFlowLayout.minimumLineSpacing = 0;
    }
    return _calendarFlowLayout;
}

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
    if (self = [super initWithFrame:CGRectMake(0, 0, 316.0f, 480.0f)]) {
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
    [self.headerView addSubview:self.leftChevronButton];
    [self.headerView addSubview:self.monthTitleLabel];
    [self.headerView addSubview:self.rightChevronButton];
    
    for (UILabel *label in self.dayLabels) {
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [self.headerView addSubview:label];
    }
    
    [self addSubview:self.headerView];
    
    [self addSubview:self.collectionView];
    
    self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.leftChevronButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.monthTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.rightChevronButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.collectionView registerNib:[UINib nibWithNibName:kDatePickerCollectionViewCellXib bundle:nil] forCellWithReuseIdentifier:kDatePickerCollectionViewCellIdentifier];
}

- (void)updateConstraints {
    [super updateConstraints];
    
    NSDictionary *viewsDictionary = @{@"headerView": self.headerView,
                                      @"leftChevronButton": self.leftChevronButton,
                                      @"monthTitleLabel": self.monthTitleLabel,
                                      @"rightChevronButton": self.rightChevronButton,
                                      @"collectionView": self.collectionView};
    
    NSDictionary *metrics = @{@"width": @316,
                              @"headerViewHeight": @101,
                              @"collectionViewHeight": @379,
                              @"dayLabelWidth": @15,
                              @"dayLabelHeight": @21,
                              @"chevronWidth": @26,
                              @"chevronHeight": @27,
                              @"chevronSpacing": @10,
                              @"monthTitleLabelHeight": @21};
    
    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-chevronSpacing-[leftChevronButton(==chevronWidth)]" options:0 metrics:metrics views:viewsDictionary]];
    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[leftChevronButton(==chevronHeight)]" options:0 metrics:metrics views:viewsDictionary]];
    [self.leftChevronButton centerInContainerOnAxis:NSLayoutAttributeCenterY];
    
    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[rightChevronButton(==chevronWidth)]-chevronSpacing-|" options:0 metrics:metrics views:viewsDictionary]];
    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[rightChevronButton(==chevronHeight)]" options:0 metrics:metrics views:viewsDictionary]];
    [self.rightChevronButton centerInContainerOnAxis:NSLayoutAttributeCenterY];
    
    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[monthTitleLabel]-0-|" options:0 metrics:metrics views:viewsDictionary]];
    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[monthTitleLabel(==monthTitleLabelHeight)]" options:0 metrics:metrics views:viewsDictionary]];
    [self.monthTitleLabel centerInContainerOnAxis:NSLayoutAttributeCenterY];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[headerView(==width)]-0-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:viewsDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collectionView(==width)]-0-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:viewsDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[headerView(==headerViewHeight)]-0-[collectionView(==collectionViewHeight)]"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:viewsDictionary]];
    
    [self.headerView spaceViews:self.dayLabels onAxis:UILayoutConstraintAxisHorizontal withSpacing:-4.0f alignmentOptions:0];
    
    for (UILabel *label in self.dayLabels) {
        viewsDictionary = @{@"label": label};
        [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[label(==dayLabelHeight)]-0-|" options:0 metrics:metrics views:viewsDictionary]];
    }
}

#pragma mark - UICollectionViewDataSource

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

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DatePickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDatePickerCollectionViewCellIdentifier
                                                                                   forIndexPath:indexPath];
    
    if (cell.enabled &&
        !cell.booked) {
        self.selectedIndex = indexPath;
        [self.collectionView reloadData];
    }
}

#pragma mark Collection view layout

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
    return UIEdgeInsetsMake(1,1,1,1);  // top, left, bottom, right
}

@end
