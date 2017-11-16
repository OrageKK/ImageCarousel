# ImageCarousel
简单封装的图片轮播器
内存过大由于我加载的图片分辨率较高

## 自定义view
```objc

typedef NS_ENUM(NSInteger, ImageCarouselStyleType) {
    ImageCarouselStyleNone,
    ImageCarouselStyleTitle,
    ImageCarouselStylePageControl,
    ImageCarouselStyleBoth
};
@protocol CarouselViewDelegate <NSObject>

@optional

- (void)didClick:(NSInteger)index;

@end

@interface shufflingView : UIView
{
    float _automaticScrollDelay;
    ImageCarouselStyleType _carouselViewStyle;
}
@property(nonatomic, strong) NSArray *picDataArray;
@property(nonatomic, strong) NSArray *titleDataArray;
@property(nonatomic, weak) UIFont *titleLabelTextFont;
@property(nonatomic, weak) UIColor *titleLabelTextColor;
@property(nonatomic, weak) UIColor *pageIndicatorTintColor;
@property(nonatomic, weak) UIColor *pageControlCurrentColor;

// 是否自动滚动
@property(nonatomic, assign) BOOL isAutomaticScroll;
// 滚动时间间隔
@property(nonatomic, assign) float automaticScrollDelay;
/// 枚举
@property(nonatomic, assign) ImageCarouselStyleType carouselViewStyle;

@property(nonatomic, weak) id<CarouselViewDelegate> delegate;
```

采用一个scrollivew和三个imageview

```objc
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
```

## 核心代码
```objc
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
```
滚动过程中调整pageControl

```objc
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
```
## 效果
![09c30e48dbe4b8aaf176f1488f4751ce.gif](https://storage1.cuntuku.com/2017/11/16/09c30e48dbe4b8aaf176f1488f4751ce.gif)