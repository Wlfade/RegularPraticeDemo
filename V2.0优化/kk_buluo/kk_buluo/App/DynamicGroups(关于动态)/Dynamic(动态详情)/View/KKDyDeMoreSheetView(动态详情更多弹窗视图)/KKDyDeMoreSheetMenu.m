//
//  KKDyDeMoreSheetMenu.m
//  BananaBall
//
//  Created by 单车 on 2018/2/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "KKDyDeMoreSheetMenu.h"
#import "MenuItem.h"
#import "ItemButton.h"

#import "KKDyDetailWholeItem.h"
#import "KKReportActionSheet.h"

#import "KKPersonalPageController.h" //个人主页

#import "KKMyFriendViewController.h" //好友列表

#import "KKChatVC.h"

#define menuHeight 268
#define titleViewHeight 40
#define menuViewHeight 90
#define cancelViewHeight 48

@interface KKDyDeMoreSheetMenu()
/** 存放按钮的数组 */
@property (nonatomic,strong)NSMutableArray *itemBtnsArr;

@property (nonatomic,strong)NSArray *topItems;

@property (nonatomic,strong)NSArray *bottomItems;

@property (nonatomic,weak)UIView *menu; //菜单视图

@property (nonatomic,weak)UIView *backGroundView;

@property (nonatomic,strong)UIView *superView;

@property (nonatomic,strong)UIViewController *viewController;

@property (nonatomic,strong)KKDyDetailWholeItem *dydeItem;

@end

@implementation KKDyDeMoreSheetMenu

-(NSArray *)topItems{
    if (!_topItems) {
        MenuItem *menu1 = [MenuItem itemWithTitle:@"发送给朋友" withImage:[UIImage imageNamed:@"dyde_more_shareFriend_icon"]];
        
        
        MenuItem *menu2 = [MenuItem itemWithTitle:@"转发到广场" withImage:[UIImage imageNamed:@"dyde_more_shareSquare_icon"]];

        NSArray *array = @[menu1,menu2];
        
        _topItems = array;
    }
    return _topItems;
}
- (NSArray *)bottomItems{
    if (!_bottomItems) {
        MenuItem *menu1 = [MenuItem itemWithTitle:@"查看ta" withImage:[UIImage imageNamed:@"dyde_more_check_icon"]];
        menu1.cleckBlock = ^{
            KKPersonalPageController *personalPageVC = [[KKPersonalPageController alloc]init];
            
            if ([self.dydeItem.dynamicHeadItem.commonObjectTypeName isEqualToString:@"USER"]) {
                personalPageVC.personalPageType = PERSONAL_PAGE_OTHER;
                
            }else if([self.dydeItem.dynamicHeadItem.commonObjectTypeName isEqualToString:@"GUILD_INDEX"]){
                personalPageVC.personalPageType = PERSONAL_PAGE_GUILD;
                
            }
            
        personalPageVC.userId = self.dydeItem.dynamicHeadItem.userId;
            [self.viewController.navigationController pushViewController:personalPageVC animated:YES];
        };
        
        MenuItem *menu2 = [MenuItem itemWithTitle:@"收藏" withImage:[UIImage imageNamed:@"dy_more_uncollect_icon"]withSelectedImage:[UIImage imageNamed:@"dy_more_collected_icon"]];
        menu2.isSelected = self.dydeItem.dynamicOperationItem.collected;
        if (menu2.isSelected == YES) {
            menu2.title = @"取消收藏";
        }
        
        
        
        MenuItem *menu3 = [MenuItem itemWithTitle:@"举报" withImage:[UIImage imageNamed:@"dy_more_report_icon"]];
        
        menu3.cleckBlock = ^{
            [KKReportActionSheet KKReportActionSheetPersent:self.viewController animated:YES completion:nil];
        };
        
        NSArray *array = @[menu1,menu2,menu3];
        
        _bottomItems = array;
    }
    return _bottomItems;
}
+ (instancetype)showInView:(UIView *)supView withViewController:(UIViewController *)viewController withDyDetailWholeItem:(KKDyDetailWholeItem *)dydeItem{
    KKDyDeMoreSheetMenu *menu = [[KKDyDeMoreSheetMenu alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    menu.superView = supView;
    
    if (viewController == nil) {
        menu.viewController = supView.viewController;
    }else{
        menu.viewController = viewController;
    }
    menu.dydeItem = dydeItem;
    
    [menu creatSubView];
    
    [supView addSubview:menu];

    return menu;
}


- (void)creatSubView{

    UIView *backGroundView = [[UIView alloc]initWithFrame:self.bounds];
    backGroundView.backgroundColor = [UIColor blackColor];
    backGroundView.userInteractionEnabled = YES;
    backGroundView.alpha = 0.5;
    self.backGroundView = backGroundView;
    [self insertSubview:backGroundView atIndex:0];

    UIView *menu = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - menuHeight, SCREEN_WIDTH, menuHeight)];
    menu.userInteractionEnabled = YES;
    menu.backgroundColor = RGB(230, 230, 230);

    [self setUpTitleView:menu];
    
    [self setUpTopItemBtn:menu];
    [self setUpBottomItemBtn:menu];
    
    [self setUpCancleBtn:menu];
    
    self.menu = menu;

    UIView *blackView = [[UIView alloc]initWithFrame:menu.frame];
    blackView.backgroundColor = RGB(242, 242, 242);
    [self addSubview:blackView];

    menu.transform = CGAffineTransformMakeTranslation(0, menu.height);

    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        menu.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [blackView removeFromSuperview];
    }];

    [self addSubview:menu];

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self cancelAction];
}

/**
 创建标题
 */
- (void)setUpTitleView:(UIView *)menu{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, menu.width, titleViewHeight)];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.text = @"分享";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = COLOR_GRAY_TEXT;
    [menu addSubview:titleLabel];
}
/**
 上部分按钮视图
 */
- (void)setUpTopItemBtn:(UIView *)menu{
//    CGFloat h = menuHeight - 48 - 10; //按钮的宽高
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, titleViewHeight, menu.width, menuViewHeight)];
    topView.backgroundColor = [UIColor whiteColor];
    [menu addSubview:topView];
    
    CGFloat h = 70; //按钮的宽高
    CGFloat w = 0.7*h;
//    CGFloat gap = 25;
    CGFloat gap = (SCREEN_WIDTH - 5*w)/4;
    CGFloat margin = 20;
    CGFloat x = 0;
    CGFloat y = 10;

    for (int i = 0; i < self.topItems.count; i++) {
        x = margin + (w+gap) * i;
        ItemButton *itemBtn = [ItemButton buttonWithType:UIButtonTypeCustom];
        itemBtn.frame = CGRectMake(x, y, w , h);
        itemBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        itemBtn.titleLabel.adjustsFontSizeToFitWidth = YES;

        [itemBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

        [itemBtn addTarget:self action:@selector(topClickAction:) forControlEvents:UIControlEventTouchUpInside];
        MenuItem *item = _topItems[i];
        itemBtn.tag = 10+i;
        [itemBtn setImage:item.image forState:UIControlStateNormal];
        [itemBtn setTitle:item.title forState:UIControlStateNormal];

        [self.itemBtnsArr addObject:itemBtn];
        
        [topView addSubview:itemBtn];
    }
}
/**
 下部分按钮视图
 */
- (void)setUpBottomItemBtn:(UIView *)menu{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, titleViewHeight + menuViewHeight, menu.width, menuViewHeight)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [menu addSubview:bottomView];
    
    CGFloat h = 70; //按钮的宽高
    CGFloat w = 0.7*h;
    //    CGFloat gap = 25;
    CGFloat gap = (SCREEN_WIDTH - 5*w)/4;
    CGFloat margin = 20;
    CGFloat x = 0;
    CGFloat y = 10;
    
    for (int i = 0; i < self.bottomItems.count; i++) {
        x = margin + (w+gap) * i;
        ItemButton *itemBtn = [ItemButton buttonWithType:UIButtonTypeCustom];
        itemBtn.frame = CGRectMake(x, y, w , h);
        itemBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        itemBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        [itemBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        [itemBtn addTarget:self action:@selector(bottomClickAction:) forControlEvents:UIControlEventTouchUpInside];
        MenuItem *item = _bottomItems[i];
        itemBtn.tag = 20+i;
        [itemBtn setImage:item.image forState:UIControlStateNormal];
        [itemBtn setTitle:item.title forState:UIControlStateNormal];
        
        if (item.selectedImage) {
            [itemBtn setImage:item.selectedImage forState:UIControlStateSelected];
            itemBtn.selected = item.isSelected;
        }
        
        [self.itemBtnsArr addObject:itemBtn];
        
        [bottomView addSubview:itemBtn];
    }
}
- (void)topClickAction:(ItemButton*)sender{

    NSInteger index = sender.tag - 10;
    
    MenuItem *item = self.topItems[index];
    if ([self.delegate respondsToSelector:@selector(shareMenuDidSelect:withMenuItem:)]) {
        [self.delegate shareMenuDidSelect:self withMenuItem:item];
    }
    
}
- (void)bottomClickAction:(ItemButton*)sender{
    
    NSInteger index = sender.tag - 20;
    
    MenuItem *item = self.bottomItems[index];

    if ([self.delegate respondsToSelector:@selector(shareMenuDidSelect:withMenuItem:)]) {
        [self.delegate shareMenuDidSelect:self withMenuItem:item];
    }

}
- (void)setUpCancleBtn:(UIView *)menu{
    UIView *cancelView = [[UIView alloc]initWithFrame:CGRectMake(0, menuHeight - 48, self.width, 48)];
    cancelView.backgroundColor = [UIColor whiteColor];
    [menu addSubview:cancelView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, menu.width - 20, 1)];
    lineView.backgroundColor = rgba(240, 240, 240, 1);
    [cancelView addSubview:lineView];
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.backgroundColor = [UIColor whiteColor];
    cancleBtn.frame = CGRectMake(0, 1, self.width, 47);
    [cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelView addSubview:cancleBtn];
}
- (void)cancelAction{
    if ([self.delegate respondsToSelector:@selector(shareMenuDidClickCloseBtn:)]) {
        [self.delegate shareMenuDidClickCloseBtn:self];
    }
}
//+ (void)hide:(void(^)(void))completion{
//    for (KKDyDeMoreSheetMenu *childView in [AppDelegate sharedAppDelegate].window.subviews) {
//        if ([childView isKindOfClass:[self class]]) {
////            [self removeFromSuperview];
//            [childView setUpHiddentAnimation:^{
//                if (completion) {
//                    completion();
//                }
//            }];
//        }
//    }
//}

+ (void)hideWithViewController:(UIViewController *)controller withCompletion:(void(^)(void))completion{
    for (KKDyDeMoreSheetMenu *childView in controller.view.subviews) {
        if ([childView isKindOfClass:[self class]]) {
            //            [self removeFromSuperview];
            [childView setUpHiddentAnimation:^{
                if (completion) {
                    completion();
                }
            }];
        }
    }
}

- (void)setUpHiddentAnimation:(void(^)(void))completion{
//    [self removeFromSuperview];

    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        self.transform = CGAffineTransformMakeTranslation(0, self.height);
        self.menu.transform = CGAffineTransformMakeTranslation(0, self.menu.height);
        [self.backGroundView removeFromSuperview];
        self.backGroundView = nil;
    } completion:^(BOOL finished) {
//        [blackView removeFromSuperview];
        [self removeFromSuperview];
    }];
    if (completion) {
        completion();
    }
}

@end
