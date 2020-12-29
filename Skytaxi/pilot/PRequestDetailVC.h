//
//  PRequestDetailVC.h
//  Skytaxi
//
//  Created by meixiang wu on 2018/4/6.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookModel.h"

@interface PRequestDetailVC : UIViewController
@property (weak, nonatomic) IBOutlet UIView *mDepartureView;
@property (weak, nonatomic) IBOutlet UIView *mArivalView;
@property (weak, nonatomic) IBOutlet UILabel *mDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *mPassengerCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *mWeightLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mHeliImg;
@property (weak, nonatomic) IBOutlet UILabel *mTotalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *mDepartLabel;
@property (weak, nonatomic) IBOutlet UILabel *mArivelLabel;
@property (weak, nonatomic) IBOutlet UILabel *mDepAddrLabel;
@property (weak, nonatomic) IBOutlet UILabel *mArivalAddrLabel;
@property (weak, nonatomic) IBOutlet UILabel *mStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *mEndLabel;
@property (weak, nonatomic) IBOutlet UIView *mDepView;
@property (weak, nonatomic) IBOutlet UIView *mInfoView;
@property (weak, nonatomic) IBOutlet UIView *mRetView;
@property (weak, nonatomic) IBOutlet UILabel *mRetFromLabel;
@property (weak, nonatomic) IBOutlet UILabel *mRetDespLabel;
@property (weak, nonatomic) IBOutlet UILabel *mRetFromTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mRetToTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mRetDateLabel;
@property (weak, nonatomic) IBOutlet UIView *mRetFromView;
@property (weak, nonatomic) IBOutlet UIView *mRetToView;
@property (weak, nonatomic) IBOutlet UILabel *mCustomerLabel;

@property (nonatomic, strong) BookModel* data;

- (IBAction)onBackClick:(id)sender;
- (IBAction)onAcceptClick:(id)sender;
- (IBAction)onDeclineClick:(id)sender;

@end
