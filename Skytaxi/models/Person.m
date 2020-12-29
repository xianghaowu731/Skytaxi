//
//  Person.m
//  Person
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "Person.h"

@implementation Person
- (id)initWithDictionary:(NSDictionary *)dicParams
{
    Person *item = [[Person alloc] init];
    
    item.name = [dicParams objectForKey:@"name"];
    item.weight = [dicParams objectForKey:@"weight"];
    return item;
}

@end
