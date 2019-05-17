//
//  BBDynamicBlowUpView.h
//  BananaBall
//
//  Created by 单车 on 2018/2/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BBDynamicBlowUpView;
@protocol BBDynamicBlowUpViewDelegate <NSObject>

/** 视图关闭动作 */
- (void)BBDynamicBlowUpViewCloseAction:(BBDynamicBlowUpView *)menu;
@end
@interface BBDynamicBlowUpView : UIView

@property (nonatomic,weak)id <BBDynamicBlowUpViewDelegate> delegate;

+(instancetype)BlowUpWithImageArr:(NSMutableArray*)mutArr withCurrentPage:(NSInteger)currentPage;
+(void)hiddenInpoint:(CGPoint)point completion:(void(^)(void))completion;
@end
