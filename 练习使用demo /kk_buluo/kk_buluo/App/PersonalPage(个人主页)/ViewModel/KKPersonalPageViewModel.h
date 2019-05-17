//
//  KKPersonalPageViewModel.h
//  kk_buluo
//
//  Created by 樊星 on 2019/3/25.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKPersonalPageTableHeadView.h"
#import "HHPaginator.h"

@protocol KKPersonPageVM_Delegate <NSObject>
//配置数据
-(void)layoutUserInfoData:(id)resultDic;
-(void)layoutTopicListData:(id)dic;
- (void)getGuildHomeSubjectQueryFail;
@end

@interface KKPersonalPageViewModel : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) KKPersonPageType personalPageType;
@property (nonatomic, weak)   id<KKPersonPageVM_Delegate> delegate;
@property (nonatomic, assign) NSInteger pageNum;

-(void)requestUserInfo;        //请求人物详情
-(void)addFriendRequest;       //加好友
-(void)deleteFriendRequest;    //删好友
-(void)addAttentionRequest;    //添加关注
-(void)requestDynamicList;     //动态列表
-(void)cancelAttentionRequest; //取消关注
-(void)applyInGroup;           //申请加群


@end

