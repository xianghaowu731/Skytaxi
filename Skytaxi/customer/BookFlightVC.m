//
//  BookFlightVC.m
//  Skytaxi
//
//  Created by meixiang wu on 2018/4/3.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "BookFlightVC.h"
#import "Config.h"
#import "ChooseItemVC.h"
#import "AppDelegate.h"
#import "CPassengerSetVC.h"
#import "AirportModel.h"
#import "BookModel.h"
#import "CostModel.h"
#import "ChooseDateView.h"
#import "ChooseReturnWay.h"

@interface BookFlightVC ()<ChooseDateViewDelegate, ChooseReturnWayDelegate>{
    NSInteger mTripType;
    NSArray* PassengerList;
    NSArray* weekdayNameArray;
    NSArray* returnTypeArray;
    NSInteger returnType;
    NSInteger nChoosePax;
    NSInteger nAirportId;
    NSInteger nChooseDateType;//1- depdate, 2- deptime, 3-return date, 4-return time
    NSString* chooseDate;//tripdate
    NSString* returnDate;//returndate
    NSArray* PickupArray;
    BOOL bfirst;
    NSArray* depTimeArray;
    NSArray* retTimeArray;
    NSInteger nDepTimeInd;
    NSInteger nRetTimeInd;
}

@end

@implementation BookFlightVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    g_myBook = [[BookModel alloc] init];
    
    PassengerList = @[@"1 PAX", @"2 PAX", @"3 PAX", @"4 PAX"];
    weekdayNameArray = @[@"Sunday",@"Monday", @"Tuesday", @"Wednesday", @"Thursday",@"Friday",@"Saturday"];
    returnTypeArray = @[@"Same Day Return", @"Differnt Day Return"];
    PickupArray = @[@"Bankstown Airport"];
    depTimeArray = @[@"7:00 am", @"8:00 am", @"9:00 am", @"10:00 am", @"11:00 am", @"12:00 pm"];
    retTimeArray = @[@"12:00 pm", @"1:00 pm", @"2:00 pm", @"3:00 pm"];
    mTripType = TRIP_TYPE_ONEWAY;
    returnType = 0;
    nChoosePax = 1;
    nAirportId = 0;
    nChooseDateType = 1;
    chooseDate = @"";
    returnDate = @"";
    bfirst = YES;
    nDepTimeInd = 0;
    nRetTimeInd = 0;
    
    [self initDate];
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

- (void)setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners
{
    UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                  byRoundingCorners:corners
                                                        cornerRadii:CGSizeMake(5.0, 5.0)];
    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    view.layer.mask = shape;
}

- (void)initDate{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"h:mm a"];
    NSString *timestr = [outputFormatter stringFromDate:[NSDate date]];
    [outputFormatter setDateFormat:@"yyyy-MMM-dd"];
    chooseDate = [outputFormatter stringFromDate:[NSDate date]];
    [outputFormatter setDateFormat:@"MMM dd, yyyy"];
    NSString *dateStr = [outputFormatter stringFromDate:[NSDate date]];
    self.mDepTimeLabel.text = depTimeArray[nDepTimeInd];
    self.mDepDateLabel.text = dateStr;
    NSDate *today = [NSDate date];
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *tomorrow = [today dateByAddingTimeInterval:secondsPerDay];
    self.mReturnDateLabel.text = [outputFormatter stringFromDate:tomorrow];
    self.mReturnTimeLabel.text = retTimeArray[nRetTimeInd];
    [outputFormatter setDateFormat:@"yyyy-MMM-dd"];
    returnDate = [outputFormatter stringFromDate:tomorrow];
}

- (void)setLayout{
    if(mTripType == TRIP_TYPE_ONEWAY){
        [self.mReturnImg setImage:[UIImage imageNamed:@"ic_oneway.png"]];
        if(bfirst){
            self.mReturnDateLabel.text = @"Return Flight?";
        } else{
            self.mReturnDateLabel.text = @"No Return Required";
        }
        self.mReturnTimeView.hidden = YES;
    } else{
        [self.mReturnImg setImage:[UIImage imageNamed:@"ic_returnway.png"]];
        self.mReturnTimeView.hidden = NO;
        if(returnType == 0){
            self.mReturnDateLabel.text = self.mDepDateLabel.text;
            returnDate = chooseDate;
        }
    }
    AirportModel* one = g_airportArray[nAirportId];
    self.mFromLabel.text = one.pcode;
    self.mFromDescLabel.text = one.pickup;
    self.mToLabel.text = one.dcode;
    self.mToDescLabel.text = one.dest;
    self.mPassengerCountLabel.text = [NSString stringWithFormat:@"%ld",nChoosePax];
    self.mDepTimeLabel.text = depTimeArray[nDepTimeInd];
    self.mReturnTimeLabel.text = retTimeArray[nRetTimeInd];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setLayout];
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

- (BOOL)validateData{
    if(mTripType == TRIP_TYPE_ONEWAY){
        return YES;
    }
    NSString* fromStr = [NSString stringWithFormat:@"%@ %@", chooseDate, self.mDepTimeLabel.text];
    NSString* toStr = [NSString stringWithFormat:@"%@ %@", returnDate, self.mReturnTimeLabel.text];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MMM-dd h:mm a"];
    NSDate* fromDate = [outputFormatter dateFromString:fromStr];
    NSDate* toDate = [outputFormatter dateFromString:toStr];
    NSComparisonResult bCompare = [fromDate compare: toDate];
    if(bCompare == NSOrderedAscending){
        return YES;
    }
    return NO;
}

- (IBAction)onAddPassengerClick:(id)sender {
    if(![self validateData]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning!"
                                                                       message:@"Please enter Date and Time correctly."
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               
                                                           }];
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    AirportModel *one = g_airportArray[nAirportId];
    g_myBook.airportId = [NSString stringWithFormat:@"%ld", (long)nAirportId];
    g_myBook.airportName = one.dest;
    g_myBook.tripTime = self.mDepTimeLabel.text;
    g_myBook.tripDate = chooseDate;
    g_myBook.returnDate = [NSString stringWithFormat:@"%@ %@", returnDate, self.mReturnTimeLabel.text];
    g_myBook.nPax = self.mPassengerCountLabel.text;
    if(mTripType == TRIP_TYPE_ONEWAY){
        g_myBook.tripType = @"1";
        if(nChoosePax == 1){
            g_myBook.flightTime = one.pax1.hr;
            g_myBook.price = one.pax1.nr;
        } else if(nChoosePax == 4){
            g_myBook.flightTime = one.pax4.hr;
            g_myBook.price = one.pax4.nr;
        } else{
            g_myBook.flightTime = one.paxs.hr;
            g_myBook.price = one.paxs.nr;
        }
        
    } else{
        if(returnType == 0){
            g_myBook.tripType = @"2";//same day return
            if(nChoosePax == 1){
                g_myBook.flightTime = one.pax1.hr;
                g_myBook.price = one.pax1.sr;
            } else if(nChoosePax == 4){
                g_myBook.flightTime = one.pax4.hr;
                g_myBook.price = one.pax4.sr;
            } else{
                g_myBook.flightTime = one.paxs.hr;
                g_myBook.price = one.paxs.sr;
            }
        } else{
            g_myBook.tripType = @"3";//different day return
            if(nChoosePax == 1){
                g_myBook.flightTime = one.pax1.hr;
                g_myBook.price = one.pax1.dr;
            } else if(nChoosePax == 4){
                g_myBook.flightTime = one.pax4.hr;
                g_myBook.price = one.pax4.dr;
            } else{
                g_myBook.flightTime = one.paxs.hr;
                g_myBook.price = one.paxs.dr;
            }
        }
    }
    CPassengerSetVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_CPassengerSetVC"];
    [self.navigationController pushViewController:mVC animated:YES];
}

- (IBAction)onArrivalClick:(id)sender {
    NSMutableArray* tempArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < g_airportArray.count; i++){
        AirportModel *one = g_airportArray[i];
        NSString* name = one.dest;
        [tempArray addObject:name];
    }
    ChooseItemVC *viewC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_ChooseItemVC"];
    viewC.data = tempArray;
    g_nChoose = nAirportId;
    CGPoint point = self.mToAddrView.frame.origin;
    point.x+=self.mFromDescLabel.frame.size.width/2;point.y+= (100 +self.mToDescLabel.frame.size.height);
    [viewC ShowPopover:self ShowAtPoint:point DismissHandler:^{
        nAirportId = g_nChoose;
        [self setLayout];
    }];
}

- (IBAction)onChoosePassenger:(id)sender {
    ChooseItemVC *viewC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_ChooseItemVC"];
    viewC.data = PassengerList;
    //viewC.direction = 1;
    g_nChoose = nChoosePax-1;
    CGPoint point = self.mToAddrView.frame.origin;
    point.x+=self.mFromDescLabel.frame.size.width;point.y += (160 + self.mPassengerCountLabel.frame.size.height);
    [viewC ShowPopover:self ShowAtPoint:point DismissHandler:^{
        nChoosePax = g_nChoose+1;
        [self setLayout];
    }];
}

- (IBAction)onTimeClick:(id)sender {
    ChooseItemVC *viewC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_ChooseItemVC"];
    viewC.data = depTimeArray;
    g_nChoose = nDepTimeInd;
    CGPoint point = self.mToAddrView.frame.origin;
    point.x+=self.mFromDescLabel.frame.size.width * 3/4;point.y+= (160 +self.mDepTimeLabel.frame.size.height);
    [viewC ShowPopover:self ShowAtPoint:point DismissHandler:^{
        nDepTimeInd = g_nChoose;
        [self setLayout];
    }];
}

- (IBAction)onDateTimeChange:(id)sender {
    nChooseDateType = 1;
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    ChooseDateView *chooseView = [[[NSBundle mainBundle] loadNibNamed:@"ChooseDateView" owner:self options:nil] objectAtIndex:0];
    chooseView.m_alertView = alertView;
    chooseView.delegate = self;
    chooseView.type = 0;
    chooseView.mDate = [NSDate date];
    [chooseView setLayout];
    
    [alertView setContainerView:chooseView];
    [alertView setButtonTitles:nil];
    [alertView setUseMotionEffects:true];
    [alertView show];
    
}

- (void)doneSaveWithChooseDateView:(ChooseDateView *)chooseDateView Option:(NSDate *)option
{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    switch (nChooseDateType) {
        case 1:
            [outputFormatter setDateFormat:@"yyyy-MMM-dd"];
            chooseDate = [outputFormatter stringFromDate:option];
            [outputFormatter setDateFormat:@"MMM dd, yyyy"];
            self.mDepDateLabel.text = [outputFormatter stringFromDate:option];
            break;
        case 2:
            [outputFormatter setDateFormat:@"h:mm a"];
            self.mDepTimeLabel.text = [outputFormatter stringFromDate:option];
            break;
        case 3:
            [outputFormatter setDateFormat:@"yyyy-MMM-dd"];
            returnDate = [outputFormatter stringFromDate:option];
            [outputFormatter setDateFormat:@"MMM dd, yyyy"];
            self.mReturnDateLabel.text = [outputFormatter stringFromDate:option];
            break;
        case 4:
            [outputFormatter setDateFormat:@"h:mm a"];
            self.mReturnTimeLabel.text = [outputFormatter stringFromDate:option];
            break;
        default:
            break;
    }
    [self setLayout];
}

- (IBAction)onReturnWayClick:(id)sender {
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    ChooseReturnWay *returnView = [[[NSBundle mainBundle] loadNibNamed:@"ChooseReturnWay" owner:self options:nil] objectAtIndex:0];
    returnView.m_alertView = alertView;
    returnView.delegate = self;
    
    [alertView setContainerView:returnView];
    [alertView setButtonTitles:nil];
    [alertView setUseMotionEffects:true];
    [alertView show];
}

- (void)doneSaveWithChooseReturnWay:(ChooseReturnWay *)chooseReturnWay Option:(NSInteger)option{
    if(option == 0){
        mTripType = TRIP_TYPE_ONEWAY;
    } else if(option == 1){
        mTripType = TRIP_TYPE_ROUND;
        returnType = 0;
    } else {
        mTripType = TRIP_TYPE_ROUND;
        returnType = 1;
        nChooseDateType = 3;
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
        ChooseDateView *chooseView = [[[NSBundle mainBundle] loadNibNamed:@"ChooseDateView" owner:self options:nil] objectAtIndex:0];
        chooseView.m_alertView = alertView;
        chooseView.delegate = self;
        chooseView.type = 0;
        NSDate *today = [NSDate date];
        NSTimeInterval secondsPerDay = 24 * 60 * 60;
        NSDate *tomorrow = [today dateByAddingTimeInterval:secondsPerDay];
        chooseView.mDate = tomorrow;
        [chooseView setLayout];
        
        [alertView setContainerView:chooseView];
        [alertView setButtonTitles:nil];
        [alertView setUseMotionEffects:true];
        [alertView show];
    }
    bfirst = NO;
    [self setLayout];
}

- (IBAction)onReturnTimeChange:(id)sender {
    ChooseItemVC *viewC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_ChooseItemVC"];
    viewC.data = retTimeArray;
    g_nChoose = nRetTimeInd;
    CGPoint point = self.mToAddrView.frame.origin;
    point.x+=self.mFromDescLabel.frame.size.width * 3 /4;point.y+= (210 +self.mDepTimeLabel.frame.size.height);
    [viewC ShowPopover:self ShowAtPoint:point DismissHandler:^{
        nRetTimeInd = g_nChoose;
        [self setLayout];
    }];
}

- (IBAction)onPickupClick:(id)sender {
    ChooseItemVC *viewC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_ChooseItemVC"];
    viewC.data = PickupArray;
    CGPoint point = self.mToAddrView.frame.origin;
    point.x+=self.mFromDescLabel.frame.size.width/2;point.y+= (55 +self.mToDescLabel.frame.size.height);
    [viewC ShowPopover:self ShowAtPoint:point DismissHandler:^{
        //nAirportId = g_nChoose;
        [self setLayout];
    }];
}
@end
