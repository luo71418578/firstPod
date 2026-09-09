//
//  lhsDataMacros.h
//  YYElectricMoto
//
//  Created by PC-IT-LHS on 2025/11/29.
//

#ifndef lhsDataMacros_h
#define lhsDataMacros_h

#import "HexColors.h"
#import "UIApplication+Extensions.h"

//颜色设置
#define  colorWith(string)   [UIColor hx_colorWithHexRGBAString:string]

//字体大小设置
#define  fontSize(size) [UIFont systemFontOfSize:size]

#define fontBoldSize(size) [UIFont fontWithName:@"Helvetica-Bold" size:size]

//字符串是否为空
#define  kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

//数组是否为空
#define  kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)

//字典是否为空
#define  kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)

//是否是字典
#define isDict(obj) ( [obj isKindOfClass:[NSDictionary class]] ? YES : NO )

//是否是字符串
#define isString(obj) ( [obj isKindOfClass:[NSString class]] ? YES : NO )

//是否是数组
#define isArray(obj) ( [obj isKindOfClass:[NSArray class]] ? YES : NO )

//是否是数字
#define isNumber(obj) ( [obj isKindOfClass:[NSNumber class]] ? YES : NO )

// 屏幕宽度
#define  SLBScreenW  [UIScreen mainScreen].bounds.size.width
// 屏幕高度
#define  SLBScreenH  [UIScreen mainScreen].bounds.size.height
// 状态栏高度
#define  SLBStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height

// 安全区域顶部高度
#define  SLBSafeAreaTopHeight  [UIApplication sharedApplication].statusBarFrame.size.height + SLBNavBarHeight

#define hasLiuHai     [UIApplication sharedApplication].statusBarFrame.size.height > 20
#define SLBStatusBarHeight  [UIApplication sharedApplication].statusBarFrame.size.height

//导航栏高度
#define SLBNavBarHeight 44.0

#define SLBTabBarHeight (hasLiuHai ? 83.0 : 49.0)

//是否是iPhone X系列
#define isIphoneX (hasLiuHai ? YES : NO)

//状态栏高度 + 导航栏高度
#define SLBNavHeight (SLBStatusBarHeight + SLBNavBarHeight)

//RGB颜色
#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define HexColor(hex) [UIColor colorWithHexString:hex]

//弱引用
#define WeakSelf(type)  __weak typeof(type) weak##type = type;

//强引用
#define StrongSelf(type)  __strong typeof(type) strong##type = type;

//角度转弧度
#define DegreesToRadian(x) (M_PI * (x) / 180.0)

//弧度转角度
#define RadianToDegrees(x) (180.0 * (x) / M_PI)

//系统版本
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//判断是否大于某个版本
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

//判断是否大于等于某个版本
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

//判断是否小于某个版本
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

//判断是否小于等于某个版本
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//是否是iOS11及以上
#define isIOS11 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")

//是否是iOS13及以上
#define isIOS13 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"13.0")

//是否是iOS14及以上
#define isIOS14 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"14.0")

//是否是iOS15及以上
#define isIOS15 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"15.0")

//是否是iOS16及以上
#define isIOS16 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"16.0")

//获取keyWindow
#define SLBKeyWindow [UIApplication sharedApplication].keyWindow

//获取当前控制器
#define SLBCurrentVC [UIApplication sharedApplication].delegate.window.rootViewController

//获取App版本号
#define SLBAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

//获取App build号
#define SLBAppBuild [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

//获取App名称
#define SLBAppName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

//获取当前时间戳
#define SLBCurrentTime [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]

//获取当前日期
#define SLBCurrentDate [NSDate date]

//格式化日期
#define SLBDateFormat(date, format) [NSDateFormatter localizedStringFromDate:date dateStyle:format timeStyle:format]

//字符串转日期
#define SLBStringToDate(string, format) [NSDateFormatter dateFromString:string format:format]

//日期转字符串
#define SLBDateToString(date, format) [NSDateFormatter stringFromDate:date format:format]

//判断是否是手机号码
#define isPhoneNumber(phone) ([phone isKindOfClass:[NSString class]] && phone.length == 11 && [phone hasPrefix:@"1"])

//判断是否是邮箱
#define isEmail(email) ([email isKindOfClass:[NSString class]] && [email containsString:@"@"] && [email containsString:@"."])

//判断是否是URL
#define isURL(url) ([url isKindOfClass:[NSString class]] && [url hasPrefix:@"http"])

//判断是否是空字符串
#define isEmptyString(string) (string == nil || [string isKindOfClass:[NSNull class]] || ([string isKindOfClass:[NSString class]] && string.length == 0))

//判断是否是空数组
#define isEmptyArray(array) (array == nil || [array isKindOfClass:[NSNull class]] || ([array isKindOfClass:[NSArray class]] && array.count == 0))

//判断是否是空字典
#define isEmptyDictionary(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || ([dic isKindOfClass:[NSDictionary class]] && dic.allKeys.count == 0))

//判断是否是空对象
#define isEmptyObject(obj) (obj == nil || [obj isKindOfClass:[NSNull class]])

//判断是否是空值
#define isNull(obj) (obj == nil || [obj isKindOfClass:[NSNull class]])

//判断是否是空字符串或空数组或空字典
#define isEmpty(obj) (isEmptyString(obj) || isEmptyArray(obj) || isEmptyDictionary(obj))

//判断是否是有效对象
#define isValidObject(obj) (!isEmptyObject(obj))

//判断是否是有效字符串
#define isValidString(string) (!isEmptyString(string))

//判断是否是有效数组
#define isValidArray(array) (!isEmptyArray(array))

//判断是否是有效字典
#define isValidDictionary(dic) (!isEmptyDictionary(dic))

//判断是否是有效值
#define isValidValue(value) (!isNull(value))

//判断是否是有效对象
#define isValid(obj) (isValidObject(obj) && isValidString(obj) && isValidArray(obj) && isValidDictionary(obj))

//判断是否是有效对象
#define isValidObj(obj) (isValidObject(obj))

//判断是否是有效字符串
#define isValidStr(string) (isValidString(string))

//判断是否是有效数组
#define isValidArr(array) (isValidArray(array))

//判断是否是有效字典
#define isValidDic(dic) (isValidDictionary(dic))

//判断是否是有效值
#define isValidVal(value) (isValidValue(value))

//判断是否是有效对象
#define isValidObject(obj) (isValidObject(obj))

//判断是否是有效字符串
#define isValidString(string) (isValidString(string))

//判断是否是有效数组
#define isValidArray(array) (isValidArray(array))

//判断是否是有效字典
#define isValidDictionary(dic) (isValidDictionary(dic))

//判断是否是有效值
#define isValidValue(value) (isValidValue(value))

//判断是否是有效对象
#define isValidObject(obj) (isValidObject(obj))

//判断是否是有效字符串
#define isValidString(string) (isValidString(string))

//判断是否是有效数组
#define isValidArray(array) (isValidArray(array))

//判断是否是有效字典
#define isValidDictionary(dic) (isValidDictionary(dic))

//判断是否是有效值
#define isValidValue(value) (isValidValue(value))

//判断是否是有效对象
#define isValidObject(obj) (isValidObject(obj))

//判断是否是有效字符串
#define isValidString(string) (isValidString(string))

//判断是否是有效数组
#define isValidArray(array) (isValidArray(array))

//判断是否是有效字典
#define isValidDictionary(dic) (isValidDictionary(dic))

//判断是否是有效值
#define isValidValue(value) (isValidValue(value))

#endif /* lhsDataMacros_h */
