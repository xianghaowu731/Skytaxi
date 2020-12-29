//
//  PBookingDetailVC.m
//  Skytaxi
//
//  Created by meixiang wu on 2018/5/3.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "PBookingDetailVC.h"
#import "AppDelegate.h"
#import "AirportModel.h"
#include "InvoiceVC.h"
#import "HttpApi.h"
#import <SVProgressHUD.h>

@interface PBookingDetailVC ()

@end

@implementation PBookingDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setLayout];
}

- (void)setLayout{
    //view adjust
    if([self.data.tripType isEqualToString:@"1"]){//no return
        self.mReturnInfoView.hidden = YES;
        CGRect contentFrame = self.mContentView.frame;
        CGRect nextframe = self.mNextView.frame;
        nextframe.origin.y = 360;
        if(contentFrame.size.height < 600){
            contentFrame.size.height = 600;
            self.mContentView.frame = contentFrame;
            self.mScrollView.contentSize = self.mContentView.frame.size;
        } else{
            nextframe.size.height = contentFrame.size.height - 360;
        }
        self.mHeightConst.constant = contentFrame.size.height;
        self.mNextView.frame = nextframe;
        
    } else{
        self.mReturnInfoView.hidden = NO;
        CGRect contentFrame = self.mContentView.frame;
        CGRect rtFrame = self.mReturnInfoView.frame;
        rtFrame.origin.y = 360;
        self.mReturnInfoView.frame = rtFrame;
        CGRect nextframe = self.mNextView.frame;
        nextframe.origin.y = 550;
        nextframe.size.height = 240;
        if(contentFrame.size.height < 790){
            contentFrame.size.height = 790;
            self.mContentView.frame = contentFrame;
            self.mScrollView.contentSize = self.mContentView.frame.size;
        } else{
            nextframe.size.height = contentFrame.size.height - 550;
        }
        self.mHeightConst.constant = contentFrame.size.height;
        self.mNextView.frame = nextframe;
    }
    CGRect btnRc = self.mCompletedBtn.frame;
    btnRc.origin.y = self.mNextView.frame.size.height - 46;
    self.mCompletedBtn.frame = btnRc;
    
    //show infos
    self.mPriceLabel.text = self.data.price;
    if([self.data.statusId isEqualToString:@"6"] || [self.data.statusId isEqualToString:@"4"]){
        NSCharacterSet *nonNumbersSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
        NSString *result = [self.data.price stringByTrimmingCharactersInSet:nonNumbersSet];
        NSString* tempprice = [result stringByReplacingOccurrencesOfString:@"," withString:@""];
        NSString* subprice = [NSString stringWithFormat:@"%.2f", [tempprice floatValue] * 0.2];
        self.mPaidLabel.text = [NSString stringWithFormat:@"(paid:$%@)", subprice];
    } else{
        self.mPaidLabel.text = @"";
    }
    
    self.mPaxLabel.text = self.data.nPax;
    self.mDateLabel.text = self.data.tripDate;
    self.mBookingIDLabel.text = self.data.bookId;
    if([self.data.userId length] > 0){
        if([self.data.userInfo.firstName length] > 0){
            self.customerName.text = [NSString stringWithFormat:@"%@ %@", self.data.userInfo.firstName, self.data.userInfo.lastName];
        } else{
            self.customerName.text = self.data.userInfo.userName;
        }
    }
    
    //show details
    NSInteger nID = [self.data.airportId integerValue];
    AirportModel* one = g_airportArray[nID];
    self.mDepartName.text = one.pickup;
    self.mDepartAddress.text = one.paddr;
    self.mDestName.text = one.dest;
    self.mDestAddress.text = one.daddr;
    self.mFromTimeLabel.text = self.data.tripTime;
    NSString *arrivalTimeStr = [NSString stringWithFormat:@"%@ %@", self.data.tripDate, self.data.tripTime];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MMM-dd h:mm a"];
    NSDate *arrivalDate = [outputFormatter dateFromString:arrivalTimeStr];
    NSInteger mintime = [self.data.flightTime integerValue];
    NSDate *minHour = [arrivalDate dateByAddingTimeInterval:mintime * 60.0f];
    [outputFormatter setDateFormat:@"h:mm a"];
    NSString* totime = [outputFormatter stringFromDate:minHour];
    self.mToTimeLabel.text = totime;
    [outputFormatter setDateFormat:@"MMM dd, yyyy"];
    self.mDateLabel.text = [outputFormatter stringFromDate:arrivalDate];
    
    if([self.data.tripType isEqualToString:@"1"]){
        self.mDestTitle.text = @"Destination";
    } else if([self.data.tripType isEqualToString:@"2"]){
        self.mDestTitle.text = @"Dropoff";
    } else {
        self.mDestTitle.text = @"Dropoff";
    }
    
    if(![self.data.tripType isEqualToString:@"1"]){
        self.rtDepartName.text = one.dest;
        self.rtDepartAddress.text = one.daddr;
        self.rtDestName.text = one.pickup;
        self.rtDestAddress.text = one.paddr;
        [outputFormatter setDateFormat:@"yyyy-MMM-dd h:mm a"];
        NSDate *rtDate = [outputFormatter dateFromString:self.data.returnDate];
        NSDate *rtToDate = [rtDate dateByAddingTimeInterval:mintime * 60.0f];
        [outputFormatter setDateFormat:@"h:mm a"];
        self.rtFromTime.text = [outputFormatter stringFromDate:rtDate];
        self.rtToTime.text = [outputFormatter stringFromDate:rtToDate];
        self.mPickupTitle.text = @"Pickup";
        if([self.data.tripType isEqualToString:@"3"]){
            [outputFormatter setDateFormat:@"dd MMM"];
            self.mPickupTitle.text = [NSString stringWithFormat:@"Pickup (%@)",[outputFormatter stringFromDate:rtDate]];
        }
    }
    
    if([self.data.statusId isEqualToString:@"6"]){
        self.mCompletedBtn.enabled = NO;
        [self.mCompletedBtn setTitle:@"THIS FLIGHT HAS BEEN COMPLETED" forState:UIControlStateNormal];
    } else {
        self.mCompletedBtn.enabled = YES;
        [self.mCompletedBtn setTitle:@"CONFIRM COMPLETED FLIGHT" forState:UIControlStateNormal];
    }
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

- (IBAction)onCallClick:(id)sender {
    [self callCustomer];
}

- (IBAction)onEmailClick:(id)sender {
    UserModel *user = self.data.userInfo;
    if([user isEqual:nil])
        return;
    NSString *emailTitle = @"Welcome Skytaxi App";
    // Email Content
    NSString *messageBody = @"<h3>About Skytaxi.</h3>"; // Change the message body to HTML
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:user.email];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:YES];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    //[self.navigationController pushViewController:mc animated:YES];
}

- (IBAction)onCompleteClick:(id)sender {
    if([self.data.statusId isEqualToString:@"2"]){
        [self showAlertDlg:@"Notice" Msg:@"This flight did not be paid yet"];
        return;
    }
    [SVProgressHUD show];
    [[HttpApi sharedInstance] doCompleted:self.data.bookId Completed:^(NSString *response){
        [SVProgressHUD showSuccessWithStatus:@"Completed this flight"];
        self.data.statusId = @"6";
        [self setLayout];
    } Failed:^(NSString *errStr) {
        [SVProgressHUD showErrorWithStatus:errStr];
    }];
}

- (void)callCustomer{
    UserModel *user = self.data.userInfo;
    NSString *phoneNumber = [user.phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([phoneNumber length] == 0) return;
    NSURL *phoneUrl = [NSURL URLWithString:[@"telprompt://" stringByAppendingString:phoneNumber]];
    NSURL *phoneFallbackUrl = [NSURL URLWithString:[@"tel://" stringByAppendingString:phoneNumber]];
    
    if([[UIDevice currentDevice].systemVersion floatValue] >= 10.0){
        
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:phoneUrl options:@{}
                                         completionHandler:^(BOOL success) {
                                             NSLog(@"Open call: %d",success);
                                         }];
            } else {
                // Fallback on earlier versions
            }if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:phoneUrl options:@{}
                                         completionHandler:^(BOOL success) {
                                             NSLog(@"Open call: %d",success);
                                         }];
            } else {
                // Fallback on earlier versions
            }
        } else {
            BOOL success = [[UIApplication sharedApplication] openURL:phoneUrl];
            NSLog(@"Open call: %d",success);
        }
        
        
    }
    else{
        if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
            [[UIApplication sharedApplication] openURL:phoneUrl];
        } else if ([[UIApplication sharedApplication] canOpenURL:phoneFallbackUrl]) {
            [[UIApplication sharedApplication] openURL:phoneFallbackUrl];
        } else {
            UIAlertView *calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [calert show];
        }
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
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
