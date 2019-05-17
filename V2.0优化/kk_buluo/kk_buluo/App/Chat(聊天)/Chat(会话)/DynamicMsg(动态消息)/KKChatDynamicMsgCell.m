//
//  KKChatDynamicMsgCell.m
//  kk_buluo
//
//  Created by david on 2019/3/30.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKChatDynamicMsgCell.h"
//model
#import "KKChatDynamicMsgContent.h"
//tool
#import "KKReMakeDictionary.h"

@interface KKChatDynamicMsgCell (){
    CGFloat _imgViewWidth;
    CGFloat _imgViewCornerRadius;
    CGFloat _addCellWidth;
}

@end

@implementation KKChatDynamicMsgCell
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setDimension];
        [self initialize];
    }
    return self;
}


+ (CGSize)sizeForMessageModel:(RCMessageModel *)model withCollectionViewWidth:(CGFloat)collectionViewWidth referenceExtraHeight:(CGFloat)extraHeight {
    
    KKChatDynamicMsgContent *dynamicMsgContent = (KKChatDynamicMsgContent *)model.content;
    CGFloat addH = dynamicMsgContent.type==2 ? 145 : 100;
    return CGSizeMake(collectionViewWidth, addH+extraHeight);
}

#pragma mark - UI
-(void)setDimension {
    _imgViewWidth = 59;
    _imgViewCornerRadius = 0;
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
    //3.1 titleL
    DGLabel *titleL = [DGLabel labelWithText:@"" fontSize:15 color:COLOR_BLACK_TEXT bold:NO];
    titleL.lineBreakMode = NSLineBreakByTruncatingTail;
    titleL.numberOfLines = 2;
    self.titleLabel = titleL;
    [self.messageContentView addSubview:titleL];
    
    //3.2 图片
    UIImageView *picImgV = [[UIImageView alloc]initWithFrame:CGRectMake(12, 6, _imgViewWidth, _imgViewWidth)];
    picImgV.backgroundColor = UIColor.lightGrayColor;
    self.imgView = picImgV;
    [self.messageContentView addSubview:picImgV];
    
    //3.3 descL
    DGLabel *summaryL = [DGLabel labelWithText:@"" fontSize:13 color:COLOR_BLACK_TEXT bold:NO];
    summaryL.numberOfLines = 2;
    self.summaryLabel = summaryL;
    [self.messageContentView addSubview:summaryL];
    
    //3.4 grayLine
    UIView *grayLine = [[UIView alloc]init];
    self.grayLine = grayLine;
    grayLine.backgroundColor = COLOR_BG;
    [self.messageContentView addSubview:grayLine];
    
    //3.5 author
    DGLabel *authhorL = [DGLabel labelWithText:@"" fontSize:11 color:COLOR_GRAY_TEXT];
    self.tagLabel = authhorL;
    [self.messageContentView addSubview:authhorL];
    
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat msgContentW = self.messageContentViewWidth;
    CGFloat msgContentH = self.messageContentView.height;
    CGFloat leftSpace = 12;
    CGFloat rightSpace = 12;
    CGFloat titleH = 0;
    CGFloat titleTopSpace = 0;
    CGFloat imgW = _imgViewWidth;
    CGFloat addW = _addCellWidth;
    CGRect cFrame = self.messageContentView.frame;
    
    //长短文判断
    KKChatDynamicMsgContent *content = (KKChatDynamicMsgContent *)self.model.content;
    if (content.type == 2) {
        titleH = 38;
        titleTopSpace = 7;
    }
    
    //消息方向判断
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
    
    //0.bg
    self.bubbleBgImageView.frame = self.messageContentView.bounds;
    
    //1.title
    CGFloat titleW = msgContentW - leftSpace - 8 - rightSpace;
    self.titleLabel.frame = CGRectMake(leftSpace, titleTopSpace, titleW, titleH);
    
    //2.img
    self.imgView.frame = CGRectMake(leftSpace, self.titleLabel.bottom+6, imgW, imgW);
    
    //3.summaryL
    CGFloat summaryW = msgContentW-self.imgView.right-8-rightSpace;
    CGFloat summaryH = self.imgView.height-2*2;
    self.summaryLabel.frame = CGRectMake(self.imgView.right+8, self.imgView.top+1, summaryW, summaryH);
    
    //4.grayLine
    self.grayLine.frame = CGRectMake(leftSpace-4, self.imgView.bottom+8, msgContentW-leftSpace-rightSpace+8, 0.7);
    
    //5.author
    CGFloat authorH = msgContentH-self.grayLine.bottom;
    self.tagLabel.frame = CGRectMake(leftSpace, self.grayLine.bottom, msgContentW-leftSpace-rightSpace, authorH);
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
    KKChatDynamicMsgContent *content = (KKChatDynamicMsgContent *)self.model.content;
    
    //2.1 img
    [self.imgView sd_setImageWithURL:Url(content.imgUrl) placeholderImage:Img(@"default_trasmit_icon")];
    
    //2.2 title
    self.titleLabel.attributedText = [self convertTitleToAttributedStr:content.title];
    
    //2.3 summary
    self.summaryLabel.attributedText = [self convertSummaryToAttributedStr:content.summary];;
    
    //2.4 作者
    self.tagLabel.text = [NSString stringWithFormat:@"%@",content.tagStr];
}

/*!
 更新消息发送状态
 @param model 消息Cell的数据模型
 */
- (void)updateStatusContentView:(RCMessageModel *)model {
    [super updateStatusContentView:model];
}

#pragma mark - tool
-(NSAttributedString *)convertSummaryToAttributedStr:(NSString *)str {
    
   if(str.length < 1) {  return nil; }
    
    //1.转为attributeStr
    NSDictionary *aDict = [KKReMakeDictionary getHtmlAttributedStringAndHeightWithString:str withTextFont:[UIFont systemFontOfSize:13] withTextColor:COLOR_GRAY_TEXT withMaxWith:SCREEN_WIDTH - 20 withMaxHeight:CGFLOAT_MAX wihthImageFont:13];
    NSAttributedString *aStr = [aDict objectForKey:@"html"];
    
    //2.调整
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithAttributedString:aStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 0.0f;
    paragraphStyle.minimumLineHeight = 22.0f;
    [attributedStr addAttribute:NSParagraphStyleAttributeName
                        value:paragraphStyle
                        range:NSMakeRange(0, [attributedStr length])];
    //3.return
    return attributedStr;
}

-(NSAttributedString *)convertTitleToAttributedStr:(NSString *)str {
    
    if(str.length < 1) {  return nil; }
    
    //1.转为attributeStr
    NSDictionary *aDict = [KKReMakeDictionary getHtmlAttributedStringAndHeightWithString:str withTextFont:[UIFont systemFontOfSize:15] withTextColor:COLOR_BLACK withMaxWith:SCREEN_WIDTH - 20 withMaxHeight:CGFLOAT_MAX wihthImageFont:15];
    NSAttributedString *aStr = [aDict objectForKey:@"html"];
    
    //2.调整
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithAttributedString:aStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:0.5];
    [attributedStr addAttribute:NSParagraphStyleAttributeName
                          value:paragraphStyle
                          range:NSMakeRange(0, [attributedStr length])];
    //3.return
    return attributedStr;
}
@end
