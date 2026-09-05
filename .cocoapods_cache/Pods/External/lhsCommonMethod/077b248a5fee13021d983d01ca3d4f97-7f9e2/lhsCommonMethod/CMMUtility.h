//
//  CMMUtility.h
//
//  Created by LHS on 2026/9/3
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "lhsDataMacros.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMMUtility : NSObject

//获取当前控制器
+ (UIViewController *)currentViewController;

//获取当前控制器
+ (UIWindow *)currentWindow;

//地区码是否有效
+ (BOOL)areaCode:(NSString *)code;

//简单判断是否是有效的身份证号码 18位或17位+xX
+ (BOOL)isVaildIDCardNo:(NSString *)idCardNo;

// 校验身份证号
+(BOOL)checkIdNumber:(NSString *)idNumber;

//根据身份证号码获取年龄
+(NSString *)getIdentityCardAge:(NSString *)numberStr;
//根据身份证获取生日
+(NSString *)getIdentityCardBirthday:(NSString *)numberStr;
//从身份证上获取性别
+(NSString *)getIdentityCardSex:(NSString *)numberStr;

//校验手机号
+(BOOL)checkPhoneNumber:(NSString *)phone;

//取某个字符串从开始位置起，一段长度的字符串
+(NSString *)getStringWithRange:(NSString *)str Begin:(int)begin End:(int)end;

//nsnumber转string
+(NSString *)stringWithNSNumber:(NSNumber *)number;

//抖动
+(void)shakeView:(UIView *)view;
//小数点后两位
+(NSString *)formatterNumberWithComma:(id)number;
//小数点后四位
+(NSString *)formatterFourNumberWithComma:(id)number;
//没有小数点
+(NSString *)formatterIntNumberWithComma:(id)number;
//不带小数点的千分位分隔符
+(NSString *)stringFormatToThreeBit:(NSString *)string;
//带两位小数的千分位分隔符
+(NSString *)moneyFormat:(NSString *)money;


//判断内容为8-16位且同时包含数字和字母
+(BOOL)judgePassWordLegal:(NSString *)pass;

//计算字符串所占空间的大小
+ (CGSize)sizeOfString:(NSString *)str withMaxWidth:(CGFloat)width withFont:(UIFont *)font;

//添加黑色背景
+(UIView *)addBagViewOn:(nullable UIViewController *)controller Color:(UIColor *)color;

//字符串中把数字提取出来
+(NSInteger)subNumberStrWithString:(NSString *)str;


//画虚线
+ (void)addImaginaryByView:(UIView *)view FromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint withLineColor:(UIColor *)lineColor;
//给视图画虚线框
+ (void)addDottedBorderWithView:(UIView*)view cornerRadius:(CGFloat)cornerRadius width:(CGFloat)width height:(CGFloat)height;

//系统弹窗UIAlertController
+ (void)showAlertFrom:(UIViewController *)controller
      title:(NSString *)title
    message:(NSString *)message
  sureTitle:(NSString *)sureTitle
cancelTitle:(NSString *)cancelTitle
  sureBlock:(void(^)(NSString * str))sureBlock
cancelBlock:(void(^)(NSString * str))cancelBlock;

//系统弹窗UIAlertController（可设置按钮颜色）
+ (void)showAlertFrom:(UIViewController *)controller
              message:(NSString *)message
            sureTitle:(NSString *)sureTitle
       sureTitleColor:(UIColor *)sureTitleColor
          cancelTitle:(NSString *)cancelTitle
     cancelTitleColor:(UIColor *)cancelTitleColor
            sureBlock:(void(^)(NSString * str))sureBlock
          cancelBlock:(void(^)(NSString * str))cancelBlock;

// 获取屏蔽手机号中间四位的字符串
+(NSString *)getFormattingTellPhoneNumWithTellNum:(NSString *)tellNum;

// 获取只显示姓的名字字符串
+(NSString *)getFormattingNameWithName:(NSString *)name;

// 获取只显示前四位后四位的身份证号
+(NSString *)getFormattingCardIDWithCardID:(NSString *)cardID;

// 获取只显示前六位后四位的身份证号
+(NSString *)getFormattingBankIDWithBankID:(NSString *)cardID;

//根据文字多少获取label高度
+ (CGFloat)getLabelHeightWithWidth:(CGFloat)width text:(NSString *)string font:(UIFont *)font;

//计算整数数字位数
+ (NSInteger)nsinterLength:(NSInteger)x;

//删除小数点后面两位以后的
+(NSString*)getTheCorrectNum:(NSString*)tempString;

//返回数据 精度是准处理
+ (NSString *)decimalNumberWithDouble:(double)conversionValue;

//四舍五入
+(float)roundFloat:(float)price;

//获取当前日历的天
+(NSInteger)returnNowDay;

//设置圆角
+ (void)setCornerWithView:(UIView *)view
                    rect:(CGRect)rect
            UIRectCorner:(UIRectCorner)UIRectCorner
                    size:(CGSize)size;
//是否含有汉字
+ (BOOL)hasChinese:(NSString *)str;
//中文转译
+ (NSString *)changeChineseStr:(NSString *)str;
//是否是纯汉字
+ (BOOL)isChinese:(NSString *)content;

// 获取app build版本
+(NSString *)getAppBuildVersion;
// 获取app bundleId
+(NSString *)getAppBundleID;
// 获取app 名字
+(NSString *)getAppName;
// 获取app当前版本
+(NSString *)getAppVersion;
//获取iOS系统版本
+(NSString *)osVersion;
// 是否支持TouchID
+ (BOOL)isCanOpenTouchID;

//转json串
+(NSString *)convertToJsonData:(id)dictOrArr;
//json串转字典
+(id)jsonToObjectWithStr:(NSString *)jsonString;
+(NSData *)convertToData:(id)obj;

// 添加四边阴影效果
+ (void)addAllShadowToView:(UIView *)theView withColor:(UIColor *)theColor;
// 添加单边阴影效果
+ (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor;

//颜色转图片
+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size;


//图片尺寸压缩 NSData
+ (NSData*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
//图片尺寸压缩 UIImage
+(UIImage*)image:(UIImage *)image scaleToSize:(CGSize)size;
/**
 *从图片中按指定的位置大小截取图片的一部分
 * UIImage image 原始的图片
 * CGRect rect 要截取的区域
 */
+(UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect;

+ (void)deleteWebCache;
+ (void)customDeleteWebCache;
+ (void)clearCaches;


//根据图片url获取图片尺寸
+ (CGSize)getImageSizeWithURL:(id)URL;

//获得原视频的方向,url为视频路径
- (NSUInteger)degressFromVideoFileWithURL:(NSURL *)url;

+(NSError *)error:(NSString *)str Code:(NSInteger)code;


//保存plist文件
+ (void)saveFileWithDict:(id)dict Key:(NSString *)key;
+ (void)deletaFileByKey:(NSString *)key;
+ (NSDictionary *)getFileWithKey:(NSString *)key;
+ (NSArray *)getArrWithKey:(NSString *)key;


//获取文件夹大小
+ (float)folderSizeAtPath:(NSString*)folderPath;

+(NSString *)formateURLString:(NSString *)URLString;
///特殊字符编码
+(NSString *)encodeCharactersString:(NSString *)str;

#pragma mark - 压缩图片
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;

/// 渐变色
+ (void)colorGradientFrom:(UIColor*)color0 toColor:(UIColor*)color1 startP:(CGPoint)point0 EndP:(CGPoint)point1 frame:(CGRect)frame SubView:(UIView*)subView;

//比较两数组是否有不同元素
+ (BOOL)filterArr:(NSArray *)arr1 andArr2:(NSArray *)arr2;
/**
 *  获取星期几
 */
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;
// 画水印 //显示 日期  +  定位
+(UIImage *)waterMarkImage:(UIImage *)image
                      date:(NSString *)date
                  position:(NSString *)position
                lonAndLati:(NSString *)lonAndLati;

// 转拼音
+ (NSString *)transformToPinyin:(NSString *)originalString
                      isQuanpin:(BOOL)quanpin;

// 拨打电话
+ (void)callTelephone:(NSString *)telNum;

+ (void)showAlertToast:(NSString *)toast;



//截取 ? 之前的部分
+ (NSString *)getURLWithoutParams:(NSString *)originalURL;
//截取 ？之后的部分
+ (NSString *)getURLParamsPart:(NSString *)originalURL;


//HmacSHA256  :  HMAC算法，需要和SHA256结合起来
+ (NSString *)hmac256:(NSString *)plaintext withKey:(NSString *)key;
+ (NSString *)sha256:(NSString *)str;
+ (NSString *)md5:(NSString *)str;


//base64编码
+ (NSString *)encodeString:(NSString *)string;
//base64解码
+ (NSString *)decodeString:(NSString *)string;
/// NSData 转 Base64 字符串
+ (NSString *)base64StringFromData:(NSData *)data;

+ (BOOL) canGoToTaoBao;
+ (BOOL) canGoToTianMao;
+ (BOOL) canGoToJD;
+ (BOOL) canGoToPDD;
+ (BOOL) canGoToDouYin;

+ (double)getCpuUsage;
+ (int64_t)getTotalMemory;  //总内存
+ (double)availableMemory;  //可使用内存

//获取运营商
+ (NSString *)network_sp;
// 获取电池电量
+ (CGFloat)getBatteryLevel;
// 获取磁盘总空间
+ (int64_t)getTotalDiskSpace;
// 获取未使用的磁盘空间
+ (int64_t)getFreeDiskSpace;

// 16进制字符串转NSData
+ (NSData *)convertHexStrToData:(NSString *)str;

// NSData转16进制string
+ (NSString *)convertDataToHexStr:(NSData *)data;

// 16进制转2进制
+ (NSString*)convertHexToBinary:(NSString*)hexString;

//十进制转16进制
+(NSString *)toHex:(long long int)num;


//生成二维码
+(CIImage *)creatQRcodeWithUrlstring:(NSString *)urlString;

//生成指定大小二维码图片
+(UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size;

//校验密码是否符合标准（1:长度>=8、2：大写，小写，数字，特殊字符四选三）
+ (BOOL)isValidPassword:(NSString *)password;

//添加动画
+ (void)addAnimationWith:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
