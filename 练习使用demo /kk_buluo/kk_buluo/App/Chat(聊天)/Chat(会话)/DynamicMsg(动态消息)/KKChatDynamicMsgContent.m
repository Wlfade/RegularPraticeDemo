//
//  KKChatDynamicMsgContent.m
//  kk_buluo
//
//  Created by david on 2019/3/31.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKChatDynamicMsgContent.h"

@implementation KKChatDynamicMsgContent

#pragma mark - RCMessagePersistentCompatible
///消息是否存储，是否计入未读数
+ (RCMessagePersistent)persistentFlag {
    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}

#pragma mark - RCMessageContentView
/// 会话列表中显示的摘要
- (NSString *)conversationDigest {
    if(self.type == 2){
        return @"[文章]";
    }else {
        return @"[动态]";
    }
}

#pragma mark - RCMessageCoding
/// NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.idStr = [aDecoder decodeObjectForKey:@"idStr"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.summary = [aDecoder decodeObjectForKey:@"summary"];
        self.imgUrl = [aDecoder decodeObjectForKey:@"imgUrl"];
        self.type = [[aDecoder decodeObjectForKey:@"type"] integerValue];
        self.tagStr = [aDecoder decodeObjectForKey:@"tagStr"];
        self.extra = [aDecoder decodeObjectForKey:@"extra"];
    }
    return self;
}

/// NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.idStr forKey:@"idStr"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.summary forKey:@"summary"];
    [aCoder encodeObject:self.imgUrl forKey:@"imgUrl"];
    [aCoder encodeObject:@(self.type) forKey:@"type"];
    [aCoder encodeObject:self.tagStr forKey:@"tagStr"];
    [aCoder encodeObject:self.extra forKey:@"extra"];
}

///将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict safeSetObject:self.idStr forKey:@"idStr"];
    [dataDict safeSetObject:self.title forKey:@"title"];
    [dataDict safeSetObject:self.summary forKey:@"summary"];
    [dataDict safeSetObject:self.imgUrl forKey:@"imgUrl"];
    [dataDict safeSetObject:@(self.type) forKey:@"type"];
    [dataDict safeSetObject:self.tagStr forKey:@"tagStr"];
    [dataDict safeSetObject:self.extra forKey:@"extra"];
    
    if (self.senderUserInfo) {
        [dataDict setObject:[self encodeUserInfo:self.senderUserInfo] forKey:@"user"];
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:kNilOptions error:nil];
    return data;
}

///将json解码生成消息内容
- (void)decodeWithData:(NSData *)data {
    if (data) {
        __autoreleasing NSError *error = nil;
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        if (dictionary) {
            self.idStr = dictionary[@"idStr"];
            self.title = dictionary[@"title"];
            self.summary = dictionary[@"summary"];
            self.imgUrl = dictionary[@"imgUrl"];
            self.type = [dictionary[@"type"] integerValue];
            self.tagStr = dictionary[@"tagStr"];
            self.extra = dictionary[@"extra"];
            
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}

///消息的类型名
+ (NSString *)getObjectName {
    return KKBLMsgIdDynamic;
}

@end
