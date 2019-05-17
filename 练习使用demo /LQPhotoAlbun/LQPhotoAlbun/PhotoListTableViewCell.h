//
//  PhotoListTableViewCell.h
//  LQPhotoAlbun
//
//  Created by liang lee on 2018/5/9.
//  Copyright © 2018年 liang lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol photoAlbumTableViewCellDelegate;
@interface PhotoListTableViewCell : UITableViewCell

@property (nonatomic,strong)UIView *view_background;

-(void)setUIWithArray:(NSArray *)images;

@property (nonatomic,weak)id<photoAlbumTableViewCellDelegate>delegate;

@end

@protocol photoAlbumTableViewCellDelegate <NSObject>

-(void)didSelectedImageViewOnCell:(PhotoListTableViewCell *)cell withImageView:(UIImageView *)imageView;

@end

