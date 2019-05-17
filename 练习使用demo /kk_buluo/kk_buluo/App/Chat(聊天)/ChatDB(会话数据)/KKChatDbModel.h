//
//  KKChatDbModel.h
//  kk_buluo
//
//  Created by david on 2019/3/29.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKChatDbModel : NSObject
@property (nonatomic, copy) NSString *idStr;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *logoUrl;
@property (nonatomic, copy) NSString *groupMemberNumber;
@end

NS_ASSUME_NONNULL_END
