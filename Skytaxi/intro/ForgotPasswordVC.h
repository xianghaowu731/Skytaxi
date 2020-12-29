//
//  ForgotPasswordVC.h
//  Skytaxi
//
//  Created by meixiang wu on 2018/3/31.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *mEmailTxt;

- (IBAction)onSignupClick:(id)sender;
- (IBAction)onReturnLogin:(id)sender;
- (IBAction)onResetPassword:(id)sender;

@end
