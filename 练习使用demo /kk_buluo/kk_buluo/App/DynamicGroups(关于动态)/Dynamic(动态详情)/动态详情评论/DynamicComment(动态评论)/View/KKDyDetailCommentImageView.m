//
//  KKDyDetailCommentImageView.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/19.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDyDetailCommentImageView.h"
#import "KKDyCommentImageItem.h"
#import "BBDynaicTapImageView.h"
#import "XMGCover.h"
#import "BBDynamicBlowUpView.h"
#import "KKImageListItem.h"
@interface KKDyDetailCommentImageView()
<BBDynaicTapImageViewDelegate,BBDynamicBlowUpViewDelegate>

@end

@implementation KKDyDetailCommentImageView
- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)setDynamicImageItem:(KKDyCommentImageItem *)dynamicImageItem{
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
    
    [XMGCover show];
    NSMutableArray *midMutArr = [NSMutableArray arrayWithArray:_dynamicImageItem.midImageUrlArr];
    BBDynamicBlowUpView *blowUpView = [BBDynamicBlowUpView BlowUpWithImageArr:midMutArr withCurrentPage:tag - 11];
    blowUpView.delegate = self;
}
#pragma mark BBDynamicBlowUpViewDelegate
- (void)BBDynamicBlowUpViewCloseAction:(BBDynamicBlowUpView *)menu{
    [BBDynamicBlowUpView hiddenInpoint:CGPointMake(44, 44) completion:^{
        [XMGCover hidden];
    }];
}

@end
