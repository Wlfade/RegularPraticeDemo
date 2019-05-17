//
//  KKTwoLineTitleView.m
//  kk_buluo
//
//  Created by david on 2019/3/18.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKTwoLineTitleView.h"

@interface KKTwoLineTitleView ()
@property (nonatomic,weak,readwrite) UILabel *titleLabel;
@property (nonatomic,weak,readwrite) UILabel *detailLabel;
//tapGr
@property (nonatomic,copy) void(^tapBlock)(NSInteger tag);
@property (nonatomic, assign) float timeInterval;
@end


@implementation KKTwoLineTitleView

#pragma mark - life circle
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}


#pragma mark - UI
-(void)setupSubviews {
    //1.titleL
    UILabel *titleL = [[UILabel alloc]init];
    self.titleLabel = titleL;
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textColor = rgba(51, 51, 51, 1);
    titleL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
    }];
    
    //2.detailL
    UILabel *detailL = [[UILabel alloc]init];
    self.detailLabel = detailL;
    detailL.font = [UIFont systemFontOfSize:11];
    detailL.textColor = rgba(153, 153, 153, 1);
    detailL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:detailL];
    [detailL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
    }];
}


#pragma mark - tap
/** 添加tap收拾 */
-(void)addTapWithTimeInterval:(float)timeInterval tapBlock:(void (^)(NSInteger))tapBlock {
    //1.tapGr
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelf:)];
    [self addGestureRecognizer:tap];
    
    //2.block
    self.tapBlock = tapBlock;
    self.userInteractionEnabled = YES;
    self.timeInterval = timeInterval>0 ? timeInterval : 0;
}

/** tap操作 */
-(void)tapSelf:(UITapGestureRecognizer *)gr {
    if (self.tapBlock) {
        self.tapBlock(self.tag);
    }
    
    self.userInteractionEnabled = NO;
    [self performSelector:@selector(changeEnabled:) withObject:gr afterDelay:self.timeInterval];
}

/** 改变userInteractionEnabled */
- (void)changeEnabled:(UITapGestureRecognizer *)gr {
    self.userInteractionEnabled = YES;
}

@end
