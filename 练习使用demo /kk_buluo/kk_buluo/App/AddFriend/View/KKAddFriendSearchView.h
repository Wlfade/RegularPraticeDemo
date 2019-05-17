//
//  KKAddFriendSearchView.h
//  kk_buluo
//
//  Created by 樊星 on 2019/3/20.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKAddFriendSearchView : UIView
@property (nonatomic, copy) void(^cancelClick)(void);
@property (nonatomic, copy) void(^textChangeBlock)(NSString *text);
@end
