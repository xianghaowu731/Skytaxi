//
//  CFindPilotVC.h
//  Skytaxi
//
//  Created by meixiang wu on 2018/4/4.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFindPilotVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *mIndicatorView;

- (IBAction)onButtonClick:(id)sender;
- (IBAction)onCancelClick:(id)sender;

@end
