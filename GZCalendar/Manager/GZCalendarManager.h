//
//  GZCalendarManager.h
//  OC_Demo
//
//  Created by 谷胜亚 on 2018/6/1.
//  Copyright © 2018年 谷胜亚. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GZMonth, GZYear;
@interface GZCalendarManager : NSObject

/// 公历
@property (nonatomic, strong) NSCalendar *calendar;

/// 阴历(中国农历)
@property (nonatomic, strong) NSCalendar *lunarCalendar;

+ (instancetype)manager;

/// 加载指定一年的数据
- (GZYear *)loadDataWithYear:(NSUInteger)year;

/// 加载指定年月的数据
- (GZMonth *)loadDataWithTime:(NSDate *)date;

@end
