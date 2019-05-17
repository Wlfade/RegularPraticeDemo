//
//  KKAboutWebAppFooterView.m
//  kk_buluo
//
//  Created by 景天 on 2019/4/22.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKAboutWebAppFooterView.h"

@interface KKAboutWebAppFooterView()
@property (nonatomic, strong) UIButton *operationButton;
@end

@implementation KKAboutWebAppFooterView

- (UIButton *)operationButton {
    if (!_operationButton) {
        _operationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _operationButton.backgroundColor = [UIColor whiteColor];
        _operationButton.clipsToBounds = YES;
        _operationButton.layer.cornerRadius = 2.5;
        [_operationButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _operationButton.backgroundColor = RGB(43, 63, 255);
        [_operationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_operationButton setTitle:@"进入应用" forState:UIControlStateNormal];
        _operationButton.frame = CGRectMake([ccui getRH:45], [ccui getRH:22], SCREEN_WIDTH - [ccui getRH:90], [ccui getRH:40]);
        [_operationButton addTarget:self action:@selector(operationButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _operationButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.operationButton];
    }
    return self;
}

- (void)operationButtonAction {
    if (self.toOpenWebAppBlock) {
        self.toOpenWebAppBlock();
    }
}

@end
