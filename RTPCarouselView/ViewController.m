//
//  ViewController.m
//  RTPCarouselView
//
//  Created by 谭培 on 2017/2/22.
//  Copyright © 2017年 谭培. All rights reserved.
//

#import "ViewController.h"
#import "RTPCarouselView.h"
@interface ViewController ()<RTPCarouselViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    RTPCarouselView *aView = [[RTPCarouselView alloc]initWithFrame:CGRectMake(20, 50, 350, 150) andImageNameArray:@[@"1",@"2",@"3"] isRun:YES andTimeInterval:2];
    aView.delegate = self;
    [aView setPageIndicatorTintColor:[UIColor darkGrayColor] andCurrentPageIndicatorTintColor:[UIColor whiteColor]];
    [self.view addSubview:aView];
}

-(void)sendSelectedRow:(NSInteger)selectedRow inView:(RTPCarouselView *)view{
    NSLog(@"%lu--%@",selectedRow,view);
}

@end
