//
//  KKAddFriendViewModel.h
//  kk_buluo
//
//  Created by 樊星 on 2019/3/21.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KKAddFriendVM_Delegate <NSObject>
//配置数据
-(void)layoutData:(id)resultDic;
@end

@interface KKAddFriendViewModel : NSObject
@property (nonatomic, strong) NSString *phoneNum;
@property (nonatomic, weak)   id<KKAddFriendVM_Delegate> delegate;

//触发请求
-(void)triggerRequest;

@end
