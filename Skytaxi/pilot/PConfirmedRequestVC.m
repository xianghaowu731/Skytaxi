//
//  PConfirmedRequestVC.m
//  Skytaxi
//
//  Created by meixiang wu on 2018/4/7.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "PConfirmedRequestVC.h"
#import "PCancelReasonView.h"
#import "AppDelegate.h"
#import "AirportModel.h"
#import <SVProgressHUD.h>
#import "HttpApi.h"
#import "Config.h"

extern UserModel *pilot;
@interface PConfirmedRequestVC ()<PCancelReasonViewDelegate>{
    NSArray* weekdayNameArray;
}

@end

@implementation PConfirmedRequestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weekdayNameArray = @[@"Sunday",@"Monday", @"Tuesday", @"Wednesday", @"Thursday",@"Friday",@"Saturday"];
    CALayer *imageLayer = self.mDepFromView.layer;
    [imageLayer setCornerRadius:2];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:PRIMARY_COLOR.CGColor];
    
    imageLayer = self.mDepToView.layer;
    [imageLayer setCornerRadius:2];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:PRIMARY_COLOR.CGColor];
    
    imageLayer = self.mRetFromView.layer;
    [imageLayer setCornerRadius:2];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:PRIMARY_COLOR.CGColor];
    
    imageLayer = self.mRetToView.layer;
    [imageLayer setCornerRadius:2];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:PRIMARY_COLOR.CGColor];
    [self adjustLayout];
    [self setLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [self adjustLayout];
    [self setLayout];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)adjustLayout{
    CGRect infoFrame = self.mInfoView.frame;
    CGRect depFrame = self.mDepView.frame;
    CGRect retFrame = self.mRetView.frame;
    if([self.data.tripType isEqualToString:@"1"]){
        self.mRetView.hidden = YES;
        depFrame.origin.y = 180 * infoFrame.size.height / 325;
    } else {
        self.mRetView.hidden = NO;
        depFrame.origin.y = 112 * infoFrame.size.height / 325;
        retFrame.origin.y = 210 * infoFrame.size.height / 325;
    }
    self.mDepView.frame = depFrame;
    self.mRetView.frame = retFrame;
}

- (void)setLayout{
    NSInteger nID = [self.data.airportId integerValue];
    AirportModel* one = g_airportArray[nID];
    self.mArrivalLabel.text = one.dcode;
    self.mArrivalDestLabel.text = one.dest;
    self.mPriceLabel.text = self.data.price;
    NSInteger nPax = [self.data.nPax integerValue];
    
    NSString *arrivalTimeStr = [NSString stringWithFormat:@"%@ %@", self.data.tripDate, self.data.tripTime];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MMM-dd h:mm a"];
    NSDate *arrivalDate = [outputFormatter dateFromString:arrivalTimeStr];
    NSInteger deliverytime = [self.data.flightTime integerValue];
    NSDate *plusHour = [arrivalDate dateByAddingTimeInterval:deliverytime * 60.0f];
    [outputFormatter setDateFormat:@"h:mm a"];
    NSString* totime = [outputFormatter stringFromDate:plusHour];
    
    NSArray *foo = [self.data.tripDate componentsSeparatedByString:@"-"];
    NSInteger weekday = [[NSCalendar currentCalendar] component:NSCalendarUnitWeekday fromDate:arrivalDate];
    self.mDateLabel.text = [NSString stringWithFormat:@"%@, %@ %@, %@", weekdayNameArray[weekday-1], foo[2], foo[1], foo[0]];
    self.mStartTimeLabel.text = self.data.tripTime;
    self.mEndTimeLabel.text = totime;
    self.mPaxCountLabel.text = [NSString stringWithFormat:@"%ld Passengers", (long)nPax];
    
    self.mWeightLabel.text = [NSString stringWithFormat:@"%@ Kgs", self.data.weight];
    self.mBookIdLabel.text = [NSString stringWithFormat:@"Booking ID : %@", self.data.bookId];
    
    if([self.data.statusId isEqualToString:@"2"]){
        self.mConfirmImg.hidden = YES;
    }
    
    if(nPax == 4){
        [self.mHeliImg setImage:[UIImage imageNamed:@"bg_flight2.png"]];
    }
    
    if(![self.data.tripType isEqualToString:@"1"]){
        [outputFormatter setDateFormat:@"yyyy-MMM-dd h:mm a"];
        NSDate *retDate = [outputFormatter dateFromString:self.data.returnDate];
        NSDate *retPlusHour = [retDate dateByAddingTimeInterval:deliverytime * 60.0f];
        [outputFormatter setDateFormat:@"h:mm a"];
        self.mRetFromTimeLabel.text = [outputFormatter stringFromDate:retDate];
        NSString* retTotime = [outputFormatter stringFromDate:retPlusHour];
        weekday = [[NSCalendar currentCalendar] component:NSCalendarUnitWeekday fromDate:retPlusHour];
        [outputFormatter setDateFormat:@"dd MMM, yyyy"];
        NSString *retDateStr = [outputFormatter stringFromDate:retDate];
        self.mRetDateLabel.text = [NSString stringWithFormat:@"%@, %@", weekdayNameArray[weekday-1], retDateStr];
        self.mRetToTimeLabel.text = retTotime;
        self.mRetFromLabel.text = one.dcode;
        self.mRetDespLabel.text = one.dest;
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

- (IBAction)onCancelClick:(id)sender {
    // Here we need to pass a full frame
    if(![self isValidCancel]){
        return;
    }
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    PCancelReasonView *cancelView = [[[NSBundle mainBundle] loadNibNamed:@"PCancelReasonView" owner:self options:nil] objectAtIndex:0];
    cancelView.m_alertView = alertView;
    cancelView.delegate = self;
    
    [alertView setContainerView:cancelView];
    [alertView setButtonTitles:nil];
    [alertView setUseMotionEffects:true];
    [alertView show];
}

- (void)doneSaveWithCancelReasonView:(PCancelReasonView *)cancelReasonView Reason:(NSString *)reason
{
    if([reason length] > 0){
        [SVProgressHUD show];
        [[HttpApi sharedInstance] requestCancel:self.data.bookId Reason:reason Type:@"2" Completed:^(NSString *result){
            [SVProgressHUD dismiss];
            [self.navigationController popViewControllerAnimated:YES];
        } Failed:^(NSString *errStr){
            [SVProgressHUD showErrorWithStatus:errStr];
        }];
    }
}

- (BOOL)isValidCancel{
    NSDate* curDate = [NSDate date];
    NSString *arrivalTimeStr = [NSString stringWithFormat:@"%@ %@", self.data.tripDate, self.data.tripTime];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MMM-dd h:mm a"];
    NSDate *arrivalDate = [outputFormatter dateFromString:arrivalTimeStr];
    NSTimeInterval distanceBetweenDates = [arrivalDate timeIntervalSinceDate:curDate];
    double secondsInAnHour = 3600;
    NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
    
    //if([self.data.statusId isEqualToString:@"6"]){//completed status
    //    [self showAlertDlg:@"Warning" Msg:@"This flight has completed already. You can't cancel this flight."];
    //    return NO;
    //}
    
    if(hoursBetweenDates < 0){
        return NO;
    }
    return YES;
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
