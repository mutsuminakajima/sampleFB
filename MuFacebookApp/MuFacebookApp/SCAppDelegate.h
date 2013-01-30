//
//  SCAppDelegate.h
//  MuFacebookApp
//
//  Created by nakajima-m on 13/01/28.
//  Copyright (c) 2013年 nakajima-m. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString *const SCSessionStateChangeNotification;

@class SCViewController;

@interface SCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property (strong, nonatomic) SCViewController *viewController;

//Facebook-opensession
- (void)openSession;

@end
