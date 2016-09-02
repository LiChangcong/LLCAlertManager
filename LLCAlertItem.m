//
//  LLCAlertItem.m
//  testAlertView
//
//  Created by Live on 16/8/31.
//  Copyright © 2016年 Live. All rights reserved.
//

#import "LLCAlertItem.h"

@implementation LLCAlertItem

+ (nonnull instancetype) alertItemWithTitle:(nullable NSString *) title
                              style:(LLCAlertItemStyle) style
                      actionHandler:(nullable buttonActionHandler) handler {
    LLCAlertItem *item = [LLCAlertItem new];
    item.title = title;
    item.style = style;
    item.handler = handler;

    return item;
}

@end
