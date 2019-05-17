//
//  Validation.h
//  LittleCircle
//
//  Created by 樊星 on 16/4/13.
//  Copyright © 2016年 trioly.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//验证手机号码等普通验证框架代码
@interface JCValidation : NSObject

+ (BOOL) checkTelNumber:(NSString *) telNumber;

+ (BOOL) checkAllNum:(NSString *)number;

+ (BOOL) checkNumLength:(NSString *)number length:(NSUInteger)length;

+ (BOOL) checkMaxNumLength:(NSString *)number length:(NSUInteger)length;

+ (BOOL) isValidateEmail:(NSString *)email;

+ (BOOL) isValidateWechat:(NSString *)wechat;

+ (BOOL) stringContainsEmoji:(NSString *)string;

+ (BOOL) userInputShouldChinese:(NSString *)string;

+ (BOOL) isValidateChinese:(NSString *)chinese;

+ (BOOL) isContainNum:(NSString *)string;

+ (BOOL) checkUserIdCard: (NSString *) cardNo;

+ (BOOL) isOperId:(NSString *)string;

+ (BOOL) isOperGroupId:(NSString *)string;

+ (BOOL) checkCompanyChatId:(NSString *)string;

//邮政编码
+ (BOOL) checkPostCode:(NSString *)postCode;

//校验输入金额
+ (void)checkInputMoney:(UITextField *)textfield;

//限制输入位数
+ (void)checkPhoneInputLength:(UITextField *)textfield;

//限制输入位数
+ (void)checkInputLength:(UITextField *)textfield andMaxLength:(int)max;

//是否包含该网址校验
+ (BOOL)urlValidation:(NSDictionary *)param;

@end
