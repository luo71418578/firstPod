//
//  NSArray+JSON.m
//  renmaiyingxiao
//
//  Created by Apple on 2018/4/16.
//  Copyright © 2018年 yongdaxin. All rights reserved.
//

#import "NSArray+JSON.h"

@implementation NSArray (JSON)

- (NSString*)jsonString
{
    NSData* infoJsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    NSString* json = [[NSString alloc] initWithData:infoJsonData encoding:NSUTF8StringEncoding];
    return json;
}

+ (NSArray*)initWithJsonString:(NSString*)json
{
    
    if (json.length == 0) {
        return nil;
    }
    
    NSData* infoData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSArray* info = [NSJSONSerialization JSONObjectWithData:infoData options:0 error:nil];
    return info;
}

@end
