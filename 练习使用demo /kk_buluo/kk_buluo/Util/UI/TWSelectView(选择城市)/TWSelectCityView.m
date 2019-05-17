//
//  TWSelectCityView.m
//  TWCitySelectView
//
//  Created by TreeWriteMac on 16/6/30.
//  Copyright © 2016年 Raykin. All rights reserved.
//

#import "TWSelectCityView.h"

@interface TWSelectCityView ()<UIPickerViewDelegate,UIPickerViewDataSource, UIGestureRecognizerDelegate>{
    
    NSArray *_AllARY;          //取出所有数据(json类型，在pilst里面)
    NSMutableArray *_ProvinceAry;          //只装省份的数组
    NSMutableArray *_CityAry;              //只装城市的数组
    NSMutableArray *_DistrictAry;          //只装区的数组（还有县）
    
    NSInteger _proIndex;            //用于记录选中哪个省的索引
    NSInteger _cityIndex;           //用于记录选中哪个市的索引
    NSInteger _districtIndex;       //用于记录选中哪个区的索引
}

@property (copy, nonatomic) void (^selectedBlock)(NSString *proviceStr,NSString *cityStr);
@property (nonatomic, weak) UIView *dispalyView;
@property (nonatomic, weak) UIPickerView *pickerView;
@end

@implementation TWSelectCityView

static const CGFloat CityPicker_btnW = 60;
static const CGFloat CityPicker_toolH = 40;
static const CGFloat CityPicker_diplayH = 260;

-(instancetype)initWithFrame:(CGRect)rect {

    if (self = [super initWithFrame:rect]) {
        _ProvinceAry = [NSMutableArray array];
        _CityAry = [NSMutableArray array];
        _DistrictAry = [NSMutableArray array];
        
        _AllARY = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"]];
        for (NSDictionary *dci in _AllARY) {
            [_ProvinceAry addObject:[[dci allKeys] firstObject]];
        }
        
        [self setupSubvies];
    }
    return self;
    
}

#pragma mark - UI
-(void)setupSubvies {
    

    //1.self背景
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer)] ;
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    //2.显示pickview和按钮最底下的view
    UIView *displayV = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, CityPicker_diplayH)];
    self.dispalyView = displayV;
    [self addSubview:displayV];
    
    //3.tool
    UIView *tool = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, CityPicker_toolH)];
    tool.backgroundColor = UIColor.grayColor;
    [displayV addSubview:tool];
    
    //3.1取消
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.frame = CGRectMake(0, 0, CityPicker_btnW, CityPicker_toolH);
    [cancelBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [tool addSubview:cancelBtn];
    /*
    UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(left.frame.size.width, 0, self.width-(left.frame.size.width*2), toolH)];
    titleLB.text = title;
    titleLB.textAlignment = NSTextAlignmentCenter;
    [tool addSubview:titleLB];
     */
    
    //3.2确认
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    confirmBtn.frame = CGRectMake(self.width-CityPicker_btnW ,0,CityPicker_btnW, CityPicker_toolH);
    [confirmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(clickConfirmButton) forControlEvents:UIControlEventTouchUpInside];
    [tool addSubview:confirmBtn];
    
    
    //4.pickerV
    UIPickerView *pickerV = [[UIPickerView alloc] initWithFrame:CGRectMake(0,CityPicker_toolH, self.width, displayV.frame.size.height-CityPicker_toolH)];
    self.pickerView = pickerV;
    pickerV.delegate = self;
    pickerV.dataSource = self;
    pickerV.backgroundColor = UIColor.whiteColor;
    [displayV addSubview:pickerV];
    
    
    for (NSDictionary *dci in _AllARY) {
        
        if ([dci objectForKey:_ProvinceAry[_proIndex]]) {
            _CityAry = [NSMutableArray arrayWithArray:[[dci objectForKey:_ProvinceAry[_proIndex]] allKeys]];
            
            [pickerV reloadComponent:1];
            [pickerV selectRow:0 inComponent:1 animated:YES];
        }
    }
    
}


#pragma mark - pickerViewDelegate
//自定义每个pickview的label
-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = [UILabel new];
    pickerLabel.numberOfLines = 0;
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    pickerLabel.textColor = COLOR_BLACK_TEXT;
    pickerLabel.font = [UIFont boldSystemFontOfSize:17];
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {
        _proIndex = row;
        _cityIndex = 0;
        _districtIndex = 0;
        
        for (NSDictionary *dci in _AllARY) {
            
            if ([dci objectForKey:_ProvinceAry[_proIndex]]) {
                _CityAry = [NSMutableArray arrayWithArray:[[dci objectForKey:_ProvinceAry[_proIndex]] allKeys]];
                
                [pickerView reloadComponent:1];
                [pickerView selectRow:0 inComponent:1 animated:YES];
            }
        }
        
    }
    
    if (component == 1) {
        _cityIndex = row;
        _districtIndex = 0;
    }
    
    if (component == 2) {
        _districtIndex = row;
    }
    
    
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return [_ProvinceAry objectAtIndex:row];
    }else if (component == 1){
        return [_CityAry objectAtIndex:row];
    }
    return nil;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==0) {
        return _ProvinceAry.count;
    }else if (component == 1){
        return _CityAry.count;
    }
    
    return 0;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

#pragma mark - interaction

-(void)showCityView:(void (^)(NSString *, NSString *))selectedBlock{
    
    self.selectedBlock = selectedBlock;
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    WS(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = weakSelf.dispalyView.frame;
        frame.origin.y = weakSelf.height-CityPicker_diplayH;
        weakSelf.dispalyView.frame = frame;
    }];
    
}

/** 左边的取消按钮 */
-(void)clickCancelButton{
    [self hideSelf];
}

/** 右边的确认按钮 */
-(void)clickConfirmButton{
    
    WS(weakSelf);
    if (self.selectedBlock) {
        weakSelf.selectedBlock(_ProvinceAry[_proIndex],_CityAry[_cityIndex]);
    }
    
    [self hideSelf];
}


-(void)tapGestureRecognizer {
     [self hideSelf];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.dispalyView]) {
        return NO ;
    }
    return YES ;
}

-(void)hideSelf {
    
    WS(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = weakSelf.dispalyView.frame;
        frame.origin.y = weakSelf.height;
        weakSelf.dispalyView.frame = frame;
        weakSelf.alpha = 0.1;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

@end
