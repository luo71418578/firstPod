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
#import "CountdownTimer/CountdownTimer.h"
#import "CutDownButton/CountDown.h"

// MARK: - 文档选择器
#import "DocumentPickerManager/documentPickerManager.h"

// MARK: - 定位管理
#import "MMLocationManager/MMLocationManager.h"

// MARK: - 颜色工具
#import "HexColors/HexColors.h"

// MARK: - 权限管理（LBXPermissions）
#import "LBXPermissions/LBXPermission.h"
#import "LBXPermissions/LBXPermissionBluetooth.h"
#import "LBXPermissions/LBXPermissionCalendar.h"
#import "LBXPermissions/LBXPermissionCamera.h"
#import "LBXPermissions/LBXPermissionContacts.h"
#import "LBXPermissions/LBXPermissionData.h"
#import "LBXPermissions/LBXPermissionHealth.h"
#import "LBXPermissions/LBXPermissionLocation.h"
#import "LBXPermissions/LBXPermissionMediaLibrary.h"
#import "LBXPermissions/LBXPermissionMicrophone.h"
#import "LBXPermissions/LBXPermissionNet.h"
#import "LBXPermissions/LBXPermissionNotification.h"
#import "LBXPermissions/LBXPermissionPhotos.h"
#import "LBXPermissions/LBXPermissionReminders.h"
#import "LBXPermissions/LBXPermissionSetting.h"
#import "LBXPermissions/LBXPermissionTracking.h"
#import "LBXPermissions/NetReachability.h"

// MARK: - Category 扩展
#import "Category/NSArray+JSON.h"
#import "Category/NSDictionary+JSON.h"
#import "Category/NSString+TransformationType.h"
#import "Category/UIApplication+Extensions.h"

// MARK: - Toast 提示
#import "Toast/UIView+Toast.h"

#endif /* lhsCommonMethod_h */
