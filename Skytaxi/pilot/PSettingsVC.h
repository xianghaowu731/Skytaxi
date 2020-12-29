//
//  PSettingsVC.h
//  Skytaxi
//
//  Created by meixiang wu on 2018/4/6.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSettingsVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *mImgView;
@property (weak, nonatomic) IBOutlet UILabel *mUsernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *mEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *mHomeAddrLabel;
@property (weak, nonatomic) IBOutlet UILabel *mWorkAddrLabel;

- (IBAction)onBackClick:(id)sender;
- (IBAction)onSignoutClick:(id)sender;
- (IBAction)goTermsCondition:(id)sender;
- (IBAction)onImageClick:(id)sender;
- (IBAction)onHomeAddrChange:(id)sender;
- (IBAction)onWorkAddrChange:(id)sender;
- (IBAction)onChangeSetting:(id)sender;

@end
