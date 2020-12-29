//
//  CPassengerSetVC.h
//  Skytaxi
//
//  Created by meixiang wu on 2018/4/3.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPassengerSetVC : UIViewController
@property (weak, nonatomic) IBOutlet UIView *mOneView;
@property (weak, nonatomic) IBOutlet UIView *mTwoView;
@property (weak, nonatomic) IBOutlet UIView *mThreeView;
@property (weak, nonatomic) IBOutlet UIView *mFourView;
@property (weak, nonatomic) IBOutlet UITextField *mOneNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *mTwoNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *mThreeNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *mFourNameTxt;
@property (weak, nonatomic) IBOutlet UILabel *mOneWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *mTwoWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *mThreeWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *mFourWeightLabel;
@property (weak, nonatomic) IBOutlet UIView *mWeightView;

- (IBAction)onBackClick:(id)sender;
- (IBAction)onOneWeightClick:(id)sender;
- (IBAction)onTwoWeightClick:(id)sender;
- (IBAction)onThreeWeightClick:(id)sender;
- (IBAction)onFourWeightClick:(id)sender;
- (IBAction)onFinaliseClick:(id)sender;

@end
