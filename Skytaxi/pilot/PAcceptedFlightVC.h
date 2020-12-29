//
//  PAcceptedFlightVC.h
//  Skytaxi
//
//  Created by meixiang wu on 2018/4/6.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PAcceptedFlightVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *mFilterLabel;
@property (weak, nonatomic) IBOutlet UILabel *mSortLabel;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

- (IBAction)onBackClick:(id)sender;
- (IBAction)onSettingClick:(id)sender;

@end
