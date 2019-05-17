//
//  KKTouchTableView.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/28.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol KKTouchTableViewDelegate<NSObject>

@optional
- (void)tableView:(UITableView *)tableView
     touchesBegan:(NSSet *)touches
        withEvent:(UIEvent *)event;

- (void)tableView:(UITableView *)tableView
 touchesCancelled:(NSSet *)touches
        withEvent:(UIEvent *)event;

- (void)tableView:(UITableView *)tableView
     touchesEnded:(NSSet *)touches
        withEvent:(UIEvent *)event;

- (void)tableView:(UITableView *)tableView
     touchesMoved:(NSSet *)touches
        withEvent:(UIEvent *)event;

@end
@interface KKTouchTableView : UITableView

@property (nonatomic,weak) id<KKTouchTableViewDelegate> touchDelegate;

@end

NS_ASSUME_NONNULL_END
