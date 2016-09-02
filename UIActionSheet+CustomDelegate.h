//
//  UIActionSheet+CustomDelegate.h
//  testAlertView
//
//  Created by Live on 16/9/1.
//  Copyright © 2016年 Live. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLCAlertItem.h"

@interface UIActionSheet (CustomDelegate)<UIActionSheetDelegate>

@property(nonatomic , strong) LLCAlertItem *cancelItem;

@property(nonatomic , strong) LLCAlertItem *destructiveItem;

@property(nonatomic , strong) NSMutableArray<LLCAlertItem *> *otherActionItems;

- (instancetype) initWithTitle:(NSString *)title actionItems:(NSArray<LLCAlertItem *> *) actionItems;

@end
