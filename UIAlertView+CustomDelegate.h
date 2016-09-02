//
//  UIAlertView+CustomDelegate.h
//  testAlertView
//
//  Created by Live on 16/8/31.
//  Copyright © 2016年 Live. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLCAlertItem.h"

@interface UIAlertView (CustomDelegate)<UIAlertViewDelegate>

@property(nonatomic , strong) LLCAlertItem *cancelItem;

@property(nonatomic , strong) NSMutableArray<LLCAlertItem *> *otherActionItems;

- (instancetype) initWithTitle:(NSString *)title message:(NSString *)message actionItems:(NSArray<LLCAlertItem *> *) items;

@end
