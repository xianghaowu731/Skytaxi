//
//  CPaymentOptionVC.m
//  Skytaxi
//
//  Created by meixiang wu on 2018/4/4.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "CPaymentOptionVC.h"
#import "Config.h"
#import "CPaymentConfirmVC.h"
#import "AppDelegate.h"
#import <SVProgressHUD.h>
#import "HttpApi.h"
#import "NetworkManager.h"
#import "UserModel.h"
#import "TermsVController.h"

// Set the environment:
// - For live charges, use PayPalEnvironmentProduction (default).
// - To use the PayPal sandbox, use PayPalEnvironmentSandbox.
// - For testing, use PayPalEnvironmentNoNetwork.
#define kPayPalEnvironment PayPalEnvironmentSandbox
extern UserModel *customer;
@interface CPaymentOptionVC ()<STPPaymentCardTextFieldDelegate>{
    
}
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;
@property(nonatomic) NSInteger mPayType;
@property(nonatomic) NSString *transaction_id;
@property(nonatomic) NSString *charge_id;
@property(nonatomic) NSString *paystatus;
@property(nonatomic) NSString *totalprice;
@property(nonatomic) BOOL bpaid;
@end

@implementation CPaymentOptionVC{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    STPPaymentCardTextField *paymentTextField = [[STPPaymentCardTextField alloc] init];
    paymentTextField.delegate = self;
    paymentTextField.cursorColor = [UIColor purpleColor];
    //paymentTextField.postalCodeEntryEnabled = YES;
    self.paymentTextField = paymentTextField;
    [self.paymentTextField setFrame:CGRectMake(0, 0, self.mCardNumberView.frame.size.width, self.mCardNumberView.frame.size.height)];
    [self.mCardNumberView addSubview:paymentTextField];
    
    // Set up payPalConfig
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = NO;
    _payPalConfig.merchantName = @"Skytaxi, Inc.";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    
    // Setting the languageOrLocale property is optional.
    //
    // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
    // its user interface according to the device's current language setting.
    //
    // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
    // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
    // to use that language/locale.
    //
    // For full details, including a list of available languages and locales, see PayPalPaymentViewController.h.
    
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    // Setting the payPalShippingAddressOption property is optional.
    //
    // See PayPalConfiguration.h for details.
    
    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    
    // use default environment, should be Production in real life
    self.environment = kPayPalEnvironment;
    
    NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);
    
    self.mPayType = PAYMENT_CREDIT;
    self.transaction_id = @"";
    self.charge_id = @"";
    self.bpaid = NO;
    
    self.mCheckBox = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.mCheckView addSubview:self.mCheckBox];
    self.mCheckBox.on = NO;
    self.mCheckBox.onFillColor = WHITE_COLOR;
    self.mCheckBox.onTintColor = CONTROLL_EDGE_COLOR;
    self.mCheckBox.tintColor = CONTROLL_EDGE_COLOR;
    self.mCheckBox.onCheckColor = CONTROLL_EDGE_COLOR;
    self.mCheckBox.onAnimationType = BEMAnimationTypeBounce;
    self.mCheckBox.offAnimationType = BEMAnimationTypeBounce;
    self.mCheckBox.boxType = BEMBoxTypeSquare;
    
    //self.mAuthorizeBtn.enabled = NO;
    [self setLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    // Preconnect to PayPal early
    [self setPayPalEnvironment:self.environment];
}


- (void)setLayout{
    
    switch (self.mPayType) {
        case PAYMENT_CREDIT:
            self.mCreditInfoView.hidden = NO;
            self.mCreditView.backgroundColor = PRIMARY_COLOR;
            self.mCreditLabel.textColor = WHITE_COLOR;
            [self.mCreditImg setImage:[UIImage imageNamed:@"ic_card_white.png"]];
            self.mPaypalView.backgroundColor = WHITE_COLOR;
            self.mPaypalLabel.textColor = GRAY_EDGE_COLOR;
            [self.mPaypalImg setImage:[UIImage imageNamed:@"ic_paypal_gray.png"]];
            [self.paymentTextField becomeFirstResponder];
        break;
        case PAYMENT_PAYPAL:
            self.mCreditInfoView.hidden = YES;
            self.mCreditView.backgroundColor = WHITE_COLOR;
            self.mCreditLabel.textColor = GRAY_EDGE_COLOR;
            [self.mCreditImg setImage:[UIImage imageNamed:@"ic_card_gray.png"]];
            self.mPaypalView.backgroundColor = PRIMARY_COLOR;
            self.mPaypalLabel.textColor = WHITE_COLOR;
            [self.mPaypalImg setImage:[UIImage imageNamed:@"ic_paypal_white.png"]];
        break;
        default:
            self.mCreditView.backgroundColor = PRIMARY_COLOR;
            self.mCreditLabel.textColor = WHITE_COLOR;
            [self.mCreditImg setImage:[UIImage imageNamed:@"ic_card_white.png"]];
            self.mPaypalView.backgroundColor = WHITE_COLOR;
            self.mPaypalLabel.textColor = GRAY_EDGE_COLOR;
            [self.mPaypalImg setImage:[UIImage imageNamed:@"ic_paypal_gray.png"]];
        break;
    }
    self.mBookingIDLabel.text = [NSString stringWithFormat:@"Authorize BOOKING ID : %@", g_myBook.bookId];
    
    NSCharacterSet *nonNumbersSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    NSString *result = [g_myBook.price stringByTrimmingCharactersInSet:nonNumbersSet];
    NSString* tempprice = [result stringByReplacingOccurrencesOfString:@"," withString:@""];
    self.totalprice = [NSString stringWithFormat:@"%.2f", [tempprice floatValue] * 0.2]; // 20% of total price
    self.mPriceLabel.text = [NSString stringWithFormat:@"Total Price : %@", g_myBook.price];
    self.mDepositLabel.text = [NSString stringWithFormat:@"Required Deposite Price : $%@", self.totalprice];
}

- (void)paymentCardTextFieldDidChange:(nonnull STPPaymentCardTextField *)textField {
    
}

- (void)paymentContextDidChange:(STPPaymentContext *)paymentContext {
    //self.activityIndicator.animating = paymentContext.loading;
    //self.mAuthorizeBtn.enabled = paymentContext.selectedPaymentMethod != nil;
    //self.paymentLabel.text = paymentContext.selectedPaymentMethod.label;
    //self.mCreditImg.image = paymentContext.selectedPaymentMethod.image;
}

- (void)setPayPalEnvironment:(NSString *)environment {
    self.environment = environment;
    [PayPalMobile preconnectWithEnvironment:environment];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onAuthorizeClick:(id)sender {
    if(!self.mCheckBox.on){
        [self showAlertDlg:@"Warning!" Msg:@"Please check the terms & conditions."];
        return ;
    }
    
    if(self.bpaid){//server connect failed case
        [self uploadPayInfo];
        return;
    }
    if(self.mPayType == PAYMENT_CREDIT){
        if(![self.paymentTextField isValid]){
            [self showAlertDlg:@"Warning" Msg:@"Please type card infomation again."];
            return;
        }
        [self doPayByCreditCard];
    } else{
        [self doChargeByPaypal];
    }
}

- (IBAction)onCreditClick:(id)sender {
    self.mPayType = PAYMENT_CREDIT;
    [self setLayout];
}

- (IBAction)onPaypalClick:(id)sender {
    self.mPayType = PAYMENT_PAYPAL;
    [self setLayout];
}

- (IBAction)onDeclineClick:(id)sender {
    NSString* reason = @"User can't make payment.";
    [SVProgressHUD show];
    [[HttpApi sharedInstance] requestCancel:g_myBook.bookId Reason:reason Type:@"1" Completed:^(NSString *result){
        [SVProgressHUD dismiss];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } Failed:^(NSString *errStr){
        [SVProgressHUD showErrorWithStatus:errStr];
    }];
}

- (IBAction)onGoTerms:(id)sender {
    TermsVController* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_TermsVController"];
    [self.navigationController pushViewController:mVC animated:YES];
}

- (void)doPayByCreditCard{
    if(![NetworkManager IsConnectionAvailable]){
        [self showAlertDlg:@"Network Error" Msg:@"Please check network status."];
        return;
    }
    STPCardParams *params = self.paymentTextField.cardParams;
    NSString *cardnum = params.number;
    NSString *expMonth = [NSString stringWithFormat:@"%ld",params.expMonth];
    NSString *expYear = [NSString stringWithFormat:@"%ld", params.expYear];
    
    [SVProgressHUD show];
    [[HttpApi sharedInstance] getStripeCardToken:cardnum ExpMonth:expMonth ExpYear:expYear Cvc:params.cvc Completed:^(NSString* result){
        self.transaction_id = result;
        [self doChargeByCard];
    } Failed:^(NSString *err) {
        [SVProgressHUD dismiss];
        [self showAlertDlg:@"Warning" Msg:err];
    }];
}

- (void)doChargeByCard{
    NSString *amount = [NSString stringWithFormat:@"%ld", (long)([self.totalprice floatValue] * 100)];//
    NSString *desc = [NSString stringWithFormat:@"Charge by card using Stripe for flight trip to %@", g_myBook.airportName];
    [[HttpApi sharedInstance] chargeStripeCard:amount Currency:@"aud" Strip_Id:_transaction_id Desc:desc Completed:^(NSDictionary *result) {
        [SVProgressHUD dismiss];
        self.charge_id = [result valueForKey:@"ch_id"];
        self.paystatus = [result valueForKey:@"status"];
        self.bpaid = YES;
        [self uploadPayInfo];
    } Failed:^(NSString *err) {
        [SVProgressHUD dismiss];
        [self showAlertDlg:@"Warning" Msg:err];
        self.bpaid = NO;
    }];
}

- (void)uploadPayInfo{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MMM-dd h:mm a"];
    NSString* paytime = [outputFormatter stringFromDate:[NSDate date]];
    NSString *type_str = @"Credit Card";
    if(self.mPayType == PAYMENT_PAYPAL)
        type_str = @"Paypal";
    
    NSString* amount = [NSString stringWithFormat:@"$%@", self.totalprice];
    [SVProgressHUD show];
    [[HttpApi sharedInstance] uploadPayInfo:g_myBook.bookId PayTime:paytime Type:type_str TransactionID:self.transaction_id ChargeID:self.charge_id Amount:amount Status:self.paystatus Completed:^(NSString *result){
        [SVProgressHUD dismiss];
        g_myBook.payType = type_str;
        g_myBook.pay_trans = self.transaction_id;
        g_myBook.pay_charge = self.charge_id;
        g_myBook.pay_status = self.paystatus;
        g_myBook.statusId = @"4";
        CPaymentConfirmVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_CPaymentConfirmVC"];
        mVC.data = g_myBook;
        mVC.type = 0;
        [self.navigationController pushViewController:mVC animated:YES];
    } Failed:^(NSString *errstr){
        [SVProgressHUD showErrorWithStatus:errstr];
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

- (void)doChargeByPaypal{
    //NSString *amount = [NSString stringWithFormat:@"%.2f", self.totalprice.doubleValue];
    NSString *desc = [NSString stringWithFormat:@"Charge by card using Paypal for flight trip to %@", g_myBook.airportName];
    NSString *sku_name = [NSString stringWithFormat:@"Customer-%@", customer.userId];
    // Note: For purposes of illustration, this example shows a payment that includes
    //       both payment details (subtotal, shipping, tax) and multiple items.
    //       You would only specify these if appropriate to your situation.
    //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
    //       and simply set payment.amount to your total charge.
    
    // Optional: include multiple items
    PayPalItem *item1 = [PayPalItem itemWithName:sku_name
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:self.totalprice]
                                    withCurrency:@"AUD"
                                         withSku:sku_name];
    
    NSArray *items = @[item1];
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    
    // Optional: include payment details
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0.00"];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0.00"];
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                               withShipping:shipping
                                                                                    withTax:tax];
    
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = total;
    payment.currencyCode = @"AUD";
    payment.shortDescription = desc;
    payment.items = items;  // if not including multiple items, then leave payment.items as nil
    payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:self.payPalConfig
                                                                                                     delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];
}

#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
    self.bpaid = YES;
    NSDictionary *confirmdata = completedPayment.confirmation;
    NSDictionary *response = confirmdata[@"response"];
    
    self.transaction_id = @"";
    self.charge_id = response[@"id"];
    self.paystatus = response[@"state"];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self uploadPayInfo];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
    self.bpaid = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
    [self showAlertDlg:@"Warning" Msg:@"PayPal Payment Canceled"];
}

#pragma mark - Helpers

- (void)showSuccess {
    
}
@end
