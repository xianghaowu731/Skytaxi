//
//  NetworkManager.m
//  novietnesGPS
//
//  Created by meixiang wu on 16/10/2017.
//  Copyright © 2017 meixiang wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"
#import "Config.h"
#import "Reachability.h"

@implementation NetworkManager

+(BOOL)IsConnectionAvailable
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    return !(networkStatus == NotReachable);
}

@end
