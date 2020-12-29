//
//  TermsVController.m
//  Skytaxi
//
//  Created by meixiang wu on 2018/4/2.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "TermsVController.h"

@interface TermsVController ()

@end

@implementation TermsVController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *urlAddress = @"http://skytaxiapp.com/Terms.html";
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.mWebView loadRequest:requestObj];
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
@end
