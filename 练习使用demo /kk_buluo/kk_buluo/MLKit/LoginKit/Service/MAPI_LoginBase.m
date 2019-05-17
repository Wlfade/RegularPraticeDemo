//
//  MAPI_LoginBase.m
//  LoginKit
//
//  Created by david on 2019/2/21.
//  Copyright © 2019 david. All rights reserved.
//

#import "MAPI_LoginBase.h"

@implementation MAPI_LoginBase

/** 父类声明,由子类实现 */
-(void)requestAtView:(UIView *)view mask:(BOOL)mask block:(LoginKitBlock)block {
    CCLOG(@"父类声明,该由子类实现");
}

@end
