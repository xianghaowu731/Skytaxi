//
//  SignupVController.h
//  Skytaxi
//
//  Created by meixiang wu on 2018/3/31.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BEMCheckBox.h>

@interface SignupVController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *mEmailTxt;
@property (weak, nonatomic) IBOutlet UITextField *mPasswordTxt;
@property (weak, nonatomic) IBOutlet UITextField *mNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *mPhoneTxt;
@property (weak, nonatomic) IBOutlet UIView *mCheckView;
@property (strong, nonatomic) IBOutlet BEMCheckBox* mCheckBox;

- (IBAction)onReturnClick:(id)sender;
- (IBAction)onForgotClick:(id)sender;
- (IBAction)onSignUp:(id)sender;
- (IBAction)onGoTermsClick:(id)sender;

@end
