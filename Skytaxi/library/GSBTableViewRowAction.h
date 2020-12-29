//
//  GSBTableViewRowAction.h
//  ChatApp
//
//  Created by Dick Arnold on 6/11/15.
//  Copyright (c) 2015 YAKEN. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GSBTableViewRowAction : UITableViewRowAction
@property UIImage *icon;
//@property UIFont *font;
+ (instancetype)rowActionWithStyle:(UITableViewRowActionStyle)style title:(NSString *)title icon:(UIImage*)icon handler:(void (^)(UITableViewRowAction *action, NSIndexPath *indexPath))handler;
@end
