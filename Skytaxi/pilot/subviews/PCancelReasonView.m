//
//  PCancelReasonView.m
//
//  Created by MeiLong Jing on 8/11/16.
//  Copyright © 2016 __CompanyName__. All rights reserved.
//

#import "PCancelReasonView.h"
#import "Config.h"

@interface PCancelReasonView ()
{
    NSString *reason;
    NSArray *reasonlist;
}

@end

@implementation PCancelReasonView

- (void)awakeFromNib {
    [super awakeFromNib];
    reason = @"";
    reasonlist = @[@"Bad Weather at pick up point",@"Bad Weather at destination", @"Aircraft Issue", @"Incorrect Passenger Details", @"Too much luggage",@"Did not arrive on time", @"Passenger incapacitated", @"Cusomer wanted refund", @"Other reasons"];
    self.mCheckBox0 = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.mCheckView0 addSubview:self.mCheckBox0];
    self.mCheckBox0.on = NO;
    self.mCheckBox0.onFillColor = YELLOW_COLOR;
    self.mCheckBox0.onTintColor = YELLOW_COLOR;
    self.mCheckBox0.tintColor = YELLOW_COLOR;
    self.mCheckBox0.onCheckColor = WHITE_COLOR;
    //UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(check0:)];
    //[self.mCheckBox0 addGestureRecognizer:singleFingerTap];
    self.mCheckBox0.onAnimationType = BEMAnimationTypeBounce;
    self.mCheckBox0.offAnimationType = BEMAnimationTypeBounce;
    self.mCheckBox0.boxType = BEMBoxTypeCircle;
    
    self.mCheckBox1 = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.mCheckView1 addSubview:self.mCheckBox1];
    self.mCheckBox1.on = NO;
    self.mCheckBox1.onFillColor = YELLOW_COLOR;
    self.mCheckBox1.onTintColor = YELLOW_COLOR;
    self.mCheckBox1.tintColor = YELLOW_COLOR;
    self.mCheckBox1.onCheckColor = WHITE_COLOR;
    self.mCheckBox1.onAnimationType = BEMAnimationTypeBounce;
    self.mCheckBox1.offAnimationType = BEMAnimationTypeBounce;
    self.mCheckBox1.boxType = BEMBoxTypeCircle;
    
    self.mCheckBox2 = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.mCheckView2 addSubview:self.mCheckBox2];
    self.mCheckBox2.on = NO;
    self.mCheckBox2.onFillColor = YELLOW_COLOR;
    self.mCheckBox2.onTintColor = YELLOW_COLOR;
    self.mCheckBox2.tintColor = YELLOW_COLOR;
    self.mCheckBox2.onCheckColor = WHITE_COLOR;
    self.mCheckBox2.onAnimationType = BEMAnimationTypeBounce;
    self.mCheckBox2.offAnimationType = BEMAnimationTypeBounce;
    self.mCheckBox2.boxType = BEMBoxTypeCircle;
    
    self.mCheckBox3 = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.mCheckView3 addSubview:self.mCheckBox3];
    self.mCheckBox3.on = NO;
    self.mCheckBox3.onFillColor = YELLOW_COLOR;
    self.mCheckBox3.onTintColor = YELLOW_COLOR;
    self.mCheckBox3.tintColor = YELLOW_COLOR;
    self.mCheckBox3.onCheckColor = WHITE_COLOR;
    self.mCheckBox3.onAnimationType = BEMAnimationTypeBounce;
    self.mCheckBox3.offAnimationType = BEMAnimationTypeBounce;
    self.mCheckBox3.boxType = BEMBoxTypeCircle;
    
    self.mCheckBox4 = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.mCheckView4 addSubview:self.mCheckBox4];
    self.mCheckBox4.on = NO;
    self.mCheckBox4.onFillColor = YELLOW_COLOR;
    self.mCheckBox4.onTintColor = YELLOW_COLOR;
    self.mCheckBox4.tintColor = YELLOW_COLOR;
    self.mCheckBox4.onCheckColor = WHITE_COLOR;
    self.mCheckBox4.onAnimationType = BEMAnimationTypeBounce;
    self.mCheckBox4.offAnimationType = BEMAnimationTypeBounce;
    self.mCheckBox4.boxType = BEMBoxTypeCircle;
    
    self.mCheckBox5 = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.mCheckView5 addSubview:self.mCheckBox5];
    self.mCheckBox5.on = NO;
    self.mCheckBox5.onFillColor = YELLOW_COLOR;
    self.mCheckBox5.onTintColor = YELLOW_COLOR;
    self.mCheckBox5.tintColor = YELLOW_COLOR;
    self.mCheckBox5.onCheckColor = WHITE_COLOR;
    self.mCheckBox5.onAnimationType = BEMAnimationTypeBounce;
    self.mCheckBox5.offAnimationType = BEMAnimationTypeBounce;
    self.mCheckBox5.boxType = BEMBoxTypeCircle;
    
    self.mCheckBox6 = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.mCheckView6 addSubview:self.mCheckBox6];
    self.mCheckBox6.on = NO;
    self.mCheckBox6.onFillColor = YELLOW_COLOR;
    self.mCheckBox6.onTintColor = YELLOW_COLOR;
    self.mCheckBox6.tintColor = YELLOW_COLOR;
    self.mCheckBox6.onCheckColor = WHITE_COLOR;
    self.mCheckBox6.onAnimationType = BEMAnimationTypeBounce;
    self.mCheckBox6.offAnimationType = BEMAnimationTypeBounce;
    self.mCheckBox6.boxType = BEMBoxTypeCircle;
    
    self.mCheckBox7 = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.mCheckView7 addSubview:self.mCheckBox7];
    self.mCheckBox7.on = NO;
    self.mCheckBox7.onFillColor = YELLOW_COLOR;
    self.mCheckBox7.onTintColor = YELLOW_COLOR;
    self.mCheckBox7.tintColor = YELLOW_COLOR;
    self.mCheckBox7.onCheckColor = WHITE_COLOR;
    self.mCheckBox7.onAnimationType = BEMAnimationTypeBounce;
    self.mCheckBox7.offAnimationType = BEMAnimationTypeBounce;
    self.mCheckBox7.boxType = BEMBoxTypeCircle;
    
    self.mCheckBox8 = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.mCheckView8 addSubview:self.mCheckBox8];
    self.mCheckBox8.on = NO;
    self.mCheckBox8.onFillColor = YELLOW_COLOR;
    self.mCheckBox8.onTintColor = YELLOW_COLOR;
    self.mCheckBox8.tintColor = YELLOW_COLOR;
    self.mCheckBox8.onCheckColor = WHITE_COLOR;
    self.mCheckBox8.onAnimationType = BEMAnimationTypeBounce;
    self.mCheckBox8.offAnimationType = BEMAnimationTypeBounce;
    self.mCheckBox8.boxType = BEMBoxTypeCircle;
    
}

- (void)doneSave
{
    [self.delegate doneSaveWithCancelReasonView:self Reason:reason];
    [self.m_alertView close];
}

- (IBAction)onBtn0Click:(id)sender {
    if(self.mCheckBox0.on){
        [self.mCheckBox0 setOn:NO];
    } else{
        [self.mCheckBox0 setOn:YES];
    }
}

- (IBAction)onBtn1Click:(id)sender {
    if(self.mCheckBox1.on){
        [self.mCheckBox1 setOn:NO];
    } else{
        [self.mCheckBox1 setOn:YES];
    }
}

- (IBAction)onBtn2Click:(id)sender {
    if(self.mCheckBox2.on){
        [self.mCheckBox2 setOn:NO];
    } else{
        [self.mCheckBox2 setOn:YES];
    }
}

- (IBAction)onBtn3Click:(id)sender {
    if(self.mCheckBox3.on){
        [self.mCheckBox3 setOn:NO];
    } else{
        [self.mCheckBox3 setOn:YES];
    }
}

- (IBAction)onBtn4Click:(id)sender {
    if(self.mCheckBox4.on){
        [self.mCheckBox4 setOn:NO];
    } else{
        [self.mCheckBox4 setOn:YES];
    }
}

- (IBAction)onBtn5Click:(id)sender {
    if(self.mCheckBox5.on){
        [self.mCheckBox5 setOn:NO];
    } else{
        [self.mCheckBox5 setOn:YES];
    }
}

- (IBAction)onBtn6Click:(id)sender {
    if(self.mCheckBox6.on){
        [self.mCheckBox6 setOn:NO];
    } else{
        [self.mCheckBox6 setOn:YES];
    }
}

- (IBAction)onBtn7Click:(id)sender {
    if(self.mCheckBox7.on){
        [self.mCheckBox7 setOn:NO];
    } else{
        [self.mCheckBox7 setOn:YES];
    }
}

- (IBAction)onBtn8Click:(id)sender {
    if(self.mCheckBox8.on){
        [self.mCheckBox8 setOn:NO];
    } else{
        [self.mCheckBox8 setOn:YES];
    }
}

- (IBAction)onDoneClick:(id)sender {
    reason = @"";
    if(self.mCheckBox0.on){
        reason = reasonlist[0];
    }
    if(self.mCheckBox1.on){
        if([reason length]>0){
            reason = [NSString stringWithFormat:@"%@, %@", reason, reasonlist[1]];
        } else{
            reason = reasonlist[1];
        }
    }
    if(self.mCheckBox2.on){
        if([reason length]>0){
            reason = [NSString stringWithFormat:@"%@, %@", reason, reasonlist[2]];
        } else{
            reason = reasonlist[2];
        }
    }
    if(self.mCheckBox3.on){
        if([reason length]>0){
            reason = [NSString stringWithFormat:@"%@, %@", reason, reasonlist[3]];
        } else{
            reason = reasonlist[3];
        }
    }
    if(self.mCheckBox4.on){
        if([reason length]>0){
            reason = [NSString stringWithFormat:@"%@, %@", reason, reasonlist[4]];
        } else{
            reason = reasonlist[4];
        }
    }
    if(self.mCheckBox5.on){
        if([reason length]>0){
            reason = [NSString stringWithFormat:@"%@, %@", reason, reasonlist[5]];
        } else{
            reason = reasonlist[5];
        }
    }
    if(self.mCheckBox6.on){
        if([reason length]>0){
            reason = [NSString stringWithFormat:@"%@, %@", reason, reasonlist[6]];
        } else{
            reason = reasonlist[6];
        }
    }
    if(self.mCheckBox7.on){
        if([reason length]>0){
            reason = [NSString stringWithFormat:@"%@, %@", reason, reasonlist[7]];
        } else{
            reason = reasonlist[7];
        }
    }
    if(self.mCheckBox8.on){
        if([reason length]>0){
            reason = [NSString stringWithFormat:@"%@, %@", reason, reasonlist[8]];
        } else{
            reason = reasonlist[8];
        }
    }
    [self doneSave];
}

- (IBAction)onCancelClick:(id)sender {
    reason = @"";
    [self.m_alertView close];
}

@end
