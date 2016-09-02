//
//  LLCAlertManager.h
//  testAlertView
//
//  Created by Live on 16/8/31.
//  Copyright © 2016年 Live. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLCAlertManagerEnum.h"
#import "LLCAlertItem.h"

#define LLC_ALERT_CUSTOM_HIDE_BUTTON_INDEX (-10000)

@interface LLCAlertManager : NSObject

+ (instancetype) shareManager;

- (void) showAlertWithStyle:(LLCAlertStyle) style
                      title:(NSString *) title
                    message:(NSString *) message
                actionItems:(NSArray<LLCAlertItem *> *) actionItems;

- (void) hideAllShowingAlert;

- (BOOL) addShowingAlert:(id) showingAlert;

- (BOOL) removeFinishShowingAlert:(id) finishShowingAlert;

@end
