# GCD封装定时器

##用法

####1.添加定时器，再调用启动

```
[[CLGCDTimerManager sharedManager] adddDispatchTimerWithName:@"AAA"
timeInterval:1
delaySecs:0
queue:nil
repeats:YES
actionType:CLAbandonPreviousAction
action:^{
i++;
//主线程
dispatch_async(dispatch_get_main_queue(), ^{
label.text = [NSString stringWithFormat:@"%d",i];
NSLog(@"<<<<<<<<--------------->>>>>>>>>");
});
}];
[[CLGCDTimerManager sharedManager] startTimer:@"AAA"];

```

####2.直接创建并且调用

```
[[CLGCDTimerManager sharedManager] scheduledDispatchTimerWithName:@"AAA"
timeInterval:1
delaySecs:0
queue:nil
repeats:YES
actionType:CLAbandonPreviousAction
action:^{
i++;
//主线程
dispatch_async(dispatch_get_main_queue(), ^{
label.text = [NSString stringWithFormat:@"%d",i];
NSLog(@"<<<<<<<<--------------->>>>>>>>>");
});
}];
```

##接口

```
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
```









