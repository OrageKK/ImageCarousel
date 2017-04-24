//
//  shufflingView.h
//  imageShuffling
//
//  Created by 黄坤 on 2017/4/24.
//  Copyright © 2017年 oragekk. All rights reserved.
//

#import <UIKit/UIKit.h>

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
@end
