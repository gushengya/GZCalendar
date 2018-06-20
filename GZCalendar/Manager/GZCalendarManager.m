//
//  GZCalendarManager.m
//  OC_Demo
//
//  Created by 谷胜亚 on 2018/6/1.
//  Copyright © 2018年 谷胜亚. All rights reserved.
//

#import "GZCalendarManager.h"
#import "GZYearMonthDay.h"
#import "NSDate+Calendar.h"

/// 默认加载相邻几个月的数据
#define DefaultLoadMonths (5)

@interface GZCalendarManager()



@property (nonatomic, strong) NSMutableDictionary *allYearsList;

@end

@implementation GZCalendarManager

static id _instance;
+ (instancetype)manager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self defaultSettings];
    }
    
    return self;
}

/// 加载指定年月的数据
- (GZMonth *)loadDataWithTime:(NSDate *)date
{
    // 取出时间的年跟月
    NSDateComponents *com = [self.calendar components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSNumber *yearNumber = [NSNumber numberWithUnsignedInteger:com.year];
    NSNumber *monthNumber = [NSNumber numberWithUnsignedInteger:com.month];
    
    // 找到指定年
    GZYear *year = [self.allYearsList objectForKey:yearNumber];
    if (year == nil) {
        year = [self loadDataWithYear:yearNumber.integerValue];
    }
    
    GZMonth *month = [year.allMonths objectForKey:monthNumber];
    return month;
}

- (GZYear *)loadDataWithYear:(NSUInteger)year
{
    // 如果已经初始化过该年则跳过
    NSNumber *num = [NSNumber numberWithUnsignedInteger:year];
    GZYear *model = [self.allYearsList objectForKey:num];
    if (model) return model;
    
    // 初始化模型
    model = [[GZYear alloc] init];
    model.allMonths = [NSMutableDictionary dictionary];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:1];
    [components setDay:1];
    
    // 生成时间
    NSDate *date = [self.calendar dateFromComponents:components];
    
    // 当年有多少月
    NSUInteger monthCount = [date monthsOfYear];
    
    for (int i = 0; i < monthCount; i++) {
        NSDateComponents *components = [[NSDateComponents alloc] init];
        // 从前两个月开始计算
        components.month = i;
        
        // 添加到当前时间形成指定月的时间
        NSDate *newDate = [self.calendar dateByAddingComponents:components toDate:date options:0];
        
        // 根据指定月时间初始化指定月数据
        [self initMonthDataWithDate:newDate AndYear:model];
    }
    
    return model;
}

/// 根据传入的时间初始化指定时间所在月的数据
- (void)initMonthDataWithDate:(NSDate *)date AndYear:(GZYear *)year
{
    GZMonth *monthModel = [[GZMonth alloc] init];
    monthModel.allDays = [NSMutableArray array];
    monthModel.dayCount = [date daysOfMonth];
    monthModel.monthOfYear = [date monthIndexOfYear];
    monthModel.monthTime = date;
    
    // 所属月份
    NSUInteger month = [date monthIndexOfYear];
    // 当月有多少天
    NSUInteger days = [date daysOfMonth];
    // 当月第一天
    NSDate *firstDay = [date firstDayOfMonth];
    
    for (int i = 0; i < days; i++) {
        GZDay *day = [[GZDay alloc] init];
        NSDateComponents *components = [NSDateComponents new];
        [components setDay:i];
        // 生成新时间
        NSDate *newDate = [self.calendar dateByAddingComponents:components toDate:firstDay options:0];
        day.date = newDate;
        day.dayOfMonth = [newDate dayIndexOfMonth];
        day.dayOfWeek = [newDate dayIndexOfWeek];
        [monthModel.allDays addObject:day];
    }
    
    // 将当月数据存储到年中
    [year.allMonths setObject:monthModel forKey:[NSNumber numberWithUnsignedInteger:month]];
}


+ (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear) fromDate:date];
    return [components year];
}

#pragma mark- <-----------  做一些默认设置  ----------->
- (void)defaultSettings
{
    self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    self.calendar.timeZone = [NSTimeZone localTimeZone];
    
    // 阴历
    self.lunarCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    self.lunarCalendar.timeZone = [NSTimeZone localTimeZone];
}

- (NSMutableDictionary *)allYearsList
{
    if (!_allYearsList) {
        _allYearsList = [NSMutableDictionary dictionary];
    }
    
    return _allYearsList;
}

@end
