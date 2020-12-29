//
//  ChooseReturnWay
//
//  Created by MeiLong Jing on 8/11/16.
//  Copyright © 2016 __CompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOSAlertView.h"

@class ChooseReturnWay;

@protocol ChooseReturnWayDelegate <NSObject>

- (void)doneSaveWithChooseReturnWay:(ChooseReturnWay *)chooseReturnWay Option:(NSInteger)option;

@end

@interface ChooseReturnWay : UIView

@property (strong, nonatomic) CustomIOSAlertView *m_alertView;
@property (nonatomic, strong) id <ChooseReturnWayDelegate> delegate;
- (IBAction)onNoReturnClick:(id)sender;
- (IBAction)onSameDayClick:(id)sender;
- (IBAction)onDifferentDayClick:(id)sender;

@end
