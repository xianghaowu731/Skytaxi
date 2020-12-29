//
//  PConfirmedRequestVC.h
//  Skytaxi
//
//  Created by meixiang wu on 2018/4/7.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookModel.h"

@interface PConfirmedRequestVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *mDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *mPaxCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *mWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *mStartTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mArrivalLabel;
@property (weak, nonatomic) IBOutlet UILabel *mArrivalDestLabel;
@property (weak, nonatomic) IBOutlet UILabel *mEndTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mConfirmImg;
@property (weak, nonatomic) IBOutlet UIImageView *mHeliImg;
@property (weak, nonatomic) IBOutlet UILabel *mBookIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *mPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *mDepFromView;
@property (weak, nonatomic) IBOutlet UIView *mDepToView;

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

@property (nonatomic) BookModel* data;

- (IBAction)onBackClick:(id)sender;
- (IBAction)onCancelClick:(id)sender;

@end
