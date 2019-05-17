//
//  KKChatSearchMoreVC.m
//  kk_buluo
//
//  Created by david on 2019/3/24.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKChatSearchMoreVC.h"
#import "KKChatVC.h"

//view
#import "KKChatListSearchTableViewCell.h"

#define kChatSearchMatchMsgCell  @"ChatSearchMatchMsgCell"

@interface KKChatSearchMoreVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation KKChatSearchMoreVC

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavi];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - UI
-(void)setupNavi {
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:self.naviTitleStr];
}

-(void)setupUI {
    
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT, self.view.width, SCREEN_HEIGHT-STATUS_AND_NAV_BAR_HEIGHT) style:UITableViewStylePlain];
    self.tableView = tableV;
    tableV.backgroundColor = [UIColor clearColor];
    tableV.delegate = self;
    tableV.dataSource = self;
    [tableV setSeparatorColor:COLOR_HEX(0xdfdfdf)];
    [self.view addSubview:tableV];
    //cell
    [tableV registerClass:[KKChatListSearchTableViewCell class] forCellReuseIdentifier:kChatSearchMatchMsgCell];
    
    //fotter
    tableV.tableFooterView = [UIView new];
}


#pragma mark tool
-(UIView *)createSeactionHeaderView:(NSString *)text {
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = UIColor.whiteColor;
    //1.label
    DGLabel *label = [DGLabel labelWithText:text fontSize:[ccui getRH:13] color:COLOR_GRAY_TEXT];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([ccui getRH:10]);
        make.centerY.mas_equalTo(0);
    }];
    //2.grayLine
    UIView *grayLine = [[UIView alloc]init];
    grayLine.backgroundColor = COLOR_BG;
    [view addSubview:grayLine];
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([ccui getRH:10]);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1.5);
    }];
    return view;
}

#pragma mark - delegate

#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.msgArr.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [self createSeactionHeaderView:[NSString stringWithFormat:@"共%ld条相关的聊天记录",self.msgArr.count]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSInteger row = indexPath.row;
    
    //1.获取cell
    KKChatListSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kChatSearchMatchMsgCell forIndexPath:indexPath];
    
    //2.设置cell
    WS(weakSelf);
    RCMessage *msg = self.msgArr[row];
    
    [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:msg.senderUserId completion:^(RCUserInfo *userInfo) {
        
        [cell.headIconImageView sd_setImageWithURL:Url(userInfo.portraitUri)];
        cell.nameLabel.text = userInfo.name;
        NSString *fullStr = [msg.content conversationDigest];
        
        NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc]initWithString:fullStr];
        if (weakSelf.keywords.length > 0) {
            NSRange range = [fullStr rangeOfString:weakSelf.keywords];
            [aStr addAttributes:@{NSForegroundColorAttributeName : UIColor.redColor} range:range];
        }
        cell.msgLabel.attributedText = aStr;
    }];
    
    //3.return
    return cell;
}



#pragma mark  UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSInteger row = indexPath.row;
    RCMessage *msg = self.msgArr[row];
    [self pushToChatVC:msg];
}

#pragma mark - jump
-(void)pushToChatVC:(RCMessage *)msg {
    KKChatVC *chatVC = [[KKChatVC alloc]initWithConversationType:msg.conversationType targetId:msg.targetId];
    chatVC.locatedMessageSentTime = msg.sentTime;
    [self.navigationController pushViewController:chatVC animated:YES];
}

@end
