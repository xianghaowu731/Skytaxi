//
//  CSettingsVC.h
//  Skytaxi
//
//  Created by meixiang wu on 2018/4/2.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSettingsVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *mUserImgView;
@property (weak, nonatomic) IBOutlet UILabel *mUsernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *mEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *mHomeAddrLabel;
@property (weak, nonatomic) IBOutlet UILabel *mWorkAddrLabel;


- (IBAction)onBackClick:(id)sender;
- (IBAction)onSignOutClick:(id)sender;
- (IBAction)onTermsClick:(id)sender;
- (IBAction)onImageClick:(id)sender;
- (IBAction)onHomeAddrChange:(id)sender;
- (IBAction)onWorkAddrChange:(id)sender;
- (IBAction)onUserInfoClick:(id)sender;

@end
