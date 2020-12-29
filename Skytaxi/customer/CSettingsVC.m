//
//  CSettingsVC.m
//  Skytaxi
//
//  Created by meixiang wu on 2018/4/2.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "CSettingsVC.h"
#import "Config.h"
#import "UserModel.h"
#import "AppDelegate.h"
#import <UIImageView+WebCache.h>
#import "TermsVController.h"
#import "HNKMapViewController.h"
#import "ImageChooser.h"
#import "Common.h"
#import "HttpApi.h"
#import <SVProgressHUD.h>
#import "ChangeSetting.h"

extern UserModel *customer;

@interface CSettingsVC ()<ChangeSettingDelegate>
@property(strong, nonatomic) UIImage* image;
@property(strong, nonatomic) ImageChooser* imgChooser;
@end

@implementation CSettingsVC{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CALayer *imageLayer = self.mUserImgView.layer;
    [imageLayer setCornerRadius:42];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
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
    [self setLayout];
}

- (void)setLayout{
    self.mUsernameLabel.text =[NSString stringWithFormat:@"%@ %@",customer.userName, customer.lastName];
    self.mPhoneLabel.text = customer.phone;
    self.mEmailLabel.text = customer.email;
    if(g_loginType == LOGIN_TYPE_SOCIAL){
        [self.mUserImgView sd_setImageWithURL:[NSURL URLWithString:customer.photo]];
    } else{
        NSString* filename = customer.photo;
        if([filename length] == 0) filename = @"default.png";
        NSString* url = [NSString stringWithFormat:@"%@%@%@", SERVER_URL, USER_PHOTO_BASE_URL, filename];
        [self.mUserImgView sd_setImageWithURL:[NSURL URLWithString:url]];
    }
    NSString* addr_str = customer.homeAddr;
    if([addr_str length] == 0) addr_str = @"Unknown Address";
    self.mHomeAddrLabel.text = addr_str;
    addr_str = customer.workAddr;
    if([addr_str length] == 0) addr_str = @"Unknown Address";
    self.mWorkAddrLabel.text = addr_str;
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

- (IBAction)onSignOutClick:(id)sender {
    [[HttpApi sharedInstance] logout:customer.userId Completed:^(NSString* result){
        
    } Failed:^(NSString *errstr){
        
    }];
    [Common setValue:@"remember_login" forKey:@"0"];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController* mVC = [sb instantiateViewControllerWithIdentifier:@"SID_SignNC"];
    [self presentViewController:mVC animated:YES completion:NULL];
}

- (IBAction)onTermsClick:(id)sender {
    TermsVController* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_TermsVController"];
    [self.navigationController pushViewController:mVC animated:YES];
}

- (IBAction)onImageClick:(id)sender {
    if(g_loginType == LOGIN_TYPE_SOCIAL){
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Update" message:@"Are you going to update photo?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                         {
                             self.imgChooser = [[ImageChooser alloc] init];
                             [self.imgChooser showActionSheet:self Completed:^(UIImage* img){
                                 //[self.mUserImgView setImage:img];
                                 self.image = img;
                                 [self uploadPhoto];
                             }];
                         }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)onHomeAddrChange:(id)sender {
    HNKMapViewController* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_HNKMapViewController"];
    mVC.mType = 1;
    mVC.user = customer;
    [self.navigationController pushViewController:mVC animated:YES];
}

- (IBAction)onWorkAddrChange:(id)sender {
    HNKMapViewController* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_HNKMapViewController"];
    mVC.mType = 2;
    mVC.user = customer;
    [self.navigationController pushViewController:mVC animated:YES];
}

- (IBAction)onUserInfoClick:(id)sender {
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    ChangeSetting *updateView = [[[NSBundle mainBundle] loadNibNamed:@"ChangeSetting" owner:self options:nil] objectAtIndex:0];
    updateView.m_alertView = alertView;
    updateView.delegate = self;
    updateView.data = customer;
    
    [alertView setContainerView:updateView];
    [alertView setButtonTitles:nil];
    [alertView setUseMotionEffects:true];
    [updateView setLayout];
    [alertView show];
}

- (void)doneSaveWithChangeSetting:(ChangeSetting *)changeSetting
{
    [self setLayout];
}

- (void)uploadPhoto{
    UIImage *small = [Common resizeImage:self.image];
    NSData *postData = UIImageJPEGRepresentation(small, 1.0);
    [SVProgressHUD show];
    [[HttpApi sharedInstance] uploadPhotoPost:postData UserID:customer.userId Completed:^(NSString *image) {
        [SVProgressHUD dismiss];
        if(g_loginType == LOGIN_TYPE_GENERAL){
            customer.photo = image;
        }
        [self setLayout];
    } Failed:^(NSString *strError) {
        [SVProgressHUD showErrorWithStatus:strError];
    }];
}
@end
