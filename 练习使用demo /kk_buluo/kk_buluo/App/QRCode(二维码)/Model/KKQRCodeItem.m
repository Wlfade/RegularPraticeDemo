//
//  KKQRCodeItem.m
//  kk_buluo
//
//  Created by 单车 on 2019/4/25.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKQRCodeItem.h"
#import "KKMutableAttributedStringTool.h"

@implementation KKQRCodeItem
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"qrCode":@"qrCode.qrCode",
             @"qrCodeExpireDays":@"qrCode.expireDays",
             @"qrCodeExpireTime":@"qrCode.expireTime"
             };
}
//赋值完成后调用
-(void)mj_keyValuesDidFinishConvertingToObject{
    if ([_sex isEqualToString:@"M"]) {
        _sexPlaceHold = [UIImage imageNamed:@"login_male_normal"];
    }else if ([_sex isEqualToString:@"F"]){
        _sexPlaceHold = [UIImage imageNamed:@"login_famale_normal"];
    }
    
    NSData *decodedImgData = [[NSData alloc] initWithBase64EncodedString:_qrCode options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    /// 把data数据转换成图片内容
    _qrCodeImage = [UIImage imageWithData:decodedImgData];
    
    if ([_QRcodeType isEqualToString:@"USER"]) {
        _userNameAtt = [self makeUserName:_userName withGeneral:_sex withLocation:_profile];
        
        _titleA = [KKMutableAttributedStringTool makeTheStrings:@[@"扫描二维码，查看个人主页"] withColors:@[RGB(153, 153, 153)] withFonts:@[[UIFont boldSystemFontOfSize:16]]];
    }else if([_QRcodeType isEqualToString:@"GROUP"]){
        _userNameAtt = [self makeGroupName:_groupName];
        
        NSString *describeStr = [NSString stringWithFormat:@"该二维码%@天内(%@前)有效",_qrCodeExpireDays,_qrCodeExpireTime];
        _titleA = [KKMutableAttributedStringTool makeTheStrings:@[@"扫描二维码，查看群主页\n",describeStr] withColors:@[RGB(153, 153, 153),RGB(153, 153, 153)] withFonts:@[[UIFont boldSystemFontOfSize:16],[UIFont boldSystemFontOfSize:13]]];
    }else if([_QRcodeType isEqualToString:@"GUILD"]){
        _userNameAtt = [self makeGroupName:_guildName];
        _titleA = [KKMutableAttributedStringTool makeTheStrings:@[@"扫描二维码，查看公会号主页"] withColors:@[RGB(153, 153, 153)] withFonts:@[[UIFont boldSystemFontOfSize:16]]];
    }
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineSpacing=4;
    //    paragraphStyle.maximumLineHeight = 30.0f;
    paragraphStyle.maximumLineHeight = 18.0f;
    
    [_titleA addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,_titleA.length)];
    [_titleA addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleNone] range:NSMakeRange(0,_titleA.length)];
    
}
- (NSMutableAttributedString *)makeGroupName:(NSString *)groupName{
//    NSMutableAttributedString *attrStr01 = [[KKMutableAttributedStringTool makeTheStrings:@[groupName]] withColors:@[RGB(51, 51, 51)] withFonts:@[[UIFont boldSystemFontOfSize:16]]];
    NSMutableAttributedString *attrStr01 = [KKMutableAttributedStringTool makeTheStrings:@[groupName] withColors:@[RGB(51, 51, 51)] withFonts:@[[UIFont boldSystemFontOfSize:16]]];
    return attrStr01;
}
//用户类型的显示字符创建
- (NSMutableAttributedString *)makeUserName:(NSString *)userName withGeneral:(NSString *)general withLocation:(NSString *)location{
    
    NSMutableAttributedString *attrStr01 = [KKMutableAttributedStringTool makeTheStrings:@[[NSString stringWithFormat:@"%@\n",userName?userName:@""],location?location:@"未知"] withColors:@[RGB(51, 51, 51),RGB(153, 153, 153)] withFonts:@[[UIFont boldSystemFontOfSize:16],[UIFont systemFontOfSize:13]]];
    NSString *genranlImageName;
    if ([general isEqualToString:@"M"]) {
        genranlImageName = @"male_icon";
    }else if ([general isEqualToString:@"F"]){
        genranlImageName = @"famale_icon";
    }
    
    NSAttributedString *imageAttStr = [KKMutableAttributedStringTool makeTextAttachmentWithImagName:genranlImageName withImageSize:CGSizeMake(14, 14)];
    
    [attrStr01 insertAttributedString:imageAttStr atIndex:userName.length];
    
    
    //设置段落风格
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    //字体行间距
    [paragraphStyle setLineSpacing:5];
    //加入属性
    [attrStr01 addAttribute:NSParagraphStyleAttributeName
     
                value:paragraphStyle
     
                range:NSMakeRange(0, attrStr01.length)];
    return attrStr01;
}
+ (instancetype)QRCodeWithDictionary:(NSDictionary *)dictionary withTypeStr:(NSString *)typeStr{
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    [mutDic setValue:typeStr forKey:@"QRcodeType"];
    KKQRCodeItem *item = [KKQRCodeItem mj_objectWithKeyValues:mutDic];
    return item;
}
@end
