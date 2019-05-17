//
// Created by zorro on 15/3/7.
// Copyright (c) 2015 tutuge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (EmojiExtension)

- (NSString *)getPlainString;
- (NSUInteger)getOrderCount;
- (NSUInteger)getRaceCount;
/** 有多少个表情 */
- (NSUInteger)getEmotionCount;
/** 表情 */
- (NSUInteger)getEmotionStrCount;

- (NSUInteger)getAtStrCount;
- (NSUInteger)getAtCount;
- (NSUInteger)getOrderStrCount;
- (NSUInteger)getRaceStrCount;

- (NSMutableArray *)getSaveMutableArray;

@end
