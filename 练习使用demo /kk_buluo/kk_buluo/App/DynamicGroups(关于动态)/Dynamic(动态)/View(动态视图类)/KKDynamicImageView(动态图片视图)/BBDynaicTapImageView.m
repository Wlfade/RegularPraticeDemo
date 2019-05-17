//
//  BBDynaicTapImageView.m
//  BananaBall
//
//  Created by 单车 on 2018/2/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BBDynaicTapImageView.h"
#import "HHObjectCheck.h"
@interface BBDynaicTapImageView ()
@property (nonatomic,weak)UILabel *textLabel;
@end

@implementation BBDynaicTapImageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

        [self addGuesture];
    }
    return self;
}
- (void)addGuesture{

    UILabel *textLabel = [[UILabel alloc]init];
    textLabel.font=[UIFont systemFontOfSize:9];
    textLabel.backgroundColor=RGBA(0, 0, 0, .8);
    self.textLabel = textLabel;
    [self addSubview:textLabel];
    textLabel.textColor=[UIColor whiteColor];
//    textLabel.text=@"共5张";
    textLabel.textAlignment=NSTextAlignmentCenter;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tapped:)];
    [self addGestureRecognizer:tap];

    self.clipsToBounds = YES;
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.userInteractionEnabled = YES;
}

- (void)Tapped:(UIGestureRecognizer *) gesture
{
    if ([self.delegate respondsToSelector:@selector(tappedWithObject:withTag:)])
    {
        [self.delegate tappedWithObject:self withTag:self.tag];
    }
}
- (void)upSetImageUrl:(NSString *)urlStr withTextStr:(NSString *)textStr{
    [self sd_setImageWithURL:[NSURL URLWithString:urlStr]];
//    if (![HHObjectCheck isEmpty:textStr]) {
//        self.textLabel.hidden = NO;
//        self.textLabel.text = textStr;
//        [self.textLabel sizeToFit];
//        CGRect textLabelFrame = self.textLabel.frame;
//        textLabelFrame.origin.x = self.width - textLabelFrame.size.width - 2;
//        textLabelFrame.origin.y = self.height - textLabelFrame.size.height - 2;
//        self.textLabel.frame = textLabelFrame;
//    }else{
//        self.textLabel.hidden = YES;
//    }
}
@end
