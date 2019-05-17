//
//  GEmotionView.m
//  JCZJ
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 apple. All rights reserved.
//
#import "AppDelegate.h"
#import "GEmotionView.h"

@implementation GEmotionView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame GEmotion:GEmotionTypeNormal];
}


- (id)initWithFrame:(CGRect)frame GEmotion:(GEmotionType)type{
    
    self = [super initWithFrame:frame];// 先调用父类的initWithFrame方法
    
    if (self) {

        self.backgroundColor=[UIColor whiteColor];
        
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"EmotionDefault2" ofType:@".plist"];
        data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        nameArray=[data objectForKey:@"position"];
        
        UIScrollView *emotionScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        emotionScrollView.contentSize=CGSizeMake(frame.size.width*nameArray.count, frame.size.height-37);
        emotionScrollView.delegate=self;
        [emotionScrollView setPagingEnabled:YES];
        [emotionScrollView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:emotionScrollView];
       
        for (int a=0; a<nameArray.count; a++) {
            NSArray *perPageNum = nameArray[a];
            for (int i=0; i<perPageNum.count+1; i++) {
                UIButton *emotionPic=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
                emotionPic.center=CGPointMake((i%7+1)*(SCREEN_WIDTH/8)+SCREEN_WIDTH*a, 40+50*(i/7));
                [emotionScrollView addSubview:emotionPic];
                if (i==perPageNum.count) {
                    [emotionPic setBackgroundImage:[UIImage imageNamed:@"delete_emotion"] forState:UIControlStateNormal];
                }else{
                    [emotionPic setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[[nameArray objectAtIndex:a] objectAtIndex:i] ofType:@".png"]] forState:UIControlStateNormal];
                }
                
                emotionPic.tag=100+i+(((NSArray*)(nameArray[0])).count+1)*a;
                [emotionPic addTarget:self action:@selector(emotionPic:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        for (int i=0; i<nameArray.count; i++) {
            UIImageView *pageImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-34+20*i, frame.size.height-60, 8, 8)];
            pageImageView.image=[UIImage imageNamed:@"翻页-其他页"];
            [self addSubview:pageImageView];
            pageImageView.tag=i+1;
            if (i==0) {
                pageImageView.image=[UIImage imageNamed:@"翻页-当前页"];
            }
        }
        
        UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height-37, SCREEN_WIDTH, 37)];
        bottomView.backgroundColor=RGB(248, 248, 248);
        [self addSubview:bottomView];
        
        UIView *emotionTagView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 37)];
        emotionTagView.backgroundColor=RGB(230, 230, 230);
        [bottomView addSubview:emotionTagView];
        
        self.emotionTagImageView=[[UIImageView alloc]initWithFrame:CGRectMake(14, 8, 22, 22)];
        self.emotionTagImageView.image=[UIImage imageNamed:@"表情"];
        [emotionTagView addSubview:self.emotionTagImageView];
        
        self.sendBtn = [UIButton buttonWithType:(UIButtonTypeCustom)] ;
        self.sendBtn.backgroundColor = RGB(17, 182, 244) ;
        [self.sendBtn setTitle:[NSString stringWithFormat:@"发送"] forState:(UIControlStateNormal)];
        [bottomView addSubview:self.sendBtn] ;
        [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bottomView) ;
            make.centerY.equalTo(bottomView) ;
            make.width.mas_equalTo(75) ;
            make.height.mas_equalTo(37) ;
        }] ;
        if (type == GEmotionTypeNormal) {
            self.emotionTagImageView.hidden = NO ;
            emotionTagView.hidden = NO ;
            self.sendBtn.hidden = YES ;
        }else if (type == GEmotionTypeSend)
        {
            self.emotionTagImageView.hidden = YES ;
            emotionTagView.hidden = YES ;
            self.sendBtn.hidden = NO ;
        }
    }
    return self;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    int page=((int)scrollView.contentOffset.x)/SCREEN_WIDTH+1;
    if (page < 1) {
        page = 1;
    }
    BBLOG (@"scrollViewDidEndDragging%d",page);
    [self resetPage:page];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page=((int)scrollView.contentOffset.x)/SCREEN_WIDTH+1;
    BBLOG (@"scrollViewDidEnddecelerating%d",page);
    if (page < 1) {
        page = 1;
    }
    [self resetPage:page];
}
- (void)resetPage:(int)page{
    
    for (int i=1; i<5; i++){
        UIImageView *pageImageView=(UIImageView *)[self viewWithTag:i];
        pageImageView.image=[UIImage imageNamed:@"翻页-其他页"];
    }
    UIImageView *pageImageView=(UIImageView *)[self viewWithTag:page];
    pageImageView.image=[UIImage imageNamed:@"翻页-当前页"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)emotionPic:(UIButton *)button{

//    int currentIndex=(int)button.tag-100;
    int page=(int)(button.tag-100)/21;
    int row=(int)(button.tag-100)%21;
    
    if (row==((NSArray*)(nameArray[page])).count) {
        [self.delegate GEmotionTapped:nil];
    }else{
        NSMutableDictionary *infoDic=[[NSMutableDictionary alloc]init];
        [infoDic setObject:[[nameArray objectAtIndex:page] objectAtIndex:row] forKey:@"imageName"];
        
        [self.delegate GEmotionTapped:infoDic];
    }

}

@end
