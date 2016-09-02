//
//  LLCAlertManagerEnum.h
//  testAlertView
//
//  Created by Live on 16/9/1.
//  Copyright © 2016年 Live. All rights reserved.
//

#ifndef LLCAlertManagerEnum_h
#define LLCAlertManagerEnum_h

typedef NS_ENUM(NSInteger , LLCAlertStyle) {
    LLCAlertStyle_UnSupport = -1,
    LLCAlertStyle_AlertView = 0,
    LLCAlertStyle_ActionSheet,
};

typedef NS_ENUM(NSInteger , LLCAlertItemStyle) {
    LLCAlertItemStyle_Default = 0,
    LLCAlertItemStyle_Cancel,
    LLCAlertItemStyle_Destructive,
};


#endif /* LLCAlertManagerEnum_h */
