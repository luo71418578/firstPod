//
//  lhsCommonMethod.h
//  lhsCommonMethod
//
//  统一头文件（Umbrella Header）
//  通过 CocoaPods 安装后，只需 #import "lhsCommonMethod.h" 即可引用所有公开接口
//

#ifndef lhsCommonMethod_h
#define lhsCommonMethod_h

// MARK: - 核心工具类
#import "CMMUtility.h"
#import "HWToolBox.h"
#import "lhsDataMacros.h"
// #import "SLBLoadingView.h"  // 文件当前不存在
#import "TLJumpNavManager.h"

// MARK: - 第三方组件封装
#import "CMMThirdPart.h"

// MARK: - 倒计时
#import "CountdownTimer.h"
#import "CountDown.h"

// MARK: - 文档选择器
#import "documentPickerManager.h"

// MARK: - 定位管理
#import "MMLocationManager.h"

// MARK: - 颜色工具
#import "HexColors.h"

// MARK: - 权限管理（LBXPermissions）
#import "LBXPermission.h"
#import "LBXPermissionBluetooth.h"
#import "LBXPermissionCalendar.h"
#import "LBXPermissionCamera.h"
#import "LBXPermissionContacts.h"
#import "LBXPermissionData.h"
#import "LBXPermissionHealth.h"
#import "LBXPermissionLocation.h"
#import "LBXPermissionMediaLibrary.h"
#import "LBXPermissionMicrophone.h"
#import "LBXPermissionNet.h"
#import "LBXPermissionNotification.h"
#import "LBXPermissionPhotos.h"
#import "LBXPermissionReminders.h"
#import "LBXPermissionSetting.h"
#import "LBXPermissionTracking.h"
#import "NetReachability.h"

// MARK: - Category 扩展
#import "NSArray+JSON.h"
#import "NSDictionary+JSON.h"
#import "NSString+TransformationType.h"
#import "UIApplication+Extensions.h"

// MARK: - Toast 提示
#import "UIView+Toast.h"

#endif /* lhsCommonMethod_h */
