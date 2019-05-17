//
//  DGFloatButton.h
//  AbacusGo
//
//  Created by david on 17/9/1.
//  Copyright © 2017年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DGFloatButton : UIButton

/** 点击的block */
@property (nonatomic,copy) void(^clickBlock)(void);

@end
