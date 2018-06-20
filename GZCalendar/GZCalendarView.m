//
//  GZCalendarView.m
//  OC_Demo
//
//  Created by 谷胜亚 on 2018/6/1.
//  Copyright © 2018年 谷胜亚. All rights reserved.
//  日历视图

#import "GZCalendarView.h"
#import "GZCalendarCell.h"
#import "GZYearMonthDay.h"
#import "GZCalendarManager.h"
#import "GZCalendarFlowLayout.h"

@interface GZCalendarView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/// 下方日历视图
@property (nonatomic, strong) UICollectionView *collectionView;

/// 数据源
@property (nonatomic, strong) NSArray *dataList;

/// 正在展示的月份
@property (nonatomic, strong) GZMonth *activeMonth;

/// 布局类
@property (nonatomic, strong) GZCalendarFlowLayout *flowLayout;

@end

@implementation GZCalendarView

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    
    return self;
}

// 即将添加到父视图上
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview != nil) // 当该值不为nil的时候才表示即将被添加到父视图上, 为nil时表示即将从父视图移除
    {
        [self configUI];
    }
}

/// 配置UI控件
- (void)configUI
{
    /// 设置父视图的属性
    self.backgroundColor = [UIColor whiteColor];
    
    /// 初始化collectionView
    GZCalendarFlowLayout *flowLayout = [[GZCalendarFlowLayout alloc] init];
    self.flowLayout = flowLayout;
    
    // 滚动方向
    flowLayout.scrollDirection = self.style.horizontalScroll ? UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.frame = CGRectMake(0, 0, 1, 1);
    
    // 注册collectionViewCell
    [collectionView registerClass:[GZCalendarCell class] forCellWithReuseIdentifier:@"GZCalendarCell"];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.bounces = NO; // 没有弹簧效果
    collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    // 默认加载当月数据
    [self loadNewDataWithCenterMonth:self.style.defaultDate];
}


#pragma mark- <-----------  UICollectionViewDataSource  ----------->
// 共多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataList.count;
}

// 对应组有多少cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    GZMonth *month = self.dataList[section];
    return month.allDays.count;
}

// 对应索引cell如何设置
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GZCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GZCalendarCell" forIndexPath:indexPath];
    cell.layer.borderColor = [UIColor blueColor].CGColor;
    cell.layer.borderWidth = 1;
    GZMonth *month = self.dataList[indexPath.section];
    GZDay *day = month.allDays[indexPath.row];
    cell.day = day;
    return cell;
}

// 每个cell的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.style.itemSize.width, self.style.itemSize.height);
}

// 组inset
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

// 组头视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeZero;
}

// 组尾视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

// 组内item行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

// 组内列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

// 组头视图或组尾视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) // 组头
    {
        return nil;
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        return nil;
    }
    
    return nil;
}


#pragma mark- <-----------  UICollectionViewDelegate  ----------->
// 点击对应索引位置cell的处理事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    
}


#pragma mark- <-----------  UIScrollViewDelegate  ----------->
// 系统滚动动画结束调用的代理
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView  // 在该方法中加载新的数据
{
    [self updateCollectionToCenter];
    NSLog(@"滚动停止动画");
}

// 停止减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self endScrollAction];
    NSLog(@"滚动已停止减速");
}

// 不减速有两种情况： 1. 慢慢移动  2. 滚动到边缘位置无法再次滚动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) // 将会减速bool属性为NO时, 表示滑动到了边界而被迫终止滑动,因此不会调用scrollViewDidEndDecelerating方法需要在这种情况下设置对应处理方法
    {
        // 将collectionView滚动到第三页
        [self endScrollAction];
        NSLog(@"停止拖拽, 不会减速");
        return;
    }
    NSLog(@"停止拖拽, 减速");
}

/// 滚动时手指即将离开屏幕, 离开屏幕后系统计算得到的滚动时间, 系统计算后得到的新的offset
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
//
//    // 获取手指离开时offset
//    CGPoint startPoint = scrollView.contentOffset;
//
//    // 获取系统计算的移动后offset
//    CGPoint endPoint = *targetContentOffset;
//
//    // 判断松手前的位置
//    CGSize minSize = CGSizeZero; int i = -1;
//    while (startPoint.y > minSize.width + minSize.height)
//    {
//        i++;
//
//        // 索引位置的size
//        NSString *sizeString = [self.monthOffsetAndHeight objectForKey:[NSNumber numberWithUnsignedInteger:i]];
//
//        // 转为CGSize(offset, 高度)
//        minSize = CGSizeFromString(sizeString);
//    }
//
//    // 上一月
//    if (endPoint.y < minSize.width)
//    {
//        targetContentOffset->y = minSize.width;
//    }
//    else if (endPoint.y > minSize.width + minSize.height / 2) // 上移超过1/2, 则滚动到下一月
//    {
//        targetContentOffset->y = minSize.width + minSize.height;
//    }
//    else
//    {
//        targetContentOffset->y = minSize.width;
//    }
//}


/// 更新collectionView到中心位置
- (void)updateCollectionToCenter
{
    int i = 0; GZMonth *month = nil;
    CGFloat left = self.style.horizontalScroll ? self.collectionView.contentOffset.x : self.collectionView.contentOffset.y;
    CGFloat right = 0;
    
    do {
        month = self.dataList[i];
        right = self.style.horizontalScroll ? month.offset.x + month.size.width : month.offset.y + month.size.height;
        i++;
    } while (left >= floor(right));
    
    if (i == 3) return;
    
    // 2. 非当前组的话, 加载新的应该显示的数据
    GZDay *day = month.allDays.firstObject;
    
    // 3. 刷新数据
    [self loadNewDataWithCenterMonth:day.date];
}

/// 当滚动停止或无法滚动时执行的操作
- (void)endScrollAction
{
    // 1. 即将停止时的offset
    CGPoint offset = self.collectionView.contentOffset;
    
    // 取得最后一个数据
    GZMonth *tmp = self.dataList.lastObject;
    
    CGFloat left  = self.style.horizontalScroll ? offset.x : offset.y;
    CGFloat right = self.style.horizontalScroll ? tmp.offset.x : tmp.offset.y;
    
    CGFloat full = 0;
    
    if (fabs(left - right) <= 1 || left == 0) {
        
        [self updateCollectionToCenter];return;
    }

    // 2. 判断滚动到了索引为几的一组
    int i = 0; GZMonth *month = nil;
    do {
        month = self.dataList[i];
        full = self.style.horizontalScroll ? month.offset.x + month.size.width : month.offset.y + month.size.height;
        i++;
    } while (left >= floor(full));
    
    
    CGFloat half = self.style.horizontalScroll ? month.offset.x + month.size.width / 2 : month.offset.y + month.size.height / 2;
    // 超过一半的话就到下一页
    if (left > half)
    {
        offset = self.style.horizontalScroll ? CGPointMake(month.offset.x + month.size.width, 0) : CGPointMake(0, month.offset.y + month.size.height);
    }
    else
    {
        offset = self.style.horizontalScroll ? CGPointMake(month.offset.x, 0) : CGPointMake(0, month.offset.y);
    }

    // 4. 动画形式滚动
    [self.collectionView setContentOffset:offset animated:YES];
}


#pragma mark- <-----------  根据当前应该显示的月份加载邻近4个月的数据  ----------->
- (void)loadNewDataWithCenterMonth:(NSDate *)date
{
    NSMutableArray *tmp = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        NSDateComponents *com = [[NSDateComponents alloc] init];
        com.month = i - 5 / 2;
        NSDate *newDate = [[GZCalendarManager manager].calendar dateByAddingComponents:com toDate:date options:0];
        GZMonth *month = [[GZCalendarManager manager] loadDataWithTime:newDate];
        [tmp addObject:month];
    }
    
    self.dataList = [self layoutCellFrameWithDataSource:tmp];
    
    // 重新给layout对象数据源
    self.flowLayout.itemList = self.dataList;
    
    // 刷新collectionView
    [self.collectionView reloadData];
    
    // 调起代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarView:currentMonthChangeTo:)]) {
        [self.delegate calendarView:self currentMonthChangeTo:self.dataList[2]];
    }
}

#pragma mark- <-----------  主动方法  ----------->
/// 回到当月
- (void)comebackThisMonth
{
    NSDateComponents *com1 = [[GZCalendarManager manager].calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:self.activeMonth.monthTime];
    NSDateComponents *com2 = [[GZCalendarManager manager].calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:self.style.defaultDate];
    if (com1.year == com2.year && com1.month == com2.month) {
        return;
    }
    [self loadNewDataWithCenterMonth:self.style.defaultDate];
}

/// 动画形式滚动到下一月
- (void)scrollToNextMonth
{
    // 取得索引为3的月份
    GZMonth *month = self.dataList[3];
    
    // 滚动
    [self.collectionView setContentOffset:month.offset animated:YES];
}

/// 动画形式滚动到上一月
- (void)scrollToLastMonth
{
    // 取得索引为1的月份
    GZMonth *month = self.dataList[1];
    
    // 滚动
    [self.collectionView setContentOffset:month.offset animated:YES];
}


#pragma mark- <-----------  计算数据在layout中的布局  ----------->
/// 在外部计算cell布局及frame并保存到day对象中等待传入layout
- (NSArray *)layoutCellFrameWithDataSource:(NSArray *)dataSource
{
    // 预加载月份数量
    NSUInteger sectionCount = dataSource.count;
    
    // 每个在contentSize范围的元素X值和Y值
    CGFloat itemX = 0, itemY = 0;
    
    // 偏移量
    CGPoint offset = CGPointZero;
    
    // 循环组
    for (int i = 0; i < sectionCount; i++) {
        
        // 索引月份可视范围高度
        CGFloat monthDisplayH = self.style.itemSize.height;
        
        // 取出对应索引的Month对象
        GZMonth *month = [dataSource objectAtIndex:i];
        
        // 全部Day的数组
        NSArray *dayList = month.allDays;
        
        // 指定组中有多少cell
        NSInteger itemCount = [dayList count];
        
        // 标记当前行
        NSInteger currentRow = 0;
        
        // 循环
        for (int j = 0; j < itemCount; j++) {

            // 从数据源中取出对应indexPath的Day对象
            GZDay *day = dayList[j];
            
            // 某天处于日历的列索引(随指定周几为一周的第一天而发生变化)
            NSInteger columnIndex = (day.dayOfWeek + 7 - 1) % 7;
            
            // 动态行索引
            NSInteger rowIndex = 0;
            
            // 求余
            NSInteger remainder = day.dayOfMonth % 7;
            
            // 商
            NSInteger quotient = day.dayOfMonth / 7;
            
            // 求余为0时
            if (remainder == 0 && columnIndex == 6) // 求余为0且列索引为6表示每周的最后一天, 肯定整除
            {
                rowIndex = quotient - 1; // 整除的值减一即为行索引
            }
            else if (remainder - columnIndex <= 1) // 余数减去列索引小于等于1表示当前商值即为行索引
            {
                rowIndex = quotient;
            }
            else
            {
                rowIndex = quotient + 1;
            }
            
            
            if (rowIndex != currentRow)
            {
                currentRow++;
                // 当月实际高度增加
                monthDisplayH += self.style.itemSize.height;
            }
            
            // 获取到当前item的行索引以及列索引后, 设置item的X、Y值
            itemX = self.style.horizontalScroll ? (self.style.itemSize.width * 7 * i + self.style.itemSize.width * columnIndex) : self.style.itemSize.width * columnIndex;
            itemY = offset.y + self.style.itemSize.height * rowIndex;
            
            // 设置Day对象的orign属性
            day.location = CGPointMake(itemX, itemY);
        }
        
        // 某月全部显示所占的高度
        CGFloat totolDisplayH = monthDisplayH;
        
        
        
        // 设置Month的属性
        month.offset = offset;
        month.size = CGSizeMake(7 * self.style.itemSize.width, totolDisplayH);
        
        // 更新下月的offset
        if (self.style.horizontalScroll) // 水平滚动
        {
            offset = CGPointMake(offset.x + self.style.itemSize.width * 7, 0);
        }
        else // 竖直滚动
        {
            offset = CGPointMake(0, offset.y + totolDisplayH);
        }
        
        // 计算出处于中间位置月份的offsetY以及展示高度
        if (i == 2) {
            // 保存正在展示月份
            self.activeMonth = month;
            
            // 更新frame
            self.collectionView.frame = CGRectMake(0, 0, month.size.width, month.size.height);
            
            // 让外层的view同步改变尺寸
            if (self.delegate && [self.delegate respondsToSelector:@selector(calendarView:updateCalendarViewSize:)]) {
                [self.delegate calendarView:self updateCalendarViewSize:self.collectionView.frame.size];
            }
            
            // 滚动到指定offset
            [self.collectionView setContentOffset:month.offset];
        }
    }
    
    return dataSource;
}


#pragma mark- <-----------  Get / Set方法  ----------->
- (GZCalendarStyle *)style
{
    if (!_style) {
        _style = [[GZCalendarStyle alloc] init];
    }
    
    return _style;
}

@end



@implementation GZCalendarStyle

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 设置默认值
        self.horizontalScroll = NO; // 默认竖直方向滑动
        self.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 40) / 7, ([UIScreen mainScreen].bounds.size.width - 40) / 7); // 默认item的尺寸
        self.defaultDate = [NSDate date]; // 默认当天日期为今天
        self.firstWeekday = 1; // 默认一周的第一天为周日
        self.itemStyle = [[GZCalendarItemStyle alloc] init]; // item风格
    }
    
    return self;
}

@end


@implementation GZCalendarItemStyle

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 设置默认值
        self.lunarEnable = YES;
        self.lunarFont = [UIFont systemFontOfSize:12];
        self.lunarColor = [UIColor blackColor];
        self.solarColor = [UIColor blackColor];
        self.solarFont = [UIFont systemFontOfSize:12];
        
        // 偏移量、间距
        self.offset = CGPointMake(0, 0);
        self.bothTimeMargin = 0;
    }
    
    return self;
}

@end









