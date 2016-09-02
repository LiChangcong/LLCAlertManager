//
//  LLCAlertItem.h
//  testAlertView
//
//  Created by Live on 16/8/31.
//  Copyright © 2016年 Live. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLCAlertManagerEnum.h"

typedef void (^buttonActionHandler)();

@interface LLCAlertItem : NSObject

@property(nonatomic , copy , nonnull) NSString *title;

@property(nonatomic , assign) LLCAlertItemStyle style;

@property(nonatomic , copy , nullable) buttonActionHandler handler;

+ (nonnull instancetype) alertItemWithTitle:(nullable NSString *) title
                              style:(LLCAlertItemStyle) style
                      actionHandler:(nullable buttonActionHandler) handler;

@end
