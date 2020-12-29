//
//  ForgotPasswordVC.m
//  Skytaxi
//
//  Created by meixiang wu on 2018/3/31.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "ForgotPasswordVC.h"
#import "SignupVController.h"
#import "Common.h"
#import "HttpApi.h"
#import <SVProgressHUD.h>

@interface ForgotPasswordVC ()

@end

@implementation ForgotPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)onSignupClick:(id)sender {
    SignupVController* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_SignupVController"];
    [self.navigationController pushViewController:mVC animated:YES];
}

- (IBAction)onReturnLogin:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)onResetPassword:(id)sender {
    if(![Common NSStringIsValidEmail:self.mEmailTxt.text]){
        [self showAlertDlg:@"Warning!" Msg:@"Please type email address correctly"];
        return;
    }
    [SVProgressHUD show];
    [[HttpApi sharedInstance] forgotPassword:self.mEmailTxt.text Completed:^(NSString *result) {
        [SVProgressHUD dismiss];
        [self showAlertDlg:@"Notice" Msg:result];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } Failed:^(NSString *errStr){
        [SVProgressHUD dismiss];
    }];
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
@end
