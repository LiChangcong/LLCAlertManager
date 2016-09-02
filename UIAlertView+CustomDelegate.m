//
//  UIAlertView+CustomDelegate.m
//  testAlertView
//
//  Created by Live on 16/8/31.
//  Copyright © 2016年 Live. All rights reserved.
//

#import "UIAlertView+CustomDelegate.h"
#import <objc/runtime.h>
#import "LLCAlertManager.h"

static NSString *cancelItemKey = @"cancelItemKey";
static NSString *otherActionItemKey = @"otherActionItemKey";

@interface UIAlertView()


@end

@implementation UIAlertView (CustomDelegate)

@dynamic cancelItem;
@dynamic otherActionItems;

#pragma mark - Init

- (instancetype) initWithTitle:(NSString *)title message:(NSString *)message actionItems:(NSArray<LLCAlertItem *> *)items {

    //find cancel Item,fill otherActionsItemArray

    self.otherActionItems = [NSMutableArray arrayWithCapacity:items.count];

    for (LLCAlertItem *item in items) {
        if (item.style == LLCAlertItemStyle_Cancel && !self.cancelItem) {
            self.cancelItem = item;
        } else {
            [self.otherActionItems addObject:item];
        }
    }

    NSString *cancelTitle = nil;
    if (self.cancelItem) {
        cancelTitle = self.cancelItem.title ? self.cancelItem.title : @"";
    }

    self = [self initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelTitle otherButtonTitles: nil];
    self.delegate = self;

    //add other buttons
    for (LLCAlertItem *actionItem in self.otherActionItems) {
        [self addButtonWithTitle:actionItem.title ? actionItem.title : @""];
    }

    return self;
}

#pragma mark - Setter

- (void) setCancelItem:(LLCAlertItem *)cancelItem {
    objc_setAssociatedObject(self, &cancelItemKey, cancelItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void) setOtherActionItems:(NSMutableArray<LLCAlertItem *> *)otherActionItems {
    objc_setAssociatedObject(self, &otherActionItemKey, otherActionItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Getter

- (LLCAlertItem *) cancelItem {
    return objc_getAssociatedObject(self, &cancelItemKey);
}

- (NSMutableArray<LLCAlertItem *> *) otherActionItems {
    return objc_getAssociatedObject(self, &otherActionItemKey);
}

#pragma mark - Delegate

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    //
    if (buttonIndex == LLC_ALERT_CUSTOM_HIDE_BUTTON_INDEX) {
        return;
    } else if (buttonIndex == self.cancelButtonIndex) {
        if (self.cancelItem.handler)
            self.cancelItem.handler();
    } else {
        LLCAlertItem *actionItem = self.otherActionItems[self.cancelItem ? buttonIndex - 1:buttonIndex];
        if (actionItem.handler)
            actionItem.handler();
    }

    //clear from manager
    [[LLCAlertManager shareManager] removeFinishShowingAlert:alertView];
}

@end
