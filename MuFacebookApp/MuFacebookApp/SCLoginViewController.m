//
//  SCLoginViewController.m
//  MuFacebookApp
//
//  Created by nakajima-m on 13/01/28.
//  Copyright (c) 2013年 nakajima-m. All rights reserved.
//

#import "SCLoginViewController.h"
#import "SCAppDelegate.h"

@interface SCLoginViewController()

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *fbActivityIndicator;

- (IBAction)fbLoginButton:(UIButton *)sender;


@end


@implementation SCLoginViewController
@synthesize fbActivityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)fbLoginButton:(UIButton *)sender {
    
    NSLog(@"======pushButton");
    //アクティビティインジケータをスタートさせる
    [self.fbActivityIndicator startAnimating];
    
    SCAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate openSession];
    
}

- (void)loginFailed{
    NSLog(@"======loginFailed");
    
    //画面戻るなど何らかのユーザー操作で認証フローがキャンセルされたtoki
    [self.fbActivityIndicator stopAnimating];
    
}

@end
