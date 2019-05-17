//
//  KKChatSearchHistoryMsgVC.m
//  kk_buluo
//
//  Created by david on 2019/3/24.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKChatSearchHistoryMsgVC.h"
#import "KKChatVC.h"
//view
#import "KKChatSearchBar.h"
#import "KKChatListSearchTableViewCell.h"
//融云
#import <RongIMKit/RongIMKit.h>

#define kHistoryMsgCell @"KKChatListSearchTableViewCell"

@interface KKChatSearchHistoryMsgVC ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
//searchView
@property (nonatomic, strong) KKChatSearchBar *searchBar;
//tableView
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) DGLabel *emptyLabel;

@property (nonatomic, strong) NSArray <RCMessage *>*resultArray;
@property (nonatomic, assign) BOOL isLoading;
@end

@implementation KKChatSearchHistoryMsgVC

#pragma mark - lazy load

- (DGLabel *)emptyLabel {
    if (!_emptyLabel) {
        _emptyLabel = [[DGLabel alloc] initWithFrame:CGRectMake(10, 45, self.view.frame.size.width - 20, 16)];
        _emptyLabel.font = [UIFont systemFontOfSize:14.f];
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
        _emptyLabel.numberOfLines = 0;
        [self.tableView addSubview:_emptyLabel];
    }
    return _emptyLabel;
}

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_BG;
    
    self.isLoading = NO;
    [self setupNavi];
    [self setupUI];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
}


#pragma mark - UI
-(void)setupNavi {

    
    //1.searchV
    UIView *searchV = [[UIView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, SCREEN_WIDTH, NAV_BAR_HEIGHT)];
    
    //2.searchBar
    KKChatSearchBar *searchBar = [[KKChatSearchBar alloc] initWithFrame:CGRectMake(0, 0, searchV.frame.size.width - 65, NAV_BAR_HEIGHT) hasBorder:NO];
    [searchV addSubview:searchBar];
    self.searchBar = searchBar;
    searchBar.delegate = self;
    searchBar.tintColor = [UIColor blueColor];
    [searchBar becomeFirstResponder];
    
    //3.cancelBtn
    DGButton *cancelBtn = [DGButton btnWithFontSize:[ccui getRH:18] title:@"取消" titleColor:COLOR_BLACK_TEXT];
    cancelBtn.frame = CGRectMake(CGRectGetMaxX(searchBar.frame)-3, CGRectGetMinY(searchBar.frame), 55, NAV_BAR_HEIGHT);
    WS(weakSelf);
    [cancelBtn addClickBlock:^(DGButton *btn) {
        [weakSelf clickCancelButton];
    }];
    [searchV addSubview:cancelBtn];
    
    //4.设置navi
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self hideBackButton:YES];
    [self.naviBar addSubview:searchV];
    
}


-(void)setupUI {
    
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_AND_NAV_BAR_HEIGHT) style:UITableViewStylePlain];
    self.tableView = tableV;
    tableV.backgroundColor = [UIColor clearColor];
    tableV.delegate = self;
    tableV.dataSource = self;
    [tableV setSeparatorColor:COLOR_HEX(0xdfdfdf)];
    [self.view addSubview:tableV];
    //cell
    [tableV registerClass:[KKChatListSearchTableViewCell class] forCellReuseIdentifier:kHistoryMsgCell];
    
    //fotter
    tableV.tableFooterView = [UIView new];
}

#pragma mark - interaction
- (void)clickCancelButton {
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - delegate

#pragma mark tableViewDelegate
#pragma mark  UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSInteger row = indexPath.row;
    
    //1.获取cell
    KKChatListSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHistoryMsgCell forIndexPath:indexPath];
    
    //2.设置cell
    RCMessage *msg = self.resultArray[row];
    NSString *keywords = self.searchBar.text;
    
    [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:msg.senderUserId completion:^(RCUserInfo *userInfo) {
        
        [cell.headIconImageView sd_setImageWithURL:Url(userInfo.portraitUri)];
        cell.nameLabel.text = userInfo.name;
        NSString *fullStr = [msg.content conversationDigest];
        
        NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc]initWithString:fullStr];
        if (keywords.length > 0) {
            NSRange range = [fullStr rangeOfString:keywords];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    //2.搜索消息
    RCMessage *msg = self.resultArray[indexPath.row];
    [self pushToChatVC:msg];
}


#pragma mark - search


- (void)searchMoreMessage {
    RCMessage *msgModel = self.resultArray[self.resultArray.count - 1];
    NSArray *array = [[RCIMClient sharedRCIMClient] searchMessages:self.conversationType
                                                          targetId:self.targetId
                                                           keyword:self.searchBar.text
                                                             count:50
                                                         startTime:msgModel.sentTime];
    if (array.count < 50) {
        self.isLoading = NO;
    } else {
        self.isLoading = YES;
    }
    
    NSMutableArray *resultArray = self.resultArray.mutableCopy;
    for (RCMessage *message in array) {
        [resultArray addObject:message];
    }
    self.resultArray = resultArray;
    [self refreshSearchView:nil];
}


#pragma mark delegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.resultArray = nil;
    NSArray *array = [[RCIMClient sharedRCIMClient] searchMessages:self.conversationType
                                                          targetId:self.targetId
                                                           keyword:searchText
                                                             count:50
                                                         startTime:0];
    self.resultArray = array;
    [self refreshSearchView:searchText];
    if (self.resultArray.count < 50) {
        self.isLoading = NO;
    } else {
        self.isLoading = YES;
    }
    
    //2.reload
    [self.tableView reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark scrollDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y < self.tableView.contentSize.height && self.isLoading) {
        [self searchMoreMessage];
    }
}

#pragma mark ui
- (void)refreshSearchView:(NSString *)searchText {
    [self.tableView reloadData];
    NSString *searchStr = [searchText stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (!self.resultArray.count && searchText.length > 0 && searchStr.length > 0) {
        NSString *str = [NSString stringWithFormat:@"没有搜索到“%@”相关的内容", searchText];
        self.emptyLabel.textColor = COLOR_GRAY_TEXT;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:COLOR_HEX(0x0099ff)
                                 range:NSMakeRange(6, searchText.length)];
        self.emptyLabel.attributedText = attributedString;
        CGFloat height = [self labelAdaptive:str];
        CGRect rect = self.emptyLabel.frame;
        rect.size.height = height;
        self.emptyLabel.frame = rect;
        self.emptyLabel.hidden = NO;
    } else {
        self.emptyLabel.hidden = YES;
    }
}

- (CGFloat)labelAdaptive:(NSString *)string {
    float maxWidth = self.view.frame.size.width - 20;
    CGRect textRect =
    [string boundingRectWithSize:CGSizeMake(maxWidth, 8000)
                         options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin |
                                  NSStringDrawingUsesFontLeading)
                      attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]}
                         context:nil];
    textRect.size.height = ceilf(textRect.size.height);
    return textRect.size.height + 5;
}


#pragma mark - jump

-(void)pushToChatVC:(RCMessage *)msg {
    KKChatVC *chatVC = [[KKChatVC alloc]initWithConversationType:msg.conversationType targetId:msg.targetId];
    chatVC.locatedMessageSentTime = msg.sentTime;
    [self.navigationController pushViewController:chatVC animated:YES];
}


@end
