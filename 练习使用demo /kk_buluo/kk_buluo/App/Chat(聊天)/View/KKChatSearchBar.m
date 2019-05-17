//
//  KKChatSearchBar.m
//  kk_buluo
//
//  Created by david on 2019/3/22.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKChatSearchBar.h"

@implementation KKChatSearchBar

-(instancetype)initWithFrame:(CGRect)frame hasBorder:(BOOL)hasBorder {
    self = [super initWithFrame:frame];
    if (self) {
        self.placeholder = @" 搜索";
        self.keyboardType = UIKeyboardTypeDefault;
        self.searchBarStyle = UISearchBarStyleMinimal;
        //设置顶部搜索栏的背景色
        [self setBackgroundColor:UIColor.clearColor];
        //设置顶部搜索栏输入框的样式
        UITextField *searchField = [self valueForKey:@"searchField"];
        searchField.borderStyle = UITextBorderStyleNone;
        searchField.font = Font([ccui getRH:16]);
        searchField.layer.cornerRadius = 1.f;
        searchField.layer.masksToBounds = YES;
        if (hasBorder) {
            searchField.layer.borderWidth = 0.5f;
            searchField.layer.borderColor = [COLOR_HEX(0xdfdfdf) CGColor];
            searchField.backgroundColor = UIColor.whiteColor;
        }else{
            searchField.backgroundColor = rgba(244, 244, 244, 1);
        }

    }
    return self;
}

@end
