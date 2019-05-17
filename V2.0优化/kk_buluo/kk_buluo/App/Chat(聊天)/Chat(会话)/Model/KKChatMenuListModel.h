//
//  KKChatMenuListModel.h
//  kk_buluo
//
//  Created by david on 2019/4/26.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KKChatMenuModel;

@interface KKChatMenuListModel : NSObject

@property (nonatomic, assign) BOOL guildOutOfService;

@property (nonatomic, strong) NSArray <KKChatMenuModel *>*menus;

@end


@interface KKChatMenuModel : NSObject

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *parentId;

@property (nonatomic, copy) NSString *extId;

@property (nonatomic, copy) NSString *extIdType;

@property (nonatomic, copy) NSString *menuType;

@property (nonatomic, copy) NSString *idStr;//id

@property (nonatomic, assign) NSInteger menuLevel;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, strong) NSArray <KKChatMenuModel *>*children;

@end
