//
//  Common.h
//  Foods
//
//  Created by Jin_Q on 3/17/16.
//  Copyright © 2016 Jin_Q. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Common : NSObject
+ (NSString *)convertHTML:(NSString *)html;
+ (NSString *) getValueKey:(NSString *)key;
+ (void) saveValueKey:(NSString *)key
                Value:(NSString *)value ;
+ (id) getObjectWithKey:(NSString *)key;
+ (void) saveObjectWithKey:(NSString *)key
                     Value:(id)value ;
+ (BOOL) isStringEmpty:(NSString *)string;
+ (UIImage *)resizeImage:(UIImage *)image;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

+(NSString *)replaceStringwithString:(NSString *)mainString strTobeReplaced:(NSString *)strTobeReplaced stringReplaceWith:(NSString *)stringReplaceWith;

+(BOOL) NSStringIsValidEmail:(NSString *)checkString;
+ (BOOL)validatePhone:(NSString *)phoneNumber;

@end
