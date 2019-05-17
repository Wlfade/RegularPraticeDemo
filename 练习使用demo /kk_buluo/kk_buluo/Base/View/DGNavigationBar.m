//
//  DGNavigationBar.m
//  DGTool
//
//  Created by david on 2018/12/26.
//  Copyright © 2018 david. All rights reserved.
//

#import "DGNavigationBar.h"

@interface DGNavigationBar ()
@property (nonatomic,weak) UIImageView *bgImageView;
@property (nonatomic, weak) UIView *grayLine;
@end

@implementation DGNavigationBar

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI
- (void)setupUI {
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH,STATUS_AND_NAV_BAR_HEIGHT);
    self.backgroundColor = COLOR_NAVI_BG;
    
    //1.bgImage
    UIImageView *bgImageV = [[UIImageView alloc] initWithFrame:self.bounds];
    self.bgImageView  = bgImageV;
    [self addSubview:bgImageV];
    bgImageV.image = [self imageWithColor:COLOR_NAVI_BG];
    bgImageV.contentMode = UIViewContentModeScaleAspectFill;
    bgImageV.hidden = YES;
    
    //2.titleLabel
    UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(80, STATUS_BAR_HEIGHT, SCREEN_WIDTH-160, 44)];
    self.titleLabel = titleL;
    [self addSubview:titleL];
    titleL.textColor = UIColor.whiteColor;
    titleL.backgroundColor = UIColor.clearColor;
    titleL.font = [UIFont systemFontOfSize:19];
    titleL.textAlignment = NSTextAlignmentCenter;
    
    //3.backBtn
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton = backBtn;
    [self addSubview:backBtn];
    UIImage *backImage = [UIImage imageNamed:@"navi_back_white"];
    [backBtn setImage:backImage forState:UIControlStateNormal];
    backBtn.frame=CGRectMake(10, STATUS_BAR_HEIGHT, 50, 44);
    [backBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //4.grayLine
//    UIView *grayLine = [[UIView alloc]initWithFrame:CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT-0.5, SCREEN_WIDTH, 0.5)];
//    self.grayLine = grayLine;
//    grayLine.backgroundColor = rgba(238, 238, 238, 1);
//    [self addSubview:grayLine];
}

#pragma mark - setter
-(void)setBarType:(DGNavigationBarType)barType {
    _barType = barType;
    
    UIImage *backImgWhite = [UIImage imageNamed:@"navi_back_white"];
    UIImage *backImgGray = [UIImage imageNamed:@"navi_back_gray"];
    
    switch (barType) {
        case DGNavigationBarTypeDefault:{
            self.bgColor = COLOR_NAVI_BG;
            self.titleLabel.textColor = COLOR_HEX(0x333333);
            [self.backButton setImage:backImgWhite forState:UIControlStateNormal];
        }break;
            
        case DGNavigationBarTypeWhite:{
            self.bgColor = UIColor.whiteColor;
            self.titleLabel.textColor = COLOR_HEX(0x333333);
            [self.backButton setImage:backImgGray forState:UIControlStateNormal];
        }break;
            
        case DGNavigationBarTypeClear:{
            self.bgColor = UIColor.clearColor;
            self.titleLabel.textColor = COLOR_HEX(0x333333);
            self.backButton.hidden = YES;
            self.grayLine.hidden = YES;
        }break;
            
        case DGNavigationBarTypeGray:{
            self.bgColor = COLOR_HEX(0xf2f2f2);
            self.titleLabel.textColor = COLOR_HEX(0x333333);
            [self.backButton setImage:backImgGray forState:UIControlStateNormal];
        }break;
            
        default:
            break;
    }
}


-(void)setBgImage:(UIImage *)bgImage {
    _bgImageView.image = bgImage;
    _bgImageView.hidden = NO;
}

-(void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    _bgImageView.hidden = YES;
    self.backgroundColor = bgColor;
}


#pragma mark - tool
/** 纯色转图片 */
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
