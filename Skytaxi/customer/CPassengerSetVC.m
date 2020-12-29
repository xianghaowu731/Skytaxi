//
//  CPassengerSetVC.m
//  Skytaxi
//
//  Created by meixiang wu on 2018/4/3.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "CPassengerSetVC.h"
#import "AppDelegate.h"
#import "ChooseItemVC.h"
#import "CFlightDetailVC.h"
#import "Person.h"

@interface CPassengerSetVC (){
    NSInteger nPax;
}

@property (nonatomic, strong) NSArray *weightlist;

@end

@implementation CPassengerSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.weightlist = @[@"0 Kgs",@"10 Kgs", @"15 Kgs", @"20 Kgs", @"25 Kgs",@"30 Kgs", @"35 Kgs", @"40 Kgs", @"45 Kgs", @"50 Kgs", @"55 Kgs", @"60 Kgs", @"65 Kgs", @"70 Kgs", @"75 Kgs", @"80 Kgs", @"85 Kgs", @"90 Kgs", @"95 Kgs", @"100 Kgs", @"105 Kgs", @"110 Kgs", @"115 Kgs", @"120 Kgs"];
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

- (void)setLayout{
    self.mOneView.hidden = NO;
    self.mTwoView.hidden = NO;
    self.mThreeView.hidden = NO;
    self.mFourView.hidden = NO;
    nPax = [g_myBook.nPax integerValue];
    if(nPax == 1){
        self.mTwoView.hidden = YES;
        self.mThreeView.hidden = YES;
        self.mFourView.hidden = YES;
    } else if(nPax == 2){
        self.mThreeView.hidden = YES;
        self.mFourView.hidden = YES;
    } else if(nPax == 3){
        self.mFourView.hidden = YES;
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

- (IBAction)onOneWeightClick:(id)sender {
    ChooseItemVC *viewC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_ChooseItemVC"];
    viewC.data = self.weightlist;
    g_nChoose = 0;
    CGPoint point = self.mOneView.frame.origin;
    point.x+=self.mOneView.frame.size.width * 7/8;point.y+= 135;
    [viewC ShowPopover:self ShowAtPoint:point DismissHandler:^{
        self.mOneWeightLabel.text = self.weightlist[g_nChoose];
    }];
}

- (IBAction)onTwoWeightClick:(id)sender {
    ChooseItemVC *viewC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_ChooseItemVC"];
    viewC.data = self.weightlist;
    g_nChoose = 0;
    CGPoint point = self.mTwoView.frame.origin;
    point.x+=self.mTwoView.frame.size.width * 7/8;point.y+= 135;
    [viewC ShowPopover:self ShowAtPoint:point DismissHandler:^{
        self.mTwoWeightLabel.text = self.weightlist[g_nChoose];
    }];
}

- (IBAction)onThreeWeightClick:(id)sender {
    ChooseItemVC *viewC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_ChooseItemVC"];
    viewC.data = self.weightlist;
    g_nChoose = 0;
    CGPoint point = self.mThreeView.frame.origin;
    point.x+=self.mThreeView.frame.size.width * 7/8;point.y+= 135;
    [viewC ShowPopover:self ShowAtPoint:point DismissHandler:^{
        self.mThreeWeightLabel.text = self.weightlist[g_nChoose];
    }];
}

- (IBAction)onFourWeightClick:(id)sender {
    ChooseItemVC *viewC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_ChooseItemVC"];
    viewC.data = self.weightlist;
    viewC.direction = 1;//up
    g_nChoose = 0;
    CGPoint point = self.mFourView.frame.origin;
    point.x+=self.mFourView.frame.size.width * 7/8;point.y+= 135;
    [viewC ShowPopover:self ShowAtPoint:point DismissHandler:^{
        self.mFourWeightLabel.text = self.weightlist[g_nChoose];
    }];
}

- (IBAction)onFinaliseClick:(id)sender {
    if(![self checkNameFileds]){
        return;
    }
    NSString* person_str = @"";
    NSInteger weight = 0;
    if(nPax > 0 ){
        person_str = self.mOneNameTxt.text;
        NSArray *foo1 = [self.mOneWeightLabel.text componentsSeparatedByString:@" "];
        weight = [foo1[0] integerValue];
    }
    if(nPax > 1 ){
        person_str = [NSString stringWithFormat:@"%@, %@", person_str, self.mTwoNameTxt.text];
        NSArray *foo2 = [self.mTwoWeightLabel.text componentsSeparatedByString:@" "];
        weight += [foo2[0] integerValue];
    }
    if(nPax > 2 ){
        person_str = [NSString stringWithFormat:@"%@, %@", person_str, self.mThreeNameTxt.text];
        NSArray *foo3 = [self.mThreeWeightLabel.text componentsSeparatedByString:@" "];
        weight += [foo3[0] integerValue];
    }
    if(nPax > 3 ){
        person_str = [NSString stringWithFormat:@"%@, %@", person_str, self.mFourNameTxt.text];
        NSArray *foo4 = [self.mFourWeightLabel.text componentsSeparatedByString:@" "];
        weight += [foo4[0] integerValue];
    }
    g_myBook.persons = person_str;
    g_myBook.weight = [NSString stringWithFormat:@"%ld", (long)weight];
    CFlightDetailVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_CFlightDetailVC"];
    [self.navigationController pushViewController:mVC animated:YES];
}

- (BOOL) checkNameFileds{
    if(nPax > 0 ){
        if([self.mOneNameTxt.text length] == 0){
            [self showAlertDlg:@"Warning!" Msg:@"Please type first person's name."];
            return NO;
        }
    }
    if(nPax > 1 ){
        if([self.mTwoNameTxt.text length] == 0){
            [self showAlertDlg:@"Warning!" Msg:@"Please type second person's name."];
            return NO;
        }
    }
    if(nPax > 2 ){
        if([self.mThreeNameTxt.text length] == 0){
            [self showAlertDlg:@"Warning!" Msg:@"Please type third person's name."];
            return NO;
        }
    }
    if(nPax > 3 ){
        if([self.mFourNameTxt.text length] == 0){
            [self showAlertDlg:@"Warning!" Msg:@"Please type fourth person's name."];
            return NO;
        }
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
