//
//  LLCAlertManager.m
//  testAlertView
//
//  Created by Live on 16/8/31.
//  Copyright © 2016年 Live. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "LLCAlertManager.h"
#import "LLCAlertManagerShowingItem.h"
#import "UIAlertView+CustomDelegate.h"
#import "UIActionSheet+CustomDelegate.h"
@interface LLCAlertManager()
{
    NSMutableArray<LLCAlertManagerShowingItem *> *showingAlertArray;
}
@end

@implementation LLCAlertManager

+ (instancetype) shareManager {
    static LLCAlertManager *manager = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });

    return manager;
}

#pragma mark - Init

- (instancetype) init {
    self = [super init];
    if (self) {
        showingAlertArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Show

- (void) showAlertWithStyle:(LLCAlertStyle) style
                      title:(NSString *) title
                    message:(NSString *) message
                actionItems:(NSArray<LLCAlertItem *> *) actionItems {

    if (LLCAlertStyle_AlertView == style) {

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message actionItems:actionItems];
        [alertView show];
        [self addShowingAlert:alertView];

        /****
        if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message actionItems:actionItems];
            [alertView show];
            [self addShowingAlert:alertView];

        } else {

            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            __weak typeof(self) weakSelf = self;
            __weak typeof(alertController) weakAlert = alertController;
            for (LLCAlertItem *item in actionItems) {
                UIAlertAction *alertAction = [UIAlertAction actionWithTitle:item.title style:[self systemAlertActionStyle:item.style] handler:^(UIAlertAction * _Nonnull action) {
                    if (item.handler)
                        item.handler();
                    [weakSelf removeFinishShowingAlert:weakAlert];
                }];
                [alertController addAction:alertAction];

            }
            //show
            UIViewController *topController = [self topViewControllerInApplication];
            [topController presentViewController:alertController animated:YES completion:^{
                [weakSelf addShowingAlert:weakAlert];
            }];
        }
        ****/

    } else if (LLCAlertStyle_ActionSheet == style) {

        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title actionItems:actionItems];

        UIViewController *topController = [self topViewControllerInApplication];
        [actionSheet showInView:topController.view];
        [self addShowingAlert:actionSheet];

        /****

        if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title actionItems:actionItems];

            UIViewController *topController = [self topViewControllerInApplication];
            [actionSheet showInView:topController.view];
            [self addShowingAlert:actionSheet];

        } else {

            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];

            __weak typeof(self) weakSelf = self;
            __weak typeof(alertController) weakAlert = alertController;

            for (LLCAlertItem *item in actionItems) {

                UIAlertAction *alertAction = [UIAlertAction actionWithTitle:item.title style:[self systemAlertActionStyle:item.style] handler:^(UIAlertAction * _Nonnull action) {
                    if (item.handler)
                        item.handler();
                    [weakSelf removeFinishShowingAlert:weakAlert];
                }];

                [alertController addAction:alertAction];
            }
            //show
            UIViewController *topController = [self topViewControllerInApplication];
            [topController presentViewController:alertController animated:YES completion:^{
                [weakSelf addShowingAlert:weakAlert];
            }];
        }
         
         ****/

    }
}

#pragma mark - Hide All

- (void) hideAllShowingAlert {

    for (LLCAlertManagerShowingItem *item in showingAlertArray) {
        LLCAlertStyle style = [self alertStyleWithShowAlert:item.showInfo];
        if (style == LLCAlertStyle_UnSupport) {
            break;
        } else if (style == LLCAlertStyle_AlertView) {
            if ([item.showInfo isKindOfClass:[UIAlertView class]]) {

                UIAlertView *alertView = (UIAlertView *) item.showInfo;
                [alertView dismissWithClickedButtonIndex:LLC_ALERT_CUSTOM_HIDE_BUTTON_INDEX animated:YES];

            } else if ([item.showInfo isKindOfClass:[UIAlertController class]]) {
                UIAlertController *alertController = (UIAlertController *) item.showInfo;
                [alertController dismissViewControllerAnimated:YES completion:NULL];
            }

        } else if (style == LLCAlertStyle_ActionSheet) {
            if ([item.showInfo isKindOfClass:[UIAlertView class]]) {

                UIActionSheet *actionSheet = (UIActionSheet *) item.showInfo;
                [actionSheet dismissWithClickedButtonIndex:LLC_ALERT_CUSTOM_HIDE_BUTTON_INDEX animated:YES];

            } else if ([item.showInfo isKindOfClass:[UIAlertController class]]) {
                UIAlertController *alertController = (UIAlertController *) item.showInfo;
                [alertController dismissViewControllerAnimated:YES completion:NULL];
            }
        }
    }

    [showingAlertArray removeAllObjects];
}

#pragma mark - Add , Remove showing Manager

- (BOOL) addShowingAlert:(id) showingAlert {

    LLCAlertStyle style = [self alertStyleWithShowAlert:showingAlert];

    if (style == LLCAlertStyle_UnSupport) {
        return NO;
    } else {

        for (LLCAlertManagerShowingItem *item in showingAlertArray) {
            if (item.showInfo == showingAlert) {
                return NO;
            }
        }

        LLCAlertManagerShowingItem *newShowingItem = [LLCAlertManagerShowingItem new];
        newShowingItem.style = style;
        newShowingItem.showInfo = showingAlert;

        [showingAlertArray addObject:newShowingItem];

        return YES;
    }
}

- (BOOL) removeFinishShowingAlert:(id) finishShowingAlert {

    LLCAlertStyle style = [self alertStyleWithShowAlert:finishShowingAlert];

    if (style == LLCAlertStyle_UnSupport) {
        return NO;
    } else {
        for (LLCAlertManagerShowingItem *item in showingAlertArray) {
            if (item.showInfo == finishShowingAlert) {
                [showingAlertArray removeObject:item];
                return YES;
            }
        }
        return NO;
    }
}

#pragma mark - Private

- (LLCAlertStyle) alertStyleWithShowAlert:(id) showingAlert {
    LLCAlertStyle style = LLCAlertStyle_UnSupport;

    if ([showingAlert isKindOfClass:[UIAlertView class]]) {
        style = LLCAlertStyle_AlertView;
    } else if ([showingAlert isKindOfClass:[UIActionSheet class]]) {
        style = LLCAlertStyle_ActionSheet;
    } else if ([showingAlert isKindOfClass:[UIAlertController class]]) {
        UIAlertController *alertController = (UIAlertController *) showingAlert;
        if (alertController.preferredStyle == UIAlertControllerStyleAlert) {
            style = LLCAlertStyle_AlertView;
        } else {
            style = LLCAlertStyle_ActionSheet;
        }
    }

    return style;
}

- (UIAlertActionStyle) systemAlertActionStyle:(LLCAlertItemStyle) style{
    switch (style) {
        case LLCAlertItemStyle_Default:
        {
            return UIAlertActionStyleDefault;
        }
            break;
        case LLCAlertItemStyle_Cancel:
        {
            return UIAlertActionStyleCancel;
        }
            break;
        case LLCAlertItemStyle_Destructive:
        {
            return UIAlertActionStyleDestructive;
        }
            break;

        default:
            return UIAlertActionStyleDefault;
            break;
    }
}

- (UIViewController *) topViewControllerInApplication {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;

    if ([rootViewController isKindOfClass:[UINavigationController class]]) {

        UINavigationController *navi = (UINavigationController *) rootViewController;
        return navi.visibleViewController;

    } else if ([rootViewController isKindOfClass:[UITabBarController class]]) {

        UITabBarController *tabController = (UITabBarController *) rootViewController;
        UIViewController *selectedConstroller = tabController.selectedViewController;
        if ([selectedConstroller isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navi = (UINavigationController *) selectedConstroller;
            return navi.visibleViewController;
        } else {
            if (selectedConstroller.presentedViewController) {
                return selectedConstroller.presentedViewController;
            } else {
                return selectedConstroller;
            }
        }

    } else {
        if (rootViewController.presentedViewController) {
            return rootViewController.presentedViewController;
        } else {
            return rootViewController;
        }
    }

}

+ (UIViewController *)activityViewController
{
    UIViewController* activityViewController = nil;

    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows)
        {
            if(tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }

    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0)
    {
        UIView *frontView = [viewsArray objectAtIndex:0];

        id nextResponder = [frontView nextResponder];

        if([nextResponder isKindOfClass:[UIViewController class]])
        {
            activityViewController = nextResponder;
        }
        else
        {
            activityViewController = window.rootViewController;
        }
    }

    return activityViewController;
}

@end
