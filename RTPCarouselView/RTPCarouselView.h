//
//  RTPCarouselView.h
//  RTPCarouselView
//
//  Created by 谭培 on 2017/2/22.
//  Copyright © 2017年 谭培. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RTPCarouselView;

@protocol RTPCarouselViewDelegate <NSObject>

-(void)sendSelectedRow:(NSInteger)selectedRow inView:(RTPCarouselView *)view;
//selectedRow从1开始
@end

@interface RTPCarouselView : UIView

-(void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor andCurrentPageIndicatorTintColor:(UIColor *)CurrentPageIndicatorTintColor;

-(void)fireTimerInDate:(NSDate *)date;

-(void)invalidateTimer;

@property (nonatomic,weak)id <RTPCarouselViewDelegate>delegate;

-(instancetype)initWithFrame:(CGRect)frame andImageNameArray:(NSArray *)imageNameArray isRun:(BOOL)isRun andTimeInterval:(CGFloat)timeInterval;

-(instancetype)initWithFrame:(CGRect)frame andImageNameArray:(NSArray *)imageNameArray;

@end
