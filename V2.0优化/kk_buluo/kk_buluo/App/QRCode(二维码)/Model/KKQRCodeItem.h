//
//  KKQRCodeItem.h
//  kk_buluo
//
//  Created by 单车 on 2019/4/25.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKQRCodeItem : NSObject

//@property (nonatomic, strong) NSAttributedString *titleA;
@property (nonatomic, strong) NSMutableAttributedString *titleA;

/** 二维码类型 */
@property (nonatomic, strong) NSString *QRcodeType;
/** 用户二维码 */
@property (nonatomic, strong) NSString *qrCode;

/** 用户二维码多少天内 */
@property (nonatomic, strong) NSString *qrCodeExpireDays;

/** 用户二维码多少天内 */
@property (nonatomic, strong) NSString *qrCodeExpireTime;

/** 二维码图片 */
@property (nonatomic, strong) UIImage *qrCodeImage;
/** 用户头像 */
@property (nonatomic, strong) NSString *logoUrl;

/** 用户名称 */
@property (nonatomic, strong) NSAttributedString *userNameAtt;
/** 用户名称 */
@property (nonatomic, strong) NSString *userName;
/** 用户性别 */
@property (nonatomic, strong) NSString *sex;

/** 用户性别默认占位图片 */
@property (nonatomic, strong) UIImage *sexPlaceHold;

/** 用户所在地 */
@property (nonatomic, strong) NSString *profile;

/** 群名称 */
@property (nonatomic, strong) NSString *groupName;

/** 工会名称 */
@property (nonatomic, strong) NSString *guildName;

+ (instancetype)QRCodeWithDictionary:(NSDictionary *)dictionary withTypeStr:(NSString *)typeStr;
@end

NS_ASSUME_NONNULL_END
