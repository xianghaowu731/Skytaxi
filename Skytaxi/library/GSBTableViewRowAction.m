//
//  GSBTableViewRowAction.m
//  ChatApp
//
//  Created by Dick Arnold on 6/11/15.
//  Copyright (c) 2015 YAKEN. All rights reserved.
//

#import "GSBTableViewRowAction.h"
#import <UIKit/UIKit.h>
@implementation GSBTableViewRowAction

+ (instancetype)rowActionWithStyle:(UITableViewRowActionStyle)style title:(NSString *)title icon:(UIImage*)icon handler:(void (^)(UITableViewRowAction *action, NSIndexPath *indexPath))handler
{
    if (title.length) title = [@"\n" stringByAppendingString:title]; // move title under centerline; icon will go above
    GSBTableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:style title:title handler:handler];
    action.icon = icon;
    return action;
}

- (void)_setButton:(UIButton*)button
{
    //if (self.font) button.titleLabel.font = self.font;
    if (self.icon) {
        [button setImage:[self.icon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        button.tintColor = button.titleLabel.textColor;
        CGSize titleSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}];
        button.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height/2 + 5), 0, 0, -titleSize.width); // +5px gap under icon
    }
}
@end

