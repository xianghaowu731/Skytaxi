//
//  HelpVController.m
//  Skytaxi
//
//  Created by meixiang wu on 2018/4/2.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "HelpVController.h"
#import "Config.h"
#import "FaqVController.h"
#import "AboutVController.h"
#import "HttpApi.h"
#import <SVProgressHUD.h>

@interface HelpVController ()

@end

@implementation HelpVController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CALayer *imageLayer = self.mMessageTxt.layer;
    [imageLayer setCornerRadius:7];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:GRAY_EDGE_COLOR.CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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

- (IBAction)onFaqClick:(id)sender {
    FaqVController* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_FaqVController"];
    [self.navigationController pushViewController:mVC animated:YES];
}

- (IBAction)onAboutClick:(id)sender {
    AboutVController* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_AboutVController"];
    [self.navigationController pushViewController:mVC animated:YES];
}

- (IBAction)onSendClick:(id)sender {
    //NSString *emailTitle = @"Welcome Skytaxi App";
    // Email Content
    NSString *messageBody = self.mMessageTxt.text; // Change the message body to HTML
    // To address
    //NSArray *toRecipents = [NSArray arrayWithObject:@"info@skytaxiapp.com"];
    NSString *toRecipents = @"info@skytaxiapp.com";
    [SVProgressHUD show];
    [[HttpApi sharedInstance]sendMail:toRecipents Msg:messageBody FromMail:self.data.email Completed:^(NSString *result) {
        [SVProgressHUD dismiss];
    } Failed:^(NSString *errStr) {
        [SVProgressHUD dismiss];
    }];
    
    
    /*MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:YES];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];*/
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
@end
