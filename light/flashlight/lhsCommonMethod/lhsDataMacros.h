//
//  lhsDataMacros.h
//  YYElectricMoto
//
//  Created by PC-IT-LHS on 2025/11/29.
//

#ifndef lhsDataMacros_h
#define lhsDataMacros_h

#import "thirdPart/HexColors/HexColors.h"

//颜色设置
#define  colorWith(string)   [UIColor hx_colorWithHexRGBAString:string]


//主暗 黑色
#define color151f38         colorWith(@"151f38")
//标注 黄色
#define colorff5d15         colorWith(@"ff5d15")
//按钮 蓝色
#define color8ae3ff         colorWith(@"8ae3ff")
//按钮 蓝色加深
#define color57cbf0         colorWith(@"57cbf0")
//线条 灰色
#define colore6e6e6         colorWith(@"e6e6e6")
//底 灰色
#define colorf2f2f2         colorWith(@"f2f2f2")

//标题、重点文字、正文
#define color1a1a1a         colorWith(@"1a1a1a")
//灰底
#define colorf2f2f2         colorWith(@"f2f2f2")
//未选中状态
#define colorcccccc         colorWith(@"cccccc")
//浅灰背景
#define colorededed         colorWith(@"ededed")
//白色背景
#define colorffffff         colorWith(@"ffffff")
//
#define color111         colorWith(@"")



#define color333333         colorWith(@"333333")
#define color666666         colorWith(@"666666")
#define color999999         colorWith(@"999999")
#define colorf0f0f0         colorWith(@"f0f0f0")
#define colorf7f7f7         colorWith(@"f7f7f7")


//iPhone4
#define ISIPHONE4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
//判断为iPhone5
#define ISIPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//iPhone6
#define ISIPHONE6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

//iPhone6Plus      宽414     高736
#define ISIPHONE6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

//iPhone6Plus放大模式
#define ISIPHONE6PlusBigMode ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)

// 判断iPHoneXr、iphone11     宽414     高896
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)

// 判断iPhoneXsMax、iphone11proMax  宽414    高896
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)


// 判断iPhoneX、iPhoneXs、iphone11pro (包含iphone12 mini)                          宽375  高812
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

// 判断iPhone12mini iPhone13mini      宽360  高780  打印出来跟iPhone X尺寸一样：      宽375  高812
#define IS_IPHONE_12mini ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1080, 2340), [[UIScreen mainScreen] currentMode].size) : NO)

// 判断iPhone12、iPhone12Pro、iPhone13、iPhone13Pro                      宽390  高844
#define IS_IPHONE_12 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1170, 2532), [[UIScreen mainScreen] currentMode].size) : NO)

// 判断iPhone12ProMax、 iPhone13ProMax  iPhone14plus                    宽428  高926
#define IS_IPHONE_12_proMax ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1284, 2778), [[UIScreen mainScreen] currentMode].size) : NO)

// 判断iPhone14Pro   iPhone15  iPhone15Pro  Phone16  iPhone 16e         宽393 高852
#define IS_IPHONE_14_pro ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1179, 2556), [[UIScreen mainScreen] currentMode].size) : NO)

// 判断iPhone14ProMax   iPhone15Plus  iPhone15ProMax  iPhone16Plus      宽430 高932
#define IS_IPHONE_14_proMax ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1290, 2796), [[UIScreen mainScreen] currentMode].size) : NO)

// 判断iPhoneAir                             宽420 高912
#define IS_IPHONE_Air ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1260, 2736), [[UIScreen mainScreen] currentMode].size) : NO)

// 判断iPhone16Pro  iPhone17  iPhone17Pro    宽402 高874
#define IS_IPHONE_16_pro ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1206, 2622), [[UIScreen mainScreen] currentMode].size) : NO)

// 判断iPhone16ProMax   iPhone17ProMax       宽440 高956
#define IS_IPHONE_16_pro_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1320, 2868), [[UIScreen mainScreen] currentMode].size) : NO)




#define iPhone12mini  (SLBScreenH == 780)
#define iPhoneX  (SLBScreenH == 812)
#define iPhone6P (SLBScreenH == 736)
#define iPhone6  (SLBScreenH == 667)
#define iPhone5  (SLBScreenH == 568)
#define iPhone4  (SLBScreenH == 480)

#define hasLiuHai     [UIApplication appSceneWindow].safeAreaInsets.top > 20

//导航栏高度
#define SLBNavBarHeight               44.f
//状态栏高度
#define SLBStatusBarHeight  [UIApplication appSceneWindow].windowScene.statusBarManager.statusBarFrame.size.height

//tabbar高度
#define SLBTabBarHeight                     49.f
#define SLBBottomHeight                     (hasLiuHai ? 34.f : 0.f)
#define SLBTabBarAndBottomHeight            (hasLiuHai ? 49.f+34.f : 49.f)

#define SLBScreenW                          [[UIScreen mainScreen] bounds].size.width
#define SLBScreenH                          [[UIScreen mainScreen] bounds].size.height

#define SysVersion                          [[UIDevice currentDevice] systemVersion].floatValue


#define ViewWidth(v)                        v.frame.size.width
#define ViewHeight(v)                       v.frame.size.height
#define ViewX(v)                            v.frame.origin.x
#define ViewY(v)                            v.frame.origin.y
#define SelfViewHeight                      self.view.bounds.size.height
#define RectX(f)                            f.origin.x
#define RectY(f)                            f.origin.y
#define RectWidth(f)                        f.size.width
#define RectHeight(f)                       f.size.height
#define RectSetWidth(f, w)                  CGRectMake(RectX(f), RectY(f), w, RectHeight(f))
#define RectSetHeight(f, h)                 CGRectMake(RectX(f), RectY(f), RectWidth(f), h)
#define RectSetX(f, x)                      CGRectMake(x, RectY(f), RectWidth(f), RectHeight(f))
#define RectSetY(f, y)                      CGRectMake(RectX(f), y, RectWidth(f), RectHeight(f))
#define RectSetSize(f, w, h)                CGRectMake(RectX(f), RectY(f), w, h)
#define RectSetOrigin(f, x, y)              CGRectMake(x, y, RectWidth(f), RectHeight(f))
#define Rect(x, y, w, h)                    CGRectMake(x, y, w, h)
#define Size(w, h)                          CGSizeMake(w, h)
#define Point(x, y)                         CGPointMake(x, y)


//字体大小
#define kFont(size) ([UIFont systemFontOfSize:(size)])
//本地图片
#define kImage(str) ([UIImage imageNamed:str])


//************************   判断对象是否为空   ************************

// 字符串
#define QM_IS_STR_NIL(objStr) (![objStr isKindOfClass:[NSString class]] || objStr == nil || [objStr length] <= 0 || [objStr isEqualToString:@"(null)"]|| [objStr isEqualToString:@""] ||[objStr isEqualToString:@"<null>"] || [objStr isKindOfClass:[NSNull class]])

// 字典
#define QM_IS_DICT_NIL(objDict) (![objDict isKindOfClass:[NSDictionary class]] || objDict == nil || [objDict count] <= 0 || [objDict isKindOfClass:[NSNull class]])

// 数组
#define QM_IS_ARRAY_NIL(objArray) (![objArray isKindOfClass:[NSArray class]] || objArray == nil || [objArray count] <= 0)

// float
#define QM_IS_FLOAT_NIL(objFloat) (objFloat == nil)


#define str(text)  QM_IS_STR_NIL(text)?@"":text
#define _str(text)  QM_IS_STR_NIL(text)?@"-":text
#define string(text,text1)  QM_IS_STR_NIL(text)?text1:text

//************************     强弱引用     ************************

//先ldz_Weak，然后使用时候先ldz_Strong(type)，然后在调用，防止取值为空
#define ldz_Weak(type)    __weak __typeof(type) weak##type = type;
#define ldz_Strong(type)  __strong __typeof(weak##type) strong##type = weak##type;

//************************     单例化一个类     ************************
// @interface
#define singleton_interface(className) \
+ (className *)sharedInstace##className;\

// @implementation
#define singleton_implementation(className) \
static className *_instance; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (className *)sharedInstace##className \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}


#define LDZStatementAndPropSetFuncStatement(propertyModifier,className, propertyPointerType, propertyName)        \
@property(nonatomic,propertyModifier)propertyPointerType  propertyName;                                           \
- (className * (^) (propertyPointerType propertyName)) propertyName##Set;

#define LDZSetFuncImplementation(className, propertyPointerType, propertyName)                                    \
- (className * (^) (propertyPointerType propertyName))propertyName##Set{                                          \
return ^(propertyPointerType propertyName) {                                                                      \
self->_##propertyName = propertyName;                                                                             \
return self;                                                                                                      \
};                                                                                                                \
}

//打印log
#ifdef DEBUG
#define DLogg(fmt, ...)  NSLog((@"[文件名:%s]" "[函数名:%s]" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#define DLog(fmt, ...)   NSLog((@"[函数名:%s]" "[行号:%d] \n" fmt), __FUNCTION__, __LINE__, ##__VA_ARGS__);

#else
#define DLog(...)
#endif


#define VCName     NSStringFromClass([(UINavigationController *)self.window.rootViewController topViewController].class);

//存储在本地
#define kUserDefaults  [NSUserDefaults standardUserDefaults]

// 快速宏定义__block
#define KBlockObj(blockName)       typedef void(^blockName)(void)
#define KBlockObj1(blockName,...)  typedef void(^blockName)(__VA_ARGS__)
// 判断block 是否存在之后传值
#define KBlockExistence(Block, ...) !Block ?: Block(__VA_ARGS__)



#endif /* lhsDataMacros_h */
