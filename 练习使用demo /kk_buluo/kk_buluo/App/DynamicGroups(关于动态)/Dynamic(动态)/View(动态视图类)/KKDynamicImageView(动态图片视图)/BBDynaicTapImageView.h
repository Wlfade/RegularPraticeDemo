//
//  BBDynaicTapImageView.h
//  BananaBall
//
//  Created by 单车 on 2018/2/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BBDynaicTapImageView;
@protocol BBDynaicTapImageViewDelegate <NSObject>
- (void) tappedWithObject:(BBDynaicTapImageView *)tapImage withTag:(NSInteger)tag;
@end
@interface BBDynaicTapImageView : UIImageView
@property (nonatomic,weak) id<BBDynaicTapImageViewDelegate> delegate;
//- (void)upSetImageUrl:(NSString *)urlStr;
- (void)upSetImageUrl:(NSString *)urlStr withTextStr:(NSString *)textStr;

@end
