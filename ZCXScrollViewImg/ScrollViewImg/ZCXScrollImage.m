//
//  ZCXScrollImage.m
//  ScrollViewImg
//
//  Created by ZhangCX on 2017/5/27.
//  Copyright © 2017年 ZhangCX. All rights reserved.
//

#import "ZCXScrollImage.h"
#import "UIImageView+WebCache.h"

#define pageSize 16

//获得RGB颜色
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r, g, b)                        RGBA(r, g, b, 1.0f)

#define pageColor RGB(67, 199, 176)

/** 滚动宽度*/
#define ScrollWidth self.frame.size.width

/** 滚动高度*/
#define ScrollHeight self.frame.size.height


@interface ZCXScrollImage ()<UIScrollViewDelegate>

@property (nonatomic, copy) NSArray *imageArray;

@end

@implementation ZCXScrollImage{
    __weak UIImageView *_leftImageView,*_rightImageView,*_centerImageView;
    __weak UIScrollView *_scrollView;
    __weak UIPageControl *_PageControl;
    
    NSTimer *_timer;
    NSInteger _currentIndex;
    NSInteger _imageCount;
}
//加载网络图片
- (instancetype)initWithFrame:(CGRect)frame WithNetImages:(NSArray *)imageArray scrollDelay:(NSInteger)scrollDelay
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageArray = [imageArray copy];
        _scrollDelay = scrollDelay  ;
        //创建滚动视图
        [self createScrollView];
        //设置图片数量
        [self setImageCount:imageArray.count];
        
    }
    return self;
}
- (void)setImageCount:(NSInteger)imageCount{
    _imageCount = imageCount;
    
    //复用imageView初始化
    [self initImageView];
    
    //创建pageControl
    [self createPageControl];
    
    /** 定时器*/
    [self setUpTimer];
    
    /** 初始化图片位置*/
    [self changeImageLeft:_imageCount-1 center:0 right:1];
    

}
#pragma mark - 复用imageView初始化
- (void)initImageView{
    UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScrollWidth, ScrollHeight)];
    UIImageView *centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScrollWidth, 0, ScrollWidth, ScrollHeight)];
    UIImageView *rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScrollWidth * 2, 0, ScrollWidth, ScrollHeight)];
    //中间的图片也就是正在显示的图片允许交互
    centerImageView.userInteractionEnabled = YES;
    //添加手势响应
    [centerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTap)] ];
    
    [_scrollView addSubview:leftImageView];
    [_scrollView addSubview:centerImageView];
    [_scrollView addSubview:rightImageView];
    
    _leftImageView = leftImageView;
    _centerImageView = centerImageView;
    _rightImageView = rightImageView;
    
}
#pragma mark - 点击响应事件
//点击响应时间
-(void)imageViewDidTap{
    NSLog(@"is clicked");
    
    [self.delegate didSelectedImageAtIndex:_currentIndex];
}
#pragma mark - 页面指示器
//设置页面指示器
-(void)createPageControl{
    UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, ScrollHeight - pageSize, ScrollWidth, 8)];
    //设置yanse
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    //设置当前激活指示器颜色
    pageControl.currentPageIndicatorTintColor = pageColor;
    pageControl.numberOfPages = _imageCount;
    pageControl.currentPage = 0;
    
    [self addSubview:pageControl];
    _PageControl = pageControl;
}

#pragma mark - 创建滚动视图

- (void)createScrollView{
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    
    //设置scrollView的内容宽度
    scrollView.contentSize = CGSizeMake(ScrollWidth * 3, 0);
    //当前显示的图片位置，开始显示的是第一个，前一个是第三个，后一个是第二个
    _currentIndex = 0;
    
    [self addSubview:scrollView];
    _scrollView = scrollView;
    
}

#pragma mark - 滚动代理
//开始滚动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}
//滚动结束
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self setUpTimer];
}
//滚动中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self changeImageWithOffset:scrollView.contentOffset.x];
}
#pragma mark - 开始滚动，判断位置，替换图片
- (void)changeImageWithOffset:(CGFloat)offset
{
    if(offset >= ScrollWidth * 2)//右滑
    {
        _currentIndex ++;
        if(_currentIndex == _imageCount - 1)
        {
            [self changeImageLeft:_currentIndex - 1 center:_currentIndex right:0];
        }else if(_currentIndex == _imageCount)
        {
            _currentIndex = 0;
            [self changeImageLeft:_imageCount - 1 center:0 right:1];
        }else
        {
            [self changeImageLeft:_currentIndex - 1 center:_currentIndex right:_currentIndex + 1];
        }
    }
    if(offset < 0)//左滑
    {
        _currentIndex --;
        if(_currentIndex == 0)
        {
            [self changeImageLeft:_imageCount - 1 center:0 right:1];
        }else if(_currentIndex == -1)
        {
            _currentIndex = _imageCount - 1;
            [self changeImageLeft:_currentIndex - 1 center:_currentIndex right:0];
        }else
        {
            [self changeImageLeft:_currentIndex - 1 center:_currentIndex right:_currentIndex + 1];
        }
    }
    
    _PageControl.currentPage = _currentIndex;
}
- (void)changeImageLeft:(NSInteger)LeftIndex center:(NSInteger)centerIndex right:(NSInteger)rightIndex{
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:_imageArray[LeftIndex]] placeholderImage:_placeHolderImage];
    [_centerImageView sd_setImageWithURL:[NSURL URLWithString:_imageArray[centerIndex]] placeholderImage:_placeHolderImage];
    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:_imageArray[rightIndex]] placeholderImage:_placeHolderImage];
    
    [_scrollView setContentOffset:CGPointMake(ScrollWidth, 0)];
}
#pragma mark - 定时器
-(void)dealloc
{
    [self removeTimer];
}
-(void)removeTimer{
    if(_timer == nil){
        return;
    };
    
    [_timer invalidate];
    _timer = nil;
}
-(void)setUpTimer{
    if(_scrollDelay < 0.5){//滚动延时小于0.5秒直接返回
        return;
    }
    _timer = [NSTimer timerWithTimeInterval:_scrollDelay target:self selector:@selector(scroll) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

-(void)scroll{
    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x + ScrollWidth, 0) animated:YES];
}

- (void)setAutoScrollDelay:(NSTimeInterval)AutoScrollDelay
{
    _scrollDelay = AutoScrollDelay;
    
    [self removeTimer];
    [self setUpTimer];
}


#pragma mark - 初始化图片位置

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
