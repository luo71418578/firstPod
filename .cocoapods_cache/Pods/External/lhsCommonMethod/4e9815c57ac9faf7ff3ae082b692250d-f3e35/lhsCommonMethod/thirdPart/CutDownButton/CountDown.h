//
//  CountDown.h
//  shanlinbao
//
//  Created by SLB on 2017/10/10.
//  Copyright © 2017年 xianglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountDown : UIButton



/**
 用秒数日期倒计时

 @param timeInterval 秒数
 @param completeBlock 结束回调
 */
- (void)countDownWithTime:(NSInteger)timeInterval
            completeBlock:(void (^)(NSInteger second))completeBlock;


/**
 用NSDate日期倒计时

 @param startDate 开始日期
 @param finishDate 结束日期
 @param completeBlock 结束回调
 */
- (void)countDownWithStratDate:(NSDate *)startDate
                   finishDate:(NSDate *)finishDate
                completeBlock:(void (^)(NSInteger day,
                                        NSInteger hour,
                                        NSInteger minute,
                                        NSInteger second))completeBlock;

/**
 用时间戳倒计时

 @param starTimeStamp 开始时间
 @param finishTimeStamp 结束时间
 @param completeBlock 完成回调
 */
- (void)countDownWithStratTimeStamp:(long long)starTimeStamp
                   finishTimeStamp:(long long)finishTimeStamp
                     completeBlock:(void (^)(NSInteger day,
                                             NSInteger hour,
                                             NSInteger minute,
                                             NSInteger second))completeBlock;

//每秒走一次，回调block
- (void)countDownWithPER_SECBlock:(void (^)(void))PER_SECBlock;

//销毁
- (void)destoryTimer;

//时间戳转Date
- (NSDate *)dateWithLongLong:(long long)longlongValue;

//获取当天的年月日的字符串
- (NSString *)getNowyyyymmdd;

@end
