//
//  DGTextView.h
//
//
//  Created by David.G on 16/7/20.
//  Copyright © 2016年 david. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^CM_textHeightChangedBlock)(NSString *text,CGFloat textHeight);

@interface DGTextView : UITextView

@property (nonatomic, copy) NSAttributedString *attributedPlaceHolder;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

//textView 的最大高度
@property (nonatomic, assign) NSInteger maxTextH;
//textView 的最小高度
@property (nonatomic, assign) NSInteger minTextH;
//textView 是否需要滚动
@property (nonatomic, assign) BOOL needFrameChange ;

/**
 *  文字高度改变block → 文字高度改变会自动调用
 *  block参数(text) → 文字内容
 *  block参数(textHeight) → 文字高度
 */
@property (nonatomic, copy) CM_textHeightChangedBlock textChangedBlock;

//放出来给外界调用, 因为设置attributeText的富文本,不会触发UITextViewTextDidChangeNotification
-(void)textChanged:(NSNotification*)notification;

/** 设置InputAccessoryView, 用于点击"完成"撤销键盘 */
-(void)setDoneInputAccessoryView;


- (void)textValueDidChanged:(CM_textHeightChangedBlock)block;


@end
