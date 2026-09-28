//
//  HWToolBox.m
//
//  Created by LHS on 2026/9/3.
//

#import "HWToolBox.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation HWToolBox

// 根据字节大小返回文件大小字符KB、MB
+ (NSString *)stringFromByteCount:(long long)byteCount
{
    return [NSByteCountFormatter stringFromByteCount:byteCount countStyle:NSByteCountFormatterCountStyleFile];
}

// 时间转换为时间戳，精确到微秒
+ (NSTimeInterval)getTimeStampWithDate:(NSDate *)date
{
    return [[NSNumber numberWithDouble:[date timeIntervalSince1970] * 1000 * 1000] longLongValue];
}

// 时间戳转换为时间
+ (NSDate *)getDateWithTimeStamp:(NSTimeInterval)timeStamp
{
    return [NSDate dateWithTimeIntervalSince1970:timeStamp * 0.001 * 0.001];
}

// 一个时间戳与当前时间的间隔（s）
+ (NSInteger)getIntervalsWithTimeStamp:(NSTimeInterval)timeStamp
{
    return [[NSDate date] timeIntervalSinceDate:[self getDateWithTimeStamp:timeStamp]];
}

//验证是否是纯数字
+ (BOOL)isAllNumber:(NSString *)number
{
    if (number.length == 0) {
        return NO;
    }
    
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([pred evaluateWithObject:number]) {
        return YES;
    }
    
    return NO;
}

//获得设备型号
+ (NSString *)getCurrentDeviceModel
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    // iPhone
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone5s";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone6";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone6Plus";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone6sPlus";
    if ([platform isEqualToString:@"iPhone8,3"]) return @"iPhoneSE";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhoneSE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone7Plus";
    if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone8";
    if ([platform isEqualToString:@"iPhone10,4"]) return @"iPhone8";
    if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone8Plus";
    if ([platform isEqualToString:@"iPhone10,5"]) return @"iPhone8Plus";
    if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhoneX";
    if ([platform isEqualToString:@"iPhone10,6"]) return @"iPhoneX";
    if ([platform isEqualToString:@"iPhone11,2"]) return@"iPhoneXS";
    if ([platform isEqualToString:@"iPhone11,4"] || [platform isEqualToString:@"iPhone11,6"]) return@"iPhoneXSMax";
    if ([platform isEqualToString:@"iPhone11,8"]) return@"iPhoneXR";
    
    if ([platform isEqualToString:@"iPhone12,1"]) return@"iPhone11";
    if ([platform isEqualToString:@"iPhone12,3"]) return@"iPhone11Pro";
    if ([platform isEqualToString:@"iPhone12,5"]) return@"iPhone11ProMax";
    if ([platform isEqualToString:@"iPhone12,8"]) return@"iPhoneSE2";
    
    if ([platform isEqualToString:@"iPhone13,1"]) return@"iPhone12mini";
    if ([platform isEqualToString:@"iPhone13,2"]) return@"iPhone12";
    if ([platform isEqualToString:@"iPhone13,3"]) return@"iPhone12Pro";
    if ([platform isEqualToString:@"iPhone13,4"]) return@"iPhone12ProMax";

    if ([platform isEqualToString:@"iPhone14,4"]) return@"iPhone13mini";
    if ([platform isEqualToString:@"iPhone14,5"]) return@"iPhone13";
    if ([platform isEqualToString:@"iPhone14,2"]) return@"iPhone13Pro";
    if ([platform isEqualToString:@"iPhone14,3"]) return@"iPhone13ProMax";
    if ([platform isEqualToString:@"iPhone14,6"]) return@"iPhoneSE3";

    if ([platform isEqualToString:@"iPhone14,7"]) return@"iPhone14";
    if ([platform isEqualToString:@"iPhone14,8"]) return@"iPhone14Plus";
    if ([platform isEqualToString:@"iPhone15,2"]) return@"iPhone14Pro";
    if ([platform isEqualToString:@"iPhone15,3"]) return@"iPhone14ProMax";

    if ([platform isEqualToString:@"iPhone15,4"]) return@"iPhone15";
    if ([platform isEqualToString:@"iPhone15,5"]) return@"iPhone15Plus";
    if ([platform isEqualToString:@"iPhone16,1"]) return@"iPhone15Pro";
    if ([platform isEqualToString:@"iPhone16,2"]) return@"iPhone15ProMax";

    if ([platform isEqualToString:@"iPhone17,3"]) return@"iPhone16";
    if ([platform isEqualToString:@"iPhone17,4"]) return@"iPhone16Plus";
    if ([platform isEqualToString:@"iPhone17,1"]) return@"iPhone16Pro";
    if ([platform isEqualToString:@"iPhone17,2"]) return@"iPhone16ProMax";
    if ([platform isEqualToString:@"iPhone17,5"]) return@"iPhone16e";

    if ([platform isEqualToString:@"iPhone18,1"]) return@"iPhone17Pro";
    if ([platform isEqualToString:@"iPhone18,2"]) return@"iPhone17ProMax";
    if ([platform isEqualToString:@"iPhone18,3"]) return@"iPhone17";
    if ([platform isEqualToString:@"iPhone18,4"]) return@"iPhoneAir";
    if ([platform isEqualToString:@"iPhone18,5"]) return@"iPhone17e";

    
    //iPad
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad2";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad2";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad2";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad2";
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad3";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad3";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad3";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad4";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad4";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad4";
    if ([platform isEqualToString:@"iPad6,11"] || [platform isEqualToString:@"iPad6,12"]) return @"iPad5";
    if ([platform isEqualToString:@"iPad7,5"] || [platform isEqualToString:@"iPad7,6"]) return @"iPad6";
    if ([platform isEqualToString:@"iPad7,11"] || [platform isEqualToString:@"iPad7,12"]) return @"iPad7";
    if ([platform isEqualToString:@"iPad11,6"] || [platform isEqualToString:@"iPad11,7"]) return @"iPad8";
    if ([platform isEqualToString:@"iPad12,1"] || [platform isEqualToString:@"iPad12,2"]) return @"iPad9";
    if ([platform isEqualToString:@"iPad13,18"] || [platform isEqualToString:@"iPad13,19"]) return @"iPad10th";
    if ([platform isEqualToString:@"iPad15,7"] || [platform isEqualToString:@"iPad15,8"]) return @"iPad(A16)";

    
    //iPad-Air
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad-Air";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad-Air";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad-Air";
    if ([platform isEqualToString:@"iPad5,3"])   return @"iPad-Air2";
    if ([platform isEqualToString:@"iPad5,4"])   return @"iPad-Air2";
    if ([platform isEqualToString:@"iPad11,3"])   return @"iPad-Air3";
    if ([platform isEqualToString:@"iPad11,4"])   return @"iPad-Air3";
    if ([platform isEqualToString:@"iPad13,1"])   return @"iPad-Air4";
    if ([platform isEqualToString:@"iPad13,2"])   return @"iPad-Air4";
    if ([platform isEqualToString:@"iPad13,16"])   return @"iPad-Air5";
    if ([platform isEqualToString:@"iPad13,17"])   return @"iPad-Air5";
    if ([platform isEqualToString:@"iPad14,8"] || [platform isEqualToString:@"iPad14,9"]) return @"iPad-Air11-inch(M2)";
    if ([platform isEqualToString:@"iPad14,10"] || [platform isEqualToString:@"iPad14,11"]) return @"iPad-Air13-inch(M2)";
    if ([platform isEqualToString:@"iPad15,3"] || [platform isEqualToString:@"iPad15,4"]) return @"iPad-Air11-inch(M3)";
    if ([platform isEqualToString:@"iPad15,5"] || [platform isEqualToString:@"iPad15,6"]) return @"iPad-Air13-inch(M3)";
    if ([platform isEqualToString:@"iPad16,8"] || [platform isEqualToString:@"iPad16,9"]) return @"iPad-Air-11-inch(M4)";
    if ([platform isEqualToString:@"iPad16,10"] || [platform isEqualToString:@"iPad16,11"]) return @"iPad-Air-13-inch(M4)";
    
    
    //iPad-Pro
    if ([platform isEqualToString:@"iPad6,7"] || [platform isEqualToString:@"iPad6,8"]) return @"iPad-Pro12.9inch";
    if ([platform isEqualToString:@"iPad6,3"] || [platform isEqualToString:@"iPad6,4"]) return @"iPad-Pro9.7inch";
    if ([platform isEqualToString:@"iPad7,1"] || [platform isEqualToString:@"iPad7,2"]) return @"iPad-Pro12.9inch2";
    if ([platform isEqualToString:@"iPad7,3"] || [platform isEqualToString:@"iPad7,4"]) return @"iPad-Pro10.5inch";
    if ([platform isEqualToString:@"iPad8,1"] ||
        [platform isEqualToString:@"iPad8,2"] ||
        [platform isEqualToString:@"iPad8,3"] ||
        [platform isEqualToString:@"iPad8,4"]) return @"iPad-Pro11inch";
    if ([platform isEqualToString:@"iPad8,5"] ||
        [platform isEqualToString:@"iPad8,6"] ||
        [platform isEqualToString:@"iPad8,7"] ||
        [platform isEqualToString:@"iPad8,8"]) return @"iPad-Pro12.9-inch3th";
    if ([platform isEqualToString:@"iPad8,9"] || [platform isEqualToString:@"iPad8,10"]) return @"iPad-Pro11-inch2th";
    if ([platform isEqualToString:@"iPad8,11"] || [platform isEqualToString:@"iPad8,12"]) return @"iPad-Pro12.9-inch4th";
    if ([platform isEqualToString:@"iPad13,4"] ||
        [platform isEqualToString:@"iPad13,5"] ||
        [platform isEqualToString:@"iPad13,6"] ||
        [platform isEqualToString:@"iPad13,7"]) return @"iPad-Pro11-inch3th";
    if ([platform isEqualToString:@"iPad13,8"] ||
        [platform isEqualToString:@"iPad13,9"] ||
        [platform isEqualToString:@"iPad13,10"] ||
        [platform isEqualToString:@"iPad13,11"]) return @"iPad-Pro12.9-inch5th";
    if ([platform isEqualToString:@"iPad14,3"] || [platform isEqualToString:@"iPad14,4"]) return @"iPad-Pro11-inch4th";
    if ([platform isEqualToString:@"iPad14,5"] || [platform isEqualToString:@"iPad14,6"]) return @"iPad-Pro12.9-inch6th";
    if ([platform isEqualToString:@"iPad16,3"] || [platform isEqualToString:@"iPad16,4"]) return @"iPad-Pro11-inch(M4)";
    if ([platform isEqualToString:@"iPad16,5"] || [platform isEqualToString:@"iPad16,6"]) return @"iPad-Pro13-inch(M4)";
    if ([platform isEqualToString:@"iPad17,1"] || [platform isEqualToString:@"iPad17,2"]) return @"iPad-Pro-11-inch(M5)";
    if ([platform isEqualToString:@"iPad17,3"] || [platform isEqualToString:@"iPad17,4"]) return @"iPad-Pro-13-inch(M5)";
    
    
    //iPad-mini
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad-mini1G";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad-mini1G";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad-mini1G";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad-mini2";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad-mini2";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad-mini2";
    if ([platform isEqualToString:@"iPad4,7"])   return @"iPad-mini3";
    if ([platform isEqualToString:@"iPad4,8"])   return @"iPad-mini3";
    if ([platform isEqualToString:@"iPad4,9"])   return @"iPad-mini3";
    if ([platform isEqualToString:@"iPad5,1"])   return @"iPad-mini4";
    if ([platform isEqualToString:@"iPad5,2"])   return @"iPad-mini4";
    if ([platform isEqualToString:@"iPad11,1"] || [platform isEqualToString:@"iPad11,2"]) return @"iPad-mini5";
    if ([platform isEqualToString:@"iPad14,1"] || [platform isEqualToString:@"iPad14,2"]) return @"iPad-mini6";
    if ([platform isEqualToString:@"iPad16,1"] || [platform isEqualToString:@"iPad16,2"]) return @"iPad-mini(A17Pro)";

    
    if ([platform isEqualToString:@"i386"])      return @"iPhoneSimulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhoneSimulator";
    
    return platform;
}


//通过view获取控制器
+ (UIViewController *)findViewController:(UIView *)view
{
    id target = view;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    
    return target;
}

//删除path路径下的文件
+ (void)clearCachesWithFilePath:(NSString *)path
{
    NSFileManager *mgr = [NSFileManager defaultManager];
    [mgr removeItemAtPath:path error:nil];
}

//获取沙盒Library的文件目录
+ (NSString *)LibraryDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
}

//获取沙盒Document的文件目录
+ (NSString *)DocumentDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

//获取沙盒Preference的文件目录
+ (NSString *)PreferencePanesDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES) lastObject];
}

//获取沙盒Caches的文件目录
+ (NSString *)CachesDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

//验证手机号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString *mobile = @"^0?(13|14|15|16|17|18|19)[0-9]{9}$";
    
    NSPredicate *regextestMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobile];
    
    if ([regextestMobile evaluateWithObject:mobileNum] == YES) {
        return YES;
    }else {
        return NO;
    }
}

//验证身份证号码
+ (BOOL)isIdentityCardNumber:(NSString *)number
{
    NSString *cardNum = @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|[X|x])";
    
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cardNum];
    
    if ([identityCardPredicate evaluateWithObject:number] == YES) {
        return YES;
    }else {
        return NO;
    }
}

//验证香港身份证号码
+ (BOOL)isIdentityHKCardNumber:(NSString *)number
{
    NSString *cardNum = @"^[A-Z]{1,2}[0-9]{6}\\(?[0-9A]\\)?$";
    
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cardNum];
    
    if ([identityCardPredicate evaluateWithObject:number] == YES) {
        return YES;
    }else {
        return NO;
    }
}

//验证是否护照
+ (BOOL)isPassportNumber:(NSString *)number
{
    NSString *portNum = @"^1[45][0-9]{7}|([P|p|S|s]\\d{7})|([S|s|G|g]\\d{8})|([Gg|Tt|Ss|Ll|Qq|Dd|Aa|Ff]\\d{8})|([H|h|M|m]\\d{8，10})$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", portNum];
    if ([identityCardPredicate evaluateWithObject:number] == YES) {
        return YES;
    }else {
        return NO;
    }
}

//验证密码格式（包含大写、小写、数字）
+ (BOOL)isConformSXPassword:(NSString *)password
{
    NSString *conText = @"(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])[a-zA-Z0-9]{6,20}";
    
    NSPredicate *regextestMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", conText];
    
    if ([regextestMobile evaluateWithObject:password] == YES) {
        return YES;
    }else {
        return NO;
    }
}

//计算文字的长度
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}

//去掉小数点后无效的0
+ (NSString *)deleteFailureZero:(NSString *)string
{
    if ([string rangeOfString:@"."].length == 0) {
        return string;
    }
    
    for (int i = 0; i < string.length; i++) {
        if (![string hasSuffix:@"0"]) {
            break;
        }else {
            string = [string substringToIndex:[string length] - 1];
        }
    }
    
    //避免像2.0000这样的被解析成2.
    if ([string hasSuffix:@"."]) {
        return [string substringToIndex:[string length] - 1];
    }else {
        return string;
    }
}

//得到中英文混合字符串长度
+ (int)lengthForText:(NSString *)text
{
    int strlength = 0;
    char *p = (char*)[text cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i < [text lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            p++;
            strlength++;
        }else {
            p++;
        }
    }
    
    return strlength;
}

//提示弹窗
+ (void)showAlertWithTitle:(NSString *)title sureMessage:(NSString *)sureMessage cancelMessage:(NSString *)cancelMessage warningMessage:(NSString *)warningMessage style:(UIAlertControllerStyle)UIAlertControllerStyle target:(id)target sureHandler:(void(^)(UIAlertAction *action))sureHandler cancelHandler:(void(^)(UIAlertAction *action))cancelHandler warningHandler:(void(^)(UIAlertAction *action))warningHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyle];
    
    if (sureMessage) {
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:sureMessage style:UIAlertActionStyleDefault handler:sureHandler];
        [alertController addAction:sureAction];
    }
    
    if (cancelMessage) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelMessage style:UIAlertActionStyleCancel handler:cancelHandler];
        [alertController addAction:cancelAction];
    }
    
    if (warningMessage) {
        UIAlertAction *warningBtn = [UIAlertAction actionWithTitle:warningMessage style:UIAlertActionStyleDestructive handler:warningHandler];
        [alertController addAction:warningBtn];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [target presentViewController:alertController animated:YES completion:nil];
    });
}

+ (NSString *)currentTime
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *DateTime = [formatter stringFromDate:date];
    
    return DateTime;
}

// 获取当前时间（时分秒毫秒）
+ (NSString *)currentTimeCorrectToMillisecond
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"HH:mm:ss.SSS"];
    NSString *time = [formatter stringFromDate:[NSDate date]];
    
    return time;
}

+(NSString *)getNowDateWithFormat:(NSString *)format {
    NSString *date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    date = [formatter stringFromDate:[NSDate date]];
    return date;
}

+(NSString *)getCurrentDate{
    NSString *date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    date = [formatter stringFromDate:[NSDate date]];
    return date;
}

+(NSString *)getStrWithDateStr:(NSString *)DateStr formate:(NSString *)formate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formate];
    NSDate *datestr =  [dateFormatter dateFromString:DateStr];
    return [dateFormatter stringFromDate:datestr];
}

+(NSDate *)getDateWithStr:(NSString *)dateStr formate:(NSString *)formate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formate];
    return [dateFormatter dateFromString:dateStr];
}

+(NSDate *)getDateWithStr:(NSString *)dateaStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter dateFromString:dateaStr];
}

+(NSString *)getDateWithTimestamp:(NSString *)Timestamp
{
    NSDateFormatter *stampFormatter = [[NSDateFormatter alloc] init];
    [stampFormatter setDateFormat:@"YYYY年MM月dd日"];
    //以 1970/01/01 GMT为基准，然后过了secs秒的时间
    NSDate *stampDate2 = [NSDate dateWithTimeIntervalSince1970:[Timestamp longLongValue]];
//    //NSDate转NSString
    return [stampFormatter stringFromDate:stampDate2];
}

+(NSString *)getDateWithTimestamp:(NSString *)Timestamp withFormater:(NSString *)formate
{
    NSDateFormatter *stampFormatter = [[NSDateFormatter alloc] init];
    [stampFormatter setDateFormat:formate];
    //以 1970/01/01 GMT为基准，然后过了secs秒的时间
    NSDate *stampDate2 = [NSDate dateWithTimeIntervalSince1970:[Timestamp longLongValue]];
    //    //NSDate转NSString
    return [stampFormatter stringFromDate:stampDate2];
}

+(NSString *)getTimeStamp
{
    return [NSString stringWithFormat:@"%.0lf", (double)[[NSDate date] timeIntervalSince1970]*1000];
}

+ (int)intervalSinceNow1:(NSString *)theDate {
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd"];//设置时间格式//很重要
    NSDate *d=[date dateFromString:theDate];

    NSTimeInterval late=[d timeIntervalSince1970]*1;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    NSTimeInterval cha=now-late;
    if (cha/86400>1) {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        return [timeString intValue];
    }
     return -1;
}

+ (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate
{
    NSInteger aa = 0;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd"];
    NSDate *dta = [[NSDate alloc] init];
    NSDate *dtb = [[NSDate alloc] init];
    
    dta = [dateformater dateFromString:aDate];
    dtb = [dateformater dateFromString:bDate];
    NSComparisonResult result = [dta compare:dtb];
    if (result==NSOrderedSame)
    {
        //相等
        aa = 0;
    }else if (result==NSOrderedAscending) {
        //bDate比aDate大
        aa = 1;
    }else if (result==NSOrderedDescending) {
        //bDate比aDate小
        aa = -1;
    }
    return aa;
}

//方式一：找到所有的key,然后删除对象
+ (void)clearAllUserDefaultsByKey{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
      
    NSDictionary *dic = [userDefaults dictionaryRepresentation];
    for (id  key in dic) {
        [userDefaults removeObjectForKey:key];
    }
    [userDefaults synchronize];
}

//方式二：清除持久域
+ (void)clearAllUserDefaultsByBundleID{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

@end
