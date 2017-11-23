//
//  CLGCDTimer.m
//  GCDTimer
//
//  Created by JmoVxia on 2017/11/23.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "CLGCDTimer.h"

@interface CLGCDTimer ()

@property (nonatomic, copy) dispatch_block_t action;
@property (nonatomic, strong) dispatch_queue_t serialQueue;
@property (nonatomic, assign) BOOL repeat;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, strong) NSString *timerName;
@property (nonatomic, assign) CLGCDTimerType type;
@property (nonatomic, strong) NSArray *actionBlockCache;

@end

@implementation CLGCDTimer

- (instancetype)initDispatchTimerWithName:(NSString *)timerName
                             timeInterval:(double)interval
                                    queue:(dispatch_queue_t)queue
                                  repeats:(BOOL)repeats
                                   action:(dispatch_block_t)action
                               actionType:(CLGCDTimerType)type {
    
    if (self = [super init]) {
        self.timeInterval = interval;
        self.repeat = repeats;
        self.action = action;
        self.timerName = timerName;
        self.type = type;
        NSString *privateQueueName = [NSString stringWithFormat:@"com.mindsnacks.msweaktimer.%p", self];
        self.serialQueue = dispatch_queue_create([privateQueueName cStringUsingEncoding:NSASCIIStringEncoding], DISPATCH_QUEUE_SERIAL);
        dispatch_set_target_queue(self.serialQueue, queue);
        NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:action, nil];
        self.actionBlockCache = array;
    }
    return self;
}

- (void)addActionBlock:(dispatch_block_t)action actionType:(CLGCDTimerType)type {
    NSMutableArray *array = [self.actionBlockCache mutableCopy];
    self.type = type;
    switch (type) {
        case CLAbandonPreviousAction: {
            [array removeAllObjects];
            [array addObject:action];
            self.actionBlockCache = array;
            break;
        }
        case CLMergePreviousAction: {
            
            [array addObject:action];
            self.actionBlockCache = array;
            break;
        }
    }
}

@end

@interface CLGCDTimerManager ()
@property (nonatomic, strong) NSMutableDictionary *timerObjectCache;
@property (nonatomic, strong) NSMutableDictionary *timerContainer;
/**是否正在运行*/
@property (nonatomic, assign) BOOL isRuning;
@end

@implementation CLGCDTimerManager

#pragma mark -  liftCycle

+ (instancetype)sharedManager {
    static CLGCDTimerManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CLGCDTimerManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.timerContainer = [NSMutableDictionary dictionary];
    }
    
    return self;
}

#pragma mark -  public

- (void)adddDispatchTimerWithName:(NSString *)timerName
                     timeInterval:(NSTimeInterval)interval
                            queue:(dispatch_queue_t)queue
                          repeats:(BOOL)repeats
                       actionType:(CLGCDTimerType)type
                           action:(dispatch_block_t)action {
    self.isRuning = NO;
    NSParameterAssert(timerName);
    
    if (nil == queue) {
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    
    CLGCDTimer *timer = self.timerObjectCache[timerName];
    
    if (!timer) {
        timer = [[CLGCDTimer alloc] initDispatchTimerWithName:timerName
                                                 timeInterval:interval
                                                        queue:queue
                                                      repeats:repeats
                                                       action:action
                                                   actionType:type];
        self.timerObjectCache[timerName] = timer;
        
    } else {
        [timer addActionBlock:action actionType:type];
        if (type == CLMergePreviousAction) {
            timer.timeInterval = interval;
            timer.serialQueue = queue;
            timer.repeat = repeats;
        }
    }
    dispatch_source_t timer_t = self.timerContainer[timerName];
    if (!timer_t) {
        timer_t = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, timer.serialQueue);
        dispatch_resume(timer_t);
        [self.timerContainer setObject:timer_t forKey:timerName];
    }
}

- (void)scheduledDispatchTimerWithName:(NSString *)timerName
                          timeInterval:(NSTimeInterval)interval
                                 queue:(dispatch_queue_t)queue
                               repeats:(BOOL)repeats
                            actionType:(CLGCDTimerType)type
                                action:(dispatch_block_t)action {
    [self adddDispatchTimerWithName:timerName
                       timeInterval:interval
                              queue:queue
                            repeats:repeats
                         actionType:type
                             action:action];
    [self startTimer:timerName];
}

- (void)startTimer:(NSString *)timerName {
    if (!self.isRuning) {
        NSParameterAssert(timerName);
        dispatch_source_t timer_t = self.timerContainer[timerName];
        NSAssert(timer_t, @"timerName is not vaild");
        CLGCDTimer *timer = self.timerObjectCache[timerName];
        dispatch_source_set_timer(timer_t, dispatch_time(DISPATCH_TIME_NOW, timer.timeInterval * NSEC_PER_SEC),
                                  timer.timeInterval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        __weak typeof(self) weakSelf = self;
        switch (timer.type) {
            case CLAbandonPreviousAction: {
                dispatch_source_set_event_handler(timer_t, ^{
                    timer.action();
                    if (!timer.repeat) {
                        [weakSelf cancelTimerWithName:timerName];
                    }
                });
                break;
            }
            case CLMergePreviousAction: {
                dispatch_source_set_event_handler(timer_t, ^{
                    [timer.actionBlockCache enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                        dispatch_block_t action = obj;
                        action();
                        if (!timer.repeat) {
                            [weakSelf cancelTimerWithName:timerName];
                        }
                    }];
                });
                break;
            }
        }
        self.isRuning = YES;
    }
}
- (void)fireTimer:(NSString *)timerName {
    self.isRuning = YES;
    CLGCDTimer *timer = self.timerObjectCache[timerName];
    [timer.actionBlockCache enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        dispatch_block_t action = obj;
        action();
    }];
    self.isRuning = NO;
}
- (void)cancelTimerWithName:(NSString *)timerName {
    dispatch_source_t timer = self.timerContainer[timerName];
    if (!timer) {
        return;
    }
    [self.timerContainer removeObjectForKey:timerName];
    dispatch_source_cancel(timer);
    [self.timerObjectCache removeObjectForKey:timerName];
}
- (void)suspendTimer:(NSString *)timerName {
    if (self.isRuning) {
        dispatch_source_t timer = self.timerContainer[timerName];
        if (!timer) {
            return;
        }
        dispatch_suspend(timer);
        self.isRuning = NO;
    }
}
- (void)resumeTimer:(NSString *)timerName {
    if (!self.isRuning) {
        dispatch_source_t timer = self.timerContainer[timerName];
        if (!timer) {
            return;
        }
        dispatch_resume(timer);
        self.isRuning = YES;
    }
}
#pragma mark -  Assoicate
- (NSMutableDictionary *)timerContainer {
    if (!_timerContainer) {
        _timerContainer = [[NSMutableDictionary alloc] init];
    }
    return _timerContainer;
}
- (NSMutableDictionary *)timerObjectCache {
    if (!_timerObjectCache) {
        _timerObjectCache = [[NSMutableDictionary alloc] init];
    }
    return _timerObjectCache;
}
@end



