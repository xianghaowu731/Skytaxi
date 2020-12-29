//
//  CFlightDetailVC.m
//  Skytaxi
//
//  Created by meixiang wu on 2018/4/4.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "CFlightDetailVC.h"
#import "Config.h"
#import "AppDelegate.h"
#import "AirportModel.h"
#import "CFindPilotVC.h"
#import "Person.h"
#import "HttpApi.h"
#import <SVProgressHUD.h>
#import "UserModel.h"
#import "NetworkManager.h"
#import "Common.h"

extern UserModel *customer;
@interface CFlightDetailVC (){
    NSArray *weekdayNameArray;
}

@end

@implementation CFlightDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void)adjustLayout{
    CGRect infoFrame = self.mInfoView.frame;
    CGRect depFrame = self.mDepView.frame;
    CGRect retFrame = self.mRetView.frame;
    if([g_myBook.tripType isEqualToString:@"1"]){
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
    NSInteger nID = [g_myBook.airportId integerValue];
    AirportModel* one = g_airportArray[nID];
    self.mDepartLabel.text = one.pcode;
    self.mDepAddrLabel.text = one.pickup;
    self.mArivelLabel.text = one.dcode;
    self.mArivalAddrLabel.text = one.dest;
    self.mTotalPriceLabel.text = g_myBook.price;
    NSInteger nPax = [g_myBook.nPax integerValue];
    
    NSString *arrivalTimeStr = [NSString stringWithFormat:@"%@ %@", g_myBook.tripDate, g_myBook.tripTime];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MMM-dd h:mm a"];
    NSDate *arrivalDate = [outputFormatter dateFromString:arrivalTimeStr];
    NSInteger deliverytime = [g_myBook.flightTime integerValue];
    NSDate *plusHour = [arrivalDate dateByAddingTimeInterval:deliverytime * 60.0f];
    [outputFormatter setDateFormat:@"h:mm a"];
    NSString* totime = [outputFormatter stringFromDate:plusHour];
    
    NSArray *foo = [g_myBook.tripDate componentsSeparatedByString:@"-"];
    NSInteger weekday = [[NSCalendar currentCalendar] component:NSCalendarUnitWeekday fromDate:arrivalDate];
    self.mDateLabel.text = [NSString stringWithFormat:@"%@, %@ %@, %@", weekdayNameArray[weekday-1], foo[2], foo[1], foo[0]];
    self.mStartLabel.text = g_myBook.tripTime;
    self.mEndLabel.text = totime;
    self.mPassengerCountLabel.text = [NSString stringWithFormat:@"%ld Passengers", (long)nPax];
    self.mWeightLabel.text = [NSString stringWithFormat:@"%@ Kgs", g_myBook.weight];
    self.mHeliTypeLabel.text = @"Robinson 44";
    if(nPax == 4){
        [self.mHeliImg setImage:[UIImage imageNamed:@"bg_flight2.png"]];
        self.mHeliTypeLabel.text = @"Bell 206";
    }
    
    if(![g_myBook.tripType isEqualToString:@"1"]){
        [outputFormatter setDateFormat:@"yyyy-MMM-dd h:mm a"];
        NSDate *retDate = [outputFormatter dateFromString:g_myBook.returnDate];
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

- (IBAction)onRequestClick:(id)sender {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MMM-dd h:mm a"];
    NSString* booktime_str = [outputFormatter stringFromDate:[NSDate date]];
    if(![NetworkManager IsConnectionAvailable]){
        [self showAlertDlg:@"Network Error" Msg:@"Please check network status."];
        return;
    }
    [SVProgressHUD show];
    [[HttpApi sharedInstance]requestBook:customer.userId
                               AirportId:g_myBook.airportId
                             AirportName:g_myBook.airportName
                                TripDate:g_myBook.tripDate
                                TripTime:g_myBook.tripTime
                                    NPax:g_myBook.nPax
                                 Persons:g_myBook.persons
                                  Weight:g_myBook.weight
                                TripType:g_myBook.tripType
                              FlightTime:g_myBook.flightTime
                                 RetTime:g_myBook.returnDate
                                   Price:g_myBook.price
                                BookTime:booktime_str
                               Completed:^(NSString* result){
                                   [SVProgressHUD dismiss];
                                   g_myBook.bookId = result;
                                   g_myBook.bookTime = booktime_str;
                                   g_waitingStatus = 1;
                                   CFindPilotVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_CFindPilotVC"];
                                   [self.navigationController pushViewController:mVC animated:YES];
                               } Failed:^(NSString *errstr){
                                   [SVProgressHUD showErrorWithStatus:errstr];
                               }];
    
}

- (IBAction)onBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
