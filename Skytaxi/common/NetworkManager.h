//
//  NetworkManager.h
//  novietnesGPS
//
//  Created by meixiang wu on 16/10/2017.
//  Copyright © 2017 meixiang wu. All rights reserved.
//

#ifndef NetworkManager_h
#define NetworkManager_h

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


//宏定义成功block 回调成功后得到的信息
typedef void (^HttpSuccess)(id data);
//宏定义失败block 回调失败信息
typedef void (^HttpFailure)(NSError *error);

@interface NetworkManager : NSObject<NSXMLParserDelegate,  NSURLConnectionDelegate>

+(BOOL)IsConnectionAvailable;


@end

#endif /* NetworkManager_h */
