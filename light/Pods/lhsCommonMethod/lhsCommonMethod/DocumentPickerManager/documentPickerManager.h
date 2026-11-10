//
//  documentPickerManager.h
//  YYElectricMoto
//
//  Created by PC-IT-LHS on 2026/1/7.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^DocumentPickerCompletionBlock)(NSArray<NSURL *> * _Nullable fileURLs, NSArray<NSString *> * _Nullable fileNames, NSArray<NSData *> * _Nullable fileDatas);
typedef void (^ImagePickerCompletionBlock)(NSArray<UIImage *> * _Nullable images, NSArray<NSData *> * _Nullable imageDatas);

@interface documentPickerManager : NSObject

+ (instancetype)sharedManager;

- (void)showPickerWithViewController:(UIViewController *)viewController
                     allowMultipleFiles:(BOOL)allowMultipleFiles
                    allowMultiplePhotos:(BOOL)allowMultiplePhotos
                         completion:(DocumentPickerCompletionBlock)documentCompletion
                    imageCompletion:(ImagePickerCompletionBlock)imageCompletion;

@end



//使用方法
//[[documentPickerManager sharedManager] showPickerWithViewController:self allowMultipleFiles:YES allowMultiplePhotos:YES completion:^(NSArray<NSURL *> * _Nullable fileURLs, NSArray<NSString *> * _Nullable fileNames, NSArray<NSData *> * _Nullable fileDatas) {
//    DLog(@"---fileURL---%@",fileURLs);
//    DLog(@"---fileName---%@",fileNames);
//    DLog(@"---fileData---%@",fileDatas);
//} imageCompletion:^(NSArray<UIImage *> * _Nullable images, NSArray<NSData *> * _Nullable imageDatas) {
//    DLog(@"---images---%@",images);
//    DLog(@"---imageDatas---%@",imageDatas);
//}];

NS_ASSUME_NONNULL_END
