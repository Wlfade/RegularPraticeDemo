//
//  BBDynamicImageView.m
//  BananaBall
//
//  Created by 单车 on 2018/1/31.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BBDynamicImageView.h"
#import "BBDynaicTapImageView.h"
#import "XMGCover.h"
#import "BBDynamicBlowUpView.h"

#import "BBDynamicImageItem.h"
#import "KKImageListItem.h"

//#define MaxImageCount 3//最大一行个数
//
//
//#define MaxCounts 9 //最大所有数量
@interface BBDynamicImageView ()<BBDynaicTapImageViewDelegate,BBDynamicBlowUpViewDelegate>


@end

@implementation BBDynamicImageView


- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setDynamicImageItem:(BBDynamicImageItem *)dynamicImageItem{
    _dynamicImageItem = dynamicImageItem;
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [ccs gotoMain:^{
        for (NSInteger i = 0; i < self->_dynamicImageItem.tapImageViewArr.count; i ++) {
            BBDynaicTapImageView *tapImageView = self->_dynamicImageItem.tapImageViewArr[i];
            KKImageListItem *item = self->_dynamicImageItem.midImageUrlArr[i];
//            if (self->_dynamicImageItem.tapImageViewArr.count > MaxImageCount && i == MaxImageCount - 1) {
//                NSString *countStr = [NSString stringWithFormat:@"共%ld张",self->_dynamicImageItem.smallImageUrlArr.count];
//                [tapImageView upSetImageUrl:item.url withTextStr:countStr];
//            }else{
//                [tapImageView upSetImageUrl:item.url withTextStr:nil];
//            }
            [tapImageView upSetImageUrl:item.url withTextStr:nil];
            tapImageView.delegate = self;
            
            [self addSubview:tapImageView];
        }
    }];
    
}
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    for (NSInteger i = 0; i < _dynamicImageItem.imageFrameArr.count; i ++) {
        NSValue *frameValue = _dynamicImageItem.imageFrameArr[i];
        CGRect frame = [frameValue CGRectValue];
        BBDynaicTapImageView *tapImageView = _dynamicImageItem.tapImageViewArr[i];
        tapImageView.frame = frame;
    }
}
- (void) tappedWithObject:(BBDynaicTapImageView *)tapImage withTag:(NSInteger)tag{
    BBLOG(@"点击了图片第%ld张",tag - 11);

//    [XMGCover show];
    NSMutableArray *midMutArr = [NSMutableArray arrayWithArray:_dynamicImageItem.midImageUrlArr];
    BBDynamicBlowUpView *blowUpView = [BBDynamicBlowUpView BlowUpWithImageArr:midMutArr withCurrentPage:tag - 11];
    blowUpView.delegate = self;
}
#pragma mark BBDynamicBlowUpViewDelegate
- (void)BBDynamicBlowUpViewCloseAction:(BBDynamicBlowUpView *)menu{
    [BBDynamicBlowUpView hiddenInpoint:CGPointMake(44, 44) completion:^{
//        [XMGCover hidden];
    }];
}

@end
