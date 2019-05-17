//
//  KKTouchTableView.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/28.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKTouchTableView.h"

@implementation KKTouchTableView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if ([_touchDelegate conformsToProtocol:@protocol(KKTouchTableViewDelegate)] && [_touchDelegate respondsToSelector:@selector(tableView:touchesBegan:withEvent:)]) {
        [_touchDelegate tableView:self touchesBegan:touches withEvent:event];
    }
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    if ([_touchDelegate conformsToProtocol:@protocol(KKTouchTableViewDelegate)] && [_touchDelegate respondsToSelector:@selector(tableView:touchesMoved:withEvent:)]) {
        [_touchDelegate tableView:self touchesMoved:touches withEvent:event];
    }
}
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    if ([_touchDelegate conformsToProtocol:@protocol(KKTouchTableViewDelegate)] && [_touchDelegate respondsToSelector:@selector(tableView:touchesCancelled:withEvent:)]) {
        [_touchDelegate tableView:self touchesCancelled:touches withEvent:event];
    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    if ([_touchDelegate conformsToProtocol:@protocol(KKTouchTableViewDelegate)] && [_touchDelegate respondsToSelector:@selector(tableView:touchesEnded:withEvent:)]) {
        [_touchDelegate tableView:self touchesEnded:touches withEvent:event];
    }
}

@end
