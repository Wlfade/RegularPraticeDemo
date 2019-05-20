//
//  EmojiTextAttachment.h
//  InputEmojiExample
//
//  Created by zorro on 15/3/7.
//  Copyright (c) 2015年 tutuge. All rights reserved.
//

/*
 
 NSMutableAttributedString *mutaAttStr=[[NSMutableAttributedString alloc]initWithString:@"认证失败，方案未上传"];
 EmojiTextAttachment *emojiTextAttachment = [EmojiTextAttachment new];
 //Set tag and image
 emojiTextAttachment.emojiTag = @"警告";
 emojiTextAttachment.image = [UIImage imageNamed:@"开赛后公开、保密_07"];
 emojiTextAttachment.emojiSize=18;
 //Insert emoji image
 [mutaAttStr insertAttributedString:[NSAttributedString attributedStringWithAttachment:emojiTextAttachment] atIndex:0];
 
 */

#import <UIKit/UIKit.h>

@interface EmojiTextAttachment : NSTextAttachment
@property(strong, nonatomic) NSString *emojiTag;
@property(strong, nonatomic) NSString *emojiName;

@property(strong, nonatomic) NSDictionary *infoDic;
@property(assign, nonatomic) CGFloat emojiSize;  //For emoji image size
@property(assign, nonatomic) CGFloat offsetY;///-为下调

@property(assign, nonatomic) int type;

@end
