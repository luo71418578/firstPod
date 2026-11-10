//
//  lhsDataMacros.h
//  YYElectricMoto
//
//  Created by PC-IT-LHS on 2025/11/29.
//

#ifndef lhsDataMacros_h
#define lhsDataMacros_h

#import "HexColors/HexColors.h"
#import "Category/UIApplication+Extensions.h"

//颜色设置
#define  colorWith(string)   [UIColor hx_colorWithHexRGBAString:string]

#define colorffffff         colorWith(@"ffffff")
#define color333333         colorWith(@"333333")
#define color666666         colorWith(@"666666")
#define color999999         colorWith(@"999999")
#define colorf0f0f0         colorWith(@"f0f0f0")
#define colorf7f7f7         colorWith(@"f7f7f7")


#define hasLiuHai     [UIApplication appSafeAreaInsets].top > 20

//导航栏高度
#define SLBNavBarHeight               44.f
//状态栏高度
#define SLBStatusBarHeight  [UIApplication appSceneWindow].windowScene.statusBarManager.statusBarFrame.size.height

//tabbar高度
#define SLBTabBarHeight                     49.f
//底部安全区高度：直接读真实 safeAreaInsets，横竖屏/新老机型/折叠屏自适应（未挂载 window 时为 0）
#define SLBSafeBottomHeight                 ([UIApplication appSafeAreaInsets].bottom)
#define SLBBottomHeight                     SLBSafeBottomHeight
#define SLBTabBarAndBottomHeight            (SLBTabBarHeight + SLBSafeBottomHeight)

//窗口尺寸：折叠屏折叠/展开、iPad 分屏时实时跟随窗口变化，窗口未创建时回退屏幕尺寸
#define SLBScreenW                          [UIApplication appWindowSize].width
#define SLBScreenH                          [UIApplication appWindowSize].height

//去除安全区后的可用宽高（窗口宽高减去左右/上下安全区，刘海屏/灵动岛/折叠屏展开态按需避让）
#define SLBSafeAreaW                        (SLBScreenW - [UIApplication appSafeAreaInsets].left - [UIApplication appSafeAreaInsets].right)
#define SLBSafeAreaH                        (SLBScreenH - [UIApplication appSafeAreaInsets].top - [UIApplication appSafeAreaInsets].bottom)

//设计稿基准尺寸与等比缩放系数（基准 375x667）
#define SLBDesignWidth                      375.0
#define SLBDesignHeight                     667.0
#define SLBScaleW                           (SLBScreenW / SLBDesignWidth)
#define SLBScaleH                           (SLBScreenH / SLBDesignHeight)

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

// float/NSNumber
#define QM_IS_FLOAT_NIL(objFloat) (![objFloat isKindOfClass:[NSNumber class]] || objFloat == nil || [objFloat isEqualToNumber:@0])


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


//存储在本地
#define kUserDefaults  [NSUserDefaults standardUserDefaults]

// 快速宏定义__block
#define KBlockObj(blockName)       typedef void(^blockName)(void)
#define KBlockObj1(blockName,...)  typedef void(^blockName)(__VA_ARGS__)
// 判断block 是否存在之后传值
#define KBlockExistence(Block, ...) !Block ?: Block(__VA_ARGS__)



#endif /* lhsDataMacros_h */
