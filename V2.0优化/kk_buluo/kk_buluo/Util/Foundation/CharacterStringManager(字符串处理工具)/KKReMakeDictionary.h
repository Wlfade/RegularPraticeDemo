//
//  KKReMakeDictionary.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/19.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKReMakeDictionary : NSObject
/* 根据传入的 键数组 从对应的字典中取出数据 然后组成新的字典返回 key 与服务端给的保持一致 赋值给模型*/
+ (NSDictionary *)makeTheDictWithKeys:(NSArray *)keys
             fromTheOriginalDictonary:(NSDictionary *)dictionary;
/**
 传入键值数组 取出 元素 赋值新字典替换键值 形成新字典
 
 @param oriKeys 目标字典中的键值数组
 @param transKeys 转换的键值数组
 @param dictionary 目标字典
 @return 新字典
 */
+ (NSDictionary *)makeTheDictWithOriginalKeys:(NSArray *)oriKeys
                            withTransMakeKeys:(NSArray *)transKeys
                     fromTheOriginalDictonary:(NSDictionary *)dictionary;


/**
 通过text 转一个可变字符串
 @param textStr 内容
 @param textFont 字体大小
 @param textColor 颜色
 @param maxWidth 最大宽度
 @param maxHeight 最大高度
 @param fontFloat 图片大小
 @return 返回一个 带有内容 和 高度的字典
 html==>NSAttributedString,  height ==> NSNumber
 */
+ (NSMutableDictionary *)getHtmlAttributedStringAndHeightWithString:(NSString *)textStr
                                                       withTextFont:(UIFont *)textFont
                                                      withTextColor:(UIColor *)textColor
                                                        withMaxWith:(CGFloat)maxWidth
                                                      withMaxHeight:(CGFloat)maxHeight
                                                     wihthImageFont:(CGFloat)fontFloat;
/**
 通过text 转一个可变字符串
 @param textStr 内容
 @param textFont 字体大小
 @param textColor 颜色
 @param maxWidth 最大宽度
 @param maxHeight 最大高度
 @param fontFloat 图片大小
 @param lineSpace 段落间隔
 @return 返回一个 带有内容 和 高度的字典
 html==>NSAttributedString,  height ==> NSNumber
 */

+ (NSMutableDictionary *)getHtmlAttributedStringAndHeightWithString:(NSString *)textStr
                                                       withTextFont:(UIFont *)textFont
                                                      withTextColor:(UIColor *)textColor
                                                        withMaxWith:(CGFloat)maxWidth
                                                      withMaxHeight:(CGFloat)maxHeight
                                                     wihthImageFont:(CGFloat)fontFloat
                                                   withLineSpaceing:(CGFloat)lineSpace;
@end

NS_ASSUME_NONNULL_END
