//
//  KKMyCommentListModel.m
//  kk_buluo
//
//  Created by david on 2019/3/25.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKMyCommentListModel.h"

@implementation KKMyCommentListModel
+(NSDictionary *)mj_objectClassInArray {
    return @{@"commentSimpleList" : @"KKMyCommentSimpleModel"};
}
@end


@implementation KKMyCommentSimpleModel
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idStr" : @"id"};
}
@end


@implementation KKMyCommentTopicSimpleModel

@end


@implementation KKMyCommentTopicObjectModel

@end

@implementation KKMyCommentTopicObjectImagePropertiesModel

@end

@implementation KKMyCommentTopicObjectImagePropertiesUrlModel

@end
