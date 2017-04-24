//
//  ViewController.m
//  imageShuffling
//
//  Created by 黄坤 on 2017/4/24.
//  Copyright © 2017年 oragekk. All rights reserved.
//

#import "ViewController.h"
#import "shufflingView.h"
@interface ViewController ()<CarouselViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    shufflingView *myView = [[shufflingView alloc]
                         initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width,
                                                  230)];
    
    
    NSArray *picDataArray = @[ @"1", @"2", @"3", @"4", @"5" ];
    NSArray *titleDataArray = @[ @"1", @"2", @"3", @"4", @"5" ];
    
    myView.picDataArray = [picDataArray copy];
    
    myView.titleDataArray = [titleDataArray copy];
    
    myView.titleLabelTextColor =
    [UIColor colorWithRed:255/255 green:0 blue:0 alpha:1.0];
    
    myView.isAutomaticScroll = YES;
    
    myView.automaticScrollDelay = 2;
    
    myView.carouselViewStyle = ImageCarouselStyleBoth;
    
    myView.pageIndicatorTintColor = [UIColor colorWithRed:255/255 green:0/255 blue:255/255 alpha:1.0];
    
    myView.pageControlCurrentColor =
    [UIColor colorWithRed:0/255 green:255/255 blue:255/255 alpha:1.0];
    
    myView.delegate = self;
    
    myView.picDataArray = [picDataArray copy];
    
    [self.view addSubview:myView];
}


- (void)didClick:(NSInteger)index {
    
    NSLog(@"%zd", index);
}


@end
