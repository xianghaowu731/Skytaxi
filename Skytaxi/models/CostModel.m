//
//  CostModel.m
//  CostModel
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "CostModel.h"

@implementation CostModel
- (id)initWithDictionary:(NSDictionary *)dicParams
{
    CostModel *item = [[CostModel alloc] init];
    
    item.nr = [dicParams objectForKey:@"nr"];//no return
    item.sr = [dicParams objectForKey:@"sr"];//same day return
    item.dr = [dicParams objectForKey:@"dr"];//different day return
    item.hr = [dicParams objectForKey:@"hr"];//time(min)
    return item;
}

@end
