//
//  NSDate+Calendar.h
//  OC_Demo
//
//  Created by 谷胜亚 on 2018/6/1.
//  Copyright © 2018年 谷胜亚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Calendar)

/// 当月第一天
- (NSDate *)firstDayOfMonth;

/// 当月的天数
- (NSUInteger)daysOfMonth;

/// 当年的天数
- (NSUInteger)daysOfYear;

/// 当月的周数
- (NSUInteger)weeksOfMonth;

/// 当月的第几天
- (NSUInteger)dayIndexOfMonth;

/// 星期几[周日是1 ~ 周六是7]
- (NSUInteger)dayIndexOfWeek;

/// 当月的第几周
- (NSUInteger)weekIndexOfMonth;

/// 当月的月份
- (NSUInteger)monthIndexOfYear;

/// 当年的月数量
- (NSUInteger)monthsOfYear;

#pragma mark- <-----------  阴历(中国农历)情况  ----------->
/// 天干地支
- (NSString *)heavenlyStemAndEarthlyBranche;

/// 生肖属相
- (NSString *)zodiac;

/// 农历月
- (NSString *)lunarMonth;

/// 农历日
- (NSString *)lunarDay;


@end
