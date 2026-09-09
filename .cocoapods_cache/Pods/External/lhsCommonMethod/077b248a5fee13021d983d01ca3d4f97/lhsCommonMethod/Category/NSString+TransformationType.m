//
//  NSString+TransformationType.m
//  EnjoyEating
//
//  Created by clz on 16/9/17.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "NSString+TransformationType.h"

@implementation NSString (TransformationType)

+ (NSString *)transformationToStringFor:(id)object{
    
    if ([object isKindOfClass:[NSString class]]) {
        
        NSString *str = (NSString *)object;
        if ([str isEqualToString:@"<null>"]) {
            
            return @"";
        }
        
        return object;
        
    }else if ([object isKindOfClass:[NSNumber class]]){
        
        NSNumber *tmp = (NSNumber *)object;
        
        return tmp.stringValue;
    }
    
    return @"";
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic{
    
    if (!dic) {
        
        return @"";
    }
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    NSRange range3 = {0,mutStr.length};
    
    [mutStr replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:range3];
    
    return mutStr;
    
}

+ (NSString *)arrayToString:(NSArray *)array separator:(NSString *)separator{
    
    if (!array) {
        
        return @"";
    }
    
    return [array componentsJoinedByString:separator];
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (CGSize)boundingRectWithText:(NSString *)text font:(CGFloat)font size:(CGSize)size {
    
    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
    para.lineBreakMode = NSLineBreakByCharWrapping;
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:font],
                          NSParagraphStyleAttributeName : para};
    
    CGSize rect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return rect;
}

+ (NSString *)dealWithReturnText:(NSString *)text{
    if([text containsString:@"<br>"]&&![text containsString:@"<br/>"]){
        return [text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    }else if ([text containsString:@"<br/>"]&&![text containsString:@"<br>"]){
        return [text stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    }else if ([text containsString:@"<br>"]&&[text containsString:@"<br/>"]){
        NSString *str1 = [text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        return [str1 stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    }else{
        return text;
    }
}


@end
