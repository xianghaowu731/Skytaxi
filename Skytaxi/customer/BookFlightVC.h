//
//  BookFlightVC.h
//  Skytaxi
//
//  Created by meixiang wu on 2018/4/3.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookFlightVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *mFromLabel;
@property (weak, nonatomic) IBOutlet UILabel *mToLabel;
@property (weak, nonatomic) IBOutlet UILabel *mFromDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *mToDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *mDepDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *mReturnDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *mPassengerCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *mDepTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *mToAddrView;
@property (weak, nonatomic) IBOutlet UILabel *mReturnTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *mReturnTimeView;
@property (weak, nonatomic) IBOutlet UIImageView *mReturnImg;

- (IBAction)onBackClick:(id)sender;
- (IBAction)onAddPassengerClick:(id)sender;
- (IBAction)onReturnWayClick:(id)sender;
- (IBAction)onChoosePassenger:(id)sender;
- (IBAction)onArrivalClick:(id)sender;
- (IBAction)onTimeClick:(id)sender;
- (IBAction)onDateTimeChange:(id)sender;
- (IBAction)onReturnTimeChange:(id)sender;
- (IBAction)onPickupClick:(id)sender;

@end
