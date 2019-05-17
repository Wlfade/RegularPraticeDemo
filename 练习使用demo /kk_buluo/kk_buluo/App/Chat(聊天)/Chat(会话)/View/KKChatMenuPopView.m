//
//  KKChatMenuPopView.m
//  kk_buluo
//
//  Created by david on 2019/4/26.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKChatMenuPopView.h"

@interface KKChatMenuPopView ()
@property (copy, nonatomic) void (^selectedBlock)(KKChatMenuModel *selectedMenuModel);
@end

@implementation KKChatMenuPopView
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer)] ;
        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - UI

-(void)showPopViewWithMenus:(NSArray<KKChatMenuModel *> *)menus atPoint:(CGPoint)anchorPoint selectedBlock:(void (^)(KKChatMenuModel *))selectedBlock {
    
    //1.添加self
    self.selectedBlock = selectedBlock;
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    //2.subview
    [self setupUI:menus atPoint:anchorPoint];
}

-(void)setupUI:(NSArray<KKChatMenuModel *> *)menus atPoint:(CGPoint)anchorPoint {
    
    CGFloat itemH = 45;
    CGFloat addH = 10;
    CGFloat popViewW = 88;
    CGFloat popViewH = addH + itemH * menus.count;
    
    //0.popV
    UIView *popV = [[UIView alloc]initWithFrame:CGRectMake(anchorPoint.x-popViewW/2.0, anchorPoint.y-popViewH, popViewW, popViewH)];
    [self addSubview:popV];
    
    //1.bg
    UIImageView *bgImgV = [[UIImageView alloc]initWithFrame:popV.bounds];
    bgImgV.image = Img(@"chat_menu_popBg");
    [popV addSubview:bgImgV];
    
    //2.items
    CGFloat leftSpace = 3;
    CGFloat itemW = popViewW - 2*leftSpace;
    CGFloat grayLineH = 1;
    
    for (NSInteger i=0; i<menus.count; i++) {
        KKChatMenuModel *menuModel = menus[i];
        NSString *title = menuModel.name;
        //btn
        DGButton *itemBtn = [DGButton btnWithFontSize:14 title:title titleColor:rgba(64, 64, 64, 1)];
        itemBtn.frame = CGRectMake(leftSpace, i*itemH, itemW, itemH);
        [popV addSubview:itemBtn];
        
        WS(weakSelf);
        [itemBtn addClickBlock:^(DGButton *btn) {
            weakSelf.selectedBlock(menuModel);
            [weakSelf hideSelf];
        }];
        
        //grayLine
        if (i+1 < menus.count) {
            UIView *grayLine = [[UIView alloc]initWithFrame:CGRectMake(0, itemH-grayLineH, itemW, grayLineH)];
            grayLine.backgroundColor = rgba(240, 240, 240, 1);
            [itemBtn addSubview:grayLine];
        }
    }
    
}

#pragma mark - interaction

-(void)tapGestureRecognizer {
    [self hideSelf];
}

-(void)hideSelf {
    [self removeFromSuperview];
}

@end
