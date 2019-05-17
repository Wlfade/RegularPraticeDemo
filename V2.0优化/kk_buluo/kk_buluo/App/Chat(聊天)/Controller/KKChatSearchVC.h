//
//  KKChatSearchVC.h
//  kk_buluo
//
//  Created by david on 2019/3/22.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KKChatSearchVcDelegate <NSObject>
- (void)onSearchCancelClick;
@end

@interface KKChatSearchVC : UIViewController<UINavigationControllerDelegate>
@property(nonatomic, weak) id<KKChatSearchVcDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
