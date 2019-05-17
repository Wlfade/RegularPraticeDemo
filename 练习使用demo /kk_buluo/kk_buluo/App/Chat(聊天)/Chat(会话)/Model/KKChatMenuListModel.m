//
//  KKChatMenuListModel.m
//  kk_buluo
//
//  Created by david on 2019/4/26.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKChatMenuListModel.h"

@implementation KKChatMenuListModel
+(NSDictionary *)mj_objectClassInArray {
    return @{@"menus" : @"KKChatMenuModel"};
}


@end


@implementation KKChatMenuModel
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idStr" : @"id"};
}

+(NSDictionary *)mj_objectClassInArray {
    return @{@"children" : @"KKChatMenuModel"};
}
@end
