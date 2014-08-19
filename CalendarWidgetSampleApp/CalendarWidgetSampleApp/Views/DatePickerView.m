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

static NSString * const kDatePickerCollectionViewCellIdentifier = @"DatePickerCollectionViewCellIdentifier";
static NSString * const kDatePickerCollectionViewCellXib        = @"DatePickerCollectionViewCell";

@interface DatePickerView () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation DatePickerView

- (void)awakeFromNib {
    [self.collectionView registerNib:[UINib nibWithNibName:kDatePickerCollectionViewCellXib bundle:nil] forCellWithReuseIdentifier:kDatePickerCollectionViewCellIdentifier];
    CalendarFlowLayout *flowLayout = [[CalendarFlowLayout alloc] init];
//    [flowLayout setItemSize:CGSizeMake(50, 50)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    [self.collectionView setCollectionViewLayout:flowLayout];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 35;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DatePickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDatePickerCollectionViewCellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[DatePickerCollectionViewCell alloc] init];
    }
    
    [cell setDayLabelText:@"31"];
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
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
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    return UIEdgeInsetsMake(1,1,1,1);  // top, left, bottom, right
}

@end
