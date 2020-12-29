//
//  LoginVController.m
//  Skytaxi
//
//  Created by meixiang wu on 2018/3/31.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "LoginVController.h"
#import "SignupVController.h"
#import "ForgotPasswordVC.h"
#import "CustomMainVC.h"
#import "HttpApi.h"
#import <SVProgressHUD.h>
#import "Config.h"
#import "Common.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "FacebookUserInfo.h"
#import "AppDelegate.h"
#import <OneSignal/OneSignal.h>
#import "NetworkManager.h"

UserModel* customer;
UserModel* pilot;

@interface LoginVController (){
    NSString* dtoken;
    NSString* fbToken;
    FacebookUserInfo *facebookUserInfo;
}
@end

@implementation LoginVController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dtoken = @"";
    // TODO(developer) Configure the sign-in button look/feel
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
    // Uncomment to automatically sign in the user.
    //[[GIDSignIn sharedInstance] signInSilently];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    g_loginType = LOGIN_TYPE_GENERAL;
    [self getOneSignalToken];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
    
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([dtoken length] == 0){
        dtoken = [Common getValueKey:@"token"];
    }
    
    if([dtoken length] == 0){
        return;
    }
    if([[Common getValueKey:@"remember_login"] isEqualToString:@"1"]){
        NSString *str = [Common getValueKey:@"login_type"];
        g_loginType = [str integerValue];
        NSString *userid = [Common getValueKey:@"userId"];
        NSString *email = [Common getValueKey:@"emailName"];
        [SVProgressHUD show];
        [[HttpApi sharedInstance] getUserById:email UserID:userid Token:dtoken Completed:^(NSDictionary* result) {
            [SVProgressHUD dismiss];
            UserModel* one = [[UserModel alloc] initWithDictionary:result];            
            if([one.type isEqualToString:USER_TYPE_PILOT]){
                pilot = one;
                [self gotoPilotPage];
            } else{
                customer = one;
                [self gotoCustomerPage];
            }
        } Failed:^(NSString *strError) {
            [SVProgressHUD showErrorWithStatus:strError];
        }];
    }
}

// Implement these methods only if the GIDSignInUIDelegate is not a subclass of
// UIViewController.

// Stop the UIActivityIndicatorView animation that was started when the user
// pressed the Sign In button
//- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
//}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onSignupClick:(id)sender {
    SignupVController* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_SignupVController"];
    [self.navigationController pushViewController:mVC animated:YES];
}

- (IBAction)onLogin:(id)sender {
    if(![self checkValidField]){
        return;
    }
    if([dtoken length] == 0){
        dtoken = [Common getValueKey:@"token"];
    }
    
    //dtoken = @"3a9e6baa-45d2-4b67-a269-4a858b5d7eb6";//
    //[Common saveValueKey:@"token" Value:dtoken];
    if([dtoken length] == 0){
        [self getOneSignalToken];
        [self showAlertDlg:@"Warning" Msg:@"Please try login again"];
        return;
    }
    
    if(![NetworkManager IsConnectionAvailable]){
        [self showAlertDlg:@"Network Error" Msg:@"Please check network status."];
        return;
    }
    
    [SVProgressHUD show];
    [[HttpApi sharedInstance] loginWithEmail:self.mEmailTxt.text Password:self.mPasswordTxt.text Token:dtoken Completed:^(NSDictionary* result) {
        [SVProgressHUD dismiss];
        g_loginType = LOGIN_TYPE_GENERAL;
        UserModel* one = [[UserModel alloc] initWithDictionary:result];
        [Common saveValueKey:@"emailName" Value:one.email];
        [Common saveValueKey:@"userId" Value:one.userId];
        [Common saveValueKey:@"login_type" Value:@"1"];
        [Common saveValueKey:@"remember_login" Value:@"1"];
        if([one.type isEqualToString:USER_TYPE_PILOT]){
            pilot = one;
            [self gotoPilotPage];
        } else{
            customer = one;
            [self gotoCustomerPage];
        }
    } Failed:^(NSString *strError) {
        [SVProgressHUD showErrorWithStatus:strError];
    }];
}

- (IBAction)onForgotClick:(id)sender {
    ForgotPasswordVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_ForgotPasswordVC"];
    [self.navigationController pushViewController:mVC animated:YES];
}

- (IBAction)onSigninWithFacebook:(id)sender {
    if([dtoken length] == 0){
        dtoken = [Common getValueKey:@"token"];
    }
    
    if([dtoken length] == 0){
        [self getOneSignalToken];
        [self showAlertDlg:@"Warning" Msg:@"Please try login again"];
        return;
    }
    
    if(![NetworkManager IsConnectionAvailable]){
        [self showAlertDlg:@"Network Error" Msg:@"Please check network status."];
        return;
    }
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions: @[@"public_profile", @"email"] fromViewController:self
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                if (error) {
                                    NSLog(@"Process error");
                                } else if (result.isCancelled) {
                                    NSLog(@"Cancelled");
                                } else {
                                    NSLog(@"Logged in");
                                    FBSDKAccessToken* fToken = [FBSDKAccessToken currentAccessToken];
                                    if ([FBSDKAccessToken currentAccessToken]) {
                                        fbToken = fToken.tokenString;
                                        
                                        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
                                        [parameters setValue:@"id,first_name, name, last_name, email" forKey:@"fields"];
                                        
                                        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
                                         
                                         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                                             if (!error) {
                                                 NSLog(@"fetched user:%@", result);
                                                 
                                                 NSDictionary *dicResult = (NSDictionary *)result;
                                                 facebookUserInfo = [[FacebookUserInfo alloc] init];
                                                 
                                                 facebookUserInfo.facebookId = dicResult[@"id"];
                                                 facebookUserInfo.firstName = dicResult[@"first_name"];
                                                 facebookUserInfo.lastName = dicResult[@"last_name"];
                                                 facebookUserInfo.email = dicResult[@"email"];
                                                 facebookUserInfo.birthday = dicResult[@"birthday"];
                                                 facebookUserInfo.gender = dicResult[@"gender"];
                                                 facebookUserInfo.location = dicResult[@"location"][@"name"];
                                                 //self.facebookUserInfo.picture = dicResult[@"picture"][@"data"][@"url"];
                                                 
                                                 [[[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"/%@/picture", facebookUserInfo.facebookId] parameters:@{@"redirect": @"false", @"width":@"200", @"height":@"200"}]
                                                  startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                                                      if (!error) {
                                                          NSLog(@"fetched user:%@", result);
                                                          NSDictionary *dicResult = (NSDictionary *)result;
                                                          facebookUserInfo.picture = dicResult[@"data"][@"url"];
                                                          [SVProgressHUD show];
                                                          [[HttpApi sharedInstance]loginWithSocial:(NSString*)facebookUserInfo.email Username:facebookUserInfo.firstName Lastname:facebookUserInfo.lastName SocialID:facebookUserInfo.facebookId Type:@"fb" Photo:facebookUserInfo.picture Token:dtoken Completed:^(NSDictionary* result){
                                                              [SVProgressHUD dismiss];
                                                              g_loginType = LOGIN_TYPE_SOCIAL;
                                                              UserModel* one = [[UserModel alloc] initWithDictionary:result];
                                                              [Common saveValueKey:@"emailName" Value:one.email];
                                                              [Common saveValueKey:@"userId" Value:one.userId];
                                                              [Common saveValueKey:@"login_type" Value:@"2"];
                                                              [Common saveValueKey:@"remember_login" Value:@"1"];
                                                              if([one.type isEqualToString:USER_TYPE_PILOT]){
                                                                  pilot = one;
                                                                  [self gotoPilotPage];
                                                              } else{
                                                                  customer = one;
                                                                  [self gotoCustomerPage];
                                                              }
                                                          } Failed:^(NSString* errStr){
                                                              [SVProgressHUD showErrorWithStatus:errStr];
                                                          }];
                                                          
                                                          [login logOut];
                                                      }
                                                  }];
                                             }
                                         }];
                                    }
                                }
                            }];
}

- (IBAction)onSigninWithGoogle:(id)sender {
    if([dtoken length] == 0){
        dtoken = [Common getValueKey:@"token"];
    }
    
    if([dtoken length] == 0){
        [self getOneSignalToken];
        [self showAlertDlg:@"Warning" Msg:@"Please try login again"];
        return;
    }
    
    if(![NetworkManager IsConnectionAvailable]){
        [self showAlertDlg:@"Network Error" Msg:@"Please check network status."];
        return;
    }
    
    [[GIDSignIn sharedInstance] signIn];
}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations on signed in user here.
     NSString *userId = user.userID;                  // For client-side use only!
     NSString *idToken = user.authentication.idToken; // Safe to send to the server
     NSString *fullName = user.profile.name;
     NSString *givenName = user.profile.givenName;
     NSString *familyName = user.profile.familyName;
     NSString *email = user.profile.email;
    NSURL *imageURL;
    if (user.profile.hasImage){
        NSUInteger dimension = round(120 * [[UIScreen mainScreen] scale]);
        imageURL = [user.profile imageURLWithDimension:dimension];
    }
    [SVProgressHUD show];
    [[HttpApi sharedInstance] loginWithSocial:email Username:givenName Lastname:familyName SocialID:userId Type:@"gl" Photo:imageURL.absoluteString  Token:dtoken Completed:^(NSDictionary *result){
        [SVProgressHUD dismiss];
        g_loginType = LOGIN_TYPE_SOCIAL;
        UserModel* one = [[UserModel alloc] initWithDictionary:result];
        [Common saveValueKey:@"emailName" Value:one.email];
        [Common saveValueKey:@"userId" Value:one.userId];
        [Common saveValueKey:@"login_type" Value:@"2"];
        [Common saveValueKey:@"remember_login" Value:@"1"];
        if([one.type isEqualToString:USER_TYPE_PILOT]){
            pilot = one;
            [self gotoPilotPage];
        } else{
            customer = one;
            [self gotoCustomerPage];
        }
    } Failed:^(NSString *errStr){
        [SVProgressHUD showErrorWithStatus:errStr];
    }];
    [[GIDSignIn sharedInstance] signOut];
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}

- (void)gotoCustomerPage{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController* mVC = [sb instantiateViewControllerWithIdentifier:@"SID_CustomNavigation"];
    mVC.modalTransitionStyle = UIModalPresentationNone;
    [self presentViewController:mVC animated:YES completion:NULL];
}

- (void)gotoPilotPage{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController* mVC = [sb instantiateViewControllerWithIdentifier:@"SID_PilotNavigation"];
    mVC.modalTransitionStyle = UIModalPresentationNone;
    [self presentViewController:mVC animated:YES completion:NULL];
}

- (BOOL)checkValidField{
    if([self.mEmailTxt.text length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please type email."];
        return false;
    }
    if([self.mPasswordTxt.text length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please type password."];
        return false;
    }
    if(![Common NSStringIsValidEmail:self.mEmailTxt.text]){
        [self showAlertDlg:@"Warning!" Msg:@"Please type email correctly."];
        return false;
    }
    return true;
}

- (void)showAlertDlg:(NSString*) title Msg:(NSString*)msg{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:msg
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    //Handel your yes please button action here
                                }];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
    return;
}
    
- (void)getOneSignalToken{
    [OneSignal IdsAvailable:^(NSString* userId, NSString* pushToken) {
        if (pushToken) {
            dtoken = userId;
            [Common saveValueKey:@"token" Value:userId];
        } else {
            NSLog(@"\n%@", @"ERROR: Could not get a pushToken from Apple! Make sure your provisioning profile has 'Push Notifications' enabled and rebuild your app.");
        }
    }];
    return;
}
@end
