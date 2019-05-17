//
//  KKAuthorizationView.h
//  kk_buluo
//
//  Created by 景天 on 2019/4/22.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol KKAuthorizationViewDelegate <NSObject>

@optional
- (void)authorizationViewDidSelectedReject;
- (void)authorizationViewDidSelectedAgree;

@end

@interface KKAuthorizationView : UIView
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *webAppNameLabel;
@property (nonatomic, weak) id<KKAuthorizationViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
