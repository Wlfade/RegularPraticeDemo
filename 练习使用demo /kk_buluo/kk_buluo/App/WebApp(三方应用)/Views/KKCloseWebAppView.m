//
//  KKCloseWebAppView.m
//  kk_buluo
//
//  Created by 景天 on 2019/4/23.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKCloseWebAppView.h"

@implementation KKCloseWebAppView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 89, 35)];
        bgView.userInteractionEnabled = YES;
        bgView.image = [UIImage imageNamed:@"webAppCloseBg"];
        [self addSubview:bgView];
        
        UIButton *operation = [UIButton buttonWithType:UIButtonTypeCustom];
        operation.frame = CGRectMake(9, 5, 31, 25);
        [operation setImage:[UIImage imageNamed:@"webAppOperation"] forState:UIControlStateNormal];
        [bgView addSubview:operation];
        [operation addTarget:self action:@selector(operationAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
        close.frame = CGRectMake(operation.right + 16, 7, 20, 20);
        [close setImage:[UIImage imageNamed:@"webAppClose"] forState:UIControlStateNormal];
        [bgView addSubview:close];
        [close addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}

- (void)operationAction {
    if (self.webAppOperationBlock) {
        self.webAppOperationBlock();
    }
}

- (void)closeAction {
    if (self.webAppCloseBlock) {
        self.webAppCloseBlock();
    }
}
@end
