//
//  KKIconTitleView.m
//  
//
//  Created by david on 2018/12/4.
//  Copyright © 2018 david. All rights reserved.
//

#import "KKIconTitleView.h"

@interface KKIconTitleView()

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *title;

@property (nonatomic,weak,readwrite) UIImageView *iconImageView;

@property (nonatomic,weak,readwrite) UILabel *titleLabel;

//tapGr
@property (nonatomic,copy) void(^tapBlock)(NSInteger tag);
@property (nonatomic, assign) float timeInterval;

@end

@implementation KKIconTitleView

#pragma mark - life circle

-(instancetype)initWithImg:(UIImage *)img title:(NSString *)title {
   self = [self init];
    if (self) {
        self.image = img;
        self.title = title;
        [self setupSubviews];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}


#pragma mark - UI
-(void)setupSubviews {
    //1.icon
    UIImageView *iconImgV = [[UIImageView alloc]init];
    self.iconImageView = iconImgV;
    iconImgV.image = self.image;
    [self addSubview:iconImgV];
    [iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(20);
    }];
    
    //2.titleL
    UILabel *titleL = [[UILabel alloc]init];
    self.titleLabel = titleL;
    titleL.text = self.title;
    titleL.font = [UIFont systemFontOfSize:12];
    titleL.textColor = rgba(102, 102, 102, 1);
    titleL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
    }];
    
    //3.tap
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelf:)];
    [self addGestureRecognizer:tap];
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


#pragma mark - setter
-(void)setIconWidth:(CGFloat)iconWidth {
    _iconWidth = iconWidth;
    
    CGFloat iconH = iconWidth;
    if (self.iconImageView.image) {
        iconH = iconWidth * self.iconImageView.image.size.height/self.iconImageView.image.size.width;
    }
    [self.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(iconWidth);
        make.height.mas_equalTo(iconH);
    }];
}

-(void)setIconHeight:(CGFloat)iconHeight {
    _iconHeight = iconHeight;
    
    CGFloat iconW = iconHeight;
    if (self.iconImageView.image) {
        iconW = iconHeight * self.iconImageView.image.size.width/self.iconImageView.image.size.height;
    }
    [self.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(iconW);
        make.height.mas_equalTo(iconHeight);
    }];
}


-(void)setNeedCircle:(BOOL)needCircle {
    _needCircle = needCircle;
    self.iconImageView.layer.cornerRadius = needCircle ? self.iconImageView.width/2.0 : 0;
    self.iconImageView.layer.masksToBounds = YES;
}

-(void)setShowFullTitle:(BOOL)showFullTitle {
    _showFullTitle = showFullTitle;
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        if (showFullTitle) {
            make.centerX.mas_equalTo(0);
        }else{
            make.left.right.mas_equalTo(0);
        }
    }];
}


@end
