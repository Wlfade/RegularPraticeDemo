//
//  KKPersonalPageNoDataCell.m
//  kk_buluo
//
//  Created by 樊星 on 2019/4/2.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKPersonalPageNoDataCell.h"

@implementation KKPersonalPageNoDataCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configSubView];
    }
    return self;
}

-(void)configSubView{
    
    self.contentView.backgroundColor = RGB(244, 244, 244);
    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [ccui getRH:85], SCREEN_WIDTH, [ccui getRH:129])];
    self.bgImageView.contentMode = UIViewContentModeCenter;
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bgImageView.bottom+[ccui getRH:8], SCREEN_WIDTH, 12)];
    textLabel.textColor = RGB(151, 151, 151);
    textLabel.font = [ccui getRFS:12];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = @"咦~还没有内容哦";
    [self addSubview:textLabel];
    
    [self addSubview:self.bgImageView];
}
@end
