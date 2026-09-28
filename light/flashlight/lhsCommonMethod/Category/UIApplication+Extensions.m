//
//  UIApplication+Extensions.m
//  Weibo11
//
//  Created by JYJ on 15/12/8.
//  Copyright © 2015年 itheima. All rights reserved.
//

#import "UIApplication+Extensions.h"

@implementation UIApplication (Extensions)

+ (UIImage *)launchImage {
    UIImage *image = nil;
    NSArray *launchImages = [NSBundle mainBundle].infoDictionary[@"UILaunchImages"];
    
    for (NSDictionary *dict in launchImages) {
        // 1. 将字符串转换成尺寸
        CGSize size = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        // 2. 与当前屏幕进行比较
        if (CGSizeEqualToSize(size, [UIScreen mainScreen].bounds.size)) {
            NSString *filename = dict[@"UILaunchImageName"];
            image = [UIImage imageNamed:filename];
            
            break;
        }
    }
    return image;
}

+ (UIWindow *)appSceneWindow {
    UIWindowScene *windowScene = nil;
    for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            windowScene = (UIWindowScene *)scene;
            break;
        }
    }
    return windowScene.windows.firstObject;
}

+ (UIViewController *)rootViewController {
    return [self appSceneWindow].rootViewController;
}

@end
