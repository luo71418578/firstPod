/**
 *  地图定位
 *
 *  使用时在plist里同时设置
     NSLocationWhenInUseUsageDescription和
     NSLocationAlwaysUseUsageDescription
 *  字段
 *
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define  MMLastLongitude @"MMLastLongitude"
#define  MMLastLatitude  @"MMLastLatitude"
#define  MMLastCity      @"MMLastCity"
#define  MMLastAddress   @"MMLastAddress"

typedef void (^LocationBlock) (CLLocationCoordinate2D locationCorrrdinate);
typedef void (^LocationErrorBlock) (NSError *error);
typedef void (^NSStringBlock) (NSString *cityString);
typedef void (^NSStringBlock) (NSString *addressString);
typedef void (^LocationAndAddressBlock) (CLLocationCoordinate2D locationCorrrdinate, CLLocation *newLocation, NSString *addressString);


@interface MMLocationManager : NSObject<CLLocationManagerDelegate>

@property(nonatomic, strong) CLLocationManager* myLocationMangr;
@property (nonatomic) CLLocationCoordinate2D lastCoordinate;
@property(nonatomic,strong)NSString *lastCity;
@property (nonatomic,strong) NSString *lastAddress;
@property (nonatomic, assign) NSInteger errorType;
@property(nonatomic,assign)float latitude;
@property(nonatomic,assign)float longitude;
@property(nonatomic,assign)BOOL showToast;

+ (MMLocationManager *)shareLocation;


/**
 是否开启权限
 */
- (BOOL)canEnableLocation;

/**
 开启定位
 */
- (void)startLocation;

/**
 *升级精准定位 iOS14
 */
- (void)requestTemporaryFullAccuracy;

/**
 *请求临时精确位置授权（带回调，iOS 14+）
 */
- (void)requestTemporaryFullAccuracyWithCompletion:(void (^)(BOOL granted))completion;

/**
 *是否精准定位 iOS14
 */
- (BOOL)hasJingZhunLocation;
/**
 *  获取坐标
 *
 *  @param locaiontBlock locaiontBlock description
 */
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock ;

/**
 *  获取坐标和地址
 *
 *  @param locaiontBlock locaiontBlock description
 *  @param addressBlock  addressBlock description
 */
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock  withAddress:(NSStringBlock) addressBlock;

/**
 *  获取坐标和地址
 *
 *  @param LocationAndAddressBlock locaiontBlock description
 */
- (void) getLocationCoordinateAndAddress:(LocationAndAddressBlock)LocationAndAddressBlock;

/**
 *  获取地址
 *
 *  @param addressBlock addressBlock description
 */
- (void) getAddress:(NSStringBlock)addressBlock;

/**
 *  获取城市
 *
 *  @param cityBlock cityBlock description
 */
- (void) getCity:(NSStringBlock)cityBlock;

/**
 *  获取城市和定位失败
 *
 *  @param cityBlock  cityBlock description
 *  @param errorBlock errorBlock description
 */
- (void) getCity:(NSStringBlock)cityBlock error:(LocationErrorBlock) errorBlock;

@end
