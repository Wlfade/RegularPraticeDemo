//
// Created by zorro on 15/3/7.
// Copyright (c) 2015 tutuge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSAttributedString+EmojiExtension.h"
#import "EmojiTextAttachment.h"

@implementation NSAttributedString (EmojiExtension)

- (NSString *)getPlainString {
    
    NSString *tempPlainString=self.string;
    tempPlainString=[tempPlainString stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    tempPlainString=[tempPlainString stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    tempPlainString=[tempPlainString stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    tempPlainString=[tempPlainString stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
    
    //微信里的空格 处理
    tempPlainString=[tempPlainString stringByReplacingOccurrencesOfString:@" " withString:@" "];
    
    NSMutableString *plainString = [NSMutableString stringWithString:tempPlainString];
    __block NSUInteger base = 0;
    
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(id value, NSRange range, BOOL *stop) {
                      
                      if (value && [value isKindOfClass:[EmojiTextAttachment class]]) {
                          
                          [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                                     withString:((EmojiTextAttachment *) value).emojiTag];
                          base += ((EmojiTextAttachment *) value).emojiTag.length - 1;
                      }
                  }];
    
    return plainString;
}

- (NSMutableArray *)getSaveMutableArray{
    __block NSMutableArray *saveMutableArray=[[NSMutableArray alloc]init];
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    __block NSUInteger base = 0;
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(id value, NSRange range, BOOL *stop) {
                      
                      if (value && [value isKindOfClass:[EmojiTextAttachment class]]) {
                          
                          [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                                     withString:((EmojiTextAttachment *) value).emojiTag];
                          base += ((EmojiTextAttachment *) value).emojiTag.length - 1;
                          NSMutableDictionary *tempDic=[[NSMutableDictionary alloc]initWithDictionary:((EmojiTextAttachment *) value).infoDic];
                          if ([((EmojiTextAttachment *) value).emojiTag hasPrefix:@"<emotion "]) {
                              [tempDic setObject:@"emotion" forKey:@"type"];
                              [saveMutableArray addObject:tempDic];
                          }
                          if ([((EmojiTextAttachment *) value).emojiTag hasPrefix:@"<lottery_project"]) {
                              [tempDic setObject:@"project" forKey:@"type"];
                              [saveMutableArray addObject:tempDic];
                          }
                          if ([((EmojiTextAttachment *) value).emojiTag hasPrefix:@"<lottery_race race_type=\"JCLQ\""]) {
                              [tempDic setObject:@"jclqrace" forKey:@"type"];
                              [saveMutableArray addObject:tempDic];
                          }else if ([((EmojiTextAttachment *) value).emojiTag hasPrefix:@"<lottery_race"]) {
                              [tempDic setObject:@"race" forKey:@"type"];
                              [saveMutableArray addObject:tempDic];
                          }
                          if ([((EmojiTextAttachment *) value).emojiTag hasSuffix:@" "]) {
                              [tempDic setObject:@"at" forKey:@"type"];
                              [saveMutableArray addObject:tempDic];
                          }
                      }
                  }];
    
    return saveMutableArray;
}

- (NSUInteger)getOrderCount{
    __block NSUInteger count=0;
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    __block NSUInteger base = 0;
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(id value, NSRange range, BOOL *stop) {
                      
                      if (value && [value isKindOfClass:[EmojiTextAttachment class]]) {
                          
                          [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                                     withString:((EmojiTextAttachment *) value).emojiTag];
                          base += ((EmojiTextAttachment *) value).emojiTag.length - 1;
                          if ([((EmojiTextAttachment *) value).emojiTag hasPrefix:@"<lottery_project"]) {
                              count++;
                              
                          }
                      }
                  }];
    
    return count;
}

- (NSUInteger)getRaceCount{
    __block NSUInteger count=0;
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    __block NSUInteger base = 0;
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(id value, NSRange range, BOOL *stop) {
                      
                      if (value && [value isKindOfClass:[EmojiTextAttachment class]]) {
                          
                          [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                                     withString:((EmojiTextAttachment *) value).emojiTag];
                          base += ((EmojiTextAttachment *) value).emojiTag.length - 1;
                          if ([((EmojiTextAttachment *) value).emojiTag hasPrefix:@"<lottery_race"]) {
                              count++;
                          }
                      }
                  }];
    
    return count;
}

- (NSUInteger)getEmotionCount {
    __block NSUInteger count=0;
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(id value, NSRange range, BOOL *stop) {
                      
                      if (value && [value isKindOfClass:[EmojiTextAttachment class]]) {
                          count += 1;
                      }
                  }];
    
    return count;
}

- (NSUInteger)getEmotionStrCount{
    __block NSUInteger count=0;
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    __block NSUInteger base = 0;
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(id value, NSRange range, BOOL *stop) {
                      
                      if (value && [value isKindOfClass:[EmojiTextAttachment class]]) {
                          
                          [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                                     withString:((EmojiTextAttachment *) value).emojiTag];
                          base += ((EmojiTextAttachment *) value).emojiTag.length - 1;
                          if ([((EmojiTextAttachment *) value).emojiTag hasPrefix:@"<emotion "]) {
                              count=count+((EmojiTextAttachment *) value).emojiName.length-1;
                          }
                      }
                  }];
    return count;
}

- (NSUInteger)getRaceStrCount{
    __block NSUInteger count=0;
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    __block NSUInteger base = 0;
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(id value, NSRange range, BOOL *stop) {
                      
                      if (value && [value isKindOfClass:[EmojiTextAttachment class]]) {
                          
                          [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                                     withString:((EmojiTextAttachment *) value).emojiTag];
                          base += ((EmojiTextAttachment *) value).emojiTag.length - 1;
                          if ([((EmojiTextAttachment *) value).emojiTag hasPrefix:@"<lottery_race"]) {
                              count=count+((EmojiTextAttachment *) value).emojiName.length;
                          }
                      }
                  }];
    
    return count;
}

- (NSUInteger)getOrderStrCount{
    __block NSUInteger count=0;
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    __block NSUInteger base = 0;
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(id value, NSRange range, BOOL *stop) {
                      
                      if (value && [value isKindOfClass:[EmojiTextAttachment class]]) {
                          
                          [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                                     withString:((EmojiTextAttachment *) value).emojiTag];
                          base += ((EmojiTextAttachment *) value).emojiTag.length - 1;
                          if ([((EmojiTextAttachment *) value).emojiTag hasPrefix:@"<lottery_project"]) {
                              count=count+((EmojiTextAttachment *) value).emojiName.length;
                          }
                      }
                  }];
    
    return count;
}

- (NSUInteger)getAtStrCount{
    __block NSUInteger count=0;
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    __block NSUInteger base = 0;
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(id value, NSRange range, BOOL *stop) {
                      
                      if (value && [value isKindOfClass:[EmojiTextAttachment class]]) {
                          
                          [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                                     withString:((EmojiTextAttachment *) value).emojiTag];
                          base += ((EmojiTextAttachment *) value).emojiTag.length - 1;
                          if ([((EmojiTextAttachment *) value).emojiTag hasSuffix:@" "]) {
                              count=count+((EmojiTextAttachment *) value).emojiName.length-2;
                          }
                      }
                  }];
    
    return count;
}

- (NSUInteger)getAtCount{
    __block NSUInteger count=0;
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    __block NSUInteger base = 0;
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(id value, NSRange range, BOOL *stop) {
                      
                      if (value && [value isKindOfClass:[EmojiTextAttachment class]]) {
                          
                          [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                                     withString:((EmojiTextAttachment *) value).emojiTag];
                          base += ((EmojiTextAttachment *) value).emojiTag.length - 1;
                          if ([((EmojiTextAttachment *) value).emojiTag hasSuffix:@" "]) {
                              count++;
                          }
                      }
                  }];
    
    return count;
}

@end
