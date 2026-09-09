//
//  CMMThirdPart.m
//
//  Created by LHS on 2026/9/3.
//

#import "CMMThirdPart.h"
#import <CoreTelephony/CoreTelephonyDefines.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@implementation CMMThirdPart

+ (NSString *)networkStatus{
    NetReachability *reachability   = [NetReachability reachabilityWithHostName:@"www.apple.com"];
    NetReachWorkStatus internetStatus = [reachability currentReachabilityStatus];
    NSString *net = @"WIFI";
    switch (internetStatus) {
        case NetReachWorkStatusWiFi:
            net = @"WIFI";
            break;
        case NetReachWorkStatusWWAN2G:
            net = @"2G";
            break;
        case NetReachWorkStatusWWAN3G:
            net = @"3G";
            break;
        case NetReachWorkStatusWWAN4G:
            net = @"4G";
            break;
        case NetReachWorkNotReachable:
            net = @"当前无网路连接";
        default:
            net = [self getNetType];   //判断具体类型
            break;
    }
    return net;
}
 
+ (NSString *)getNetType
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    NSString *currentStatus = @"";
    NSString *currentNet = @"5G";
    if (info && [info respondsToSelector:@selector(serviceCurrentRadioAccessTechnology)]) {
        NSDictionary *radioDic = [info serviceCurrentRadioAccessTechnology];
        if (radioDic.allKeys.count) {
            currentStatus = [radioDic objectForKey:radioDic.allKeys[0]];
        }
    }
    if ([currentStatus isEqualToString:CTRadioAccessTechnologyGPRS]) {
        currentNet = @"GPRS";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyEdge]) {
        currentNet = @"2.75G EDGE";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyWCDMA]){
        currentNet = @"3G";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyHSDPA]){
        currentNet = @"3.5G HSDPA";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyHSUPA]){
        currentNet = @"3.5G HSUPA";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMA1x]){
        currentNet = @"2G";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0]){
        currentNet = @"3G";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA]){
        currentNet = @"3G";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB]){
        currentNet = @"3G";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyeHRPD]){
        currentNet = @"HRPD";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyLTE]){
        currentNet = @"4G";
    }else if (@available(iOS 14.1, *)) {
        if ([currentStatus isEqualToString:CTRadioAccessTechnologyNRNSA]){
            currentNet = @"5G NSA";
        }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyNR]){
            currentNet = @"5G";
        }
    }
    return currentNet;
}




+ (void)toastWith:(NSString *)str {
    [[CMMUtility currentWindow] makeToast:str duration:1.0 position:CSToastPositionCenter];
}
+ (void)toastWith:(NSString *)str duration:(NSInteger)duration {
    [[CMMUtility currentWindow] makeToast:str duration:duration position:CSToastPositionCenter];
}
+ (void)toastImage:(NSString *)image str:(NSString *)str{
    // 用Toast的show方法显示自定义视图
    [self toastImage:image str:str position:CSToastPositionCenter];
}

+ (void)toastImage:(NSString *)image str:(NSString *)str position:(id)position{
    
    UIView *customToast = [self customToastViewWithMessage:str
                                                      icon:[UIImage imageNamed:image]];
    // 用Toast的show方法显示自定义视图
    [[CMMUtility currentWindow] showToast:customToast duration:2.0 position:position completion:nil];
}

+ (UIView *)customToastViewWithMessage:(NSString *)message icon:(UIImage *)icon {
    // 获取屏幕宽度
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    // 容器View（深色背景+圆角）
    UIView *toastView = [[UIView alloc] init];
    toastView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    toastView.layer.cornerRadius = 8;
    toastView.clipsToBounds = YES;

    // 图标
    UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    iconView.frame = CGRectMake(12, 0, 20, 20); // 图标位置+大小

    // 文字
    UILabel *label = [[UILabel alloc] init];
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:16];
    label.numberOfLines = 0; // 支持多行显示
    [label sizeToFit];

    // 计算toastView的宽度和高度
    CGFloat maxToastWidth = screenWidth - 80; // 最大宽度为屏幕宽度 - 80
    CGFloat labelWidth = maxToastWidth - 12 - 20 - 8 - 12; // 减去左右padding、图标宽度和间距
    label.frame = CGRectMake(0, 0, labelWidth, label.bounds.size.height);

    // 重新计算label的实际size
    CGSize labelSize = [label sizeThatFits:CGSizeMake(labelWidth, CGFLOAT_MAX)];
    label.frame = CGRectMake(0, 0, labelSize.width, labelSize.height);

    // 计算toastView的高度（图标和文字垂直居中）
    CGFloat toastHeight = MAX(iconView.bounds.size.height, label.bounds.size.height) + 20; // 上下各10px padding
    CGFloat toastWidth = MIN(maxToastWidth, 12 + 20 + 8 + label.bounds.size.width + 12); // 左右padding + 图标 + 间距 + 文字

    toastView.frame = CGRectMake(0, 0, toastWidth, toastHeight);

    // 设置图标和文字的垂直居中
    CGFloat iconY = (toastHeight - iconView.bounds.size.height) / 2;
    CGFloat labelY = (toastHeight - label.bounds.size.height) / 2;

    iconView.frame = CGRectMake(12, iconY, 20, iconView.bounds.size.height);
    label.frame = CGRectMake(CGRectGetMaxX(iconView.frame) + 8, labelY, label.bounds.size.width, label.bounds.size.height);

    [toastView addSubview:iconView];
    [toastView addSubview:label];

    return toastView;
}
@end
