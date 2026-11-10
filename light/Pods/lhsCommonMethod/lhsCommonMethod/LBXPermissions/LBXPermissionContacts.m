//
//  LBXContactPermission.m
//  LBXKits
//
//  Created by lbx on 2017/9/3.
//  Copyright © 2017年 lbx. All rights reserved.
//

#import "LBXPermissionContacts.h"

@implementation LBXPermissionContacts

+ (BOOL)authorized
{
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    return status ==  CNAuthorizationStatusAuthorized;
}

/**
 access authorizationStatus

 @return CNAuthorizationStatus
 */
+ (NSInteger)authorizationStatus
{
    return [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
}

+ (void)authorizeWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion
{
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    switch (status)
    {
        case CNAuthorizationStatusAuthorized:
        {
            if (completion) {
                completion(YES,NO);
            }
        }
            break;
#if TARGET_OS_IPHONE
        case CNAuthorizationStatusLimited:
        {
            if (completion) {
                completion(YES,NO);
            }
        }
            break;
#endif
        case CNAuthorizationStatusDenied:
        case CNAuthorizationStatusRestricted:
        {
            if (completion) {
                completion(NO,NO);
            }
        }
            break;
        case CNAuthorizationStatusNotDetermined:
        {
            [[CNContactStore new] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (completion) {
                        completion(granted,YES);
                    }
                });
            }];
            
        }
            break;
    }
}

@end
