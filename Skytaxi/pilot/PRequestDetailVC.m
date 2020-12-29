//
//  PRequestDetailVC.m
//  Skytaxi
//
//  Created by meixiang wu on 2018/4/6.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "PRequestDetailVC.h"
#import "Config.h"
#import "AppDelegate.h"
#import "AirportModel.h"
#import "BookingAcceptanceVC.h"
#import "HttpApi.h"
#import <SVProgressHUD.h>
#import "UserModel.h"

extern UserModel *pilot;
@interface PRequestDetailVC (){
    NSArray *weekdayNameArray;
}

@end

@implementation PRequestDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeoutProcess:) name:NOTIFICATION_TIME_OUT object:nil];
    weekdayNameArray = @[@"Sunday",@"Monday", @"Tuesday", @"Wednesday", @"Thursday",@"Friday",@"Saturday"];
    
    CALayer *imageLayer = self.mDepartureView.layer;
    [imageLayer setCornerRadius:2];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:PRIMARY_COLOR.CGColor];
    
    imageLayer = self.mArivalView.layer;
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

- (void)timeoutProcess:(NSNotification*)msg{
    [self.navigationController popViewControllerAnimated:YES];
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
    AirportModel* one = g_airportArray[[self.data.airportId integerValue]];
    self.mDepartLabel.text = one.pcode;
    self.mDepAddrLabel.text = one.pickup;
    self.mArivelLabel.text = one.dcode;
    self.mArivalAddrLabel.text = one.dest;
    NSInteger nPax = [self.data.nPax integerValue];
    self.mTotalPriceLabel.text = self.data.price;
    self.mCustomerLabel.text = self.data.userInfo.userName;
    
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
    self.mStartLabel.text = self.data.tripTime;
    self.mEndLabel.text = totime;
    self.mPassengerCountLabel.text = [NSString stringWithFormat:@"%ld Passengers", (long)nPax];
    self.mWeightLabel.text = [NSString stringWithFormat:@"%@ Kgs", self.data.weight];
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

- (IBAction)onAcceptClick:(id)sender {
    [SVProgressHUD show];
    [[HttpApi sharedInstance] doAccept:self.data.bookId PilotId:pilot.userId Completed:^(NSString* result){
        [SVProgressHUD dismiss];
        self.data.pilotId = pilot.userId;
        self.data.statusId = BOOK_ACCEPTED;
        BookingAcceptanceVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_BookingAcceptanceVC"];
        mVC.data = self.data;
        [self.navigationController pushViewController:mVC animated:YES];
    } Failed:^(NSString* errStr){
        [SVProgressHUD showErrorWithStatus:errStr];
    }];
}

- (IBAction)onDeclineClick:(id)sender {
    [SVProgressHUD show];
    [[HttpApi sharedInstance] doDecline:self.data.bookId PilotId:pilot.userId Completed:^(NSString* result){
        [SVProgressHUD dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    } Failed:^(NSString* errStr){
        [SVProgressHUD showErrorWithStatus:errStr];
    }];
}
@end
