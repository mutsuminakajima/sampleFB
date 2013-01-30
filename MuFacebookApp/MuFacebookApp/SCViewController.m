//
//  SCViewController.m
//  MuFacebookApp
//
//  Created by nakajima-m on 13/01/28.
//  Copyright (c) 2013年 nakajima-m. All rights reserved.
//

#import "SCViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "SCAppDelegate.h"

@interface SCViewController ()

//プロフィール写真
@property (strong,nonatomic) IBOutlet FBProfilePictureView* userProfileImage;

//FBのユーザー名
@property (strong,nonatomic) IBOutlet UILabel* userNameLabei;


@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSLog(@"%s %d",__PRETTY_FUNCTION__,__LINE__);

	
    // Do any additional setup after loading the view, typically from a nib.
    
    //ログアウトボタンをつける
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Logout"
                                              style:UIBarButtonItemStyleBordered
                                              target:self
                                              action:@selector(logoutButtonWasPressed:)];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(sessionStateChanged:)
//                                                 name:SCSessionStateChangeNotification
//                                               object:nil];
    
    [self populateUserDetails];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//ログアウトボタンタップ時
- (void)logoutButtonWasPressed:(id)sender{
    
    [FBSession.activeSession closeAndClearTokenInformation];
}

//FBからプロフィール写真などもらってきます
- (void)populateUserDetails{
    
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection,
                                                               NSDictionary<FBGraphUser> *user,
                                                               NSError *error){
            if (!error) {
                self.userNameLabei.text = user.name;
                self.userProfileImage.profileID = user.id;
            }
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (FBSession.activeSession.isOpen) {
        [self populateUserDetails];
    }
}



@end
