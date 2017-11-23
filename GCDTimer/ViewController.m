//
//  ViewController.m
//  GCDTimer
//
//  Created by JmoVxia on 2017/11/23.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "ViewController.h"
#import "CLGCDTimerManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(99, 99, 99, 99)];
    label.font = [UIFont systemFontOfSize:40];
    [self.view addSubview:label];
    
    static int i = 0;
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
//    [[CLGCDTimerManager sharedManager] adddDispatchTimerWithName:@"csb"
//                                                    timeInterval:2
//                                                       delaySecs:3
//                                                           queue:nil
//                                                         repeats:YES
//                                                      actionType:CLMergePreviousAction
//                                                          action:^{
//                                                              //主线程
//                                                              dispatch_async(dispatch_get_main_queue(), ^{
//                                                                  label.text = [NSString stringWithFormat:@"%d",i];
//                                                                  NSLog(@"<<<<<<<<++++++++++++++>>>>>>>>>");
//                                                              });
//                                                          }];

    [[CLGCDTimerManager sharedManager] startTimer:@"AAA"];
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(99, 199, 99, 99)];
    button1.backgroundColor = [UIColor redColor];
    [button1 setTitle:@"恢复" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(action1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(199, 199, 99, 99)];
    button2.backgroundColor = [UIColor orangeColor];
    [button2 setTitle:@"暂停" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(action2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
}
-(void)action1{
    [[CLGCDTimerManager sharedManager] resumeTimer:@"csb"];
}
-(void)action2{
    [[CLGCDTimerManager sharedManager] suspendTimer:@"csb"];
}



@end
