//
//  NSArray+JSON.h
//  renmaiyingxiao
//
//  Created by Apple on 2018/4/16.
//  Copyright © 2018年 yongdaxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (JSON)

- (NSString*)jsonString;
+ (NSArray*)initWithJsonString:(NSString*)json;


@end
