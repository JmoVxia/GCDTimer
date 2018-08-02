
# 前言
iOS开发中，经常需要使用到定时器，使用NSTimer很容易出现内存泄漏，在此简单封装GCD定时器。

#### 1.定时器方法
```
- (instancetype)initDispatchTimerWithTimeInterval:(double)interval
                                delaySecs:(float)delaySecs
                                    queue:(dispatch_queue_t)queue
                                  repeats:(BOOL)repeats
                                   action:(dispatch_block_t)action;
/*响应次数*/
@property (nonatomic, assign, readonly) NSInteger actionTimes;

/**开始定时器*/
- (void)startTimer;
/**执行一次定时器响应*/
- (void)responseOnceTimer;
/**取消定时器*/
- (void)cancelTimer;
/**暂停定时器*/
- (void)suspendTimer;
/**恢复定时器*/
- (void)resumeTimer;
/**替换旧的响应*/
- (void)replaceOldAction:(dispatch_block_t)action;
```
#### 2.全局定时器

```
+ (instancetype)sharedManager;



/**
 创建定时器，需要调用开始开启，如果存在定时器，不会重新创建
 @param timerName 定时器名称
 @param interval 间隔时间
 @param delaySecs 第一次延迟时间
 @param queue 线程
 @param repeats 是否重复
 @param action 响应
 */
- (void)scheduledDispatchTimerWithName:(NSString *)timerName
                          timeInterval:(NSTimeInterval)interval
                             delaySecs:(float)delaySecs
                                 queue:(dispatch_queue_t)queue
                               repeats:(BOOL)repeats
                                action:(dispatch_block_t)action;

/**开始定时器*/
- (void)startTimer:(NSString *)timerName;
/**执行一次定时器响应*/
- (void)responseOnceTimer:(NSString *)timerName;
/**取消定时器*/
- (void)cancelTimerWithName:(NSString *)timerName;
/**暂停定时器*/
- (void)suspendTimer:(NSString *)timerName;
/**恢复定时器*/
- (void)resumeTimer:(NSString *)timerName;
/**获取定时器*/
- (CLGCDTimer *)timer:(NSString *)timerName;

```

# 其他
简单的封装了一下，仅供大家参考，代码比较简单，完整项目地址------>[CLGCDTimerManager](https://github.com/JmoVxia/GCDTimer)




