//
//  UserModel.m
//
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
- (id)initWithDictionary:(NSDictionary *)dicParams
{
    UserModel *item = [[UserModel alloc] init];
    
    item.userId = [self checkNil:[dicParams objectForKey:@"id"]];
    item.firstName = [self checkNil:[dicParams objectForKey:@"first_name"]];
    item.lastName = [self checkNil:[dicParams objectForKey:@"last_name"]];
    item.userName = [self checkNil:[dicParams objectForKey:@"username"]];
    item.email = [self checkNil:[dicParams objectForKey:@"email"]];
    item.phone = [self checkNil:[dicParams objectForKey:@"phone"]];
    item.photo = [self checkNil:[dicParams objectForKey:@"photo"]];
    item.type = [self checkNil:[dicParams objectForKey:@"type"]];
    item.homeAddr = [self checkNil:[dicParams objectForKey:@"home_addr"]];
    item.homeLoc = [self checkNil:[dicParams objectForKey:@"home_loc"]];
    item.workAddr = [self checkNil:[dicParams objectForKey:@"work_addr"]];
    item.workLoc = [self checkNil:[dicParams objectForKey:@"work_loc"]];
    
    return item;
}

- (NSString*) checkNil:(NSString*)p{
    NSString* result = p;
    if([p isEqual:nil] || [p isEqual:[NSNull null]])
        result = @"";
    return result;
}

@end
