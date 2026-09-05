//
//  NSString+TransformationType.h
//  EnjoyEating
//
//  Created by clz on 16/9/17.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (TransformationType)

+ (NSString *)transformationToStringFor:(id)object;

+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

+ (NSString *)arrayToString:(NSArray *)array separator:(NSString *)separator;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (CGSize)boundingRectWithText:(NSString *)text font:(CGFloat)font size:(CGSize)size;

+ (NSString *)dealWithReturnText:(NSString *)text;

@end
