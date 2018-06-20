//
//  GZCalendarCell.m
//  OC_Demo
//
//  Created by 谷胜亚 on 2018/6/4.
//  Copyright © 2018年 谷胜亚. All rights reserved.
//

#import "GZCalendarCell.h"
#import "GZCalendarView.h"
#import "NSDate+Calendar.h"
#import "GZYearMonthDay.h"
@interface GZCalendarCell()

/// 阳历日期
@property (nonatomic, strong) UILabel *solarTime;

/// 阴历日期
@property (nonatomic, strong) UILabel *lunarTime;

/// 当天背景视图
@property (nonatomic, strong) UIView *bgView;

@end
@implementation GZCalendarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self uiInitialize];
    }
    
    return self;
}

/// UI初始化
- (void)uiInitialize
{
    // 阳历时间
    UILabel *solarTime = [[UILabel alloc] init];
    solarTime.textAlignment = NSTextAlignmentCenter;
    [self addSubview:solarTime];
    self.solarTime = solarTime;
    
    // 阴历时间
    UILabel *lunarTime = [[UILabel alloc] init];
    lunarTime.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lunarTime];
    self.lunarTime = lunarTime;
}

- (void)setDay:(GZDay *)day
{
    _day = day;
    
    self.solarTime.text = [NSString stringWithFormat:@"%ld-%ld", [day.date monthIndexOfYear], day.dayOfMonth];
    self.solarTime.font = self.style.itemStyle.solarFont;
    self.solarTime.textColor = self.style.itemStyle.solarColor;
    [self.solarTime sizeToFit];
    CGSize solarSize = self.solarTime.frame.size;
    CGFloat solarX = self.bounds.size.width / 2 - solarSize.width / 2;

    // 偏移量
    CGFloat offsetX = self.style.itemStyle.offset.x;
    CGFloat offsetY = self.style.itemStyle.offset.y;
    // 间距
    CGFloat margin = self.style.itemStyle.bothTimeMargin;
    
    self.solarTime.frame = CGRectMake(solarX + offsetX, (self.bounds.size.height - solarSize.height) / 2 + offsetY, solarSize.width, solarSize.height);
    
    // 是否显示农历
    if (self.style.itemStyle.lunarEnable) // 显示农历
    {
        self.lunarTime.hidden = NO;
        self.lunarTime.text = [NSString stringWithFormat:@"%@", [day.date lunarDay]];
        self.lunarTime.font = _style.itemStyle.lunarFont;
        self.lunarTime.textColor = _style.itemStyle.lunarColor;
        [self.lunarTime sizeToFit];
        CGSize lunarSize = self.lunarTime.frame.size;
        
        // 捆绑两者并算出两者中间值
        CGFloat maxHeight = solarSize.height + lunarSize.height + margin;
        
        // 阳历label的X、Y值
        CGFloat solarY = (self.bounds.size.height - maxHeight) / 2 + offsetY;
        
        // 阴历label的X、Y值
        CGFloat lunarX = self.bounds.size.width / 2 - lunarSize.width / 2 + offsetX;
        CGFloat lunarY = solarY + solarSize.height + margin;
        
        self.solarTime.frame = CGRectMake(solarX + offsetX, solarY, solarSize.width, solarSize.height);
        self.lunarTime.frame = CGRectMake(lunarX, lunarY, lunarSize.width, lunarSize.height);
    }
    else // 不显示
    {
        self.lunarTime.hidden = YES;
    }
    
    // 是否高亮显示
    
}

- (GZCalendarStyle *)style
{
    if (!_style) {
        _style = [[GZCalendarStyle alloc] init];
    }
    
    return _style;
}

@end
