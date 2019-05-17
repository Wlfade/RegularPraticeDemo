//
//  KKAddAddFriendShareView.h
//  kk_buluo
//
//  Created by 樊星 on 2019/3/22.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKAddAddFriendShareView : UIView
@property (nonatomic, strong) NSString *phoneNum;
@property (nonatomic, copy)   void(^clickTitle)(NSString *title);
@end
