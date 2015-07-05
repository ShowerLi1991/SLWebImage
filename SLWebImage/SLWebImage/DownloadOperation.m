

#import "DownloadOperation.h"
#import "NSString+SLExtension.h"


@implementation DownloadOperation


- (void)main {
    @autoreleasepool {
        

        NSLog(@"%@ %@",self.urlString, [NSThread currentThread]);
        NSURL * url = [NSURL URLWithString:self.urlString];
        NSData * data = [NSData dataWithContentsOfURL:url];
    
        
#warning 主线程更新取消, 保存到磁盘不取消, 异步保存 TODO 注意线程安全, 使用 dictionary_M 缓存
        // 修改异步执行
        if (data != nil) {
                NSString * path = @"";
            if (![data writeToFile:path atomically:YES]) {
                NSLog(@"写入失败");
            }
        }
        
        [NSThread sleepForTimeInterval:1];
        
        if (self.isCancelled) {
            NSLog(@"写入磁盘后取消取消, 主线程不更新");
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
