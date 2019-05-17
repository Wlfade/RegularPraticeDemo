//
//  KKChatSearchMoreVC.h
//  kk_buluo
//
//  Created by david on 2019/3/24.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "BaseViewController.h"
#import <RongIMKit/RongIMKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKChatSearchMoreVC : BaseViewController

@property (nonatomic, strong) NSArray <RCMessage *>*msgArr;
@property (nonatomic, copy) NSString *keywords;
@property (nonatomic, copy) NSString *naviTitleStr;
@end

NS_ASSUME_NONNULL_END
