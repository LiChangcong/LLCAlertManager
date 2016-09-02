//
//  UIActionSheet+CustomDelegate.m
//  testAlertView
//
//  Created by Live on 16/9/1.
//  Copyright © 2016年 Live. All rights reserved.
//

#import "UIActionSheet+CustomDelegate.h"
#import <objc/runtime.h>
#import "LLCAlertManager.h"

static NSString *cancelItemKey = @"cancelItemKey";
static NSString *otherActionItemKey = @"otherActionItemKey";
static NSString *destructiveItemKey = @"destructiveItemKey";

@implementation UIActionSheet (CustomDelegate)

#pragma mark - Init

- (instancetype) initWithTitle:(NSString *)title actionItems:(NSArray<LLCAlertItem *> *)actionItems {

    //find cancelItem,destructiveItem,fill actionItems

    self.otherActionItems = [NSMutableArray arrayWithCapacity:actionItems.count];

    for (LLCAlertItem *item in actionItems) {
        if (item.style == LLCAlertItemStyle_Cancel && !self.cancelItem) {
            self.cancelItem = item;
        } else if (item.style == LLCAlertItemStyle_Destructive && !self.destructiveItem) {
            self.destructiveItem = item;
        } else {
            [self.otherActionItems addObject:item];
        }
    }

    //
    NSString *cancelTitle = nil;
    if (self.cancelItem) {
        cancelTitle = self.cancelItem.title ? self.cancelItem.title : @"";
    }

    NSString *destructiveTitle = nil;
    if (self.destructiveItem) {
        destructiveTitle = self.destructiveItem ? self.destructiveItem.title : @"";
    }

    self = [self initWithTitle:title delegate:nil cancelButtonTitle:cancelTitle destructiveButtonTitle:destructiveTitle otherButtonTitles: nil];
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

- (void) setDestructiveItem:(LLCAlertItem *)destructiveItem {
    objc_setAssociatedObject(self, &destructiveItemKey, destructiveItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Getter

- (LLCAlertItem *) cancelItem {
    return objc_getAssociatedObject(self, &cancelItemKey);
}

- (LLCAlertItem *) destructiveItem {
    return objc_getAssociatedObject(self, &destructiveItemKey);
}

- (NSMutableArray<LLCAlertItem *> *) otherActionItems {
    return objc_getAssociatedObject(self, &otherActionItemKey);
}


#pragma mark - Delegate

- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == LLC_ALERT_CUSTOM_HIDE_BUTTON_INDEX) {
        return;
    } else if (buttonIndex == self.cancelButtonIndex) {
        if (self.cancelItem.handler)
            self.cancelItem.handler();
    } else if (buttonIndex == self.destructiveButtonIndex) {
        if (self.destructiveItem)
            self.destructiveItem.handler();
    } else {
        LLCAlertItem *actionItem = self.otherActionItems[buttonIndex];
        if (actionItem.handler)
            actionItem.handler();
    }
    //clear from manager
    [[LLCAlertManager shareManager] removeFinishShowingAlert:actionSheet];
}

@end
