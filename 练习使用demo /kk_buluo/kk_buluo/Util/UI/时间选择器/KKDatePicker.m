//
//  KKDatePicker.m
//  kk_buluo
//
//  Created by david on 2019/3/19.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDatePicker.h"



@interface KKDatePicker ()
@property (nonatomic, copy) void (^selectedBlock)(NSDate *date);
@property(nonatomic,strong) UIDatePicker *datePicker;
@property (nonatomic, weak) UIView *dispalyView;
@end

@implementation KKDatePicker

static const CGFloat kkDatePicker_btnW = 60;
static const CGFloat kkDatePicker_toolH = 40;
static const CGFloat kkDatePicker_diplayViewH = 260;

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubView];
    }
    return self;
}

#pragma mark - UI
-(void)setupSubView {
    
    //bg
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCancelButton:)] ;
    [self addGestureRecognizer:tap];
    
    //2.displayV
    UIView *displayV = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, kkDatePicker_diplayViewH)];
    self.dispalyView = displayV;
    [self addSubview:displayV];
    
    //3.toolV
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, kkDatePicker_toolH)];
    topV.backgroundColor = UIColor.grayColor;
    [displayV addSubview:topV];
    
    //3.1 取消按钮
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kkDatePicker_btnW, topV.height)];
    [topV addSubview:cancelBtn];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //3.2 确定按钮
    UIButton *confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(topV.width-kkDatePicker_btnW, 0, kkDatePicker_btnW, topV.height)];
    [topV addSubview:confirmBtn];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(clickConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //4.datePicker
    UIDatePicker *datePk = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, topV.height, self.width, 220)];
    self.datePicker = datePk;
    [displayV addSubview:datePk];
    datePk.datePickerMode = UIDatePickerModeDate;
    datePk.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1];
    datePk.backgroundColor = [UIColor whiteColor];
    datePk.minimumDate = [[NSDate alloc]initWithTimeIntervalSince1970:0];
    datePk.maximumDate = [[NSDate alloc]initWithTimeIntervalSinceNow:0];
}

#pragma mark - interaction

-(void)showDatePiker:(void(^)(NSDate *date))selectedBlock {
    
    self.selectedBlock = selectedBlock;
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    WS(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = weakSelf.dispalyView.frame;
        frame.origin.y = weakSelf.height - kkDatePicker_diplayViewH;
        weakSelf.dispalyView.frame = frame;
    }];
}

-(void)clickConfirmButton:(UIButton *)btn {
    if (self.selectedBlock) {
        self.selectedBlock(self.datePicker.date) ;
    }
   [self hideSelf];
}

-(void)clickCancelButton:(UIButton *)btn {
    [self hideSelf];
}


-(void)hideSelf {
    WS(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = weakSelf.dispalyView.frame;
        frame.origin.y = weakSelf.height;
        weakSelf.dispalyView.frame = frame;
        weakSelf.alpha = 0.1;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

@end
