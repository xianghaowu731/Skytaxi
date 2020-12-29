//
//  CPaymentConfirmVC.m
//  Skytaxi
//
//  Created by meixiang wu on 2018/4/4.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "CPaymentConfirmVC.h"
#import "AppDelegate.h"
#import <CustomIOSAlertView.h>
#import "ContactOptionView.h"
#import "AirportModel.h"

@interface CPaymentConfirmVC ()<ContactOptionViewDelegate>{
    
}

@end

@implementation CPaymentConfirmVC

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

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setLayout];
}

- (void)setLayout{
    //view adjust
    if([self.data.tripType isEqualToString:@"1"]){//no return
        self.mReturnInfoView.hidden = YES;
        CGRect contentFrame = self.mScrollView.frame;
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
        CGRect contentFrame = self.mScrollView.frame;
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
    CGRect btnRc = self.mBackBtn.frame;
    btnRc.origin.y = self.mNextView.frame.size.height - 46;
    self.mBackBtn.frame = btnRc;
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
            self.pilotName.text = [NSString stringWithFormat:@"%@ %@", self.data.userInfo.firstName, self.data.userInfo.lastName];
        } else{
            self.pilotName.text = self.data.userInfo.userName;
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
        self.mMsgLabel.text = @"THIS FLIGHT HAS BEEN COMPLETED";
    } else{
        self.mMsgLabel.text = @"YOUR FLIGHT HAS BEEN CONFIRMED";
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
    if(self.type == 1){
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

- (IBAction)onSendEmailClick:(id)sender {
    
    UserModel *user = self.data.userInfo;
    NSString *emailTitle = @"Welcome Skytaxi App";
    // Email Content
    NSString *messageBody = @"<h3>To Pilot</h3>"; // Change the message body to HTML
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

- (IBAction)onNewSeachClick:(id)sender {
    //UIViewController *mainView = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-8];
    //[self.navigationController popToViewController:mainView animated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)onContactClick:(id)sender {
    [self callPilot];
    /*CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    ContactOptionView *optionView = [[[NSBundle mainBundle] loadNibNamed:@"ContactOptionView" owner:self options:nil] objectAtIndex:0];
    optionView.m_alertView = alertView;
    optionView.delegate = self;
    
    [alertView setContainerView:optionView];
    [alertView setButtonTitles:nil];
    [alertView setUseMotionEffects:true];
    [alertView show];*/
}

- (void)doneSaveWithContactOptionView:(ContactOptionView *)contactOptionView Option:(NSInteger)option
{
    if(option == 1)//Email
    {
        if([self.data.pilotId length] > 0){
            UserModel *user = self.data.userInfo;
            NSString *emailTitle = @"Welcome Skytaxi App";
            // Email Content
            NSString *messageBody = @"<h3>To Pilot</h3>"; // Change the message body to HTML
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
    } else if(option ==2)//call
    {
        [self callPilot];
    } else if(option == 3)//social
    {
        NSString *title = @"Welcome Skytaxi App";
        [self shareWithViewController:self text:title link:@"http://skytaxiapp.com"];
    }
}

- (void)callPilot{
    if([self.data.pilotId length] == 0) return;
    UserModel *user = self.data.userInfo;
    NSString *phoneNumber = [user.phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([phoneNumber length] == 0) return;
    NSURL *phoneUrl = [NSURL URLWithString:[@"telprompt://" stringByAppendingString:phoneNumber]];
    NSURL *phoneFallbackUrl = [NSURL URLWithString:[@"tel://" stringByAppendingString:phoneNumber]];
    
    if([[UIDevice currentDevice].systemVersion floatValue] >= 10.0){
        
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [[UIApplication sharedApplication] openURL:phoneUrl options:@{}
                                     completionHandler:^(BOOL success) {
                                         NSLog(@"Open call: %d",success);
                                     }];
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

- (void)shareWithViewController:(UIViewController *)viewController text:(NSString *)text link:(NSString *)link
{
    NSMutableArray *activityItems = [[NSMutableArray alloc] init];
    
    if(text.length > 0) {
        [activityItems addObject:text];
    }
    
    if(link.length > 0) {
        [activityItems addObject:[NSURL URLWithString:link]];
    }
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    //NSArray *excludeActivities = @[];
    //activityController.excludedActivityTypes = excludeActivities;
    
    [viewController presentViewController:activityController animated:YES completion:nil];
    
    [activityController setCompletionWithItemsHandler:^(UIActivityType activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        if (!completed) return;
        
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
@end
