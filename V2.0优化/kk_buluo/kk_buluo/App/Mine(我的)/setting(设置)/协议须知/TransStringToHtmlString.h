//
//  TransStringToHtmlString.h
//  JCZJ
//
//  Created by apple on 16/1/6.
//  Copyright © 2016年 apple. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface TransStringToHtmlString : NSObject

+ (NSAttributedString *)getHtmlAttributedStringWithString:(NSString *)textStr;

+ (float)getHtmlHeightWithString:(NSString *)textStr;
@end
