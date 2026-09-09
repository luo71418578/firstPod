//
//  CMMThirdPart.h
//
//  Created by LHS on 2026/9/3.
//

#import <Foundation/Foundation.h>
#import "NetReachability.h"
#import "UIView+Toast.h"
#import "CMMUtility.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMMThirdPart : NSObject

//获取网络状态WIFI、4G等等
+ (NSString *)networkStatus;

// toast 文字
+ (void)toastWith:(NSString *)str;
+ (void)toastWith:(NSString *)str duration:(NSInteger)duration;
// toast Image+文字
+ (void)toastImage:(NSString *)image str:(NSString *)str;
+ (void)toastImage:(NSString *)image str:(NSString *)str position:(id)position;




@end

NS_ASSUME_NONNULL_END
