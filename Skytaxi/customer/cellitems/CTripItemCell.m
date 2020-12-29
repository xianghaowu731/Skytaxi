//
//  CTripItemCell.m
//  Skytaxi
//
//  Created by meixiang wu on 2018/4/18.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "CTripItemCell.h"

@implementation CTripItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bSelect = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
/*
-(void)didTransitionToState:(UITableViewCellStateMask)state
{
    [super didTransitionToState:state];
    if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateShowingDeleteConfirmationMask)
    {
        
        UIView *infoButton = [self infoButtonSubview:self];
        if (infoButton)
        {
            CGRect frame = infoButton.frame;
            frame.origin.y = 29;
            frame.size.height = 32;
            frame.size.width = 32;
            
            infoButton.frame = frame;
            UIImageView *infoImgV =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,32,32)];
            infoImgV.image=[UIImage imageNamed:@"ic_info.png"];
            [infoButton addSubview:infoImgV];
        }
        UIView *cancelButton = [self cancelButtonSubview:self];
        if (cancelButton)
        {
            CGRect cframe = cancelButton.frame;
            cframe.origin.y = 29;
            cframe.size.height = 32;
            cframe.size.width = 32;
            
            infoButton.frame = cframe;
            UIImageView *cancelImgV =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,32,32)];
            cancelImgV.image=[UIImage imageNamed:@"ic_cancel.png"];
            [cancelButton addSubview:cancelImgV];
        }
    }
}

- (UIView *)infoButtonSubview:(UIView *)view
{
    if ([NSStringFromClass([view class]) rangeOfString:@"Delete"].location != NSNotFound) {
        return view;
    }
    for (UIView *subview in view.subviews) {
        NSLog(@"%@",NSStringFromClass([subview class]));
        UIView *deleteButton = [self infoButtonSubview:subview];
        [deleteButton setBackgroundColor:[UIColor whiteColor]];
        if (deleteButton) {
            
            return deleteButton;
        }
    }
    return nil;
}

- (UIView *)cancelButtonSubview:(UIView *)view
{
    if ([NSStringFromClass([view class]) rangeOfString:@"CancelBtn"].location != NSNotFound) {
        return view;
    }
    for (UIView *subview in view.subviews) {
        UIView *deleteButton = [self cancelButtonSubview:subview];
        [deleteButton setBackgroundColor:[UIColor whiteColor]];
        if (deleteButton) {
            
            return deleteButton;
        }
    }
    return nil;
}
*/
@end
