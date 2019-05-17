//
//  Validation.m
//  LittleCircle
//
//  Created by 樊星 on 16/4/13.
//  Copyright © 2016年 trioly.com. All rights reserved.
//

#import "JCValidation.h"

@implementation JCValidation

+ (BOOL)checkTelNumber:(NSString *) telNumber
{
    NSString *pattern = @"^1+[123456789]+\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}

+ (BOOL) checkAllNum:(NSString *)number
{
    
    NSString *pattern = @"^[0-9]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:number];
    return isMatch;
    
}

+(BOOL) checkNumLength:(NSString*)number length:(NSUInteger)length
{
    
    return number.length == length;
}

+(BOOL) checkMaxNumLength:(NSString*)number length:(NSUInteger)length
{
    return number.length <= length;
}


+(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(BOOL) isValidateWechat:(NSString *)wechat
{
    NSString *emailRegex = @"^[a-zA-Z]+[a-zA-Z-_0-9]{5,19}+";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:wechat];
}


#pragma 正则匹配用户身份证号15或18位
+ (BOOL)checkUserIdCard: (NSString *) cardNo
{
    if (cardNo.length != 18) {
        return  NO;
    }
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    
    NSScanner* scan = [NSScanner scannerWithString:[cardNo substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;
    
    for (int i =0; i<17; i++) {
        sumValue+=[[cardNo substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
    
    if ([strlast isEqualToString: [[cardNo substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;
}



/*
 *利用Emoji表情最终会被编码成Unicode，因此，
 *只要知道Emoji表情的Unicode编码的范围，
 *就可以判断用户是否输入了Emoji表情。
 */
+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar high = [substring characterAtIndex: 0];
                                
                                // Surrogate pair (U+1D000-1F9FF)
                                if (0xD800 <= high && high <= 0xDBFF) {
                                    const unichar low = [substring characterAtIndex: 1];
                                    const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                    
                                    if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                        returnValue = YES;
                                    }
                                    
                                    // Not surrogate pair (U+2100-27BF)
                                } else {
                                    if (0x2100 <= high && high <= 0x27BF){
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    
    return returnValue;
}



+ (BOOL)userInputShouldChinese:(NSString *)string {
    NSString *regex = @"[\u4e00-\u9fa5]+";
    NSPredicate *name = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if(![name evaluateWithObject: string])
    {

        return YES;
    }
    return NO;
}


-(BOOL)IsChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
        
    }
    return NO;
    
}

+(BOOL) isValidateChinese:(NSString *)chinese
{
    NSString *emailRegex = @".{0,}[\u4E00-\u9FA5].{0,}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:chinese];
}

+ (BOOL) isContainNum:(NSString *)string{

    NSInteger alength = [string length];
    
    for (int i = 0; i<alength; i++) {
        unichar commitChar = [string characterAtIndex:i];
       
       if((commitChar>47)&&(commitChar<58)){
           
           return YES;
        }
    


}
            return NO;
}

+ (BOOL) isOperId:(NSString *)string
{
    NSString *pattern = @"^[0-9]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:string];
    if (string.length != 13) {
        isMatch = NO;
    }
    
    return isMatch;
    
}

+ (BOOL) isOperGroupId:(NSString *)string
{
    if (string.integerValue < 0) {
        return NO;
    }
    
    NSString *pattern = @"^[0-9]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = ![pred evaluateWithObject:string];
    
    
    return isMatch;
    
}


+ (BOOL) checkCompanyChatId:(NSString *)string{

    BOOL isMatch = NO;
    
    if ([self isOperId:string] || [self isOperGroupId:string]) {
        
        isMatch = YES;
    }
    
    
    return isMatch;

}

+ (BOOL) checkPostCode:(NSString *)string{
//    const char *cvalue = [string UTF8String];
//    NSInteger len = strlen(cvalue);
//    if (len != 6) {
//        return FALSE;
//    }
//    for (int i = 0; i < len; i++)
//    {
//        if (!(cvalue[i] >= '0' && cvalue[i] <= '9'))
//        {
//            return FALSE;
//        }
//    }
//    return TRUE;
    if (string.integerValue < 0) {
        return NO;
    }
    
    NSString *pattern = @"[1-9]d{5}(?!d)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = ![pred evaluateWithObject:string];
    
    return isMatch;
}

////校验输入金额
//+ (void)checkInputMoney:(UITextField *)textfield{
//    [textfield.rac_textSignal subscribeNext:^(NSString *x) {
//        static NSInteger const maxIntegerLength=8;//最大整数位
//        static NSInteger const maxFloatLength=2;//最大精确到小数位
//        if (x.length) {
//            //第一个字符处理
//            //第一个字符为0,且长度>1时
//            if ([[x substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"]) {
//                if (x.length>1) {
//                    if ([[x substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"0"]) {
//                        //如果第二个字符还是0,即"00",则无效,改为"0"
//                        textfield.text=@"0";
//                    }else if (![[x substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"."]){
//                        //如果第二个字符不是".",比如"03",清除首位的"0"
//                        textfield.text=[x substringFromIndex:1];
//                    }
//                }
//            }
//            //第一个字符为"."时,改为"0."
//            else if ([[x substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"."]){
//                textfield.text=@"0.";
//            }
//            //2个以上字符的处理
//            NSRange pointRange = [x rangeOfString:@"."];
//            NSRange pointsRange = [x rangeOfString:@".."];
//            if (pointsRange.length>0) {
//                //含有2个小数点
//                textfield.text=[x substringToIndex:x.length-1];
//            }
//            else if (pointRange.length>0){
//                //含有1个小数点时,并且已经输入了数字,则不能再次输入小数点
//                if ((pointRange.location!=x.length-1) && ([[x substringFromIndex:x.length-1]isEqualToString:@"."])) {
//                    textfield.text=[x substringToIndex:x.length-1];
//                }
//                if (pointRange.location+maxFloatLength<x.length) {
//                    //输入位数超出精确度限制,进行截取
//                    textfield.text=[x substringToIndex:pointRange.location+maxFloatLength+1];
//                }
//            }
//            else{
//                if (x.length>maxIntegerLength) {
//                    textfield.text=[x substringToIndex:maxIntegerLength];
//                }
//            }
//        }
//    }];
//}
//
//+ (void)checkPhoneInputLength:(UITextField *)textfield{
//    [textfield.rac_textSignal subscribeNext:^(NSString *x) {
//        
//        if(x.length>11){
//            textfield.text = [x substringToIndex:11];
//        }
//    }];
//}
//
//+ (void)checkInputLength:(UITextField *)textfield andMaxLength:(int)max{
//    [textfield.rac_textSignal subscribeNext:^(NSString *x) {
//        
//        if(x.length>max){
//            textfield.text = [x substringToIndex:max];
//        }
//    }];
//}

+ (BOOL)urlValidation:(NSDictionary *)param{
    
    if([[param allKeys] containsObject:@"url"]){
        NSString *string = param[@"url"];
        NSError *error;
        // 正则1
        NSString *regulaStr =@"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
        // 正则2
        regulaStr =@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                              options:NSRegularExpressionCaseInsensitive
                                                                                error:&error];
        NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
        for (NSTextCheckingResult *match in arrayOfAllMatches){
            NSString* substringForMatch = [string substringWithRange:match.range];
            NSLog(@"匹配:%@", substringForMatch);
            return YES;
        }
        return NO;
    }
    return NO;
}
@end
