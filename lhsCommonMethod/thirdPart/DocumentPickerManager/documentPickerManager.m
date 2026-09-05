//
//  documentPickerManager.m
//  YYElectricMoto
//
//  Created by PC-IT-LHS on 2026/1/7.
//

#import "documentPickerManager.h"
#import <PhotosUI/PhotosUI.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface documentPickerManager () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate, PHPickerViewControllerDelegate>

@property (nonatomic, copy) DocumentPickerCompletionBlock documentCompletion;
@property (nonatomic, copy) ImagePickerCompletionBlock imageCompletion;
@property (nonatomic, weak) UIViewController *presentingViewController;
@property (nonatomic, assign) BOOL allowMultipleFiles;
@property (nonatomic, assign) BOOL allowMultiplePhotos;

@end

@implementation documentPickerManager

+ (instancetype)sharedManager {
    static documentPickerManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[documentPickerManager alloc] init];
    });
    return sharedInstance;
}

- (void)showPickerWithViewController:(UIViewController *)viewController
                  allowMultipleFiles:(BOOL)allowMultipleFiles
                 allowMultiplePhotos:(BOOL)allowMultiplePhotos
                         completion:(DocumentPickerCompletionBlock)documentCompletion
                    imageCompletion:(ImagePickerCompletionBlock)imageCompletion {
    self.documentCompletion = documentCompletion;
    self.imageCompletion = imageCompletion;
    self.presentingViewController = viewController;
    self.allowMultipleFiles = allowMultipleFiles;
    self.allowMultiplePhotos = allowMultiplePhotos;

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openAlbum];
    }];

    UIAlertAction *fileAction = [UIAlertAction actionWithTitle:@"文件" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openDocumentPicker];
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

    [alertController addAction:albumAction];
    [alertController addAction:fileAction];
    [alertController addAction:cancelAction];

    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        alertController.popoverPresentationController.sourceView = viewController.view;
        alertController.popoverPresentationController.sourceRect = CGRectMake(viewController.view.bounds.size.width / 2, viewController.view.bounds.size.height / 2, 0, 0);
        alertController.popoverPresentationController.permittedArrowDirections = 0;
    }

    [viewController presentViewController:alertController animated:YES completion:nil];
}

- (void)openAlbum {
    
    //iOS14以上系统自带相册才支持多选
    if (@available(iOS 14, *)) {
        PHPickerConfiguration *config = [[PHPickerConfiguration alloc] init];
        config.selectionLimit = self.allowMultiplePhotos ? 0 : 1;
        config.filter = [PHPickerFilter imagesFilter];
        PHPickerViewController *pickerViewController = [[PHPickerViewController alloc] initWithConfiguration:config];
        pickerViewController.delegate = (id<PHPickerViewControllerDelegate>)self;
        pickerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.presentingViewController presentViewController:pickerViewController animated:YES completion:nil];
    } else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = NO;
        picker.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.presentingViewController presentViewController:picker animated:YES completion:nil];
    }
}

- (void)openDocumentPicker {
    NSArray *types = @[@"public.content",
                       @"public.text",
                       @"public.source-code",
                       @"public.image",
                       @"public.audiovisual-content",
                       @"com.adobe.pdf",
                       @"com.apple.keynote.key",
                       @"com.microsoft.word.doc",
                       @"com.microsoft.excel.xls",
                       @"com.microsoft.powerpoint.ppt"];

    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:types inMode:UIDocumentPickerModeOpen];
    documentPicker.delegate = self;
    documentPicker.allowsMultipleSelection = self.allowMultipleFiles;
    documentPicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.presentingViewController presentViewController:documentPicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];

    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (image) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
        if (self.imageCompletion) {
            self.imageCompletion(@[image], @[imageData]);
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PHPickerViewControllerDelegate

- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results API_AVAILABLE(ios(14)) {
    [picker dismissViewControllerAnimated:YES completion:nil];

    if (results.count == 0) {
        return;
    }

    NSMutableArray<UIImage *> *images = [NSMutableArray array];
    NSMutableArray<NSData *> *imageDatas = [NSMutableArray array];

    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    for (PHPickerResult *result in results) {
        NSItemProvider *provider = result.itemProvider;
        if ([provider canLoadObjectOfClass:UIImage.class]) {
            dispatch_group_enter(group);
            [provider loadObjectOfClass:UIImage.class completionHandler:^(UIImage *image, NSError *error) {
                if (image && !error) {
                    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
                    @synchronized (images) {
                        [images addObject:image];
                        [imageDatas addObject:imageData ?: [NSData data]];
                    }
                }
                dispatch_group_leave(group);
            }];
        }
    }

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (self.imageCompletion && images.count > 0) {
            self.imageCompletion([images copy], [imageDatas copy]);
        }
    });
}

#pragma mark - UIDocumentPickerDelegate

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    if (urls.count == 0) {
        if (self.documentCompletion) {
            self.documentCompletion(@[], @[], @[]);
        }
        return;
    }

    // 使用 OperationQueue 来控制并发数量
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    operationQueue.maxConcurrentOperationCount = 3; // 控制最大并发数
    operationQueue.name = @"DocumentPickerFileReadQueue";
    
    NSMutableArray<NSURL *> *fileURLs = [NSMutableArray array];
    NSMutableArray<NSString *> *fileNames = [NSMutableArray array];
    NSMutableArray<NSData *> *fileDatas = [NSMutableArray array];
    
    NSMutableArray *operations = [NSMutableArray array];
    
    for (NSURL *fileURL in urls) {
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            BOOL accessing = [fileURL startAccessingSecurityScopedResource];
            NSData *fileData = nil;
            NSString *fileName = nil;
            
            if (accessing) {
                @try {
                    fileData = [NSData dataWithContentsOfURL:fileURL options:NSDataReadingMappedIfSafe error:nil];
                    fileName = [fileURL lastPathComponent];
                } @catch (NSException *exception) {
                    NSLog(@"Error reading file: %@, Error: %@", fileURL.path, exception.reason);
                    fileData = [NSData data];
                    fileName = @"unknown_file";
                } @finally {
                    [fileURL stopAccessingSecurityScopedResource];
                }
            } else {
                NSLog(@"Failed to access security scoped resource: %@", fileURL.path);
                fileData = [NSData data];
                fileName = @"unknown_file";
            }
            
            // 添加到结果数组（需要线程安全）
            @synchronized (fileURLs) {
                if (fileData) {
                    [fileURLs addObject:fileURL];
                    [fileNames addObject:fileName ?: @"unknown_file"];
                    [fileDatas addObject:fileData];
                }
            }
        }];
        
        [operations addObject:operation];
    }
    
    // 添加完成回调操作
    NSBlockOperation *completionOperation = [NSBlockOperation blockOperationWithBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.documentCompletion) {
                self.documentCompletion([fileURLs copy], [fileNames copy], [fileDatas copy]);
            }
        });
    }];
    
    // 设置依赖关系
    for (NSOperation *operation in operations) {
        [completionOperation addDependency:operation];
        [operationQueue addOperation:operation];
    }
    
    [operationQueue addOperation:completionOperation];
}

- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
}

@end
