//
//  GZCalendarCell.h
//  OC_Demo
//
//  Created by 谷胜亚 on 2018/6/4.
//  Copyright © 2018年 谷胜亚. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GZCalendarStyle, GZDay;
@interface GZCalendarCell : UICollectionViewCell

/// 日历风格, 传值时应在day之前传值
@property (nonatomic, strong) GZCalendarStyle *style;

/// 日期对象
@property (nonatomic, strong) GZDay *day;


@end
