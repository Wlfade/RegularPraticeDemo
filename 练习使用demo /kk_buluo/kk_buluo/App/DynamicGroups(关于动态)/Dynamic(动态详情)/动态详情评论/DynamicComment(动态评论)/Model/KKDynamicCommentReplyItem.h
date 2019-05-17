//
//  KKDynamicCommentReplyItem.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/19.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKDynamicCommentReplyItem : NSObject

/*评论回复的ID*/
@property (nonatomic,strong) NSString *commentReplyId;
/*评论回复的内容*/
@property (nonatomic,strong) NSString *content;

/*评论回复的内容*/
@property (nonatomic,strong) NSMutableAttributedString *mutContent;

/*评论创建时间*/
@property (nonatomic,strong) NSString *gmtCreate;

@property (nonatomic,strong) NSString *replyUserId;

@property (nonatomic,strong) NSString *replyUserLogoUrl;

@property (nonatomic,strong) NSString *replyUserName;
/*系统是否删除*/
@property (nonatomic,assign) BOOL systemDeleted;
/*用户是否删除*/
@property (nonatomic,assign) BOOL userDeleted;
/*评论回复的高度*/
@property (nonatomic,assign) CGFloat dyReplyHeight;
@end

NS_ASSUME_NONNULL_END
