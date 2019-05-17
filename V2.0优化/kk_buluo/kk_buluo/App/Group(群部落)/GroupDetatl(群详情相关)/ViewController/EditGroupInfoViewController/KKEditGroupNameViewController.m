//
//  KKEditGroupNameViewController.m
//  kk_buluo
//
//  Created by new on 2019/3/21.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKEditGroupNameViewController.h"

@interface KKEditGroupNameViewController ()
@property (nonatomic, strong) UITextField *groupTF;
@property (nonatomic, strong) DGButton *createButton;
@end

@implementation KKEditGroupNameViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"修改群名"];
    /// 创建
    _createButton = [DGButton btnWithFontSize:[ccui getRH:14] title:@"完成" titleColor:[UIColor whiteColor] bgColor:[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0]];
    _createButton.frame = CGRectMake(SCREEN_WIDTH - 60, STATUS_BAR_HEIGHT + 10, [ccui getRH:40], [ccui getRH:20]);
    _createButton.layer.borderWidth = 0.5;
    _createButton.layer.borderColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0].CGColor;
    [_createButton addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [_createButton setTitleColor:[UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.naviBar addSubview:_createButton];
    
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, [ccui getRH:8] + STATUS_AND_NAV_BAR_HEIGHT, SCREEN_WIDTH, [ccui getRH:60])];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    _groupTF = [[UITextField alloc] initWithFrame:CGRectMake([ccui getRH:20], [ccui getRH:5], SCREEN_WIDTH - [ccui getRH:40], [ccui getRH:50])];
    _groupTF.text = self.myGroup.groupName;
    [_groupTF addTarget:self action:@selector(textChanging:) forControlEvents:UIControlEventEditingChanged];
    [whiteView addSubview:_groupTF];
    
    

}
- (void)textChanging:(UITextField *)tf {
    if (tf.text.length == 0) {
        _createButton.backgroundColor = RGB(244, 244, 244);
        [_createButton setTitleColor:RGB(206, 206, 206) forState:UIControlStateNormal];
    }else{
        _createButton.backgroundColor = RGB(42, 62, 255);
        [_createButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (void)sureAction {
    
    [self reqeustEditGroupNameData];
}

- (void)reqeustEditGroupNameData {
    
    WS(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"GROUP_CHAT_BASE_MODIFY" forKey:@"service"];
    [params setValue:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
    [params setValue:self.myGroup.groupId forKey:@"groupId"];
    [params setValue:self.groupTF.text forKey:@"groupName"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        
        if (str) {
            
            [CC_NoticeView showError:str];
            
        }else {
            
            [[KKRCloudMgr shareInstance] updateGroupInfo:weakSelf.myGroup.groupId];
            [[NSNotificationCenter defaultCenter] postNotificationName:RELOAD_GROUP_NOTICE object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end
