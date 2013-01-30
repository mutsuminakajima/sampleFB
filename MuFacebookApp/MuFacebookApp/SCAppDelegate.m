//
//  SCAppDelegate.m
//  MuFacebookApp
//
//  Created by nakajima-m on 13/01/28.
//  Copyright (c) 2013年 nakajima-m. All rights reserved.
//
#import <FacebookSDK/FacebookSDK.h>

#import "SCAppDelegate.h"

#import "SCViewController.h"

#import "SCLoginViewController.h"

NSString *const SCSeccionStateChangeNotification = @"com.facebook.Scrumptious :SCSessionStateChangeNotification";

@interface SCAppDelegate ()

@property (strong,nonatomic) UINavigationController* navController;
@property (strong,nonatomic) SCViewController *mainViewController;

@end


@implementation SCAppDelegate

@synthesize navController = _navController;
@synthesize mainViewController = _mainViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"======1");
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    self.mainViewController = [[SCViewController alloc] initWithNibName:@"SCViewController" bundle:nil];
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.mainViewController];
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    
    //check the Facebook session
    //See if we have a valid token for the current state.
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded ) {
        
        //YES-just open the session(this won't display any UX)
        [self openSession];
    
    } else {
        
        //No-display the login page.
        [self showLoginView];
        
    }
    return YES;
}

//LoginView表示
- (void)showLoginView{
    
     NSLog(@"======2");
    
    UIViewController *topViewController = [self.navController topViewController];
   
    UIViewController *modalViewController = [topViewController presentedViewController];
   
    //認証フローが何らかの理由でキャンセル、中断された場合の分岐
    if (![modalViewController isKindOfClass:[SCLoginViewController class]]) {

        SCLoginViewController* loginViewController = [[SCLoginViewController alloc] initWithNibName:@"SCLoginViewController" bundle:nil];
        [topViewController presentViewController:loginViewController animated:NO completion:nil];
        
    } else {
        
        SCLoginViewController* loginViewController = (SCLoginViewController*)modalViewController;
        [loginViewController loginFailed];
    }


}


//FBLogin用
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    NSLog(@"======3");
    switch (state) {
       
        case FBSessionStateOpen: {
            NSLog(@"======4");
        
            UIViewController *topViewController = [self.navController topViewController];
            
            if ([[topViewController presentedViewController] isKindOfClass:[SCLoginViewController class]])
            {
                [topViewController dismissViewControllerAnimated:YES completion:nil ];
            }
            
        }
            break;
        
        case FBSessionStateClosed:
        
        case FBSessionStateClosedLoginFailed:
            NSLog(@"======5");
        
            // Once the user has logged in, we want them to
            // be looking at the root view.
            [self.navController popToRootViewControllerAnimated:NO];
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            [self showLoginView];
           
            break;
        
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SCSeccionStateChangeNotification object:session];
    
    if (error) {
        NSLog(@"======6");
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }    
}

//FB_OpenSession
- (void)openSession{
    
    NSLog(@"======7");
    
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session, FBSessionState status, NSError *error)
                                                    {
                                                        [self sessionStateChanged:session state:status error:error];
                                                    }
     ];

}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
NSLog(@"======8");
    return [FBSession.activeSession handleOpenURL:url];

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"======9");
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
