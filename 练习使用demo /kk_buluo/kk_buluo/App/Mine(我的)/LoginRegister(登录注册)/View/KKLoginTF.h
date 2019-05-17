//
//  KKLoginTF.h
//  KKTribe
//
//  Created by lidaoyuan on 2018/7/13.
//  Copyright © 2018年 杭州鼎代. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, KKLoginTfItemType) {
    KKLoginTfItemTypeIcon = 0,       // 注册进入
    KKLoginTfItemTypeLabel,          // 切换角色进入
};

@interface KKLoginTF : UIView

//左边item
@property (nonatomic, assign) KKLoginTfItemType itemType;
@property (nonatomic,strong) UIImageView* iconImgV;
@property (nonatomic, strong) UILabel *itemLabel;
//输入textField
@property (nonatomic,strong) UITextField* inputTextField;
//右侧btn
@property(nonatomic,strong)UIView *rightView;
//分割线
@property(nonatomic,strong)UIView *separateLine;

/** 设置默认item和placeholder */
-(void)setupWithItem:(NSString *)itemStr placeholder:(NSString *)placeholder;

@end
