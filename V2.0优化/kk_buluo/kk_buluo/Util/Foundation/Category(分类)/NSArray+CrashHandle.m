//
//  NSArray+CrashHandle.m
//  Rainbow
//
//  Created by yaya on 2019/1/19.
//  Copyright © 2019 gwh. All rights reserved.
//

#import "NSArray+CrashHandle.h"
#import<objc/runtime.h>

@implementation NSArray (CrashHandle)

// Swizzling核心代码
// 需要注意的是，好多同学反馈下面代码不起作用，造成这个问题的原因大多都是其调用了super load方法。在下面的load方法中，不应该调用父类的load方法。
+ (void)load {
    Method fromMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:));
    Method toMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(cm_objectAtIndex:));
    method_exchangeImplementations(fromMethod, toMethod);
}

// 为了避免和系统的方法冲突，我一般都会在swizzling方法前面加前缀
- (id)cm_objectAtIndex:(NSUInteger)index {
    // 判断下标是否越界，如果越界就进入异常拦截
    if (self.count-1 < index) {
        @try {
            return [self cm_objectAtIndex:index];
        }
        @catch (NSException *exception) {
            // 在崩溃后会打印崩溃信息。如果是线上，可以在这里将崩溃信息发送到服务器
//            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
//            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        }
        @finally {}
    } // 如果没有问题，则正常进行方法调用
    else {
        return [self cm_objectAtIndex:index];
    }
}

/*
 这里面可能有个误会，- (id)cm_objectAtIndex:(NSUInteger)index {
 里面调用了自身？这是递归吗？
 其实不是。这个时候方法替换已经有效了，
 cm_objectAtIndex这个SEL指向的其实是原来系统的objectAtIndex:的IMP。
 因而不是递归
 */

@end
