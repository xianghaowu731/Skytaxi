//
//  CPaymentOptionVC.h
//  Skytaxi
//
//  Created by meixiang wu on 2018/4/4.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Stripe/Stripe.h>
#import <PayPalMobile.h>
#import <BEMCheckBox.h>

@interface CPaymentOptionVC : UIViewController<PayPalPaymentDelegate>
@property (weak, nonatomic) IBOutlet UIView *mCreditView;
@property (weak, nonatomic) IBOutlet UILabel *mCreditLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mCreditImg;
@property (weak, nonatomic) IBOutlet UIView *mPaypalView;
@property (weak, nonatomic) IBOutlet UILabel *mPaypalLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mPaypalImg;
@property (weak, nonatomic) IBOutlet UILabel *mBookingIDLabel;
@property (weak, nonatomic) IBOutlet UIView *mCardNumberView;
@property (weak, nonatomic) IBOutlet UILabel *mPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *mDepositLabel;
@property (weak, nonatomic) IBOutlet UIButton *mAuthorizeBtn;
@property (weak, nonatomic) IBOutlet UIView *mCreditInfoView;
@property (weak, nonatomic) IBOutlet UIButton *mDeclineBtn;
@property (weak, nonatomic) IBOutlet UIView *mCheckView;
@property (strong, nonatomic) IBOutlet BEMCheckBox* mCheckBox;
@property (weak, nonatomic) STPPaymentCardTextField *paymentTextField;

@property(nonatomic, strong, readwrite) NSString *environment;

- (IBAction)onBackClick:(id)sender;
- (IBAction)onAuthorizeClick:(id)sender;
- (IBAction)onCreditClick:(id)sender;
- (IBAction)onPaypalClick:(id)sender;
- (IBAction)onDeclineClick:(id)sender;
- (IBAction)onGoTerms:(id)sender;

@end
