//
//  GZCalendarView.h
//  OC_Demo
//
//  Created by 谷胜亚 on 2018/6/1.
//  Copyright © 2018年 谷胜亚. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GZCalendarView, GZMonth, GZDay;
@protocol GZCalendarViewDelegate<NSObject>

/// 当滑动停止后同步更新外层view的size
- (void)calendarView:(GZCalendarView *)calendar updateCalendarViewSize:(CGSize)newSize;

/// 当前月份发生改变后调起的代理
- (void)calendarView:(GZCalendarView *)calendar currentMonthChangeTo:(GZMonth *)month;

/// 点击了指定日期的item
- (void)calendarView:(GZCalendarView *)calendar didSelectItem:(GZDay *)day;
@end

@class GZCalendarStyle;
@interface GZCalendarView : UIView

/// 日历视图的风格
@property (nonatomic, strong) GZCalendarStyle *style;

@property (nonatomic, assign) id<GZCalendarViewDelegate> delegate;

#pragma mark- <-----------  主动方法  ----------->
/// 回到当月
- (void)comebackThisMonth;

/// 动画形式滚动到下一月
- (void)scrollToNextMonth;

/// 动画形式滚动到上一月
- (void)scrollToLastMonth;

@end


@class GZCalendarItemStyle;
/// 日历风格
@interface GZCalendarStyle : NSObject

/// 每个cell的尺寸
@property (nonatomic, assign) CGSize itemSize;

/// 默认展示日期
@property (nonatomic, strong) NSDate *defaultDate;

/// 以星期几作为一周的第一天[周日1、周一2、周二3、周三4、周四5、周五5、周六7] - 默认周日
@property (nonatomic, assign) NSUInteger firstWeekday;

/// 横着划还是竖着划(默认为NO表示竖直方向滑动)
@property (nonatomic, assign) BOOL horizontalScroll;

/// item风格
@property (nonatomic, strong) GZCalendarItemStyle *itemStyle;

@end

/// 日历Item风格
@interface GZCalendarItemStyle : NSObject

/// 是否展示阴历日期 -- 默认为NO不显示阴历日期
@property (nonatomic, assign) BOOL lunarEnable;

/// 阳历日期与阴历日期竖直方向的间距 -- 以阳历日期为基准, 正值表示向下 默认为0
@property (nonatomic, assign) CGFloat bothTimeMargin;

/// 日期的偏移量 -- 默认为(0,0) 正值表示向右, 正值表示向下
@property (nonatomic, assign) CGPoint offset;

#pragma mark- <-----------  阳历设置  ----------->
/// 阳历日期的颜色
@property (nonatomic, strong) UIColor *solarColor;

/// 阳历日期的font
@property (nonatomic, strong) UIFont *solarFont;

#pragma mark- <-----------  阴历设置  ----------->
/// 阴历日期的颜色
@property (nonatomic, strong) UIColor *lunarColor;

/// 阴历日期的font
@property (nonatomic, strong) UIFont *lunarFont;

@end
