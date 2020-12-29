//
//  SignupVController.m
//  Skytaxi
//
//  Created by meixiang wu on 2018/3/31.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "SignupVController.h"
#import "ForgotPasswordVC.h"
#import <SVProgressHUD.h>
#import "HttpApi.h"
#import "Common.h"
#import "UserModel.h"
#import <OneSignal/OneSignal.h>
#import "TermsVController.h"
#import "Config.h"

extern UserModel* customer;

@interface SignupVController (){
    NSString* dtoken;
}

@end

@implementation SignupVController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dtoken = @"";
    self.mCheckBox = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.mCheckView addSubview:self.mCheckBox];
    self.mCheckBox.on = NO;
    //self.mCheckBox.onFillColor = YELLOW_COLOR;
    self.mCheckBox.onTintColor = WHITE_COLOR;
    self.mCheckBox.tintColor = WHITE_COLOR;
    self.mCheckBox.onCheckColor = WHITE_COLOR;
    //UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(check0:)];
    //[self.mCheckBox0 addGestureRecognizer:singleFingerTap];
    self.mCheckBox.onAnimationType = BEMAnimationTypeBounce;
    self.mCheckBox.offAnimationType = BEMAnimationTypeBounce;
    self.mCheckBox.boxType = BEMBoxTypeSquare;
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onReturnClick:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)onForgotClick:(id)sender {
    ForgotPasswordVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_ForgotPasswordVC"];
    [self.navigationController pushViewController:mVC animated:YES];
    
}

- (IBAction)onSignUp:(id)sender {
    if(![self checkValidField]){
        return;
    }
    if([dtoken length] == 0){
        dtoken = [Common getValueKey:@"token"];
    }
    
    if([dtoken length] == 0){
        [self getOneSignalToken];
        [self showAlertDlg:@"Warning" Msg:@"Please try login again"];
        return;
    }
    [SVProgressHUD show];
    [[HttpApi sharedInstance] signupWithEmail:self.mEmailTxt.text Password:self.mPasswordTxt.text Username:self.mNameTxt.text Phone:self.mPhoneTxt.text Token:dtoken Completed:^(NSDictionary *result){
        [SVProgressHUD dismiss];
        UserModel* one = [[UserModel alloc] initWithDictionary:result];
        customer = one;
        [self gotoCustomerPage];
    } Failed:^(NSString *errStr){
        [SVProgressHUD showErrorWithStatus:errStr];
    }];
}

- (IBAction)onGoTermsClick:(id)sender {
    TermsVController* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_TermsVController"];
    [self.navigationController pushViewController:mVC animated:YES];
}

- (void)gotoCustomerPage{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController* mVC = [sb instantiateViewControllerWithIdentifier:@"SID_CustomNavigation"];
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
    if([self.mNameTxt.text length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please type username."];
        return false;
    }
    if(![Common validatePhone:self.mPhoneTxt.text]){
        [self showAlertDlg:@"Warning!" Msg:@"Please type phone correctly."];
        return false;
    }
    
    if(!self.mCheckBox.on){
        [self showAlertDlg:@"Warning!" Msg:@"Please check the terms & conditions."];
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
