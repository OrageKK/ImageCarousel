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

@property(nonatomic, strong) UIPageControl *pageControl;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, assign) CGRect TitleFrame;
@property(nonatomic, assign) CGRect PageControlFrame;
@end

@implementation shufflingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self setupTitleLabel];
        [self setupPageControl];
    }
    return self;
}
- (void)scrollViewClick:(UITapGestureRecognizer *)tap {
    
    if ([self.delegate respondsToSelector:@selector(didClick:)]) {
        
        [self.delegate didClick:self.currentImageIndex];
    }
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
    _centerImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(scrollViewClick:)];
    
    [_centerImageView addGestureRecognizer:tap];
    
    [self.mainScrollView addSubview:_leftImageView];
    [self.mainScrollView addSubview:_rightImageView];
    [self.mainScrollView addSubview:_centerImageView];
    
}
- (void)setupTitleLabel {
    
    UILabel *titleLabel = [[UILabel alloc] init];
    
    titleLabel.hidden = YES;
    
    _titleLabel = titleLabel;
    
    [self addSubview:titleLabel];
}

- (void)setupPageControl {
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    
    pageControl.numberOfPages = _picDataArray.count;
    
    _pageControl = pageControl;
    pageControl.tintColor = [UIColor blackColor];
    pageControl.pageIndicatorTintColor = _pageIndicatorTintColor;
    
    pageControl.currentPageIndicatorTintColor = _pageControlCurrentColor;
    
    [self addSubview:pageControl];
}
#pragma mark - 无限滚动核心
- (void)reloadImageViews {
    // 获取当前offset
    CGPoint scrollViewOffset = [_mainScrollView contentOffset];
    // 如果当前位于centerImageView
    if (scrollViewOffset.x == 2 * _mainScrollView.bounds.size.width) {
        if (_currentImageIndex == kImageCount - 1) {
            _currentImageIndex = 0;
        }else {
            
            _currentImageIndex = (_currentImageIndex +1) % kImageCount;
        }
        
    } else if (scrollViewOffset.x == 0) {
        if (_currentImageIndex == 0) {
            _currentImageIndex = kImageCount - 1;
        }else {
        
            _currentImageIndex = (_currentImageIndex -1) % kImageCount;
        }
        
    }
    
    _centerImageView.image =
    [UIImage imageNamed:_picDataArray[self.currentImageIndex]];
    
    // 重新设置左右图片
    _leftImageView.image =
    [UIImage imageNamed:_picDataArray[self.leftImageIndex]];
    
    _rightImageView.image =
    [UIImage imageNamed:_picDataArray[self.rightImageIndex]];
    
    _titleLabel.text = _titleDataArray[self.currentImageIndex];
    _pageControl.currentPage = self.currentImageIndex;
    
}

#pragma mark - ScrollViewDelegate
// 结束滚动开启定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
    
    [self startMyTimer];
}
// MARK: - 开始后滚动关闭定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self endMyTimer];
}
// MARK: - 滚动过程中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint scrollViewOffset = scrollView.contentOffset;
    
    if (scrollViewOffset.x > 1.5 * _mainScrollView.bounds.size.width) {
        
        _pageControl.currentPage = self.rightImageIndex;
        
        _titleLabel.text = _titleDataArray[self.rightImageIndex];
        
    } else if (scrollViewOffset.x < 0.5 * _mainScrollView.bounds.size.width) {
        
        _pageControl.currentPage = self.leftImageIndex;
        
        _titleLabel.text = _titleDataArray[self.leftImageIndex];
    }
    
    else {
        _pageControl.currentPage = self.currentImageIndex;
        
        _titleLabel.text = _titleDataArray[self.currentImageIndex];
    }
}
// MARK: - 拖拽完毕减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self reloadImageViews];
    // 移动到中间，动画效果要关闭
    [_mainScrollView
     setContentOffset:CGPointMake(_mainScrollView.bounds.size.width, 0)
     animated:NO];
}
// MARK: - 非人为拖拽会调用此方法
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    [self reloadImageViews];
    
    [_mainScrollView
     setContentOffset:CGPointMake(_mainScrollView.bounds.size.width, 0)
     animated:NO];
}
#pragma mark - 滚动配置
- (void)automaticScroll {
    
    CGPoint currentPoint = _mainScrollView.contentOffset;
    
    currentPoint.x += _mainScrollView.bounds.size.width;
    
    [_mainScrollView setContentOffset:currentPoint animated:YES];
}
- (void)startMyTimer {
    
    if (self.isAutomaticScroll) {
        NSTimer *newTimer =
        [NSTimer scheduledTimerWithTimeInterval:self.automaticScrollDelay
                                         target:self
                                       selector:@selector(automaticScroll)
                                       userInfo:nil
                                        repeats:YES];
        
        _timer = newTimer;
        
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)endMyTimer {
    
    if (self.isAutomaticScroll) {
        [_timer invalidate];
        
        _timer = nil;
    }
}

#pragma mark - getter&setter方法
- (NSUInteger)currentImageIndex {
    
    if (!_currentImageIndex) {
        
        _currentImageIndex = 0;
    }
    
    return _currentImageIndex;
}
- (NSInteger)leftImageIndex {
    
    if (_currentImageIndex == 0) {
        
        _leftImageIndex = kImageCount - 1;
        
    } else {
        
        _leftImageIndex = _currentImageIndex - 1;
    }
    
    return _leftImageIndex;
}

- (NSInteger)rightImageIndex {
    
    if (_currentImageIndex == kImageCount - 1) {
        
        _rightImageIndex = 0;
    } else {
        
        _rightImageIndex = _currentImageIndex + 1;
    }
    
    return _rightImageIndex;
}
- (void)setPicDataArray:(NSArray *)picDataArray {
    _picDataArray = picDataArray;
    
    _pageControl.numberOfPages = picDataArray.count;
    
    [self reloadImageViews];
}


- (void)setTitleDataArray:(NSArray *)titleDataArray {
    _titleDataArray = titleDataArray;
    
    _titleLabel.hidden = NO;
    
    [self reloadImageViews];
}
- (void)setIsAutomaticScroll:(BOOL)isAutomaticScroll {
    
    _isAutomaticScroll = isAutomaticScroll;
    
    [self endMyTimer];
    
    if (isAutomaticScroll) {
        [self startMyTimer];
    }
}
- (void)setTitleLabelTextFont:(UIFont *)titleLabelTextFont {
    
    _titleLabelTextFont = titleLabelTextFont;
    _titleLabel.font = titleLabelTextFont;
}

- (void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor {
    _titleLabelTextColor = titleLabelTextColor;
    _titleLabel.textColor = titleLabelTextColor;
}
- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    _pageIndicatorTintColor = pageIndicatorTintColor;
    
    _pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}

- (void)setPageControlCurrentColor:(UIColor *)pageControlCurrentColor {
    _pageControlCurrentColor = pageControlCurrentColor;
    
    _pageControl.currentPageIndicatorTintColor = pageControlCurrentColor;
}
- (float)automaticScrollDelay {
    if (!_automaticScrollDelay) {
        _automaticScrollDelay = 2.0;
    }
    return _automaticScrollDelay;
}
- (void)setAutomaticScrollDelay:(float)automaticScrollDelay {
    
    _automaticScrollDelay = automaticScrollDelay;
    
    [self setIsAutomaticScroll:self.isAutomaticScroll];
}
- (ImageCarouselStyleType)carouselViewStyle {
    
    if (!_carouselViewStyle) {
        
        _carouselViewStyle = ImageCarouselStylePageControl;
    }
    
    return _carouselViewStyle;
}
- (void)setCarouselViewStyle:(ImageCarouselStyleType)carouselViewStyle {
    _carouselViewStyle = carouselViewStyle;
    
    if (carouselViewStyle == ImageCarouselStyleNone) {
        _TitleFrame = CGRectZero;
        _PageControlFrame = CGRectZero;
    } else if (carouselViewStyle == ImageCarouselStyleTitle) {
        _TitleFrame = CGRectMake((self.bounds.size.width - kTitleLabelW) / 2,
                                 self.bounds.size.height - KTitleLabelH,
                                 kTitleLabelW, KTitleLabelH);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _PageControlFrame = CGRectZero;
    } else if (carouselViewStyle == ImageCarouselStylePageControl) {
        _TitleFrame = CGRectZero;
        _PageControlFrame = CGRectMake((self.bounds.size.width - kPageControlW) / 2,
                                       self.bounds.size.height - kPageControlH,
                                       kPageControlW, kPageControlH);
    } else if (carouselViewStyle == ImageCarouselStyleBoth) {
        _TitleFrame = CGRectMake(kMargin, self.bounds.size.height - KTitleLabelH,
                                 kTitleLabelW, KTitleLabelH);
        _PageControlFrame = CGRectMake(
                                       self.bounds.size.width - kPageControlW - kMargin,
                                       self.bounds.size.height - kPageControlH, kPageControlW, kPageControlH);
    }
    
    _pageControl.frame = _PageControlFrame;
    
    _titleLabel.frame = _TitleFrame;
}
@end
