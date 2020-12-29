//
//  LoginVController.h
//  Skytaxi
//
//  Created by meixiang wu on 2018/3/31.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@import GoogleSignIn;

extern UserModel* customer;
extern UserModel* pilot;

@interface LoginVController : UIViewController <GIDSignInDelegate, GIDSignInUIDelegate>
@property (weak, nonatomic) IBOutlet UITextField *mEmailTxt;
@property (weak, nonatomic) IBOutlet UITextField *mPasswordTxt;

- (IBAction)onSignupClick:(id)sender;
- (IBAction)onLogin:(id)sender;
- (IBAction)onForgotClick:(id)sender;
- (IBAction)onSigninWithFacebook:(id)sender;
- (IBAction)onSigninWithGoogle:(id)sender;

@end
