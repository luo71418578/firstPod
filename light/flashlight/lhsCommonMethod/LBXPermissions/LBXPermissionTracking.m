//
//  LBXPermissionCamera.m
//  LBXKits
//
//  Created by lbxia on 2017/9/10.
//  Copyright © 2017年 lbx. All rights reserved.
//

#import "LBXPermissionTracking.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>



@implementation LBXPermissionTracking

+ (BOOL)authorized
{
    ATTrackingManagerAuthorizationStatus status = [ATTrackingManager trackingAuthorizationStatus];
    return status == ATTrackingManagerAuthorizationStatusAuthorized;
}

+ (ATTrackingManagerAuthorizationStatus)authorizationStatus
{
    return [ATTrackingManager trackingAuthorizationStatus];
}

+ (void)authorizeWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion
{
    ATTrackingManagerAuthorizationStatus status = [ATTrackingManager trackingAuthorizationStatus];
    
    switch (status) {
        case ATTrackingManagerAuthorizationStatusNotDetermined:
        {
            // 未提示用户
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                        completion(YES,YES);
                    } else {
                        completion(NO,YES);
                    }
                });
            }];
        }
            break;
        case ATTrackingManagerAuthorizationStatusRestricted:
        case ATTrackingManagerAuthorizationStatusDenied:
        {
            completion(NO,NO);
        }
            break;
        case ATTrackingManagerAuthorizationStatusAuthorized:
        {
            completion(YES,NO);
        }
            break;
        default:
            break;
    }
}


@end
