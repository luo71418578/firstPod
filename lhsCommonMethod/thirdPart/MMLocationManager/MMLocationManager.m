#import "MMLocationManager.h"
#import <UIKit/UIKit.h>
#import "CMMThirdPart.h"

@interface MMLocationManager ()

@property (nonatomic, strong) LocationBlock locationBlock;
@property (nonatomic, strong) NSStringBlock cityBlock;
@property (nonatomic, strong) NSStringBlock addressBlock;
@property (nonatomic, strong) LocationErrorBlock errorBlock;
@property (nonatomic, strong) LocationAndAddressBlock locationAndAddressBlock;

@end

@implementation MMLocationManager

+ (MMLocationManager *)shareLocation;
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    self = [super init];
    if (self) {
        NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
        
        float longitude = [standard floatForKey:MMLastLongitude];
        float latitude = [standard floatForKey:MMLastLatitude];
        self.longitude = longitude;
        self.latitude = latitude;
        self.lastCoordinate = CLLocationCoordinate2DMake(latitude,longitude);
        self.lastCity = [standard objectForKey:MMLastCity];
        self.lastAddress=[standard objectForKey:MMLastAddress];
        self.showToast = YES;
    }
    return self;
}

- (void) getLocationCoordinate:(LocationBlock) locaiontBlock
{
    self.locationBlock = [locaiontBlock copy];
    [self startLocation];
}

- (void) getLocationCoordinate:(LocationBlock) locaiontBlock  withAddress:(NSStringBlock) addressBlock
{
    self.locationBlock = [locaiontBlock copy];
    self.addressBlock = [addressBlock copy];
    [self startLocation];
}

- (void) getLocationCoordinateAndAddress:(LocationAndAddressBlock)LocationAndAddressBlock {
    self.locationAndAddressBlock = [LocationAndAddressBlock copy];
    [self startLocation];
}

- (void) getAddress:(NSStringBlock)addressBlock
{
    self.addressBlock = [addressBlock copy];
    [self startLocation];
}

- (void) getCity:(NSStringBlock)cityBlock
{
    self.cityBlock = [cityBlock copy];
    [self startLocation];
}

- (void) getCity:(NSStringBlock)cityBlock error:(LocationErrorBlock) errorBlock
{
    self.cityBlock = [cityBlock copy];
    self.errorBlock = [errorBlock copy];
    
    [self startLocation];
}
//121.406417
//31.785834 上海
-(void)startLocation
{
    
//    _myLocationMangr = [[CLLocationManager alloc] init];
//    _myLocationMangr.delegate = self;
//    
//    _myLocationMangr.desiredAccuracy = kCLLocationAccuracyBest; //可提供其他精准10米、100米、1000米
//    _myLocationMangr.pausesLocationUpdatesAutomatically = NO; //
//    _myLocationMangr.distanceFilter = 5; //设置位置更新的距离过滤器为5米，越小越耗电
//
//    [_myLocationMangr requestWhenInUseAuthorization];
//    [_myLocationMangr requestAlwaysAuthorization];
//    _myLocationMangr.allowsBackgroundLocationUpdates = YES;
    
    _errorType = 0;
    if (_myLocationMangr) {
        _myLocationMangr = nil;
    }
    
    _myLocationMangr = [[CLLocationManager alloc]init];
    _myLocationMangr.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _myLocationMangr.delegate = self;
    
    // 请求权限
    if (@available(iOS 14.0, *)) {
        // iOS 14+ 使用实例方法获取权限状态
        CLAuthorizationStatus status = _myLocationMangr.authorizationStatus;
        [self handleAuthorizationStatus:status];
    } else {
        // iOS 14 以下使用类方法
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        [self handleAuthorizationStatus:status];
    }
    
}


- (void)requestTemporaryFullAccuracy{
    
    if (![self hasJingZhunLocation]) {
        
        if (@available(iOS 14.0, *)) {
            [_myLocationMangr requestTemporaryFullAccuracyAuthorizationWithPurposeKey:@"purposeKey" completion:nil];
        } else {
            // Fallback on earlier versions
        }
    }
}

- (void)requestTemporaryFullAccuracyWithCompletion:(void (^)(BOOL granted))completion {
    
    if (@available(iOS 14.0, *)) {
        // 确保 manager 已创建
        if (!_myLocationMangr) {
            _myLocationMangr = [[CLLocationManager alloc] init];
        }
        
        if (_myLocationMangr.accuracyAuthorization == CLAccuracyAuthorizationReducedAccuracy) {
            CLLocationManager *locationManager = _myLocationMangr;
            [locationManager requestTemporaryFullAccuracyAuthorizationWithPurposeKey:@"purposeKey" completion:^(NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        // 必须检查用户是否真的允许了精确位置（completion 回调不区分允许/拒绝）
                        BOOL isFullAccuracy = (locationManager.accuracyAuthorization == CLAccuracyAuthorizationFullAccuracy);
                        completion(isFullAccuracy);
                    }
                });
            }];
            return;
        }
    }
    
    // 已经是精确位置或 iOS 14 以下
    if (completion) {
        completion(YES);
    }
}

- (BOOL)hasJingZhunLocation {
    
    [self startLocation];
    
    //如果已经获得定位权限，但精度权限只是模糊定位
    if (@available(iOS 14.0, *)) {
        if (_myLocationMangr.accuracyAuthorization == CLAccuracyAuthorizationReducedAccuracy) {
            
            NSDictionary *locationTemporaryDictionary = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationTemporaryUsageDescriptionDictionary"];
            
            BOOL hasLocationTemporaryKey = locationTemporaryDictionary != nil && locationTemporaryDictionary.count != 0;
            
            if (hasLocationTemporaryKey) {
                return NO;
            }
        }else{
            return YES;
        }
    } else {
        return YES;
        // Fallback on earlier versions
    }
    return YES;
}

-(BOOL)canEnableLocation {
    // 直接使用类方法获取权限状态，避免依赖实例变量
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    return [self isLocationEnabledForStatus:status];
}

// 提取权限判断逻辑
- (BOOL)isLocationEnabledForStatus:(CLAuthorizationStatus)status {
#if TARGET_OS_IPHONE
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse ||
        status == kCLAuthorizationStatusAuthorizedAlways) {
        return YES;
    } else if (status == kCLAuthorizationStatusDenied ||
               status == kCLAuthorizationStatusNotDetermined ||
               status == kCLAuthorizationStatusRestricted) {
        return NO;
    }
    return NO;
#else
    // macOS 平台
    if (status == kCLAuthorizationStatusAuthorized) {
        return YES;
    } else if (status == kCLAuthorizationStatusDenied ||
               status == kCLAuthorizationStatusRestricted ||
               status == kCLAuthorizationStatusNotDetermined) {
        return NO;
    }
    return NO;
#endif
}

-(void)stopLocation
{
    [_myLocationMangr stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

// iOS14+ 权限变化回调
- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager API_AVAILABLE(ios(14.0)) {
    CLAuthorizationStatus status = manager.authorizationStatus;
    [self handleAuthorizationStatus:status];
}


-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    [self handleAuthorizationStatus:status];
}


#pragma mark - 权限处理
- (void)handleAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            // 未授权：请求前台定位权限
            [self.myLocationMangr requestWhenInUseAuthorization];
            break;
            
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways:
            // 已授权：开始定位
            [self.myLocationMangr startUpdatingLocation];
            break;
            
        case kCLAuthorizationStatusDenied:
            // 权限被拒绝
            if (_showToast) {
                [CMMThirdPart toastWith:@"您的位置服务当前不可用，请打开位置服务后重试"];
            }
            
            break;
            
        case kCLAuthorizationStatusRestricted:
            // 权限受限制（如家长控制）
            if (_showToast) {
                [CMMThirdPart toastWith:@"定位权限受限制，无法获取位置" duration:2];
            }
            
            break;
            
        default:
            if (_showToast) {
                [CMMThirdPart toastWith:@"未知的位置权限状态" duration:2];
            }
           
            break;
    }
}

#pragma mark --CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    __weak typeof(self) weakself = self;
    
    CLLocation *newLocation = [locations lastObject]; // 获取最新位置信息
    NSLog(@"当前位置location:{lat:%f; lon:%f; accuracy:%f}\n", newLocation.coordinate.latitude, newLocation.coordinate.longitude, newLocation.horizontalAccuracy);

    self.lastCoordinate = newLocation.coordinate;

    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    CLGeocodeCompletionHandler handle = ^(NSArray *placemarks,NSError *error)
    {
        __strong typeof(weakself) strongself = weakself;
        CLPlacemark *place = [placemarks objectAtIndex:0];
//        @property (nonatomic, readonly, copy, nullable) NSString *name; // eg. Apple Inc.
//        @property (nonatomic, readonly, copy, nullable) NSString *thoroughfare; // street name, eg. Infinite Loop
//        @property (nonatomic, readonly, copy, nullable) NSString *subThoroughfare; // eg. 1
//        @property (nonatomic, readonly, copy, nullable) NSString *locality; // city, eg. Cupertino
//        @property (nonatomic, readonly, copy, nullable) NSString *subLocality; // neighborhood, common name, eg. Mission District
//        @property (nonatomic, readonly, copy, nullable) NSString *administrativeArea; // state, eg. CA
//        @property (nonatomic, readonly, copy, nullable) NSString *subAdministrativeArea; // county, eg. Santa Clara
//        @property (nonatomic, readonly, copy, nullable) NSString *postalCode; // zip code, eg. 95014
//        @property (nonatomic, readonly, copy, nullable) NSString *ISOcountryCode; // eg. US
//        @property (nonatomic, readonly, copy, nullable) NSString *country; // eg. United States
//        @property (nonatomic, readonly, copy, nullable) NSString *inlandWater; // eg. Lake Tahoe
//        @property (nonatomic, readonly, copy, nullable) NSString *ocean; // eg. Pacific Ocean
//        @property (nonatomic, readonly, copy, nullable) NSArray<NSString *> *areasOfInterest; /
        
        DLog(@"------name-----%@",place.name);
        DLog(@"------name-----%@",place.thoroughfare);
        DLog(@"------name-----%@",place.subThoroughfare);
        DLog(@"------name-----%@",place.locality);
        DLog(@"------name-----%@",place.subLocality);
        DLog(@"------name-----%@",place.administrativeArea);
        DLog(@"------name-----%@",place.subAdministrativeArea);
        DLog(@"------name-----%@",place.postalCode);
        DLog(@"------ISOcountryCode-----%@",place.ISOcountryCode);
        DLog(@"------name-----%@",place.country);
        DLog(@"------name-----%@",place.inlandWater);
        DLog(@"------name-----%@",place.ocean);
        DLog(@"------name-----%@",place.areasOfInterest);
        DLog(@"------name-----%@",place.areasOfInterest);

        
        for (CLPlacemark * placeMark in placemarks)
        {
            // 使用属性替代弃用的 addressDictionary
            // administrativeArea: 省/州
            // locality: 市
            // subLocality: 区
            // thoroughfare: 街道名 + 门牌号
            // subThoroughfare: 门牌号
            // name: 具体地点名称
            
            NSString *state = placeMark.administrativeArea ?: @"";
            NSString *city = placeMark.locality ?: @"";
            NSString *subLocality = placeMark.subLocality ?: @"";
            
            // 街道地址：优先使用 thoroughfare，如果没有则使用 name
            NSString *street = placeMark.thoroughfare ?: placeMark.name ?: @"";
            
            self.lastCity = city;
            self.lastAddress = [NSString stringWithFormat:@"%@%@%@%@",
                               state,
                               city,
                               subLocality,
                               street];
            
            [standard setObject:self.lastCity forKey:MMLastCity];
            [standard setObject:self.lastAddress forKey:MMLastAddress];
            
            [self stopLocation];
        }
        
        if (strongself.cityBlock) {
            strongself.cityBlock(strongself.lastCity);
            strongself.cityBlock = nil;
        }
        
        if (strongself.locationBlock) {
            strongself.locationBlock(strongself.lastCoordinate);
            strongself.locationBlock = nil;
        }
        
        if (strongself.addressBlock) {
            strongself.addressBlock(strongself.lastAddress);
            strongself.addressBlock = nil;
        }
        
        if (strongself.locationAndAddressBlock) {
            strongself.locationAndAddressBlock(strongself.lastCoordinate, newLocation, strongself.lastAddress);
            strongself.locationAndAddressBlock  = nil;
        }
    };
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [clGeoCoder reverseGeocodeLocation:newLocation completionHandler:handle];
    NSLog(@"Latitude1=%f",newLocation.coordinate.latitude);
    NSLog(@"Longitude1=%f",newLocation.coordinate.longitude);
    
    
}


//-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
//{
//    __weak typeof(self) weakself = self;
//    
//    [self stopLocation];
//    self.lastCoordinate = newLocation.coordinate;
//    
//    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
//    
////    [standard setObject:@(self.lastCoordinate.longitude) forKey:MMLastLongitude];
////    [standard setObject:@(self.lastCoordinate.latitude) forKey:MMLastLatitude];
//    
//    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
//    CLGeocodeCompletionHandler handle = ^(NSArray *placemarks,NSError *error)
//    {
//        __strong typeof(weakself) strongself = weakself;
//        CLPlacemark *place = [placemarks objectAtIndex:0];
//        
//        for (CLPlacemark * placeMark in placemarks)
//        {
//            NSDictionary *addressDic = placeMark.addressDictionary;
//            
//            // 位置名
////                    NSLog(@"name,%@",place.name);
//            // 街道
////                    NSLog(@"thoroughfare,%@",place.thoroughfare);
//            // 子街道
////                    NSLog(@"subThoroughfare,%@",place.subThoroughfare);
//            // 市
////                    NSLog(@"locality,%@",place.locality);
//            // 区
////                    NSLog(@"subLocality,%@",place.subLocality);
//            // 国家
////                    NSLog(@"country,%@",place.country);
//            
//            NSString *state=[addressDic objectForKey:@"State"];
//            NSString *city=[addressDic objectForKey:@"City"];
//            NSString *subLocality=[addressDic objectForKey:@"SubLocality"];
//            NSString *street=[addressDic objectForKey:@"Name"];
//            
//            self.lastCity = city;
//            self.lastAddress=[NSString stringWithFormat:@"%@%@%@%@",str(state),str(city),str(subLocality),str(street)];
//            
//            [standard setObject:self.lastCity forKey:MMLastCity];
//            [standard setObject:self.lastAddress forKey:MMLastAddress];
//            
//            [self stopLocation];
//        }
//        
//        if (strongself.cityBlock) {
//            strongself.cityBlock(strongself.lastCity);
//            strongself.cityBlock = nil;
//        }
//        
//        if (strongself.locationBlock) {
//            strongself.locationBlock(strongself.lastCoordinate);
//            strongself.locationBlock = nil;
//        }
//        
//        if (strongself.addressBlock) {
//            strongself.addressBlock(strongself.lastAddress);
//            strongself.addressBlock = nil;
//        }
//        
//        if (strongself.locationAndAddressBlock) {
//            strongself.locationAndAddressBlock(strongself.lastCoordinate, strongself.lastAddress);
//            strongself.locationAndAddressBlock  = nil;
//        }
//    };
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    
//    [clGeoCoder reverseGeocodeLocation:newLocation completionHandler:handle];
//    NSLog(@"Latitude1=%f",newLocation.coordinate.latitude);
//    NSLog(@"Longitude1=%f",newLocation.coordinate.longitude);
//}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSString *errorString;
    [manager stopUpdatingLocation];
    switch([error code]) {
        case kCLErrorDenied:
        {
            errorString = @"用户访问位置服务否认了";
            _errorType = 1;
        }
            break;
        case kCLErrorLocationUnknown:
        {
            errorString = @"位置数据不可用";
            _errorType = 2;
        }
            break;
        default:
        {
            errorString = @"一个未知的错误发生";
            _errorType = 3;
        }
            break;
    }

    if (_errorBlock) {
        _errorBlock(error);
        _errorBlock = nil;
    }

    [self stopLocation];
    NSLog(@"获得位置失败");
    
}
@end
