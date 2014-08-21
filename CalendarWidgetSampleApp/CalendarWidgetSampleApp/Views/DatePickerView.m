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
#import "UIColor+Common.h"

static NSString * const kDatePickerCollectionViewCellIdentifier = @"DatePickerCollectionViewCellIdentifier";
static NSString * const kDatePickerCollectionViewCellXib        = @"DatePickerCollectionViewCell";

static CGFloat const kCollectionViewHeightBuffer                = 7.0f;
static CGFloat const kViewWidth                                 = 316.0f;
static CGFloat const kHeaderViewHeight                          = 85.0f;
static CGSize const kDayLabelSize                               = {15.0f, 21.0f};
static CGSize const kChevronSize                                = {26.0f, 27.0f};
static CGFloat const kChevronSpacing                            = 10.0f;
static CGFloat const kMonthTitleLabelHeight                     = 21.0f;

static UIEdgeInsets const kSectionInset                         = {1.0f, 1.0f, 1.0f, 0.0f};
static CGSize const kCollectionViewCellSize                     = {40.0f, 40.0f};
static CGFloat const kMinimumInteritemSpacing                   = 1.0f;
static CGFloat const kMinimumLineSpacing                        = 1.0f;

static NSString * const kDefaultFont                            = @"HelveticaNeue";
static NSString * const kDefaultFontBold                        = @"HelveticaNeue-Bold";

static NSString * const kLeftChevronImageName                   = @"left_chevron";
static NSString * const kRightChevronImageName                  = @"right_chevron";

@interface DatePickerView () <UICollectionViewDataSource, UICollectionViewDelegate>

// UI Elements
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) NSMutableArray *dayLabels;
@property (strong, nonatomic) UIButton *leftChevronButton;
@property (strong, nonatomic) UILabel *monthTitleLabel;
@property (strong, nonatomic) UIButton *rightChevronButton;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) CalendarFlowLayout *calendarFlowLayout;

// Local properties
@property (strong, nonatomic) NSCalendar *calendar;
@property (assign, nonatomic, readonly) NSInteger offset;
@property (assign, nonatomic, readonly) NSInteger endPadding;
@property (strong, nonatomic) NSIndexPath *selectedIndex;
@property (strong, nonatomic, readonly) NSArray *daysOfWeekPrefixes;

@property (strong, nonatomic) NSDate *firstDateOfCurrentCalendarView;
@property (strong, nonatomic, readonly) NSDate *lastDateOfCurrentCalendarView;

@property (assign, nonatomic, readonly) BOOL isCurrentMonth;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation DatePickerView

#pragma mark - Getters

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor headerBackgroundColor];
        _headerView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _headerView;
}

- (NSMutableArray *)dayLabels {
    if (!_dayLabels) {
        _dayLabels = [[NSMutableArray alloc] init];
        
        for (int i=0; i<self.calendar.weekdaySymbols.count; i++) {
            UILabel *dayLabel = [[UILabel alloc] init];
            dayLabel.font = [UIFont fontWithName:kDefaultFontBold size:17.0f];
            dayLabel.textColor = [UIColor colorWithRed:201.0f/255.0f green:201.0f/255.0f blue:201.0f/255.0f alpha:1.0f];
            dayLabel.text = self.daysOfWeekPrefixes[i];
            dayLabel.textAlignment = NSTextAlignmentCenter;
            dayLabel.translatesAutoresizingMaskIntoConstraints = NO;
            [_dayLabels addObject:dayLabel];
        }
    }
    return _dayLabels;
}

- (UIButton *)leftChevronButton {
    if (!_leftChevronButton) {
        _leftChevronButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftChevronButton setImage:[UIImage imageNamed:kLeftChevronImageName] forState:UIControlStateNormal];
        [_leftChevronButton setImage:[UIImage imageNamed:kLeftChevronImageName] forState:UIControlStateHighlighted];
        [_leftChevronButton addTarget:self action:@selector(leftChevronPressed:) forControlEvents:UIControlEventTouchUpInside];
        _leftChevronButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _leftChevronButton;
}

- (UILabel *)monthTitleLabel {
    if (!_monthTitleLabel) {
        _monthTitleLabel = [[UILabel alloc] init];
        _monthTitleLabel.font = [UIFont fontWithName:kDefaultFontBold size:17.0f];
        _monthTitleLabel.textColor = [UIColor colorWithRed:87.0f/255.0f green:97.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
        _monthTitleLabel.textAlignment = NSTextAlignmentCenter;
        _monthTitleLabel.text = @"December 2013";
        _monthTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _monthTitleLabel;
}

- (UIButton *)rightChevronButton {
    if (!_rightChevronButton) {
        _rightChevronButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightChevronButton setImage:[UIImage imageNamed:kRightChevronImageName] forState:UIControlStateNormal];
        [_rightChevronButton setImage:[UIImage imageNamed:kRightChevronImageName] forState:UIControlStateHighlighted];
        [_rightChevronButton addTarget:self action:@selector(rightChevronPressed:) forControlEvents:UIControlEventTouchUpInside];
        _rightChevronButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _rightChevronButton;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.calendarFlowLayout];
        _collectionView.backgroundColor = [UIColor colorWithRed:197.0f/255.0f green:198/255.0f  blue:195.0f/255.0f  alpha:1.0f];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
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
    return [self.calendar component:NSCalendarUnitWeekday fromDate:self.firstDateOfCurrentCalendarView]-1;
}

- (NSInteger)endPadding {
    return (self.calendar.weekdaySymbols.count - [self.calendar component:NSCalendarUnitWeekday fromDate:self.lastDateOfCurrentCalendarView]);
}

- (NSArray *)daysOfWeekPrefixes {
    return [self.calendar veryShortStandaloneWeekdaySymbols];
}

- (NSDate *)firstDateOfCurrentCalendarView {
    if (!_firstDateOfCurrentCalendarView) {
        _firstDateOfCurrentCalendarView = [self.calendar startOfDayForDate:[NSDate firstDayOfCurrentMonth]];
    }
    return _firstDateOfCurrentCalendarView;
}

- (NSDate *)lastDateOfCurrentCalendarView {
    NSDate *lastDateOfCurrentMonth = self.firstDateOfCurrentCalendarView;
    
    NSDateComponents *component = [[NSDateComponents alloc] init];
    [component setMonth:1];
    
    lastDateOfCurrentMonth = [self.calendar dateByAddingComponents:component
                                                            toDate:lastDateOfCurrentMonth
                                                           options:0];
    
    [component setMonth:0];
    [component setDay:-1];
    
    lastDateOfCurrentMonth = [self.calendar dateByAddingComponents:component
                                                            toDate:lastDateOfCurrentMonth
                                                           options:0];
    
    return lastDateOfCurrentMonth;
}

- (BOOL)isCurrentMonth {
    NSDate *currentDate = [NSDate date];
    
    if ([currentDate compare:self.firstDateOfCurrentCalendarView] != NSOrderedAscending &&
        [currentDate compare:self.lastDateOfCurrentCalendarView] != NSOrderedDescending) {
        return YES;
    }
    
    return NO;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"MMMM yyyy";
    }
    return _dateFormatter;
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
    
    [self refreshCalendar];
}

- (void)updateConstraints {
    [super updateConstraints];
    
    NSDictionary *viewsDictionary = @{@"headerView": self.headerView,
                                      @"collectionView": self.collectionView};
    
    NSDictionary *metrics = @{@"width": @(kViewWidth),
                              @"headerViewHeight": @(kHeaderViewHeight),
                              @"collectionViewHeight": @([self collectionViewHeight])};
    
    // Add horizontal constraints for main subviews
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[headerView]-0-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:viewsDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collectionView]-0-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:viewsDictionary]];
    
    // Add vertical constraints for main subviews
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[headerView(==headerViewHeight)]-0-[collectionView(==collectionViewHeight)]"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:viewsDictionary]];
    
    [self addConstraintsForHeaderView];
}

- (void)addConstraintsForHeaderView {
    NSDictionary *viewsDictionary = @{@"headerView": self.headerView,
                                      @"leftChevronButton": self.leftChevronButton,
                                      @"monthTitleLabel": self.monthTitleLabel,
                                      @"rightChevronButton": self.rightChevronButton};
    
    NSDictionary *metrics = @{@"headerViewHeight": @(kHeaderViewHeight),
                              @"dayLabelWidth": @(kDayLabelSize.width),
                              @"dayLabelHeight": @(kDayLabelSize.height),
                              @"chevronWidth": @(kChevronSize.width),
                              @"chevronHeight": @(kChevronSize.height),
                              @"chevronSpacing": @(kChevronSpacing),
                              @"monthTitleLabelHeight": @(kMonthTitleLabelHeight)};
    
    // Left Chevron Button Location
    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-chevronSpacing-[leftChevronButton(==chevronWidth)]" options:0 metrics:metrics views:viewsDictionary]];
    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[leftChevronButton(==chevronHeight)]" options:0 metrics:metrics views:viewsDictionary]];
    [self.leftChevronButton centerInContainerOnAxis:NSLayoutAttributeCenterY];
    
    // Month Title Label Location
    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[monthTitleLabel]-0-|" options:0 metrics:metrics views:viewsDictionary]];
    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[monthTitleLabel(==monthTitleLabelHeight)]" options:0 metrics:metrics views:viewsDictionary]];
    [self.monthTitleLabel centerInContainerOnAxis:NSLayoutAttributeCenterY];
    
    // Right Chevron Button Location
    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[rightChevronButton(==chevronWidth)]-chevronSpacing-|" options:0 metrics:metrics views:viewsDictionary]];
    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[rightChevronButton(==chevronHeight)]" options:0 metrics:metrics views:viewsDictionary]];
    [self.rightChevronButton centerInContainerOnAxis:NSLayoutAttributeCenterY];
    
    // Add constraints for days of week subviews
    [self.headerView spaceViews:self.dayLabels onAxis:UILayoutConstraintAxisHorizontal withSpacing:-4.0f alignmentOptions:0];
    
    for (UILabel *label in self.dayLabels) {
        viewsDictionary = @{@"label": label};
        [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[label(==dayLabelHeight)]-0-|" options:0 metrics:metrics views:viewsDictionary]];
    }
}

#pragma mark - Actions

- (void)leftChevronPressed:(id)sender {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:-1];
    self.firstDateOfCurrentCalendarView = [self.calendar dateByAddingComponents:components toDate:self.firstDateOfCurrentCalendarView options:0];
    [self refreshCalendar];
}

- (void)rightChevronPressed:(id)sender {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:+1];
    self.firstDateOfCurrentCalendarView = [self.calendar dateByAddingComponents:components toDate:self.firstDateOfCurrentCalendarView options:0];
    [self refreshCalendar];
}

- (void)refreshCalendar {
    if (self.selectedIndex != nil) {
        DatePickerCollectionViewCell *cell = [self retrieveDatePickerCellWithCollectionView:self.collectionView andIndexPath:self.selectedIndex];
        [cell setSelected:NO];
        self.selectedIndex = nil;
    }
    
    self.monthTitleLabel.text = [[self.dateFormatter stringFromDate:self.firstDateOfCurrentCalendarView] capitalizedString];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return [self.calendar component:NSCalendarUnitDay fromDate:self.lastDateOfCurrentCalendarView] + self.offset + self.endPadding;
    return self.calendar.weekdaySymbols.count * 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self retrieveDatePickerCellWithCollectionView:collectionView
                                             andIndexPath:indexPath];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (DatePickerCollectionViewCell *)retrieveDatePickerCellWithCollectionView:(UICollectionView *)collectionView
                                                              andIndexPath:(NSIndexPath *)indexPath {
    DatePickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDatePickerCollectionViewCellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[DatePickerCollectionViewCell alloc] init];
    }
    
    NSInteger currentDay = [self.calendar component:NSCalendarUnitDay fromDate:[NSDate date]];
    NSInteger current = indexPath.row - self.offset + 1;
    NSInteger lastDay = [self.calendar component:NSCalendarUnitDay fromDate:self.lastDateOfCurrentCalendarView];
    
    BOOL enableCell = NO;
    
    if ([self.firstDateOfCurrentCalendarView compare:[NSDate date]] == NSOrderedDescending) {
        // Enable cell if the first date is greater than the current date.
        enableCell = YES;
    } else if (self.isCurrentMonth &&
               current >= currentDay) {
        enableCell = YES;
    }
    
    if (indexPath.row >= self.offset &&
        current <= lastDay) {
        [cell setDayLabelText:[NSString stringWithFormat:@"%ld", (long)current]];
        [cell setEnabled:enableCell];
        
        if (self.selectedIndex != nil &&
            [self.selectedIndex isEqualToIndexPath:indexPath]) {
            [cell setIsSelected:YES];
        } else if (self.selectedIndex == nil &&
                   self.isCurrentMonth &&
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

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DatePickerCollectionViewCell *cell = [self retrieveDatePickerCellWithCollectionView:collectionView andIndexPath:indexPath];
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

#pragma mark - Utility

- (CGFloat)collectionViewHeight {
    NSInteger numberOfRows = [self collectionView:self.collectionView numberOfItemsInSection:0] / self.calendar.weekdaySymbols.count;
    CGFloat rowHeight = [self collectionView:self.collectionView layout:self.calendarFlowLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].height;
    return (CGFloat)numberOfRows * rowHeight + kCollectionViewHeightBuffer;
}

@end