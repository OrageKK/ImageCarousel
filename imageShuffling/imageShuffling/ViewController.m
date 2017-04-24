//
//  ViewController.m
//  imageShuffling
//
//  Created by 黄坤 on 2017/4/24.
//  Copyright © 2017年 oragekk. All rights reserved.
//

#import "ViewController.h"
#import "shufflingView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    shufflingView *myView = [[shufflingView alloc]
                         initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width,
                                                  230)];
    [self.view addSubview:myView];
    
    NSArray *picDataArray = @[ @"1", @"2", @"3", @"4", @"5" ];
    
    
    myView.picDataArray = [picDataArray copy];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
