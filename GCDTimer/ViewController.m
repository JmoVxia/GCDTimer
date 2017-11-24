//
//  ViewController.m
//  GCDTimer
//
//  Created by JmoVxia on 2017/11/23.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "ViewController.h"
#import "AViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(199, 199, 99, 99)];
    button3.backgroundColor = [UIColor orangeColor];
    [button3 setTitle:@"下一页" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(action3) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
}

-(void)action3{
    [self presentViewController:[AViewController new] animated:YES completion:nil];
}


@end
