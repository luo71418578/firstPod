//
//  HWToolBox.h
//
//  Created by LHS on 2026/9/3.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HWToolBox : NSObject

// 根据字节大小返回文件大小字符KB、MB
+ (NSString *)stringFromByteCount:(long long)byteCount;

// 时间转换为时间戳
+ (NSTimeInterval)getTimeStampWithDate:(NSDate *)date;

// 时间戳转换为时间
+ (NSDate *)getDateWithTimeStamp:(NSTimeInterval)timeStamp;

// 一个时间戳与当前时间的间隔（s）
+ (NSInteger)getIntervalsWithTimeStamp:(NSTimeInterval)timeStamp;

//获得当前设备型号
+ (NSString *)getCurrentDeviceModel;

//通过view获取控制器
+ (UIViewController *)findViewController:(UIView *)view;

//删除path路径下的文件
+ (void)clearCachesWithFilePath:(NSString *)path;

//获取沙盒Library的文件目录
+ (NSString *)LibraryDirectory;

//获取沙盒Document的文件目录
+ (NSString *)DocumentDirectory;

//获取沙盒Preference的文件目录
+ (NSString *)PreferencePanesDirectory;

// 获取沙盒Caches的文件目录
+ (NSString *)CachesDirectory;

//验证是否是纯数字
+ (BOOL)isAllNumber:(NSString *)number;

//验证手机号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

//验证身份证号码
+ (BOOL)isIdentityCardNumber:(NSString *)number;

//验证香港身份证号码
+ (BOOL)isIdentityHKCardNumber:(NSString *)number;

//验证密码格式（包含大写、小写、数字）
+ (BOOL)isConformSXPassword:(NSString *)password;

//验证护照
+ (BOOL)isPassportNumber:(NSString *)number;

//计算文字的长度
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;

//去掉小数点后无效的零
+ (NSString *)deleteFailureZero:(NSString *)string;

//得到中英文混合字符串长度
+ (int)lengthForText:(NSString *)text;

//提示弹窗
+ (void)showAlertWithTitle:(NSString *)title sureMessage:(NSString *)sureMessage cancelMessage:(NSString *)cancelMessage warningMessage:(NSString *)warningMessage style:(UIAlertControllerStyle)UIAlertControllerStyle target:(id)target sureHandler:(void(^)(UIAlertAction *action))sureHandler cancelHandler:(void(^)(UIAlertAction *action))cancelHandler warningHandler:(void(^)(UIAlertAction *action))warningHandler;

//获取当前时间
+ (NSString *)currentTime;

// 获取当前时间（时分秒毫秒）
+ (NSString *)currentTimeCorrectToMillisecond;

//获取当前时间 自定义格式
+(NSString *)getNowDateWithFormat:(NSString *)format;

//获取当前时间 YYYY-MM-dd HH:mm:ss
+(NSString *)getCurrentDate;

//时间字符串格式转换
+(NSString *)getStrWithDateStr:(NSString *)DateStr formate:(NSString *)formate;

//自定义formate
+(NSDate *)getDateWithStr:(NSString *)dateStr formate:(NSString *)formate;

//字符串转NSDate yyyy-MM-dd HH:mm:ss
+(NSDate *)getDateWithStr:(NSString *)dateaStr;

//时间戳转string YYYY年MM月dd日
+(NSString *)getDateWithTimestamp:(NSString *)Timestamp;

//时间戳转string 自定义样式
+(NSString *)getDateWithTimestamp:(NSString *)Timestamp withFormater:(NSString *)formate;

//获取当前时间时间戳
+(NSString *)getTimeStamp;

//计算某个时间点距离今天有多少天
+ (int)intervalSinceNow1:(NSString *)theDate;

//比较两时间大小
+ (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate;


/*******************************清除所有的存储本地的数据  *************************/


///方式一：找到所有的key,然后删除对象
+ (void)clearAllUserDefaultsByKey;
///方式二：清除持久域
+ (void)clearAllUserDefaultsByBundleID;
@end
