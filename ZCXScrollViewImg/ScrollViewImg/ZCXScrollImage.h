//
//  ZCXScrollImage.h
//  ScrollViewImg
//
//  Created by ZhangCX on 2017/5/27.
//  Copyright © 2017年 ZhangCX. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZCXScrollImageDelegate <NSObject>

//点击滚动视图后出发
-(void)didSelectedImageAtIndex:(NSInteger)index;

@end

@interface ZCXScrollImage : UIView
//接受代理
@property (nonatomic, strong)id<ZCXScrollImageDelegate> delegate;
//占位图
@property (nonatomic, strong)UIImage *placeHolderImage;
//滚动延迟
@property (nonatomic, assign)NSTimeInterval scrollDelay;
//初始化
- (instancetype)initWithFrame:(CGRect)frame WithNetImages:(NSArray *)imageArray scrollDelay:(NSInteger)scrollDelay;
@end
