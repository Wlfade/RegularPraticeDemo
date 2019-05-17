//
//  KKChatAppMsgCell.m
//  kk_buluo
//
//  Created by david on 2019/3/30.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKChatAppMsgCell.h"
//model
#import "KKChatAppMsgContent.h"


@interface KKChatAppMsgCell (){
    CGFloat _imgViewWidth;
    CGFloat _imgViewCornerRadius;
    CGFloat _addCellWidth;
}

@end

@implementation KKChatAppMsgCell
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setDimension];
        [self initialize];
    }
    return self;
}


+ (CGSize)sizeForMessageModel:(RCMessageModel *)model withCollectionViewWidth:(CGFloat)collectionViewWidth referenceExtraHeight:(CGFloat)extraHeight {
    
    return CGSizeMake(collectionViewWidth, 90+extraHeight);
}

#pragma mark - UI
-(void)setDimension {
    _imgViewWidth = 50;
    _imgViewCornerRadius = 5;
    _addCellWidth = [ccui getRH:42];
}


-(void)initialize {
    //1.背景
    self.bubbleBgImageView = [[UIImageView alloc] init];
    [self.messageContentView addSubview:self.bubbleBgImageView];
    
    
    //2.手势
    self.bubbleBgImageView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPressGr =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    [self.bubbleBgImageView addGestureRecognizer:longPressGr];
    
    UITapGestureRecognizer *tapGr =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taped:)];
    tapGr.numberOfTapsRequired = 1;
    tapGr.numberOfTouchesRequired = 1;
    [self.bubbleBgImageView addGestureRecognizer:tapGr];
    
    //3.subviews
    //3.1 图片
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(12, 6, _imgViewWidth, _imgViewWidth)];
    imgV.backgroundColor = UIColor.lightGrayColor;
    imgV.layer.cornerRadius = _imgViewCornerRadius;
    imgV.layer.masksToBounds = YES;
    self.imgView = imgV;
    [self.messageContentView addSubview:imgV];
    
    //3.2 titleL
    DGLabel *titleL = [DGLabel labelWithText:@"" fontSize:13 color:COLOR_BLACK_TEXT bold:NO];
    titleL.lineBreakMode = NSLineBreakByTruncatingTail;
    self.nameLabel = titleL;
    [self.messageContentView addSubview:titleL];
    
    
    //3.3 summaryL
    DGLabel *summaryL = [DGLabel labelWithText:@"" fontSize:11 color:COLOR_GRAY_TEXT bold:NO];
    summaryL.numberOfLines = 2;
    self.summaryLabel = summaryL;
    [self.messageContentView addSubview:summaryL];
    
    //3.4 grayLine
    UIView *grayLine = [[UIView alloc]init];
    self.grayLine = grayLine;
    grayLine.backgroundColor = COLOR_BG;
    [self.messageContentView addSubview:grayLine];
    
    //3.5 tagL
    DGLabel *tagL = [DGLabel labelWithText:@"" fontSize:11 color:COLOR_GRAY_TEXT];
    self.tagLabel = tagL;
    [self.messageContentView addSubview:tagL];
    
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat msgContentW = self.messageContentViewWidth;
    CGFloat msgContentH = self.messageContentView.height;
    CGFloat leftSpace = 12;
    CGFloat rightSpace = 12;
    CGFloat imgW = _imgViewWidth;
    CGFloat addW = _addCellWidth;
    CGRect cFrame = self.messageContentView.frame;
    
    if (self.model.messageDirection == MessageDirection_RECEIVE) {
        leftSpace = 18;
        cFrame.size.width += addW;
    }else{
        rightSpace = 18;
        CGFloat targetW = cFrame.size.width + addW;
        cFrame.size.width = targetW;
        cFrame.origin.x = self.width - targetW - 16 - [RCIM sharedRCIM].globalMessagePortraitSize.width;
    }
    
    self.messageContentView.frame = cFrame;
    msgContentW = self.messageContentView.width;
    
    //bg
    self.bubbleBgImageView.frame = self.messageContentView.bounds;
    
    //1.img
    self.imgView.frame = CGRectMake(leftSpace, 6, imgW, imgW);
    
    //2.name
    CGFloat nameW = msgContentW - self.imgView.right - 8 - rightSpace;
    self.nameLabel.frame = CGRectMake(self.imgView.right+8, 7, nameW, 20);
    
    //3.summaryL
    self.summaryLabel.frame = CGRectMake(self.nameLabel.left, self.nameLabel.bottom, nameW, imgW-20);
    
    //4.grayLine
    self.grayLine.frame = CGRectMake(leftSpace-4, self.imgView.bottom+8, msgContentW-leftSpace-rightSpace+8, 0.7);
    
    //5.author
    CGFloat extraH = msgContentH-self.grayLine.bottom;
    self.tagLabel.frame = CGRectMake(leftSpace+2, self.grayLine.bottom, msgContentW-leftSpace-rightSpace-2, extraH);
}

#pragma mark- 手势
- (void)taped:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}

- (void)longPressed:(id)sender {
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        [self.delegate didLongTouchMessageCell:self.model inView:self.bubbleBgImageView];
    }
}

#pragma mark -
- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    
    //1.发送朝向
    if (self.model.messageDirection == MessageDirection_SEND) {
        self.bubbleBgImageView.image = Img(@"chat_bubble_dynamicMsg_send");
    }else{
        self.bubbleBgImageView.image = Img(@"chat_bubble_dynamicMsg_receive");
    }
    
    //2.内容
    KKChatAppMsgContent *content = (KKChatAppMsgContent *)self.model.content;
    
    //2.1 img
    [self.imgView sd_setImageWithURL:Url(content.imgUrl) placeholderImage:Img(@"default_wepApp_icon")];
    
    //2.2 title
    self.nameLabel.text = content.name;
    
    //2.3 summary
    self.summaryLabel.text = content.summary;
    
    //2.4 额外信息
    self.tagLabel.text = [NSString stringWithFormat:@"%@",content.tagStr];
}

/*!
 更新消息发送状态
 
 @param model 消息Cell的数据模型
 */
- (void)updateStatusContentView:(RCMessageModel *)model {
    [super updateStatusContentView:model];
}

@end
