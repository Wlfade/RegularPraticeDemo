//
//  KKDyDeMoreSheetMenu.h
//  BananaBall
//
//  Created by 单车 on 2018/2/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KKDyDeMoreSheetMenu,MenuItem,KKDyDetailWholeItem;
@protocol KKDyDeMoreSheetMenuDelegate<NSObject>
@optional
- (void)shareMenuDidClickCloseBtn:(KKDyDeMoreSheetMenu *)menu;

//- (void)shareMenuDidSelect:(KKDyDeMoreSheetMenu *)menu withTage:(NSInteger)senderTag;
- (void)shareMenuDidSelect:(KKDyDeMoreSheetMenu *)menu withMenuItem:(MenuItem *)item;
@end

@interface KKDyDeMoreSheetMenu : UIView

@property (nonatomic,weak)id<KKDyDeMoreSheetMenuDelegate> delegate;

/**
 显示弹出框
 */
//+ (instancetype)showInView:(UIView *)supView withViewController:(UIViewController *)viewController;

+ (instancetype)showInView:(UIView *)supView withViewController:(UIViewController *)viewController withDyDetailWholeItem:(KKDyDetailWholeItem *)dydeItem;


//+ (void)hide:(void(^)(void))completion;

+ (void)hideWithViewController:(UIViewController *)controller withCompletion:(void(^)(void))completion;
@end
