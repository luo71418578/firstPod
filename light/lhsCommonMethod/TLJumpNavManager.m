//
//  TLJumpNavManager.m
//  TLSmartBike
//
//  Created by apple2 on 2021/10/28.
//

#import "TLJumpNavManager.h"


#define LAT_OFFSET_0(x,y) -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x))
#define LAT_OFFSET_1 (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0
#define LAT_OFFSET_2 (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0
#define LAT_OFFSET_3 (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0

#define LON_OFFSET_0(x,y) 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x))
#define LON_OFFSET_1 (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0
#define LON_OFFSET_2 (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0
#define LON_OFFSET_3 (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0

#define RANGE_LON_MAX 137.8347
#define RANGE_LON_MIN 72.004
#define RANGE_LAT_MAX 55.8271
#define RANGE_LAT_MIN 0.8293
// jzA = 6378245.0, 1/f = 298.3
// b = a * (1 - f)
// ee = (a^2 - b^2) / a^2;
#define jzA 6378245.0
#define jzEE 0.00669342162296594323

@interface TLJumpNavManager ()

@end

@implementation TLJumpNavManager


+ (double)transformLat:(double)x bdLon:(double)y
{
    double ret = LAT_OFFSET_0(x, y);
    ret += LAT_OFFSET_1;
    ret += LAT_OFFSET_2;
    ret += LAT_OFFSET_3;
    return ret;
}

+ (double)transformLon:(double)x bdLon:(double)y
{
    double ret = LON_OFFSET_0(x, y);
    ret += LON_OFFSET_1;
    ret += LON_OFFSET_2;
    ret += LON_OFFSET_3;
    return ret;
}

+ (BOOL)outOfChina:(double)lat bdLon:(double)lon
{
    if (lon < RANGE_LON_MIN || lon > RANGE_LON_MAX)
        return true;
    if (lat < RANGE_LAT_MIN || lat > RANGE_LAT_MAX)
        return true;
    return false;
}

+ (CLLocationCoordinate2D)gcj02Encrypt:(double)ggLat bdLon:(double)ggLon
{
    CLLocationCoordinate2D resPoint;
    double mgLat;
    double mgLon;
    if ([self outOfChina:ggLat bdLon:ggLon]) {
        resPoint.latitude = ggLat;
        resPoint.longitude = ggLon;
        return resPoint;
    }
    double dLat = [self transformLat:(ggLon - 105.0)bdLon:(ggLat - 35.0)];
    double dLon = [self transformLon:(ggLon - 105.0) bdLon:(ggLat - 35.0)];
    double radLat = ggLat / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - jzEE * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((jzA * (1 - jzEE)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (jzA / sqrtMagic * cos(radLat) * M_PI);
    mgLat = ggLat + dLat;
    mgLon = ggLon + dLon;

    resPoint.latitude = mgLat;
    resPoint.longitude = mgLon;
    return resPoint;
}

+ (CLLocationCoordinate2D)gcj02Decrypt:(double)gjLat gjLon:(double)gjLon {
    CLLocationCoordinate2D  gPt = [self gcj02Encrypt:gjLat bdLon:gjLon];
    double dLon = gPt.longitude - gjLon;
    double dLat = gPt.latitude - gjLat;
    CLLocationCoordinate2D pt;
    pt.latitude = gjLat - dLat;
    pt.longitude = gjLon - dLon;
    return pt;
}

+ (CLLocationCoordinate2D)bd09Decrypt:(double)bdLat bdLon:(double)bdLon
{
    CLLocationCoordinate2D gcjPt;
    double x = bdLon - 0.0065, y = bdLat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * M_PI);
    double theta = atan2(y, x) - 0.000003 * cos(x * M_PI);
    gcjPt.longitude = z * cos(theta);
    gcjPt.latitude = z * sin(theta);
    return gcjPt;
}

+(CLLocationCoordinate2D)bd09Encrypt:(double)ggLat bdLon:(double)ggLon
{
    CLLocationCoordinate2D bdPt;
    double x = ggLon, y = ggLat;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * M_PI);
    double theta = atan2(y, x) + 0.000003 * cos(x * M_PI);
    bdPt.longitude = z * cos(theta) + 0.0065;
    bdPt.latitude = z * sin(theta) + 0.006;
    return bdPt;
}


+ (CLLocationCoordinate2D)wgs84ToGcj02:(CLLocationCoordinate2D)location
{
    return [self gcj02Encrypt:location.latitude bdLon:location.longitude];
}

+ (CLLocationCoordinate2D)gcj02ToWgs84:(CLLocationCoordinate2D)location
{
    return [self gcj02Decrypt:location.latitude gjLon:location.longitude];
}


+ (CLLocationCoordinate2D)wgs84ToBd09:(CLLocationCoordinate2D)location
{
    CLLocationCoordinate2D gcj02Pt = [self gcj02Encrypt:location.latitude
                                                  bdLon:location.longitude];
    return [self bd09Encrypt:gcj02Pt.latitude bdLon:gcj02Pt.longitude] ;
}

+ (CLLocationCoordinate2D)gcj02ToBd09:(CLLocationCoordinate2D)location
{
    return  [self bd09Encrypt:location.latitude bdLon:location.longitude];
}

+ (CLLocationCoordinate2D)bd09ToGcj02:(CLLocationCoordinate2D)location
{
    return [self bd09Decrypt:location.latitude bdLon:location.longitude];
}

+ (CLLocationCoordinate2D)bd09ToWgs84:(CLLocationCoordinate2D)location
{
    CLLocationCoordinate2D gcj02 = [self bd09ToGcj02:location];
    return [self gcj02Decrypt:gcj02.latitude gjLon:gcj02.longitude];
}



+(void)showPushAlertWithLatitude:(NSString *)lat Longitude:(NSString *)lon destination:(NSString *)destination fromController:(UIViewController *)controller{
    
    __block CLLocationCoordinate2D toLocation = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.apple.com/"]]) {
        UIAlertAction *iosMapAction = [UIAlertAction actionWithTitle:@"苹果地图" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [TLJumpNavManager iosMapWithLocation:toLocation destination:destination];
        }];
        [alertController addAction:iosMapAction];
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        UIAlertAction *iosamapAction = [UIAlertAction actionWithTitle:@"高德地图" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [TLJumpNavManager iosamapWithLocation:toLocation destination:destination];
        }];
        [alertController addAction:iosamapAction];
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        UIAlertAction *baidumapAction = [UIAlertAction actionWithTitle:@"百度地图" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [TLJumpNavManager baidumapWithLocation:toLocation destination:destination];
        }];
        [alertController addAction:baidumapAction];
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        UIAlertAction *iosMapAction = [UIAlertAction actionWithTitle:@"腾讯地图" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [TLJumpNavManager tensentMapWithLocation:toLocation destination:destination];
        }];
        [alertController addAction:iosMapAction];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:cancelAction];
    [controller presentViewController:alertController animated:YES completion:nil];
    // 跳转地图
}
// 百度地图
+(void)baidumapWithLocation:(CLLocationCoordinate2D)toLocation destination:(NSString *)destination{
//    coord_type:
//    bd09ll 表示百度经纬度坐标，
//    bd09mc 表示百度墨卡托坐标，
//    gcj02  表示经过国测局加密的坐标，
//    wgs84  表示gps获取的坐标，
//    默认为bd09经纬度坐标。
    
//    mode ：交通方式
//    transit、
//    driving、
//    walking其中一种。
    CLLocationCoordinate2D loc = [self gcj02ToBd09:toLocation];
    float shopLat = loc.latitude;
    float shoplng = loc.longitude;
    
    NSString *urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin=我的位置&mode=driving"];
    
    if (toLocation.latitude != 0 && toLocation.longitude != 0) {
        urlString = [NSString stringWithFormat:@"%@&destination=latlng:%f,%f|name:%@", urlString, shopLat, shoplng, destination];
    }else{
        urlString = [NSString stringWithFormat:@"%@&destination=%@|name:%@",urlString, destination, destination];
    }
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) {
        
    }];
    
//    //百度地图
//    NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置11}}&destination=latlng:%@,%@|name=无锡市锡山区东港镇紫杉路203号&mode=driving&coord_type=gcj02",[NSString stringWithFormat:@"%f", currentLocation.latitude],[NSString stringWithFormat:@"%f", currentLocation.longitude]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
  
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) {
    }];
}
// 高德导航
+(void)iosamapWithLocation:(CLLocationCoordinate2D)toLocation destination:(NSString *)destination{
    
    //1,这种是进入导航路线选择页面
    NSString *urlString = [NSString stringWithFormat:@"iosamap://path?sourceApplication=LDZ&sname=我的位置&dev=0&t=0"];
    if (toLocation.latitude != 0 && toLocation.longitude != 0) {
        urlString = [NSString stringWithFormat:@"%@&dlat=%f&dlon=%f&dname=%@", urlString, toLocation.latitude, toLocation.longitude, destination];
    }else{
        urlString = [NSString stringWithFormat:@"%@&dname=%@",urlString, destination];
    }
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) {

    }];
    
    //2,这种是直接进入导航页面
//    NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%@&lon=%@&dev=0&style=2",@"铃导者",@"目的地",[NSString stringWithFormat:@"%f", currentLocation.latitude],[NSString stringWithFormat:@"%f", currentLocation.longitude]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) {
//    }];
    
   
}
//苹果地图
+ (void)iosMapWithLocation:(CLLocationCoordinate2D)toLocation destination:(NSString *)destination
{
    //终点坐标
    CLLocationCoordinate2D loc = toLocation;
    
    //用户位置
    MKMapItem *currentLoc = [MKMapItem mapItemForCurrentLocation];
    currentLoc.name = @"我的位置";

    //终点位置
    MKMapItem *desLocation = [[MKMapItem alloc]initWithPlacemark:[[MKPlacemark alloc]initWithCoordinate:loc addressDictionary:nil]];
    desLocation.name = destination;
    
    NSArray *items = @[currentLoc,desLocation];
    
    NSDictionary *dic = @{
                          MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                          MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
                          MKLaunchOptionsShowsTrafficKey : @(YES)
                          };
    
    [MKMapItem openMapsWithItems:items launchOptions:dic];
}

// 腾讯导航
+(void)tensentMapWithLocation:(CLLocationCoordinate2D)toLocation destination:(NSString *)destination{
//    tocoord ： 终点坐标  如：tocoord=40.010024,116.392239
//    from    ： 起点名称  非必传
//    type    ： 路线规划方式， 必传
//    公交：bus
//    驾车：drive
//    步行：walk
//    骑行：bike

    NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&from=我的位置&tocoord=%@,%@&to=%@&coord_type=1&policy=0",[NSString stringWithFormat:@"%f", toLocation.latitude],[NSString stringWithFormat:@"%f", toLocation.longitude],destination] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) {
    }];
}

// 谷歌导航
+(void)googleMapWithLocation:(CLLocationCoordinate2D)currentLocation{
    
    NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%@,%@&directionsmode=driving",@"导航测试",@"nav123456",[NSString stringWithFormat:@"%f", currentLocation.latitude],[NSString stringWithFormat:@"%f", currentLocation.longitude]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) {
    }];
   
}
@end
