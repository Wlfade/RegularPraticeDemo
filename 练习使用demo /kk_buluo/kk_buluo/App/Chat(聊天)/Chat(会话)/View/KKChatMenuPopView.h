//
//  KKChatMenuPopView.h
//  kk_buluo
//
//  Created by david on 2019/4/26.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKChatMenuListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKChatMenuPopView : UIView

-(void)showPopViewWithMenus:(NSArray <KKChatMenuModel *>*)menus atPoint:(CGPoint)anchorPoint selectedBlock:(void(^)(KKChatMenuModel *selectedMenuModel))selectedBlock;

@end

NS_ASSUME_NONNULL_END
