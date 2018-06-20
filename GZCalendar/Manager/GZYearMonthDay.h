//
//  GZYearMonthDay.h
//  OC_Demo
//
//  Created by 谷胜亚 on 2018/5/31.
//  Copyright © 2018年 谷胜亚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// 日
@interface GZDay : NSObject

/// 所属年
@property (nonatomic, assign) NSUInteger year;

/// 所属月
@property (nonatomic, assign) NSUInteger month;

/// 阳历日期
@property (nonatomic, assign) NSUInteger day;

/// 星期几(1周日~7周六)
@property (nonatomic, assign) NSUInteger dayOfWeek;

/// 当月第几周
@property (nonatomic, assign) NSUInteger weekOfMonth;

/// 当年第几周
@property (nonatomic, assign) NSUInteger weekOfYear;

/// 当年第几天
@property (nonatomic, assign) NSUInteger dayOfYear;

/// 当月第几天
@property (nonatomic, assign) NSUInteger dayOfMonth;

@property (nonatomic, strong) NSDate *date;

/// 该天在当月的位置
@property (nonatomic, assign) CGPoint location;

@end


/// 月
@interface GZMonth : NSObject

/// 所属年
@property (nonatomic, assign) NSUInteger year;

/// 当月共多少天
@property (nonatomic, assign) NSUInteger dayCount;

/// 当年第几月
@property (nonatomic, assign) NSUInteger monthOfYear;

/// 当月天数数组
@property (nonatomic, strong) NSMutableArray<GZDay *> *allDays;

/// 标志该月的时间
@property (nonatomic, strong) NSDate *monthTime;

/// 展示时的contentOffsetY值
@property (nonatomic, assign) CGFloat offsetY;

/// 当月可展示部分偏移量
@property (nonatomic, assign) CGPoint offset;

/// 当月可展示部分尺寸
@property (nonatomic, assign) CGSize size;

/// 传入时间格式获取字符串的时间
- (NSString *)timeStringFromDateFormate:(NSString *)dateFormat;

@end


/// 年
@interface GZYear : NSObject

/// 当年共多少月
@property (nonatomic, assign) NSUInteger monthCount;

/// 当年共多少天
@property (nonatomic, assign) NSUInteger dayCount;

/// 年份
@property (nonatomic, assign) NSUInteger year;

/// 月份数组
@property (nonatomic, strong) NSMutableDictionary<NSNumber *,GZMonth *> *allMonths;

@end




