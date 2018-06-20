//
//  GZYearMonthDay.m
//  OC_Demo
//
//  Created by 谷胜亚 on 2018/5/31.
//  Copyright © 2018年 谷胜亚. All rights reserved.
//

#import "GZYearMonthDay.h"
#import "GZCalendarManager.h"

@implementation GZYear

@end

@implementation GZMonth

- (NSString *)timeStringFromDateFormate:(NSString *)dateFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = dateFormat;
    return [formatter stringFromDate:self.monthTime];
}

@end

@implementation GZDay

@end
