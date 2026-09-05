//
//  CMMUtility.m
//
//  Created by LHS on 2026/9/3.
//

#import "CMMUtility.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <WebKit/WebKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>
#import <mach/task.h>
#import <mach/vm_map.h>
#import <mach/mach_init.h>
#import <mach/thread_act.h>
#import <mach/thread_info.h>
#import <mach/mach_host.h>
#import <CoreTelephony/CoreTelephonyDefines.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIDevice.h>

@implementation CMMUtility

#define APP_Document                [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define DocumentPath(path)          [APP_Document stringByAppendingPathComponent:path]

//确定是哪个viewcontroller
+ (UIViewController *)currentViewController{
    
    UIViewController * currVC = nil;
    UIViewController * Rootvc = [[self currentWindow] rootViewController];
    do {
        if ([Rootvc isKindOfClass:[UINavigationController class]]) {
            UINavigationController * nav = (UINavigationController *)Rootvc;
            UIViewController * v = [nav.viewControllers lastObject];
            currVC = v;
            Rootvc = v.presentedViewController;
            continue;
        }else if([Rootvc isKindOfClass:[UITabBarController class]]){
            UITabBarController * tabVC = (UITabBarController *)Rootvc;
            currVC = tabVC;
            Rootvc = [tabVC.viewControllers objectAtIndex:tabVC.selectedIndex];
            continue;
        }
    } while (Rootvc!=nil);
    
    return currVC;
}

+ (UIWindow *)currentWindow {
    UIWindowScene *windowScene = nil;
    for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            windowScene = (UIWindowScene *)scene;
            break;
        }
    }
    return windowScene.windows.firstObject;
}

//地区码是否有效
+ (BOOL)areaCode:(NSString *)code
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"北京" forKey:@"11"];
    [dic setObject:@"天津" forKey:@"12"];
    [dic setObject:@"河北" forKey:@"13"];
    [dic setObject:@"山西" forKey:@"14"];
    [dic setObject:@"内蒙古" forKey:@"15"];
    [dic setObject:@"辽宁" forKey:@"21"];
    [dic setObject:@"吉林" forKey:@"22"];
    [dic setObject:@"黑龙江" forKey:@"23"];
    [dic setObject:@"上海" forKey:@"31"];
    [dic setObject:@"江苏" forKey:@"32"];
    [dic setObject:@"浙江" forKey:@"33"];
    [dic setObject:@"安徽" forKey:@"34"];
    [dic setObject:@"福建" forKey:@"35"];
    [dic setObject:@"江西" forKey:@"36"];
    [dic setObject:@"山东" forKey:@"37"];
    [dic setObject:@"河南" forKey:@"41"];
    [dic setObject:@"湖北" forKey:@"42"];
    [dic setObject:@"湖南" forKey:@"43"];
    [dic setObject:@"广东" forKey:@"44"];
    [dic setObject:@"广西" forKey:@"45"];
    [dic setObject:@"海南" forKey:@"46"];
    [dic setObject:@"重庆" forKey:@"50"];
    [dic setObject:@"四川" forKey:@"51"];
    [dic setObject:@"贵州" forKey:@"52"];
    [dic setObject:@"云南" forKey:@"53"];
    [dic setObject:@"西藏" forKey:@"54"];
    [dic setObject:@"陕西" forKey:@"61"];
    [dic setObject:@"甘肃" forKey:@"62"];
    [dic setObject:@"青海" forKey:@"63"];
    [dic setObject:@"宁夏" forKey:@"64"];
    [dic setObject:@"新疆" forKey:@"65"];
    [dic setObject:@"台湾" forKey:@"71"];
    [dic setObject:@"香港" forKey:@"81"];
    [dic setObject:@"澳门" forKey:@"82"];
    [dic setObject:@"国外" forKey:@"91"];
    
    if ([dic objectForKey:code] == nil) {
        return NO;
    }
    return YES;
}

/**
 判断是否是有效的身份证号码
 @param idCardNo 身份证号字符串
 @return 如果是有效的身份证号，返回`YES`, 否则返回`NO`

 仅允许  数字 && 最后一位是{数字 || Xx}）
 */
+ (BOOL)isVaildIDCardNo:(NSString *)idCardNo{
    if ([self checkEmptyString:idCardNo]) return NO;

    NSString *regxStr = @"^(\\d{17})(\\d|[xX])$";
    NSPredicate *idcardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regxStr];
    return [idcardTest evaluateWithObject:idCardNo];
}

+ (BOOL)checkEmptyString:(NSString *) string {
    if (string == nil) return string == nil;
    NSString *newStr = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [newStr isEqualToString:@""];
}

+(BOOL)checkIdNumber:(NSString *)sPaperId
{
    //判断位数
    if ([sPaperId length] != 15 && [sPaperId length] != 18) {
        return NO;
    }
    NSString *carid = sPaperId;
    
    long lSumQT =0;
    int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };//加权因子
    unsigned char sChecker[11]={'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};//校验码
    
    
    //将15位身份证号转换成18位
    NSMutableString *mString = [NSMutableString stringWithString:sPaperId];
    
    if ([sPaperId length] == 15) {
        [mString insertString:@"19" atIndex:6];
        long p = 0;
        const char *pid = [mString UTF8String];
        for (int i=0; i<=16; i++)
        {
            p += (pid[i]-48) * R[i];
        }
        
        int o = p%11;
        NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
        [mString insertString:string_content atIndex:[mString length]];
        carid = mString;
    }
    
    //判断地区码
    NSString * sProvince = [carid substringToIndex:2];
    if (![self areaCode:sProvince]) {
        return NO;
    }
    
    //判断年月日是否有效
    int strYear = [[self getStringWithRange:carid Begin:6 End:4] intValue];
    int strMonth = [[self getStringWithRange:carid Begin:10 End:2] intValue];
    int strDay = [[self getStringWithRange:carid Begin:12 End:2] intValue];
    
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeZone:localZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:01:01",strYear,strMonth,strDay]];
    
    if (date == nil) {
        return NO;
    }
    
    //检验长度
    const char *PaperId  = [carid UTF8String];
    if( 18 != strlen(PaperId)) return -1;
    
    //校验数字
    for (int i=0; i<18; i++){
        if ( !isdigit(PaperId[i]) && !(('X' == PaperId[i] || 'x' == PaperId[i]) && 17 == i) ){
            return NO;
        }
    }
    //验证最末的校验码
    for (int i=0; i<=16; i++){
        lSumQT += (PaperId[i]-48) * R[i];
    }
    if (sChecker[lSumQT%11] != PaperId[17] ){
        return NO;
    }
    return YES;
}

+(NSString *)getIdentityCardAge:(NSString *)numberStr {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    NSDate *nowDate = [NSDate date];
     
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //生日
    NSDate *birthDay = [dateFormatter dateFromString:[self getIdentityCardBirthday:numberStr]];
     
    //用来得到详细的时差
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *date = [calendar components:unitFlags fromDate:birthDay toDate:nowDate options:0];
     
    return [NSString stringWithFormat:@"%ld",(long)[date year]];
}


+(NSString *)getIdentityCardBirthday:(NSString *)numberStr {

    NSMutableString *result = [NSMutableString stringWithCapacity:0];
    NSString *year = nil;
    NSString *month = nil;
    BOOL isAllNumber = YES;
    NSString *day = nil;
    if([numberStr length]<18)

        return result;
    //**从第6位开始 截取8个数
    NSString *fontNumer = [numberStr substringWithRange:NSMakeRange(6, 8)];

    //**检测前12位否全都是数字;
    const char *str = [fontNumer UTF8String];
    const char *p = str;
    while (*p!='\0') {

        if(!(*p>='0'&&*p<='9'))
            isAllNumber = NO;
        p++;
    }

    if(!isAllNumber)
    return result;

    year = [NSString stringWithFormat:@"%@",[numberStr substringWithRange:NSMakeRange(6, 4)]];
    //    NSLog(@"year ==%@",year);
    month = [numberStr substringWithRange:NSMakeRange(10, 2)];
    //    NSLog(@"month ==%@",month);
    day = [numberStr substringWithRange:NSMakeRange(12,2)];
    //    NSLog(@"day==%@",day);
    [result appendString:year];
    [result appendString:@"-"];
    [result appendString:month];
    [result appendString:@"-"];
    [result appendString:day];
    return result;
}

/**
 *  从身份证上获取性别
 */
+(NSString *)getIdentityCardSex:(NSString *)numberStr {

    NSString *sex = @"";
    //获取18位 二代身份证  性别
    if (numberStr.length==18){

        int sexInt=[[numberStr substringWithRange:NSMakeRange(16,1)] intValue];
        if(sexInt%2!=0){
            sex = @"男";
        }else{
            sex = @"女";
        }
    }
    
    //  获取15位 一代身份证  性别
    if (numberStr.length==15){
        int sexInt=[[numberStr substringWithRange:NSMakeRange(14,1)] intValue];
        if(sexInt%2!=0){
            sex = @"男";
        }else {
            sex = @"女";
        }
    }
    return sex;
}

+(BOOL)checkPhoneNumber:(NSString *)phone{
    //最简单版
    NSString *phoneRegex = @"1[0-9][0-9]{9}";
//    2017年11月1日版
//    NSString *phoneRegex = @"^1(3[0-9]|4[5-9]|5[0-35-9]|6[6]|7[0-8]|8[0-9]|9[89])\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}

+ (NSString *)getStringWithRange:(NSString *)str Begin:(int)begin End:(int)end;{
    return [str substringWithRange:NSMakeRange(begin,end)];
}

//nsnumber转string
+(NSString *)stringWithNSNumber:(NSNumber *)number{
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    NSString *B = [numberFormatter stringFromNumber:number];
    return B;
}

+(void)shakeView:(UIView *)view {
    CALayer *lbl = [view layer];
    CGPoint posLbl = [lbl position];
    CGPoint y = CGPointMake(posLbl.x-10, posLbl.y);
    CGPoint x = CGPointMake(posLbl.x+10, posLbl.y);
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    [lbl addAnimation:animation forKey:nil];
}

+(NSString *)formatterNumberWithComma:(id)number {
    NSString *numString;
    if ([number isKindOfClass:[NSNumber class]]) {
        numString = [NSString stringWithFormat:@"%lf",[number doubleValue]];
    }else{
        numString = (NSString *)number;
    }
    
    numString = [NSString stringWithFormat:@"%.2lf",[numString doubleValue]];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    [formatter setMaximumFractionDigits:2];
    [formatter setMinimumFractionDigits:2];
    
    NSNumber *num = [NSNumber numberWithDouble:[numString doubleValue]];
    NSString *result = [NSString stringWithFormat:@"%@",[formatter stringFromNumber:num]];
    return  result;
    
}

+(NSString *)formatterFourNumberWithComma:(id)number {
    NSString *numString;
    if ([number isKindOfClass:[NSNumber class]]) {
        numString = [NSString stringWithFormat:@"%lf",[number doubleValue]];
    }else{
        numString = (NSString *)number;
    }
    
    numString = [NSString stringWithFormat:@"%.4lf",[numString doubleValue]];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    [formatter setMaximumFractionDigits:4]; //制定最多位直接相当于截断，不会四舍五入
    [formatter setMinimumFractionDigits:4];
    
    NSNumber *num = [NSNumber numberWithDouble:[numString doubleValue]];
    NSString *result = [NSString stringWithFormat:@"%@",[formatter stringFromNumber:num]];
    return  result;
    
}

+(NSString *)formatterIntNumberWithComma:(id)number {
    NSString *numString;
    if ([number isKindOfClass:[NSNumber class]]) {
        numString = [NSString stringWithFormat:@"%lf",[number doubleValue]];
    }else{
        numString = (NSString *)number;
    }
    
    numString = [NSString stringWithFormat:@"%.2lf",[numString doubleValue]];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
//    [formatter setMaximumFractionDigits:2];
    
    NSNumber *num = [NSNumber numberWithDouble:[numString doubleValue]];
    NSString *result = [NSString stringWithFormat:@"%@",[formatter stringFromNumber:num]];
    return  result;
    
}

+(NSString *)stringFormatToThreeBit:(NSString *)string{
    if (string.length <= 0) {
        return @"".mutableCopy;
    }
    
    NSString *tempRemoveD = [string stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSMutableString *stringM = [NSMutableString stringWithString:tempRemoveD];
    NSInteger n = 2;
    for (NSInteger i = tempRemoveD.length - 3; i > 0; i--) {
        n++;
        if (n == 3) {
            [stringM insertString:@"," atIndex:i];
            n = 0;
        }
    }
    
    return stringM;
}

+(NSString *)moneyFormat:(NSString *)money{
    
    if(!money || [money floatValue] == 0){
        return @"0.00";
    }
    if (money.floatValue < 1000) {
        return  [NSString stringWithFormat:@"%.2f",money.floatValue];
    };
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@",###.00;"];
    return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[money doubleValue]]];

}


//计算字符串所占空间的大小
+ (CGSize)sizeOfString:(NSString *)str withMaxWidth:(CGFloat)width withFont:(UIFont *)font
{
    CGSize s;
    s = [str boundingRectWithSize:CGSizeMake(width, 999999) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
    return s;
}

/*
*  判断用户输入的密码是否符合规范，符合规范的密码要求：
1. 长度大于8位
2. 密码中必须同时包含数字和字母
*/
+(BOOL)judgePassWordLegal:(NSString *)pass{
    BOOL result = false;
    if ([pass length] >= 8 && [pass length] <=16){
        // 判断长度大于8位后再接着判断是否同时包含数字和字符
        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:pass];
    }
    return result;
}


+(UIView *)addBagViewOn:(nullable UIViewController *)controller Color:(UIColor *)color{
    
    UIView *bagView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    bagView.backgroundColor = [color colorWithAlphaComponent:0.4];

    UIWindow *window = [self currentWindow];
    if (controller) {
        [controller.view addSubview:bagView];
    }else{
        [window addSubview:bagView];
    }
    return bagView;
}

//把数字提取出来
+(NSInteger)subNumberStrWithString:(NSString *)str{
    NSCharacterSet* nonDigits =[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSInteger remainSecond =[[str stringByTrimmingCharactersInSet:nonDigits] integerValue];
    return remainSecond;
}

+ (void)addImaginaryByView:(UIView *)view FromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint withLineColor:(UIColor *)lineColor{
    CAShapeLayer *line = [CAShapeLayer layer];
    CGMutablePathRef path = CGPathCreateMutable();
    
    line.lineWidth = 1.0f;  //线高度
    line.strokeColor = lineColor.CGColor;
    line.fillColor = [UIColor clearColor].CGColor;
    //    line.lineDashPhase = 6;
    line.lineDashPattern = @[@10,@7];  //每段的线宽，每段的间距
    
    CGPathMoveToPoint(path, nil, startPoint.x, startPoint.y);
    
    CGPathAddLineToPoint(path, nil, endPoint.x, endPoint.y);
    
    line.path = path;
    CGPathRelease(path);
    [view.layer insertSublayer:line atIndex:0];
}

+ (void)addDottedBorderWithView:(UIView*)view cornerRadius:(CGFloat)cornerRadius width:(CGFloat)width height:(CGFloat)height{
    view.layer.cornerRadius = cornerRadius;
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.bounds = CGRectMake(0, 0, width, height);
    borderLayer.position = CGPointMake(width/2,height/2);
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:cornerRadius].CGPath;
    borderLayer.lineWidth = 1. / [[UIScreen mainScreen] scale];
    borderLayer.lineDashPattern = @[@4, @4];
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = [UIColor redColor].CGColor;
    [view.layer addSublayer:borderLayer];
}

+ (void)showAlertFrom:(UIViewController *)controller
              title:(NSString *)title
            message:(NSString *)message
          sureTitle:(NSString *)sureTitle
        cancelTitle:(NSString *)cancelTitle
          sureBlock:(void(^)(NSString * str))sureBlock
        cancelBlock:(void(^)(NSString * str))cancelBlock {
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* actionDefault = [UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        sureBlock(@"");
    }];
    UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        cancelBlock(@"");
    }];
    [alertView addAction:actionDefault];
    if (!QM_IS_STR_NIL(cancelTitle)) {
        [alertView addAction:actionCancel];
    }
    [controller presentViewController: alertView animated:YES completion:nil];
}


+ (void)showAlertFrom:(UIViewController *)controller
              message:(NSString *)message
            sureTitle:(NSString *)sureTitle
       sureTitleColor:(UIColor *)sureTitleColor
          cancelTitle:(NSString *)cancelTitle
     cancelTitleColor:(UIColor *)cancelTitleColor
            sureBlock:(void(^)(NSString * str))sureBlock
          cancelBlock:(void(^)(NSString * str))cancelBlock {
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* actionDefault = [UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        sureBlock(@"");
    }];
    [actionDefault setValue:sureTitleColor forKey:@"titleTextColor"];
    
    UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        cancelBlock(@"");
    }];
    [actionCancel setValue:cancelTitleColor forKey:@"titleTextColor"];

    [alertView addAction:actionDefault];
    if (!QM_IS_STR_NIL(cancelTitle)) {
        [alertView addAction:actionCancel];
    }
    [controller presentViewController: alertView animated:YES completion:nil];
}

// 获取屏蔽手机号中间四位的字符串
+ (NSString *)getFormattingTellPhoneNumWithTellNum:(NSString *)tellNum {
    int i = 0;
    NSString *topStr = @"";
    if (tellNum.length >= 11) {
        while (i < tellNum.length) {
            NSString * string = [tellNum substringWithRange:NSMakeRange(i, 1)];
            if (i == 3 || i == 4 || i == 5 || i == 6) {
                topStr = [NSString stringWithFormat:@"%@*",topStr];
            } else {
                topStr = [NSString stringWithFormat:@"%@%@",topStr,string];
            }
            i++;
        }
        return  topStr;
    } else {
        return @"";
    }
}

// 获取只显示姓的名字字符串
+(NSString *)getFormattingNameWithName:(NSString *)name{
    if (name.length > 0) {
        NSString *firstStr = [name substringToIndex:1];
        NSString *getStr = [NSString stringWithFormat:@"%@",firstStr];
        for (int i = 0; i < name.length - 1; i++) {
            getStr = [NSString stringWithFormat:@"%@*",getStr];
        }
        return getStr;
    } else {
        return nil;
    }
}

// 获取只显示前四位后四位的身份证号
+(NSString *)getFormattingCardIDWithCardID:(NSString *)cardID{
    if (cardID.length > 8) {
        NSString *firstStr = [cardID substringToIndex:4];
        NSString *lastStr = [cardID substringFromIndex:(cardID.length - 4)];
        NSString *getStr = [NSString stringWithFormat:@"%@",firstStr];
        for (int i = 0; i < cardID.length - 8; i++) {
            getStr = [NSString stringWithFormat:@"%@*",getStr];
        }
        getStr = [NSString stringWithFormat:@"%@%@",getStr,lastStr];
         return getStr;
    } else {
        return @"";
    }
}

// 获取只显示前六位后四位的身份证号
+(NSString *)getFormattingBankIDWithBankID:(NSString *)cardID{
    if (cardID.length > 10) {
        NSString *firstStr = [cardID substringToIndex:6];
        NSString *lastStr = [cardID substringFromIndex:(cardID.length - 4)];
        NSString *getStr = [NSString stringWithFormat:@"%@",firstStr];
        for (int i = 0; i < cardID.length - 10; i++) {
            getStr = [NSString stringWithFormat:@"%@*",getStr];
        }
        getStr = [NSString stringWithFormat:@"%@%@",getStr,lastStr];
        return getStr;
    } else {
        return @"";
    }
}

+ (CGFloat)getLabelHeightWithWidth:(CGFloat)width text:(NSString *)string font:(UIFont *)font{
    CGSize size =CGSizeMake(width,CGFLOAT_MAX);
    
    //    获取当前文本的属性
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
    
    //ios7方法，获取文本需要的size，限制宽度
    CGSize  actualsize =[string boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    return actualsize.height;
}

+ (NSInteger)nsinterLength:(NSInteger)x {
    NSInteger sum=0,j=1;
    while( x >= 1 ) {
        NSLog(@"%zd位数是 : %ld\n",j,x%10);
        x=x/10;
        sum++;
        j=j*10;
    }
    NSLog(@"你输入的是一个%zd位数\n",sum);
    return sum;
}

+(NSString*)getTheCorrectNum:(NSString*)tempString{
    //计算截取的长度
    NSUInteger endLength = tempString.length;
    //判断字符串是否包含 .
    if ([tempString containsString:@"."]) {
        //取得 . 的位置
        NSRange pointRange = [tempString rangeOfString:@"."];
        NSLog(@"%lu",pointRange.location);
        //判断 . 后面有几位
        NSUInteger f = tempString.length - 1 - pointRange.location;
        //如果大于2位就截取字符串保留两位,如果小于两位,直接截取
        if (f > 2) {
            endLength = pointRange.location + 3;
        }
    }
    //先将tempString转换成char型数组
    NSUInteger start = 0;
    const char *tempChar = [tempString UTF8String];
    //遍历,去除取得第一位不是0的位置
    for (int i = 0; i < tempString.length; i++) {
        if (tempChar[i] == '0') {
            start++;
        }else {
            break;
        }
    }
    //根据最终的开始位置,计算长度,并截取
    NSRange range = {start,endLength-start};
    tempString = [tempString substringWithRange:range];
    return tempString;
}

+ (NSString *)decimalNumberWithDouble:(double)conversionValue{
   NSString *doubleString        = [NSString stringWithFormat:@"%lf", conversionValue];
   NSDecimalNumber *decNumber    = [NSDecimalNumber decimalNumberWithString:doubleString];
   return [decNumber stringValue];
}

//四舍五入
+(float)roundFloat:(float)price{
    return (floorf(price*100 + 0.5))/100;
}

+(NSInteger)returnNowDay{
    unsigned units  = NSCalendarUnitDay;
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp1 = [calendar components:units fromDate:[NSDate date]];
    return [comp1 day];
}

+ (void)setCornerWithView:(UIView *)view
                     rect:(CGRect)rect
             UIRectCorner:(UIRectCorner)UIRectCorner
                     size:(CGSize)size{
    // 创建BezierPath 并设置角 和 半径 这里只设置了 左上 和 右上
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCorner cornerRadii:size];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.frame = view.bounds;
    layer.path = path.CGPath;
    view.layer.mask = layer;
}

+ (BOOL)hasChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}

+(NSString *)getAppBuildVersion{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+(NSString *)getAppBundleID{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

+(NSString *)getAppName{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

+(NSString *)getAppVersion{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

#pragma mark-----系统版本号
+(NSString *)osVersion{
    NSString *strSysVersion = [[UIDevice currentDevice] systemVersion]; // "2.2.1"
    return strSysVersion;
}


// 是否支持TouchID
+ (BOOL)isCanOpenTouchID {
    //创建LAContext
    LAContext *context = [LAContext new];
    
    //这个属性是设置指纹输入失败之后的弹出框的选项
    context.localizedFallbackTitle = @"";
    
    NSError *error = nil;
    return [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
}


//字典转json串
+ (NSString *)convertToJsonData:(id)dictOrArr {
    NSError *error = nil;
    // 直接使用0选项生成紧凑格式的JSON，避免额外的格式化处理
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictOrArr
                                                       options:0
                                                         error:&error];
    
    if (error) {
        NSLog(@"JSON序列化失败: %@", error.localizedDescription);
        return nil;
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    return jsonString;
}

//json串转字典
+(id)jsonToObjectWithStr:(NSString *)jsonString{
    if (QM_IS_STR_NIL(jsonString)) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id obj = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err){
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return obj;
}

+(NSData *)convertToData:(id)obj {
    return [NSJSONSerialization dataWithJSONObject:obj options:NSUTF8StringEncoding error:nil];
}

// 添加四边阴影效果
+ (void)addAllShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    // 阴影颜色
    theView.layer.shadowColor = theColor.CGColor;
    // 阴影偏移，默认(0, -3)
    theView.layer.shadowOffset = CGSizeMake(0,0);
    // 阴影透明度，默认0
    theView.layer.shadowOpacity = 0.3;
    // 阴影半径，默认3
    theView.layer.shadowRadius = 5;
}

// 添加单边阴影效果
+ (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    theView.layer.shadowColor = theColor.CGColor;
    theView.layer.shadowOffset = CGSizeMake(0,0);
    theView.layer.shadowOpacity = 0.3;
    theView.layer.shadowRadius = 5;
    // 单边阴影 顶边
    float shadowPathWidth = theView.layer.shadowRadius;
    CGRect shadowRect = CGRectMake(0, 0-shadowPathWidth/2.0, theView.bounds.size.width, shadowPathWidth);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:shadowRect];
    theView.layer.shadowPath = path.CGPath;
}

//根据颜色和尺寸创建图片
+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size{
    UIView *theView = [[UIView alloc] initWithFrame:(CGRect){{0,0}, size}];
    theView.backgroundColor = color;
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, YES, theView.layer.contentsScale);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+ (NSData*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage,0.8);
}

/**
 *将图片缩放到指定的CGSize大小
 * UIImage image 原始的图片
 * CGSize size 要缩放到的大小
 */
+(UIImage*)image:(UIImage *)image scaleToSize:(CGSize)size{
    
    // 得到图片上下文，指定绘制范围
    UIGraphicsBeginImageContext(size);
    // 将图片按照指定大小绘制
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前图片上下文中导出图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 当前图片上下文出栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

/**
 *从图片中按指定的位置大小截取图片的一部分
 * UIImage image 原始的图片
 * CGRect rect 要截取的区域
 */
+(UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect{
    //将UIImage转换成CGImageRef
    CGImageRef sourceImageRef = [image CGImage];
    //按照给定的矩形区域进行剪裁
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    //将CGImageRef转换成UIImage
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    //返回剪裁后的图片
    return newImage;
}

+ (void)deleteWebCache {
    //allWebsiteDataTypes清除所有缓存
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        
    }];
}

+ (void)customDeleteWebCache {
    /*
     在磁盘缓存上。
     WKWebsiteDataTypeDiskCache,
     
     html离线Web应用程序缓存。
     WKWebsiteDataTypeOfflineWebApplicationCache,
     
     内存缓存。
     WKWebsiteDataTypeMemoryCache,
     
     本地存储。
     WKWebsiteDataTypeLocalStorage,
     
     Cookies
     WKWebsiteDataTypeCookies,
     
     会话存储
     WKWebsiteDataTypeSessionStorage,
     
     IndexedDB数据库。
     WKWebsiteDataTypeIndexedDBDatabases,
     
     查询数据库。
     WKWebsiteDataTypeWebSQLDatabases
     */
    NSArray * types=@[WKWebsiteDataTypeCookies,WKWebsiteDataTypeLocalStorage,WKWebsiteDataTypeDiskCache,WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeOfflineWebApplicationCache];
    
    NSSet *websiteDataTypes= [NSSet setWithArray:types];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        
    }];
    
}


+ (void)clearCaches
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths lastObject];
    
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:path];
    
    for (NSString *p in files) {
        NSError *error;
        NSString *Path = [path stringByAppendingPathComponent:p];
        if ([[NSFileManager defaultManager] fileExistsAtPath:Path]) {
            //清理缓存，保留Preference，里面含有NSUserDefaults保存的信息
            if (![Path containsString:@"Preferences"]) {
                [[NSFileManager defaultManager] removeItemAtPath:Path error:&error];
            }
        }else{
            
        }
    }
}

/**
 *  根据图片url获取图片尺寸
 */
+ (CGSize)getImageSizeWithURL:(id)URL{
    NSURL * url = nil;
    if ([URL isKindOfClass:[NSURL class]]) {
        url = URL;
    }
    if ([URL isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:URL];
    }
    if (!URL) {
        return CGSizeZero;
    }
    CGImageSourceRef imageSourceRef =   CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    CGFloat width = 0, height = 0;
    if (imageSourceRef) {
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, NULL);
      if (imageProperties != NULL) {
          CFNumberRef widthNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
          if (widthNumberRef != NULL) {
              CFNumberGetValue(widthNumberRef, kCFNumberFloat64Type, &width);
          }
          CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
          if (heightNumberRef != NULL) {
            CFNumberGetValue(heightNumberRef, kCFNumberFloat64Type, &height);
        }
        CFRelease(imageProperties);
    }
    CFRelease(imageSourceRef);
    }
    return CGSizeMake(width, height);
}

+ (NSString *)changeChineseStr:(NSString *)str {
    return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

+ (BOOL)isChinese:(NSString *)content{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:content];
}


- (NSUInteger)degressFromVideoFileWithURL:(NSURL *)url {
    NSUInteger degress = 0;
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;
        
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
            // Portrait
            degress = 90;
        }else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
            // PortraitUpsideDown
            degress = 270;
        }else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
            // LandscapeRight
            degress = 0;
        }else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
            // LandscapeLeft
            degress = 180;
        }
    }
    return degress;
}

+(NSError *)error:(NSString *)str Code:(NSInteger)code{
    NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey:str}];
    return error;
}

+ (void)saveFileWithDict:(id)dict Key:(NSString *)key {
    
    if (!QM_IS_DICT_NIL(dict) || !QM_IS_ARRAY_NIL(dict)) {
        NSData *resultData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [NSString stringWithFormat:@"%@.plist",key];
        DLog(@"-----path-----%@",DocumentPath(str));
        
        BOOL result = [resultData writeToFile:DocumentPath(str) atomically:YES];
        if (result) {
            NSLog(@"%@.plist文件写入成功",key);
        }else {
            NSLog(@"%@.plist文件写入失败",key);
        }
    }
    
}

+ (void)deletaFileByKey:(NSString *)key {
    
    NSString *str = [NSString stringWithFormat:@"%@.plist",key];
    NSString *filePath = DocumentPath(str);
    
    NSFileManager* fileManager=[NSFileManager defaultManager];

    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:filePath];

    if (!blHave) {
        NSLog(@"不存在%@文件",str);
        return ;
    }else {
        
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:filePath error:nil];
        
        if (blDele) {
            NSLog(@"%@文件删除成功",str);
        }else {
            NSLog(@"%@文件删除失败",str);
        }
    }
}

+ (NSArray *)getArrWithKey:(NSString *)key {
    NSString *str = [NSString stringWithFormat:@"%@.plist",key];
    NSData *data = [NSData dataWithContentsOfFile:DocumentPath(str)];
    
    NSArray * resultArr;
    //需要判断数据为nil情况，因为如果为nil则无法转成字典的
    if (data.bytes > 0) {
        resultArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    }
    return resultArr;
}


+ (NSDictionary *)getFileWithKey:(NSString *)key {
    
    NSString *str = [NSString stringWithFormat:@"%@.plist",key];
    NSData *data = [NSData dataWithContentsOfFile:DocumentPath(str)];
    
    NSDictionary * resultDict;
    //需要判断数据为nil情况，因为如果为nil则无法转成字典的

    if (data.bytes > 0) {
        resultDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            或
//            resultArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    }
    return resultDict;
}


// 工具方法：缩放图片到指定尺寸（保持比例/强制拉伸可选）
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)targetSize keepAspectRatio:(BOOL)keepAspectRatio {
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, [UIScreen mainScreen].scale);
    
    CGRect drawRect;
    if (keepAspectRatio) {
        // 保持图片比例，居中绘制（不会拉伸变形）
        CGSize imageSize = image.size;
        CGFloat scale = MIN(targetSize.width/imageSize.width, targetSize.height/imageSize.height);
        CGFloat width = imageSize.width * scale;
        CGFloat height = imageSize.height * scale;
        drawRect = CGRectMake((targetSize.width - width)/2, (targetSize.height - height)/2, width, height);
    } else {
        // 强制拉伸到目标尺寸
        drawRect = CGRectMake(0, 0, targetSize.width, targetSize.height);
    }
    
    [image drawInRect:drawRect];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

//获取所有文件夹的大小
+ (float)folderSizeAtPath:(NSString*)folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1000.0*1000.0);
}
+ (long long)fileSizeAtPath:(NSString*)filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

+(NSString *)formateURLString:(NSString *)URLString {
//    NSString *photoPath = [URLString containsString:@"https:"][URLString stringByReplacingOccurrencesOfString:@"https:" withString:@"http:"];
    NSString *photoPath = URLString;
    photoPath = [photoPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return photoPath;
}
///特殊字符编码
+(NSString *)encodeCharactersString:(NSString *)str {
    return [[CMMUtility changeChineseStr:str] stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@"?!@#$^&%*+,:;='\"`<>()[]{}/\\| "] invertedSet]];
}

#pragma mark - 压缩图片
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size {

    UIImage *OriginalImage = image;
    
    // 执行这句代码之后会有一个范围 例如500m 会是 100m～500k
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1024.0;
    
    // 如果原始大小已经小于目标大小，直接返回
    if (dataKBytes <= size) {
        return data;
    }
    
    CGFloat maxQuality = 0.9f;
    
    // 执行while循环 如果第一次压缩不会小雨100k 那么减小尺寸在重新开始压缩
    while (dataKBytes > size)
    {
        while (dataKBytes > size && maxQuality > 0.1f)
        {
            maxQuality = maxQuality - 0.1f;
            data = UIImageJPEGRepresentation(image, maxQuality);
            dataKBytes = data.length / 1024.0;
            if(dataKBytes <= size )
            {
                return data;
            }
        }
        OriginalImage =[self compressOriginalImage:OriginalImage toWidth:OriginalImage.size.width * 0.8];
        image = OriginalImage;
        data = UIImageJPEGRepresentation(image, 1.0);
        dataKBytes = data.length / 1024.0;
        maxQuality = 0.9f;
    }
    
    return data;
}

#pragma mark - 改变图片的大小
+ (UIImage *)compressOriginalImage:(UIImage *)image toWidth:(CGFloat)targetWidth
{
    CGSize imageSize = image.size;
    CGFloat Originalwidth = imageSize.width;
    CGFloat Originalheight = imageSize.height;
    CGFloat targetHeight = Originalheight / Originalwidth * targetWidth;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [image drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/// 渐变色
+ (void)colorGradientFrom:(UIColor*)color0 toColor:(UIColor*)color1 startP:(CGPoint)point0 EndP:(CGPoint)point1 frame:(CGRect)frame SubView:(UIView*)subView
{
    //渐变设置
    CAGradientLayer *gradient = [CAGradientLayer layer];
    NSArray *colors = [NSArray arrayWithObjects:(id)color0.CGColor, (id)color1.CGColor, nil];
    //设置开始和结束位置(通过开始和结束位置来控制渐变的方向)
    gradient.startPoint = point0;
    gradient.endPoint = point1;
    gradient.colors = colors;
    gradient.locations = @[@(0.0),@(1.0f)];
    gradient.frame = frame;
    [subView.layer insertSublayer:gradient atIndex:0];
}

//比较两个数组中是否有不同元素
+ (BOOL)filterArr:(NSArray *)arr1 andArr2:(NSArray *)arr2 {
    
    NSArray *reslutFilteredArray;
    
    if (arr1.count > arr2.count) {
        NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",arr2];
        //得到两个数组中不同的数据
        reslutFilteredArray = [arr1 filteredArrayUsingPredicate:filterPredicate];
    }else {
        NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",arr1];
        //得到两个数组中不同的数据
        reslutFilteredArray = [arr2 filteredArrayUsingPredicate:filterPredicate];
    }
   
    if (reslutFilteredArray.count > 0) {
       return YES;
    }
    return NO;
}

/**
 *  获取星期几
 */
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}

// 画水印
+(UIImage *)waterMarkImage:(UIImage *)image
                      date:(NSString *)date
                  position:(NSString *)position
                lonAndLati:(NSString *)lonAndLati{
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    //画布
    CGFloat W = image.size.width;
    CGFloat H = image.size.height;
    //修正参数
    CGFloat correctH = 0;
    if(W >= H){
        correctH = 15;
    }else{
        correctH = 0;
    }
    
    CGFloat Font = 13;
    
    CGFloat wC = W/screenW;
    CGFloat hC = H/screenH;
    
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0, 0, W, H)];
   
    Font = Font * wC;

    if (!QM_IS_STR_NIL(lonAndLati)) { //经纬度不空
        //日期
        NSString *dateStr = [NSString stringWithFormat:@"%@",date];
        NSDictionary *dateAttr = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:1.3*Font],
                                   NSForegroundColorAttributeName : [UIColor whiteColor] };
        [dateStr drawInRect:[self getCgrect:20 y:615- 75- 2*correctH w:200 h:20 wC:wC hC:hC] withAttributes:dateAttr];//左下

        //定位信息
        NSString *postionStr = position;
        NSDictionary *positionAttr = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:Font],
                                       NSForegroundColorAttributeName : [UIColor whiteColor] };
        [postionStr drawInRect:[self getCgrect:20 y:615- 40- 2*correctH w:335 h:40 wC:wC hC:hC] withAttributes:positionAttr];
        
        //经纬度信息
        NSString *lonAndLatiStr = lonAndLati;
        NSDictionary *lonAndLatiAttr = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:Font],
                                       NSForegroundColorAttributeName : [UIColor whiteColor] };
        [lonAndLatiStr drawInRect:[self getCgrect:20 y:615 w:335 h:40 wC:wC hC:hC] withAttributes:lonAndLatiAttr];
        
    } else {
        //日期
        NSString *dateStr = [NSString stringWithFormat:@"%@",date];
        NSDictionary *dateAttr = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:1.3*Font],
                                   NSForegroundColorAttributeName : [UIColor whiteColor] };
        [dateStr drawInRect:[self getCgrect:20 y:615- 30- 2*correctH w:200 h:20 wC:wC hC:hC] withAttributes:dateAttr];//左下

        //定位信息
        NSString *postionStr = position;
        NSDictionary *positionAttr = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:Font],
                                       NSForegroundColorAttributeName : [UIColor whiteColor] };
        [postionStr drawInRect:[self getCgrect:20 y:615 w:335 h:40 wC:wC hC:hC] withAttributes:positionAttr];
    }
    
    
    UIImage *imageEnd = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageEnd;
}
+ (CGRect)getCgrect:(CGFloat)x y:(CGFloat)y w:(CGFloat)w h:(CGFloat)h wC:(CGFloat)wC hC:(CGFloat)hC{
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    return CGRectMake(x * screenW/375.0 * wC, y*screenH/667.0 * hC, w * wC, h * wC);
}

+ (NSString *)transformToPinyin:(NSString *)originalString isQuanpin:(BOOL)quanpin{
    
    NSMutableString *muStr = [NSMutableString stringWithString:originalString];
    //汉字转成拼音
    CFStringTransform((CFMutableStringRef)muStr, NULL, kCFStringTransformMandarinLatin, NO);
    //去掉音标
    CFStringTransform((CFMutableStringRef)muStr, NULL, kCFStringTransformStripDiacritics, NO);
    NSArray *pinyinArray = [muStr componentsSeparatedByString:@" "];
    NSMutableString *allString = [NSMutableString new];
    if (quanpin) {
        int count = 0;
        for (int i = 0; i < pinyinArray.count; i++)
        {
            for (int i = 0; i < pinyinArray.count; i++) {
                if (i == count)
                {
                    [allString appendString:@"#"];
                }
                [allString appendFormat:@"%@",pinyinArray[i]];
            }
            
            [allString appendString:@","];
            count++;
        }
    }
    NSMutableString *initialStr = [NSMutableString new];
    for (NSString *str in pinyinArray) {
        if ([str length] > 0) {
            [initialStr appendString:[str substringFromIndex:0]];
        }
    }
    [allString appendFormat:@"#%@",initialStr];
    [allString appendFormat:@",#%@",originalString];
    return allString;
}

+ (void)callTelephone:(NSString *)telNum {
    NSString *phone = [NSString stringWithFormat:@"telprompt://%@",telNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone] options:@{} completionHandler:^(BOOL success) {
    }];
}

+ (void)showAlertToast:(NSString *)toast;
 {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:toast message:nil preferredStyle:UIAlertControllerStyleAlert];
    [[CMMUtility currentViewController] presentViewController:alertController animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertController dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

+ (NSString *)getURLWithoutParams:(NSString *)originalURL {
    // 空值校验
    if (!originalURL || originalURL.length == 0) {
        return @"";
    }
    
    // 查找 ? 的位置
    NSRange queryRange = [originalURL rangeOfString:@"?"];
    if (queryRange.location == NSNotFound) {
        // 没有参数，直接返回原URL
        return originalURL;
    }
    
    // 截取 ? 之前的部分
    return [originalURL substringToIndex:queryRange.location];
}


+ (NSString *)getURLParamsPart:(NSString *)originalURL {
    // 1. 空值校验
    if (!originalURL || originalURL.length == 0) {
        return @"";
    }
    
    // 2. 查找 ? 的位置
    NSRange queryRange = [originalURL rangeOfString:@"?"];
    if (queryRange.location == NSNotFound) {
        // 无 ?，返回空字符串（若需返回原值可改为 return originalURL）
        return @"";
    }
    
    // 3. 截取 ? 后面的部分（注意：location 是 ? 的下标，需 +1 跳过 ?）
    // 处理 ? 在末尾的情况（如 https://xxx/api?），返回空字符串
    NSUInteger paramsStartIndex = queryRange.location + 1;
    if (paramsStartIndex >= originalURL.length) {
        return @"";
    }
    
    return [originalURL substringFromIndex:paramsStartIndex];
}


//HmacSHA256  :  HMAC算法，需要和SHA256结合起来
+ (NSString *)hmac256:(NSString *)plaintext withKey:(NSString *)key
{
    // 参数校验
    if (!plaintext || !key || plaintext.length == 0 || key.length == 0) {
        return nil;
    }
    
    // 使用 UTF-8 替代 ASCII，兼容性更好
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *plainData = [plaintext dataUsingEncoding:NSUTF8StringEncoding];
    
    if (!keyData || !plainData) {
        return nil;
    }
    
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    
    // 使用 NSData 的 bytes 和 length，避免 strlen 风险
    CCHmac(kCCHmacAlgSHA256,
           keyData.bytes,
           keyData.length,
           plainData.bytes,
           plainData.length,
           cHMAC);
    
    // 十六进制编码
    NSMutableString *HMAC = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [HMAC appendFormat:@"%02x", cHMAC[i]];
    }
    
    return HMAC;
}


/**
 *  SHA256 加密算法（原 MD5 已弃用，迁移至 SHA256）
 *  @param str 传入要加密的字符串
 *  @return NSString
 */
+ (NSString *)sha256:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(cStr, (CC_LONG)strlen(cStr), result);
    NSMutableString *resultStr = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [resultStr appendFormat:@"%02X", result[i]];
    }
    return resultStr;
}

/**
 *  32位md5加密算法,不要key
 *  @param str 传入要加密的字符串
 *  @return NSString
 */
+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CC_MD5(cStr,(CC_LONG)strlen(cStr), result);// This is the md5 call
    #pragma clang diagnostic pop
    NSString *resultStr = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02x%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    return [resultStr uppercaseString];
}

//base64编码
+ (NSString *)encodeString:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encodedStr = [data base64EncodedStringWithOptions:0];
    return encodedStr;
}
//base64解码
+ (NSString *)decodeString:(NSString *)string
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:0];
    NSString *decodedStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return decodedStr;
}

/// NSData 转 Base64 字符串
+ (NSString *)base64StringFromData:(NSData *)data {
    if (!data || data.length == 0) {
        return @"";
    }
    return [data base64EncodedStringWithOptions:0];
}

+ (BOOL) canGoToTaoBao {
    NSURL *schemeUrl = [NSURL URLWithString:@"taobao://"];
    if ([[UIApplication sharedApplication] canOpenURL:schemeUrl]){
        return YES;
    }else {
        return NO;
    }
}
 
+ (BOOL) canGoToTianMao  {
    NSURL *schemeUrl = [NSURL URLWithString:@"tmall://"];
    if ([[UIApplication sharedApplication] canOpenURL:schemeUrl]){
        return YES;
    }else {
        return NO;
    }
}
 
+ (BOOL) canGoToJD  {
    NSURL *schemeUrl = [NSURL URLWithString:@"openApp.jdMobile://"];
    if ([[UIApplication sharedApplication] canOpenURL:schemeUrl]){
        return YES;
    }else {
        return NO;
    }
}

+ (BOOL) canGoToPDD  {
    NSURL *schemeUrl = [NSURL URLWithString:@"pinduoduo://"];
    if ([[UIApplication sharedApplication] canOpenURL:schemeUrl]){
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL) canGoToDouYin  {
    NSURL *schemeUrl = [NSURL URLWithString:@"snssdk1128://"];
    if ([[UIApplication sharedApplication] canOpenURL:schemeUrl]){
        return YES;
    }else{
        return NO;
    }
}

+ (double)getCpuUsage {
    kern_return_t           kr;
    thread_array_t          threadList;         // 保存当前Mach task的线程列表
    mach_msg_type_number_t  threadCount;        // 保存当前Mach task的线程个数
    thread_info_data_t      threadInfo;         // 保存单个线程的信息列表
    mach_msg_type_number_t  threadInfoCount;    // 保存当前线程的信息列表大小
    thread_basic_info_t     threadBasicInfo;    // 线程的基本信息
    
    // 通过“task_threads”API调用获取指定 task 的线程列表
    //  mach_task_self_，表示获取当前的 Mach task
    kr = task_threads(mach_task_self(), &threadList, &threadCount);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    double cpuUsage = 0;
    for (int i = 0; i < threadCount; i++) {
        threadInfoCount = THREAD_INFO_MAX;
        // 通过“thread_info”API调用来查询指定线程的信息
        //  flavor参数传的是THREAD_BASIC_INFO，使用这个类型会返回线程的基本信息，
        //  定义在 thread_basic_info_t 结构体，包含了用户和系统的运行时间、运行状态和调度优先级等
        kr = thread_info(threadList[i], THREAD_BASIC_INFO, (thread_info_t)threadInfo, &threadInfoCount);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        threadBasicInfo = (thread_basic_info_t)threadInfo;
        if (!(threadBasicInfo->flags & TH_FLAGS_IDLE)) {
            cpuUsage += threadBasicInfo->cpu_usage;
        }
    }
    
    // 回收内存，防止内存泄漏
    vm_deallocate(mach_task_self(), (vm_offset_t)threadList, threadCount * sizeof(thread_t));

    return cpuUsage / (double)TH_USAGE_SCALE * 100.0;
}



+ (int64_t)getTotalMemory {
    int64_t totalMemory = [[NSProcessInfo processInfo] physicalMemory];
    if (totalMemory < -1) totalMemory = -1;
    return totalMemory;
}

+ (double)availableMemory {
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);

    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    return ((vm_page_size *vmStats.free_count) / 1000.0) / 1000.0;
 }


+ (NSString *)network_sp{
    NSString *carrier_name = @"--";    //网络运营商的名字
    
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [[networkInfo serviceSubscriberCellularProviders].allValues firstObject];
    NSString *sp = [carrier carrierName];
    NSString *code = [carrier mobileNetworkCode];
    
    if (!QM_IS_STR_NIL(sp)) {
        carrier_name = sp;
    } else {
        if ([code isEqualToString:@"00"] || [code isEqualToString:@"02"] || [code isEqualToString:@"07"]) {            //移动
            carrier_name = @"移动";
            
        }if ([code isEqualToString:@"03"] || [code isEqualToString:@"05"]|| [code isEqualToString:@"11"]){            // ret = @"电信";
            carrier_name =  @"电信";
            
        }if ([code isEqualToString:@"01"] || [code isEqualToString:@"06"]){            // ret = @"联通";
            carrier_name =  @"联通";
            
        }if ([code isEqualToString:@"20"]){            // ret = @"铁通";
            carrier_name =  @"铁通";
            
        }if ([code isEqualToString:@"15"]){            // ret = @"广电";
            carrier_name =  @"广电";
        }
    }

    return carrier_name;

}

// 获取电池电量
+ (CGFloat)getBatteryLevel {
    UIDevice *device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;

    CGFloat batteryLevel = [device batteryLevel];
    
    return batteryLevel;
}

// 获取磁盘总空间
+ (int64_t)getTotalDiskSpace {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}
// 获取未使用的磁盘空间
+ (int64_t)getFreeDiskSpace {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemFreeSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}


// 16进制字符串转NSData
+ (NSData *)convertHexStrToData:(NSString *)str{
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:20];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}

// NSData转16进制string
+ (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}

// 16进制转2进制
+ (NSString*)convertHexToBinary:(NSString*)hexString {
    NSMutableString *returnString = [NSMutableString string];
    for(int i = 0; i < [hexString length]; i++)
    {
        char c = [[hexString lowercaseString] characterAtIndex:i];
        
        switch(c) {
            case '0': [returnString appendString:@"0000"]; break;
            case '1': [returnString appendString:@"0001"]; break;
            case '2': [returnString appendString:@"0010"]; break;
            case '3': [returnString appendString:@"0011"]; break;
            case '4': [returnString appendString:@"0100"]; break;
            case '5': [returnString appendString:@"0101"]; break;
            case '6': [returnString appendString:@"0110"]; break;
            case '7': [returnString appendString:@"0111"]; break;
            case '8': [returnString appendString:@"1000"]; break;
            case '9': [returnString appendString:@"1001"]; break;
            case 'a': [returnString appendString:@"1010"]; break;
            case 'b': [returnString appendString:@"1011"]; break;
            case 'c': [returnString appendString:@"1100"]; break;
            case 'd': [returnString appendString:@"1101"]; break;
            case 'e': [returnString appendString:@"1110"]; break;
            case 'f': [returnString appendString:@"1111"]; break;
            default : break;
        }
    }
    
    return returnString;
}

//十进制转16进制
+(NSString *)toHex:(long long int)num{
    NSString * result = [NSString stringWithFormat:@"%llx",num];
    return [result uppercaseString];
}

//生成二维码
+ (CIImage *)creatQRcodeWithUrlstring:(NSString *)urlString{
    
    // 1.实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复滤镜的默认属性 (因为滤镜有可能保存上一次的属性)
    [filter setDefaults];
    
    // 3.将字符串转换成NSdata
    NSData *data  = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    
    // 4.通过KVO设置滤镜, 传入data, 将来滤镜就知道要通过传入的数据生成二维码
    [filter setValue:data forKey:@"inputMessage"];
    
    // 5.生成二维码
    CIImage *outputImage = [filter outputImage];
    return outputImage;
}

//生成制定二维码图片
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    
    CGContextScaleCTM(bitmapRef, scale, scale);
    
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}


+ (BOOL)isValidPassword:(NSString *)password {
    
    if (password.length < 8) {
        return NO;
    }
    
    // 检查是否包含小写字母
    NSPredicate *lowercasePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"(?=.*[a-z]).*"];
    BOOL hasLowercase = [lowercasePredicate evaluateWithObject:password];
    
    // 检查是否包含大写字母
    NSPredicate *uppercasePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"(?=.*[A-Z]).*"];
    BOOL hasUppercase = [uppercasePredicate evaluateWithObject:password];
    
    // 检查是否包含数字
    NSPredicate *digitPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"(?=.*\\d).*"];
    BOOL hasDigit = [digitPredicate evaluateWithObject:password];
    
    // 检查是否包含特殊字符
    NSPredicate *specialCharPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"(?=.*[^a-zA-Z0-9]).*"];
    BOOL hasSpecialChar = [specialCharPredicate evaluateWithObject:password];
    
    // 计算满足的条件数量
    NSInteger satisfiedConditions = (hasLowercase ? 1 : 0) +
                                   (hasUppercase ? 1 : 0) +
                                   (hasDigit ? 1 : 0) +
                                   (hasSpecialChar ? 1 : 0);
    
    // 至少满足3个条件
    return satisfiedConditions >= 3;
    
}


//添加动画
+ (void)addAnimationWith:(UIView *)view {
    
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration             = 1;
    popAnimation.values               = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0f, 0.0f, 1.0f)],
                                          [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05f, 1.05f, 1.0)],
                                          [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95f, 0.95f, 1.0f)],
                                          [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes             = @[@0.1f, @0.3f, @0.5f, @0.6f];
    popAnimation.timingFunctions      = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [view.layer addAnimation:popAnimation forKey:nil];
}

@end
