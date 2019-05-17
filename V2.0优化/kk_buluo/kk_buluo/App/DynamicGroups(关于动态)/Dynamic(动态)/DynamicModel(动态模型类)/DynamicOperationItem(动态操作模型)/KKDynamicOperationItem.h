//
//  KKDynamicOperationItem.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/17.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKDynamicOperationItem : NSObject
//** 转发数量 */
@property (nonatomic,assign) NSInteger transmitCount;
//** 是否转发 */
@property (nonatomic,assign)BOOL transmited;
//** 评论数量 */
@property (nonatomic,assign) NSInteger replyCount;
//** 点赞数量 */
@property (nonatomic,assign) NSInteger likeCount;
//** 点赞 */
@property (nonatomic,assign)BOOL liked;
//** 收藏 */
@property (nonatomic,assign)BOOL collected;

//** 操作视图高度 */
@property (nonatomic,assign)CGFloat dyOperationHeight;
@end

NS_ASSUME_NONNULL_END
