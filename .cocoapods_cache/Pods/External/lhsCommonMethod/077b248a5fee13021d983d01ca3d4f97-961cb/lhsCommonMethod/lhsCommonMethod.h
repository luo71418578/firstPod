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
#import "thirdPart/CMMThirdPart.h"

// MARK: - 倒计时
#import "thirdPart/CountdownTimer/CountdownTimer.h"
#import "thirdPart/CutDownButton/CountDown.h"

// MARK: - 文档选择器
#import "thirdPart/DocumentPickerManager/documentPickerManager.h"

// MARK: - 定位管理
#import "thirdPart/MMLocationManager/MMLocationManager.h"

// MARK: - 颜色工具
#import "thirdPart/HexColors/HexColors.h"

// MARK: - 权限管理（LBXPermissions）
#import "thirdPart/LBXPermissions/LBXPermission.h"
#import "thirdPart/LBXPermissions/LBXPermissionBluetooth.h"
#import "thirdPart/LBXPermissions/LBXPermissionCalendar.h"
#import "thirdPart/LBXPermissions/LBXPermissionCamera.h"
#import "thirdPart/LBXPermissions/LBXPermissionContacts.h"
#import "thirdPart/LBXPermissions/LBXPermissionData.h"
#import "thirdPart/LBXPermissions/LBXPermissionHealth.h"
#import "thirdPart/LBXPermissions/LBXPermissionLocation.h"
#import "thirdPart/LBXPermissions/LBXPermissionMediaLibrary.h"
#import "thirdPart/LBXPermissions/LBXPermissionMicrophone.h"
#import "thirdPart/LBXPermissions/LBXPermissionNet.h"
#import "thirdPart/LBXPermissions/LBXPermissionNotification.h"
#import "thirdPart/LBXPermissions/LBXPermissionPhotos.h"
#import "thirdPart/LBXPermissions/LBXPermissionReminders.h"
#import "thirdPart/LBXPermissions/LBXPermissionSetting.h"
#import "thirdPart/LBXPermissions/LBXPermissionTracking.h"
#import "thirdPart/LBXPermissions/NetReachability.h"

// MARK: - Category 扩展
#import "Category/NSArray+JSON.h"
#import "Category/NSDictionary+JSON.h"
#import "Category/NSString+TransformationType.h"
#import "Category/UIApplication+Extensions.h"

// MARK: - Toast 提示
#import "thirdPart/Toast/UIView+Toast.h"

#endif /* lhsCommonMethod_h */
