//
//  RTPCarouselView.m
//  RTPCarouselView
//
//  Created by 谭培 on 2017/2/22.
//  Copyright © 2017年 谭培. All rights reserved.
//

#import "RTPCarouselView.h"

@interface RTPCarouselView ()<UIScrollViewDelegate>

@property (nonatomic,assign)BOOL isRun;
@property (nonatomic,strong)NSMutableArray *imageArray;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIPageControl *pageControl;
@property (nonatomic,assign)CGFloat width;
@property (nonatomic,assign)CGFloat height;
@property (nonatomic,assign)CGFloat timeInterval;

@end

@implementation RTPCarouselView
{
    NSInteger _currentPage;
    NSTimer *_timer;
}

//-(void)setTimeInterval:(CGFloat)timeInterval{
//    _timeInterval = timeInterval;
//}


-(instancetype)initWithFrame:(CGRect)frame andImageNameArray:(NSArray *)imageNameArray isRun:(BOOL)isRun andTimeInterval:(CGFloat)timeInterval
{
    self = [super initWithFrame:frame];
    if (self) {

        _width = frame.size.width;
        _height = frame.size.height;
        self.imageArray = [NSMutableArray arrayWithArray:imageNameArray];
        [self.imageArray addObject:[imageNameArray firstObject]];
        [self.imageArray insertObject:[imageNameArray lastObject] atIndex:0];
        self.isRun = isRun;
        _currentPage = 0;
        _timeInterval = timeInterval;
        [self createTimer];
        [self createScroll];
        [self addPageControl];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame andImageNameArray:(NSArray *)imageNameArray{
    self = [self initWithFrame:frame andImageNameArray:imageNameArray isRun:YES andTimeInterval:2];
    return self;
}

-(void)createScroll
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _width, _height)];
    _scrollView.contentSize = CGSizeMake(_width*_imageArray.count, _height);
    for (int i = 0; i < self.imageArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*_width, 0, _width, _height)];
        imageView.image = [UIImage imageNamed:_imageArray[i]];
        imageView.userInteractionEnabled = YES;
        imageView.tag = 200 + i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [imageView addGestureRecognizer:tap];
        [_scrollView addSubview:imageView];
    }
    
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.contentOffset = CGPointMake(_width, 0);
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    [self addSubview:_scrollView];

}

-(void)tap:(UITapGestureRecognizer *)tap
{
    if (_delegate && [_delegate respondsToSelector:@selector(sendSelectedRow:inView:)]) {
        [_delegate sendSelectedRow:tap.view.tag-200 inView:self];
    }else{
        NSLog(@"没有设置代理");
    }
}


#pragma mark UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_timer) {
        [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:2]];
    }
    //图片的个数 1 2 3 4 5 6 7 8
    //数图的下标 0 1 2 3 4 5 6 7
    //显示的页码   0 1 2 3 4 5
    CGPoint point = _scrollView.contentOffset;
    if (point.x == (self.imageArray.count - 1)*_width) {
        _scrollView.contentOffset = CGPointMake(_width, 0);
    }
    if (point.x == 0) {
        scrollView.contentOffset = CGPointMake((self.imageArray.count-2)*_width, 0);
    }
    CGPoint endPoint = _scrollView.contentOffset;
    _currentPage = endPoint.x/_width;
    _pageControl.currentPage = _currentPage-1;
    NSLog(@"0000");
}



-(void)addPageControl
{
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, _height-30, 100, 300)];
    _pageControl.center = CGPointMake(_width/2, _height-15);
    _pageControl.numberOfPages = self.imageArray.count-2;
    _pageControl.pageIndicatorTintColor = [UIColor blackColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.userInteractionEnabled = NO;
    [self addSubview:_pageControl];
}

-(void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor andCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor{

    _pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
    _pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}


-(void)createTimer{
    if (_isRun) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
    }
}

-(void)fireTimerInDate:(NSDate *)date{
    [_timer setFireDate:date];
}

-(void)invalidateTimer{
    [_timer invalidate];
    _timer = nil;
}

-(void)changeImage{
    //获得当前的点
    CGPoint point = _scrollView.contentOffset;
    //求得将要变换的点
    CGPoint endPoint = CGPointMake(point.x+_width, 0);
    //判断
    if (endPoint.x == (self.imageArray.count-1)*_width) {
        [UIView animateWithDuration:0.25 animations:^{
            _scrollView.contentOffset = CGPointMake(endPoint.x, 0);
        } completion:^(BOOL finished) {
            _scrollView.contentOffset = CGPointMake(_width, 0);
            CGPoint realEnd = _scrollView.contentOffset;
            
            _currentPage = realEnd.x/_width;
            _pageControl.currentPage = _currentPage-1;
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            _scrollView.contentOffset = endPoint;
        } completion:^(BOOL finished) {
            CGPoint realEnd = _scrollView.contentOffset;
            _currentPage = realEnd.x/_width;
            _pageControl.currentPage = _currentPage-1;
        }];
    }
}

@end
