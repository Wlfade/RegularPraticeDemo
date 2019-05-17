//
//  MiSearchBar.m
//  miSearch
//
//  Created by miicaa_ios on 16/8/3.
//  Copyright (c) 2016年 xuxuezheng. All rights reserved.
//

#import "MiSearchBar.h"

@interface MiSearchBar()<UITextFieldDelegate>{
    
    
}

@property (strong, nonatomic) UILabel *searchLabel;

@end

@implementation MiSearchBar

-(id)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder{
    
    
    self = [super initWithFrame:frame];
    self.tintColor = [UIColor colorWithRed:0.262 green:0.515 blue:1.000 alpha:1.000];
    self.searchBarStyle = UISearchBarStyleMinimal;
    
    self.placeholder = placeholder;
    self.backgroundColor = [UIColor clearColor];
    
    
    self.searchTextField = [self valueForKey:@"searchField"];
    self.searchTextField.keyboardType = UIKeyboardTypeDefault;
    self.searchTextField.layer.cornerRadius = 4.0f;
    self.searchTextField.clipsToBounds = YES;
    self.searchTextField.delegate = self;
    self.searchTextField.font = [UIFont systemFontOfSize:[ccui getRH:16]];
    self.searchTextField.borderStyle = UITextBorderStyleNone;
    self.searchTextField.backgroundColor = RGB(244, 244, 244);

    return self;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [self.searchLabel setHidden:YES];

}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.text.length == 0) {
        
        [self.searchLabel setHidden:NO];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSString *seacrhStr = textField.text;
    
    if ([self.resultStrDelegate respondsToSelector:@selector(searchReturnText:)]) {
        [self.resultStrDelegate searchReturnText:seacrhStr];
    }
    return YES;
}

@end
