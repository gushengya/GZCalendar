//
//  GZCalendarFlowLayout.m
//  OC_Demo
//
//  Created by 谷胜亚 on 2018/6/4.
//  Copyright © 2018年 谷胜亚. All rights reserved.
//

#import "GZCalendarFlowLayout.h"
#import "GZYearMonthDay.h"

@interface GZCalendarFlowLayout()
{
    CGSize _contentSize;
}


/// 属性信息数组
@property (nonatomic, strong) NSMutableArray *attributeList;

@end
@implementation GZCalendarFlowLayout


// 每次布局都会调用
- (void)prepareLayout
{
    [super prepareLayout];
    
    self.attributeList = [NSMutableArray array];
    for (int i = 0; i < self.itemList.count; i++) {
        GZMonth *month = self.itemList[i];
        for (int j = 0; j < month.allDays.count; j++) {
            GZDay *day = month.allDays[j];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes *att = [super layoutAttributesForItemAtIndexPath:indexPath];
            CGSize size = att.frame.size;
            att.frame = CGRectMake(day.location.x, day.location.y, size.width, size.height);
            [self.attributeList addObject:att];
        }
        
        if (month.offset.x == 0) // 表示竖直方向滚动
        {
            _contentSize = CGSizeMake(0, month.offset.y + month.size.height);
        }
        else // 水平方向滚动
        {
            _contentSize = CGSizeMake(month.offset.x + month.size.width, 0);
        }
    }
}

// 布局结束后设置contentSize
- (CGSize)collectionViewContentSize
{
    return _contentSize;
}

/**
 *  这个方法的返回值是一个数组, 数组里面存放着rect范围内所有元素的布局属性
 *  这个方法的返回值决定了rect范围内所有元素的排布frame
 *
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attributeList;
}

/**
 *  当collectionView的显示范围发生改变的时候是否需要刷新布局
 *  一旦重新刷新布局, 就会重新调用下面的方法:
 *  1. prepareLayout方法
 *  2. layoutAttributesForElementsInRect:方法
 */
//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
//{
//    if (self.reloadLayout) {
//        self.reloadLayout = NO;
//        return YES;
//    }
//    
//    return NO;
//}


// 返回每个item的属性
//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewLayoutAttributes *att = [super layoutAttributesForItemAtIndexPath:indexPath];
//
//
//
//    return [super layoutAttributesForItemAtIndexPath:indexPath];
//}

/**
 *  这个方法的返回值, 决定了collectionView停止滚动时的偏移量
 */
//- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
//{
//
//}

@end
