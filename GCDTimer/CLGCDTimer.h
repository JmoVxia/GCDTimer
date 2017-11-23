//
//  CLGCDTimer.h
//  GCDTimer
//
//  Created by JmoVxia on 2017/11/23.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, CLGCDTimerType) {
    CLAbandonPreviousAction, // 废除同一个timer之前的任务
    CLMergePreviousAction   // 将同一个timer之前的任务合并到新的任务中
};
@interface CLGCDTimer : NSObject

- (instancetype)initDispatchTimerWithName:(NSString *)timerName
                             timeInterval:(double)interval
                                    queue:(dispatch_queue_t)queue
                                  repeats:(BOOL)repeats
                                   action:(dispatch_block_t)action
                               actionType:(CLGCDTimerType)type;

- (void)addActionBlock:(dispatch_block_t)action actionType:(CLGCDTimerType)type;

@end

@interface CLGCDTimerManager : NSObject

+ (instancetype)sharedInstance;

- (void)adddDispatchTimerWithName:(NSString *)timerName
                     timeInterval:(NSTimeInterval)interval
                            queue:(dispatch_queue_t)queue
                          repeats:(BOOL)repeats
                       actionType:(CLGCDTimerType)type
                           action:(dispatch_block_t)action;

- (void)scheduledDispatchTimerWithName:(NSString *)timerName
                          timeInterval:(NSTimeInterval)interval
                                 queue:(dispatch_queue_t)queue
                               repeats:(BOOL)repeats
                            actionType:(CLGCDTimerType)type
                                action:(dispatch_block_t)action;

/**开始定时器*/
- (void)startTimer:(NSString *)timerName;
/**开始定时器，只执行一次*/
- (void)fireTimer:(NSString *)timerName;
/**取消定时器*/
- (void)cancelTimerWithName:(NSString *)timerName;
/**暂停定时器*/
- (void)suspendTimer:(NSString *)timerName;
/**恢复定时器*/
- (void)resumeTimer:(NSString *)timerName;



@end



