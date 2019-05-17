//
//  KKProtocolVC.h
//  kt_user
//
//  Created by 单车 on 2018/9/18.
//  Copyright © 2018年 杭州鼎代. All rights reserved.
//

#import "BaseViewController.h"

@interface KKProtocolVC : BaseViewController
/** 导航栏title */
@property (nonatomic,copy) NSString *naviTitle;

/** 显示的内容 */
@property (nonatomic,strong) NSString *content;

@end
