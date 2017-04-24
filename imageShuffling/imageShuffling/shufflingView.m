//
//  shufflingView.m
//  imageShuffling
//
//  Created by 黄坤 on 2017/4/24.
//  Copyright © 2017年 oragekk. All rights reserved.
//

#import "shufflingView.h"

#define kImageCount _picDataArray.count
#define kTitleLabelW 200
#define KTitleLabelH 25
#define kMargin 20
#define kPageControlW 100
#define kPageControlH 25
#define KViewW self.bounds.size.width
#define KViewH self.bounds.size.height



@interface shufflingView ()<UIScrollViewDelegate>
@property(nonatomic, strong) UIScrollView *mainScrollView;
@property(nonatomic, strong) UIImageView *centerImageView;
@property(nonatomic, strong) UIImageView *leftImageView;
@property(nonatomic, strong) UIImageView *rightImageView;
@property(nonatomic, assign) NSInteger leftImageIndex;
@property(nonatomic, assign) NSInteger rightImageIndex;
@property(nonatomic, assign) NSUInteger currentImageIndex;
@end

@implementation shufflingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

// 添加子控件
- (void)setupSubviews {
    UIScrollView *mainScrollView = [[UIScrollView alloc]
                                    initWithFrame:CGRectMake(0, 0, KViewW,
                                                             KViewH)];
    
    mainScrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, 0);
    
    mainScrollView.bounces = NO;
    
    mainScrollView.pagingEnabled = YES;
    
    mainScrollView.showsHorizontalScrollIndicator = NO;
    
    mainScrollView.showsVerticalScrollIndicator = NO;
    
    [mainScrollView setBackgroundColor:[UIColor clearColor]];
    
    _mainScrollView = mainScrollView;
    
    _mainScrollView.delegate = self;
    
    [self addSubview:mainScrollView];
    // 默认滚动到中间imageview
    [_mainScrollView setContentOffset:CGPointMake(self.bounds.size.width, 0)
                             animated:NO];
    
    // 添加三个imageView
    _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KViewW, KViewH)];
    _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(2*KViewW, 0, KViewW, KViewH)];
    _centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(KViewW, 0, KViewW, KViewH)];
    
    [self.mainScrollView addSubview:_leftImageView];
    [self.mainScrollView addSubview:_rightImageView];
    [self.mainScrollView addSubview:_centerImageView];
    
}
- (void)reloadImageViews {
    // 获取当前offset
    CGPoint scrollViewOffset = [_mainScrollView contentOffset];
    // 如果当前位于centerImageView
    if (scrollViewOffset.x == 2 * _mainScrollView.bounds.size.width) {
        
        _currentImageIndex = (_currentImageIndex +1) % kImageCount;
        
    } else if (scrollViewOffset.x == 0) {
        _currentImageIndex = (_currentImageIndex -1) % kImageCount;
        
    }
    
    _centerImageView.image =
    [UIImage imageNamed:_picDataArray[self.currentImageIndex]];
    
    // 重新设置左右图片
    _leftImageIndex = (_currentImageIndex -1) % kImageCount;
    _leftImageView.image =
    [UIImage imageNamed:_picDataArray[self.leftImageIndex]];
    
    _rightImageIndex = (_currentImageIndex +1) % kImageCount;
    _rightImageView.image =
    [UIImage imageNamed:_picDataArray[self.rightImageIndex]];
    
}

#pragma mark - ScrollViewDelegate
// 拖拽完毕减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self reloadImageViews];
    // 移动到中间，动画效果要关闭
    [_mainScrollView
     setContentOffset:CGPointMake(_mainScrollView.bounds.size.width, 0)
     animated:NO];
}
// 非人为拖拽会调用此方法
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    [self reloadImageViews];
    
    [_mainScrollView
     setContentOffset:CGPointMake(_mainScrollView.bounds.size.width, 0)
     animated:NO];
}

- (void)setPicDataArray:(NSArray *)picDataArray {
    _picDataArray = picDataArray;
    
    [self reloadImageViews];
}
@end
