//
//  AViewController.m
//  GCDTimer
//
//  Created by JmoVxia on 2017/11/24.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "AViewController.h"
#import "CLGCDTimerManager.h"

@interface AViewController ()
/**label*/
@property (nonatomic, strong) UILabel *label;
@end

@implementation AViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _label = [[UILabel alloc] initWithFrame:CGRectMake(99, 99, 99, 99)];
    _label.font = [UIFont systemFontOfSize:40];
    _label.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_label];
    
    __block int i = 0;
    
       // 开启异步子线程
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[CLGCDTimerManager sharedManager] scheduledDispatchTimerWithName:@"AAA"
                                                                 timeInterval:1
                                                                    delaySecs:0
                                                                        queue:nil
                                                                      repeats:YES
                                                                       action:^{
                                                                           i++;
                                                                           //主线程
                                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                                               _label.text = [NSString stringWithFormat:@"%ld",(long)i];
                                                                           });
                                                                       }];
            
            [[CLGCDTimerManager sharedManager] startTimer:@"AAA"];
        });
    
    

    
   
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
    
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(99, 299, 99, 99)];
    button3.backgroundColor = [UIColor orangeColor];
    [button3 setTitle:@"销毁" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(action3) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
    UIButton *button4 = [[UIButton alloc] initWithFrame:CGRectMake(199, 299, 99, 99)];
    button4.backgroundColor = [UIColor orangeColor];
    [button4 setTitle:@"创建" forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(action4) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button4];
    
    UIButton *button5 = [[UIButton alloc] initWithFrame:CGRectMake(99, 399, 99, 99)];
    button5.backgroundColor = [UIColor orangeColor];
    [button5 setTitle:@"返回" forState:UIControlStateNormal];
    [button5 addTarget:self action:@selector(action5) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button5];
    
}
-(void)action1{
    [[CLGCDTimerManager sharedManager] resumeTimer:@"AAA"];
}
-(void)action2{
    [[CLGCDTimerManager sharedManager] suspendTimer:@"AAA"];
}
-(void)action3{
    _label.text = @"0";
    [[CLGCDTimerManager sharedManager] cancelTimerWithName:@"AAA"];
}
-(void)action4{
    [[CLGCDTimerManager sharedManager] cancelTimerWithName:@"AAA"];
    __block int i = 0;
    [[CLGCDTimerManager sharedManager] scheduledDispatchTimerWithName:@"AAA"
                                                         timeInterval:1
                                                            delaySecs:0
                                                                queue:nil
                                                              repeats:YES
                                                               action:^{
                                                                   i++;
                                                                   //主线程
                                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                                       _label.text = [NSString stringWithFormat:@"%d",i];
                                                                   });
                                                               }];
    [[CLGCDTimerManager sharedManager] startTimer:@"AAA"];
}
-(void)action5{
    [[CLGCDTimerManager sharedManager] cancelTimerWithName:@"AAA"];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)dealloc{
    NSLog(@"《《《《----页面销毁了----》》》》");
}











@end
