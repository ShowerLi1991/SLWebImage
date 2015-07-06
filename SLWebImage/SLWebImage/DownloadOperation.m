

#import "DownloadOperation.h"
#import "NSString+SLExtension.h"
#import "DownloadManager.h"


@implementation DownloadOperation


- (void)main {
    @autoreleasepool {
        
        NSURL * url = [NSURL URLWithString:self.urlString];
        NSData * data = [NSData dataWithContentsOfURL:url];
        
        NSString * urlStringMD5 = self.urlString.md5String;
        
#warning 再次异步写入磁盘
        // 修改异步执行
        if (data != nil) {
            
            [[DownloadManager sharedDownloadManager].writeToDiskQueue addOperationWithBlock:^{
                NSString * path = urlStringMD5.filePathInCaches;
                if (![data writeToFile:path atomically:YES]) {
                    NSLog(@"写入失败");
                }
            }];
        }
        
        [NSThread sleepForTimeInterval:4];
        
        if (self.isCancelled) {
            NSLog(@"写入磁盘后取消, 主线程不更新");
            [[DownloadManager sharedDownloadManager].downloadOperationCache removeObjectForKey:urlStringMD5];
            return;
        }
        
        UIImage * image = [UIImage imageWithData:data];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.didFinished(image);
        }];
    }
}

+ (instancetype)downloadOperationWithURLString:(NSString *)urlString didFinished:(void(^)(UIImage * image))didFinished {
    
    DownloadOperation * downloadOperation = [[DownloadOperation alloc] init];
    downloadOperation.urlString = urlString;
    downloadOperation.didFinished = didFinished;
    
    return downloadOperation;

}


@end
