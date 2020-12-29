//
//  CancelReasonView.h
//
//  Created by MeiLong Jing on 8/11/16.
//  Copyright © 2016 __CompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOSAlertView.h"
#import <BEMCheckBox.h>

@class CancelReasonView;

@protocol CancelReasonViewDelegate <NSObject>

- (void)doneSaveWithCancelReasonView:(CancelReasonView *)cancelReasonView Reason:(NSString*)reason;

@end

@interface CancelReasonView : UIView

@property (strong, nonatomic) CustomIOSAlertView *m_alertView;
@property (nonatomic, strong) id <CancelReasonViewDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIView *m_viewBackground;
@property (weak, nonatomic) IBOutlet UIView *mCheckView0;
@property (weak, nonatomic) IBOutlet UIView *mCheckView1;
@property (weak, nonatomic) IBOutlet UIView *mCheckView2;
@property (weak, nonatomic) IBOutlet UIView *mCheckView3;
@property (weak, nonatomic) IBOutlet UIView *mCheckView4;
@property (weak, nonatomic) IBOutlet UIView *mCheckView5;
@property (weak, nonatomic) IBOutlet UIView *mCheckView6;
@property (strong, nonatomic) IBOutlet BEMCheckBox* mCheckBox0;
@property (strong, nonatomic) IBOutlet BEMCheckBox* mCheckBox1;
@property (strong, nonatomic) IBOutlet BEMCheckBox* mCheckBox2;
@property (strong, nonatomic) IBOutlet BEMCheckBox* mCheckBox3;
@property (strong, nonatomic) IBOutlet BEMCheckBox* mCheckBox4;
@property (strong, nonatomic) IBOutlet BEMCheckBox* mCheckBox5;
@property (strong, nonatomic) IBOutlet BEMCheckBox* mCheckBox6;
- (IBAction)onBtn0Click:(id)sender;
- (IBAction)onBtn1Click:(id)sender;
- (IBAction)onBtn2Click:(id)sender;
- (IBAction)onBtn3Click:(id)sender;
- (IBAction)onBtn4Click:(id)sender;
- (IBAction)onBtn5Click:(id)sender;
- (IBAction)onBtn6Click:(id)sender;

- (IBAction)onDoneClick:(id)sender;
- (IBAction)onCancelClick:(id)sender;

@end
