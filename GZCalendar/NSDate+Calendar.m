//
//  NSDate+Calendar.m
//  OC_Demo
//
//  Created by 谷胜亚 on 2018/6/1.
//  Copyright © 2018年 谷胜亚. All rights reserved.
//

#import "NSDate+Calendar.h"
#import "GZCalendarManager.h"

/// 天干
static NSString const *HeavenlyStems[10] =
{
    @"甲", @"乙", @"丙", @"丁", @"戊", @"己", @"庚", @"辛", @"壬", @"癸"
};
/// 地支
static NSString const *EarthlyBranches[12] =
{
    @"子", @"丑", @"寅", @"卯", @"辰", @"巳", @"午", @"未", @"申", @"酉", @"戌", @"亥"
};
/// 生肖
static NSString const *Zodiac[12] =
{
    @"鼠", @"牛", @"虎", @"兔", @"龙", @"蛇", @"马", @"羊", @"猴", @"鸡", @"狗", @"猪"
};
/// 农历月
static NSString const *LunarMonth[12] =
{
    @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月", @"十月", @"冬月", @"腊月"
};
/// 农历日
static NSString const *LunarDay[30] =
{
    @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
    @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
    @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十"
};


@implementation NSDate (Calendar)

/// 公历
+ (NSCalendar *)gregorianCalendar
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    calendar.timeZone = [NSTimeZone localTimeZone];
    return calendar;
}

- (NSDate *)firstDayOfMonth
{
    NSAssert(self != nil, @"时间为空");
    NSDateComponents *components = [[self.class gregorianCalendar] components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:self];
    // 设置day属性为1
    [components setDay:1];
    // 生成新的时间
    NSDate *newDate = [[self.class gregorianCalendar] dateFromComponents:components];
    return newDate;
}

- (NSUInteger)daysOfMonth
{
    NSAssert(self != nil, @"时间为空");
    NSRange range = [[self.class gregorianCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    return range.length;
}

/// 所属年的天数
- (NSUInteger)daysOfYear
{
    NSAssert(self != nil, @"时间为空");
    NSRange range = [[self.class gregorianCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:self];
    return range.length;
}

/// 所属月的周数
- (NSUInteger)weeksOfMonth
{
    NSAssert(self != nil, @"时间为空");
    NSRange range = [[self.class gregorianCalendar] rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:self];
    return range.length;
}

/// 所属月的天数索引
- (NSUInteger)dayIndexOfMonth
{
    NSAssert(self != nil, @"时间为空");
    NSInteger index = [[self.class gregorianCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    return index;
}

/// 所属周的天数索引 - 星期几
- (NSUInteger)dayIndexOfWeek
{
    NSAssert(self != nil, @"时间为空");
    NSDateComponents *components = [[self.class gregorianCalendar] components:NSCalendarUnitWeekday fromDate:self];
    return components.weekday;
}

/// 所属月的周数索引
- (NSUInteger)weekIndexOfMonth
{
    NSAssert(self != nil, @"时间为空");
    NSInteger index = [[self.class gregorianCalendar] ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitMonth forDate:self];
    return index;
}

/// 当月的月份
- (NSUInteger)monthIndexOfYear
{
    NSAssert(self != nil, @"时间为空");
    NSInteger index = [[self.class gregorianCalendar] ordinalityOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:self];
    return index;
}

/// 当年的月数量
- (NSUInteger)monthsOfYear
{
    NSAssert(self != nil, @"时间为空");
    NSRange range = [[self.class gregorianCalendar] rangeOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:self];
    return range.length;
}

#pragma mark- <-----------  阴历(中国农历)情况  ----------->
/// 天干地支
- (NSString *)heavenlyStemAndEarthlyBranche
{
    NSAssert(self != nil, @"时间为空");
    NSDateComponents *com = [[GZCalendarManager manager].lunarCalendar components:NSCalendarUnitYear fromDate:self];
    NSUInteger heavenlyIndex = (com.year - 1) % 10;
    NSUInteger earthlyIndex = (com.year - 1) % 12;
    return [NSString stringWithFormat:@"%@%@", HeavenlyStems[heavenlyIndex], EarthlyBranches[earthlyIndex]];
}

/// 生肖属相
- (NSString *)zodiac
{
    NSAssert(self != nil, @"时间为空");
    NSDateComponents *com = [[GZCalendarManager manager].lunarCalendar components:NSCalendarUnitYear fromDate:self];
    NSUInteger zodiacIndex = (com.year - 1) % 12;
    return [NSString stringWithFormat:@"%@", Zodiac[zodiacIndex]];
}

/// 农历月
- (NSString *)lunarMonth
{
    NSAssert(self != nil, @"时间为空");
    NSDateComponents *com = [[GZCalendarManager manager].lunarCalendar components:NSCalendarUnitMonth fromDate:self];
    NSUInteger lunarMonthIndex = (com.month - 1) % 12;
    return [NSString stringWithFormat:@"%@", LunarMonth[lunarMonthIndex]];
}

/// 农历日
- (NSString *)lunarDay
{
    NSAssert(self != nil, @"时间为空");
    NSDateComponents *com = [[GZCalendarManager manager].lunarCalendar components:NSCalendarUnitDay fromDate:self];
    NSUInteger lunarDayIndex = (com.day - 1) % 30;
    return [NSString stringWithFormat:@"%@", LunarDay[lunarDayIndex]];
}

@end
