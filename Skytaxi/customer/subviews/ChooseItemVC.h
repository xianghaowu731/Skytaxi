//
//  ChooseItemVC.h
//  Skytaxi
//
//  Created by meixiang wu on 2018/4/3.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseItemVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@property (nonatomic) NSArray* data;
@property (nonatomic) NSInteger direction;//0- down, 1- UP

-(void)ShowPopover:(UIViewController*)parent ShowAtPoint:(CGPoint)point DismissHandler:(void (^)())block;
@end
