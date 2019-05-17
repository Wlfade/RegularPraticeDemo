//
//  DGItemView.m
//
//
//  Created by david on 2018/11/21.
//  Copyright © 2018 david. All rights reserved.
//

#import "DGItemView.h"


#pragma mark - DGItemButton
@interface DGItemButton : UIButton
@property (nonatomic,strong) UIFont *selectedFont;
@property (nonatomic,strong) UIFont *normalFont;
@end


@implementation DGItemButton
-(void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected && self.selectedFont) {
        self.titleLabel.font = self.selectedFont;
    }else{
        self.titleLabel.font = self.normalFont;
    }
}
@end



#pragma mark - DGItemView

static const NSUInteger onePageItemCount = 5;

@interface DGItemView ()<UIScrollViewDelegate>

@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIButton *indicatorView;

@property (nonatomic,strong) NSArray <DGItemButton *>*buttonArr;
//之前选中Button 和 当前选中Button
//@property (nonatomic,weak) DGItemButton *preSelectedButton;
@property (nonatomic,weak) DGItemButton *currentSelectedButton;

@end


@implementation DGItemView
#pragma mark - lazy load
-(UIScrollView *)scrollView {
    if (!_scrollView) {
        [self setupScrollView];
    }
    return _scrollView;
}

#pragma mark - life circle

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setDefaultValue];
        [self setupIndicatorView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setDefaultValue];
        [self setupUI];
    }
    return self;
}

#pragma mark - UI
/** 设置默认值 */
-(void)setDefaultValue {
    self.backgroundColor = UIColor.clearColor;
    
    //1.是否等宽
    self.needEqualWidth = YES;
    
    //2.默认选中
    self.selectedIndex = 0;
    
    //3.indicator设置
    self.indicatorViewHidden = NO;
    self.indicatorStyle = DGItemViewIndicatorStyleLine;
    self.indicatorColor = UIColor.redColor;
    self.indicatorScale = 1.0;
    self.lineIndicatorHeight = 2.0;
    self.layerIndicatorHeightScale = 0.7;
    
    //4.btn默认-选中
    self.normalFont = [UIFont systemFontOfSize:14];
    self.normalColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    self.selectedColor = UIColor.redColor;
    
    //5.animation
    self.duration = 0.25;
}

/** 设置UI */
-(void)setupUI {
    [self setupScrollView];
    [self setupIndicatorView];
}

/** 设置ScrollView */
-(void)setupScrollView {
    //1.scrollView
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    _scrollView = scrollView;
    scrollView.delegate = self;
    scrollView.contentOffset = CGPointMake(0, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.backgroundColor = self.backgroundColor;
    [self addSubview: scrollView];
    
    //2.IndicatorView
    //indicatorView在button下边, button背景透明
    [self setupIndicatorView];
}

/** 设置indicatorView */
- (void)setupIndicatorView {
    UIButton *indicatorV = [[UIButton alloc] init];
    indicatorV.userInteractionEnabled = NO;
    self.indicatorView = indicatorV;
    indicatorV.backgroundColor = self.indicatorColor;
    [self.scrollView addSubview:indicatorV];
}

/** 刷新scrollView里的buttons */
-(void)refreshButtons {
    //1.清空已有btn
    for(UIView *subview in self.buttonArr){
        [subview removeFromSuperview];
    }
    
    //2.设置尺寸参数
    NSInteger count = self.titleArr.count;
    CGFloat width = self.frame.size.width;
    CGFloat btnH = self.frame.size.height;
    CGFloat btnEqualW = width/(count*1.0);
    if(count > onePageItemCount){
        btnEqualW = width/(onePageItemCount*1.0);
    }
    
    //3.添加btns
    CGFloat totalBtnsW = 0;
    NSMutableArray *btnArr = [NSMutableArray array];
    
    //遍历titleArr添加btn
    for (NSUInteger i = 0; i<count; i++) {
        
        NSString *title = self.titleArr[i];
        
        //3.1 计算当前btn宽度
        CGFloat currentBtnW = btnEqualW;
        if (!self.needEqualWidth) {
            CGFloat fontSize = MAX(self.normalFont.pointSize, self.selectedFont.pointSize);
            CGFloat width = [title boundingRectWithSize:CGSizeMake(0, fontSize) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]} context:nil].size.width;
            currentBtnW = width*1.3;
        }
        
        //3.2 创建btn
        DGItemButton *btn = [self createButtonWithFrame:CGRectMake(totalBtnsW, 0, currentBtnW, btnH) title:title];
        btn.tag = i;
        
        //3.3 添加btn
        [self.scrollView addSubview:btn];
        [btnArr addObject:btn];
        
        //3.4 记录总宽度
        totalBtnsW += currentBtnW;
        
        //3.5 设置默认选中
        if (self.selectedIndex == i) {
            self.currentSelectedButton = btn;
            [self updateIndicatorViewPosition];
        }
        btn.selected = self.selectedIndex == i;
        
    }
    
    //4. 记录btns
    self.buttonArr = btnArr;
    
    //5.设置scrollView的contentSize
    CGFloat contentW = totalBtnsW >= width ? totalBtnsW : width;
    self.scrollView.contentSize = CGSizeMake(contentW, btnH);
}

#pragma mark - item change
/** 改变制定index的title */
-(void)changeTitle:(NSString *)title atIndex:(NSUInteger)index {
    //1.过滤数组越界
    if (index > self.buttonArr.count-1) {
        return ;
    }
    //2.改title
    [self.buttonArr[index] setTitle:title forState:UIControlStateNormal];
}

/** 获取指定index对应的itemButton */
-(UIButton *)itemButtonAtIndex:(NSUInteger)index {
    //1.过滤数组越界
    if (index > self.buttonArr.count-1) {
        return nil;
    }
    //2.return
    return self.buttonArr[index];
}

#pragma mark - interacton
/** 点击itemButton */
-(void)clickItemButton:(DGItemButton *)sender {
    
    //1.过滤点击已选的btn
    if(sender == self.currentSelectedButton){
        return ;
    }
    
    //2.调代理方法
    _selectedIndex = [self.buttonArr indexOfObject:sender];
    BOOL effective = [self.delegate itemView:self didSelectedAtIndex:_selectedIndex];
    if(!effective){
        return ;
    }
    
    //3.改变选中状态
    self.currentSelectedButton.selected = NO;
    sender.selected = YES;
    self.currentSelectedButton = sender;
    
    //4.更新IndicatorView的位置
    [self updateIndicatorViewPosition]; 
}

/** 改变IndicatorView的位置 */
- (void)updateIndicatorViewPosition {
    
    //1.获取btn
    DGItemButton *btn = self.currentSelectedButton;
    CGFloat btnW = btn.bounds.size.width;
    CGFloat btnH = btn.bounds.size.height;
    
    //2.计算
    CGPoint indicatorCenter = btn.center;
    CGRect indicatorBounds = CGRectMake(0, 0, btnW * self.indicatorScale, btnH*self.layerIndicatorHeightScale);
    CGFloat cornerRadius = indicatorBounds.size.height/2.0;
    
    if (self.indicatorStyle == DGItemViewIndicatorStyleLine) {
        indicatorCenter = CGPointMake(btn.center.x,btnH - self.lineIndicatorHeight/2);
        indicatorBounds = CGRectMake(0, 0, btnW * self.indicatorScale,self.lineIndicatorHeight);
        cornerRadius = 0;
    }
    
    //3.动画
    [UIView animateWithDuration:self.duration animations:^{
        self.indicatorView.center = indicatorCenter;
        self.indicatorView.bounds = indicatorBounds;
        self.indicatorView.layer.cornerRadius = cornerRadius;
    }];
}

#pragma mark - UI tool
/** 创建temButton */
-(DGItemButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title {
    
    //1.创建
    DGItemButton *btn = [[DGItemButton alloc]initWithFrame:frame];
    
    //2.设ttitle
    [btn setTitle:title forState:UIControlStateNormal];
    
    //3.设置状态
    btn.normalFont = self.normalFont;
    btn.selectedFont = self.selectedFont ? self.selectedFont : self.normalFont;
    [btn setTitleColor:self.normalColor forState:UIControlStateNormal];
    [btn setTitleColor:self.selectedColor forState:UIControlStateSelected];
    
    //4.点击
    [btn addTarget:self action:@selector(clickItemButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //5.文本缩放
    //btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    //btn.titleLabel.minimumScaleFactor = 0.9;
    
    //6.return
    return btn;
}

/** 更新ItemButtonsFont */
-(void)updateItemButtonsFont {
    if (self.buttonArr) {
        for (DGItemButton *btn in self.buttonArr) {
            btn.normalFont = self.normalFont;
            btn.selectedFont = self.selectedFont ? self.selectedFont : self.normalFont;
        }
    }
}

#pragma mark - setter
-(void)setTitleArr:(NSArray *)titleArr {
    _titleArr = titleArr;
    
    [self refreshButtons];
}

-(void)setSelectedIndex:(NSUInteger)selectedIndex {
    //1.没设置buttonArr,及设置默认选中index
    if(!self.buttonArr){
        _selectedIndex = selectedIndex;
        return ;
    }
    
    //2.过滤数组越界
    if (selectedIndex > self.buttonArr.count-1) {
        return ;
    }
    
    //3.赋值
    _selectedIndex = selectedIndex;
    
    //4.触发点击方法
    [self clickItemButton:self.buttonArr[selectedIndex]];
}

#pragma mark btn
-(void)setNormalFont:(UIFont *)normalFont {
    //1.赋值
    _normalFont = normalFont;
    
    //2.改变btns的font
    [self updateItemButtonsFont];
}

-(void)setSelectedFont:(UIFont *)selectedFont {
    //1.赋值
    _selectedFont = selectedFont;
    
    //2.改变btns的font
    [self updateItemButtonsFont];
}

-(void)setNormalColor:(UIColor *)normalColor{
    //1.赋值
    _normalColor = normalColor;
    
    //2.改变btns
    if (self.buttonArr) {
        for (DGItemButton *btn in self.buttonArr) {
            [btn setTitleColor:normalColor forState:UIControlStateNormal];
        }
    }
}

-(void)setSelectedColor:(UIColor *)selectedColor {
    //1.赋值
    _selectedColor = selectedColor;
    
    //2.改变btns
    if (self.buttonArr) {
        for (DGItemButton *btn in self.buttonArr) {
            [btn setTitleColor:selectedColor forState:UIControlStateSelected];
        }
    }
}

#pragma mark indicator
-(void)setIndicatorViewHidden:(BOOL)indicatorViewHidden {
    _indicatorViewHidden = indicatorViewHidden;
    self.indicatorView.hidden = indicatorViewHidden;
}

-(void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorColor = indicatorColor;
    self.indicatorView.backgroundColor = indicatorColor;
}

-(void)setIndicatorImage:(UIImage *)indicatorImage {
    _indicatorImage = indicatorImage;
    [self.indicatorView setBackgroundImage:indicatorImage forState:UIControlStateNormal];
}

-(void)setIndicatorStyle:(DGItemViewIndicatorStyle)indicatorStyle {
    _indicatorStyle = indicatorStyle;
}

-(void)setIndicatorScale:(CGFloat)indicatorScale {
    
    //1.取值范围过滤
    if(indicatorScale > 1.0 || indicatorScale < 0){
        indicatorScale = 1.0;
    }
    
    //2.DGItemViewIndicatorStyleLayer时,过滤取值范围
    if (self.indicatorStyle == DGItemViewIndicatorStyleLayer) {
        if (self.needEqualWidth) {
            indicatorScale = indicatorScale >= 0.4 ? indicatorScale : 0.4;
        }else{
            indicatorScale = 1.0;
        }
    }
    
    //3.赋值
    _indicatorScale = indicatorScale;
    
    //4.更新indicatorView的位置
    [self updateIndicatorViewPosition];
}


-(void)setLineIndicatorHeight:(CGFloat)lineIndicatorHeight {
    //1.限制最大值
    if (lineIndicatorHeight > self.bounds.size.height/2.0) {
        lineIndicatorHeight = self.bounds.size.height/2.0;
    }
    //2.限制最小值
    if (lineIndicatorHeight < 0) {
        lineIndicatorHeight = 0;
    }
    
    //3.赋值
    _lineIndicatorHeight = lineIndicatorHeight;
}


-(void)setLayerIndicatorHeightScale:(CGFloat)layerIndicatorHeightScale {
    
    //1.限制最大值
    if (layerIndicatorHeightScale > 1.0) {
        layerIndicatorHeightScale = 1.0;
    }
    
    //2.限制最小值
    if (layerIndicatorHeightScale < 0.4) {
        layerIndicatorHeightScale = 0.4;
    }
    
    //3.赋值
    _layerIndicatorHeightScale = layerIndicatorHeightScale;
}

#pragma mark  animation
-(void)setDuration:(CGFloat)duration {
    //1.限制最大值
    if (duration > 3.0) {
        duration = 3.0;
    }
    
    //2.限制最小值
    if (duration < 0.05) {
        duration = 0.05;
    }
    
    //3.赋值
    _duration = duration;
}


@end

