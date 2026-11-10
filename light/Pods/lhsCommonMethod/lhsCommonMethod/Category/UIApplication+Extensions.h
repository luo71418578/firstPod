//
//  UIApplication+Extensions.h
//  Weibo11
//
//  Created by JYJ on 15/12/8.
//  Copyright © 2015年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (Extensions)

/**
 *  根视图控制器
 */
+ (UIViewController *)rootViewController;

/**
 *  返回当前设备对应的启动图片
 */
+ (UIImage *)launchImage;


+ (UIWindow *)appSceneWindow;

/**
 *  当前窗口尺寸（折叠屏折叠/展开、分屏等窗口变化时实时变化），窗口尚未创建时回退到屏幕尺寸
 */
+ (CGSize)appWindowSize;

/**
 *  当前窗口安全区（折叠屏展开态可能有摄像头/状态栏占位，需要按此避让）
 */
+ (UIEdgeInsets)appSafeAreaInsets;

@end
