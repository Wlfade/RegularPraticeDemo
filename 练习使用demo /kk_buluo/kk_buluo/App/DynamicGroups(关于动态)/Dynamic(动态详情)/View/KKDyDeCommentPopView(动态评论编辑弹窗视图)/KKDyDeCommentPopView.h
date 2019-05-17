//
//  KKDyDeCommentPopView.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/23.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class KKDyDeCommentPopView;
@protocol KKDyDeCommentPopViewDelegate <NSObject>
//- (void)KKDyDeCommentPopViewDidSend:(NSMutableString *)mutableString withImage:(UIImage *)image;

- (void)KKDyDeCommentPopViewDidSend:(KKDyDeCommentPopView *)commentPopView mutString:(NSMutableString *)mutableString;

@optional
/* 默认最大文字输入 */
- (CGFloat)maxTextCountInKKDyDeCommentPopView:(KKDyDeCommentPopView *)commentPopView;

@end

@interface KKDyDeCommentPopView : UIView

@property(nonatomic,weak) id <KKDyDeCommentPopViewDelegate> delegate;

@property (nonatomic,assign) BOOL isNeedTransmit; //是否勾选了转发



//+ (instancetype)KKDyDeCommentPopViewShow:(UIViewController *)viewController isNeedImage:(BOOL)needImage;

+ (instancetype)KKDyDeCommentPopViewShow:(UIViewController *)viewController isNeedImage:(BOOL)needImage withPlaceString:(NSString *)placeStr;

+ (void)hideWithViewController:(UIViewController *)controller withCompletion:(void(^)(void))completion;

@end

NS_ASSUME_NONNULL_END
