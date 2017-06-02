//
//  ViewController.m
//  ScrollViewImg
//
//  Created by ZhangCX on 2017/5/27.
//  Copyright © 2017年 ZhangCX. All rights reserved.
//

#import "ViewController.h"
#import "ZCXScrollImage.h"

@interface ViewController ()<ZCXScrollImageDelegate>
@property(nonatomic,strong)NSArray *NetImageArray;
@end

@implementation ViewController
-(NSArray *)NetImageArray
{
    if(!_NetImageArray)
    {
        _NetImageArray = @[@"http://ws.xzhushou.cn/focusimg/201508201549023.jpg",@"http://ws.xzhushou.cn/focusimg/52.jpg",@"http://ws.xzhushou.cn/focusimg/51.jpg",@"http://ws.xzhushou.cn/focusimg/50.jpg"];
    }
    return _NetImageArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNetScrollView];
}

-(void)createNetScrollView
{
    /** 设置网络scrollView的Frame及所需图片*/
    ZCXScrollImage *scrollImage = [[ZCXScrollImage alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200) WithNetImages:self.NetImageArray scrollDelay:2];
    

    /** 设置占位图*/
    scrollImage.placeHolderImage = [UIImage imageNamed:@"placeholderImage"];
    
    
    /** 获取网络图片的index*/
    scrollImage.delegate = self;
    
    /** 添加到当前View上*/
    [self.view addSubview:scrollImage];
    
}
/** 获取网络图片的index*/
-(void)didSelectedImageAtIndex:(NSInteger)index
{
    NSLog(@"点中网络图片的下标是:%ld",(long)index);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
