//
//  DownloadManager.m
//  SLWebImage
//
//  Created by SL🐰鱼子酱 on 15/7/5.
//  Copyright © 2015年 SL🐰鱼子酱. All rights reserved.
//

#import "DownloadManager.h"
#import "DownloadOperation.h"
#import "NSString+SLExtension.h"

@interface DownloadManager ()

@property (strong, nonatomic) NSOperationQueue * downloadOperationQueue;

@end

@implementation DownloadManager

+ (instancetype)sharedDownloadManager {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (void)downloadOperationWithURLString:(NSString *)urlString didFinished:(void (^)(UIImage *))didFinished {
    
    NSString * urlStringMD5 = urlString.md5String;
    
    if (self.downloadOperationCache[urlStringMD5] != nil) {
        NSLog(@"正在下载中, 已经在下载操作缓存中");
        return;
    }
    
#warning 有缓存返回缓存
    if ([self checkImageIsInCache:urlStringMD5]) {
        didFinished(self.imageCache[urlStringMD5]);
        return;
    }
    
    DownloadOperation * downloadOperation = [DownloadOperation downloadOperationWithURLString:urlString didFinished:^(UIImage *image) {
        didFinished(image);
    }];
    
    
    [self.downloadOperationCache setObject:downloadOperation forKey:urlStringMD5];
    [self.downloadOperationQueue addOperation:downloadOperation];
}

// 取消已有但还未完成的下载操作
- (void)cancelDownloadOperationWithURLString:(NSString *)urlStringMD5 {
    
    DownloadOperation * downloadOperation = self.downloadOperationCache[urlStringMD5];
    
    if (downloadOperation == nil) {
        return;
    }
    
    [downloadOperation cancel];

}


- (BOOL)checkImageIsInCache:(NSString *)urlStringMD5 {
    if ([self checkImageIsInMemoryCache:urlStringMD5]) {
        NSLog(@"内存缓存返回图片");
        return true;
    }
    if ([self checkImageIsInDiskCache:urlStringMD5]) {
        NSLog(@"磁盘缓存返回图片");
        return true;
    }
    return false;
}

- (BOOL)checkImageIsInMemoryCache:(NSString *)urlStringMD5 {
    
    if (self.imageCache[urlStringMD5] != nil) {
        return true;
    }
    return false;
}

- (BOOL)checkImageIsInDiskCache:(NSString *)urlStringMD5 {

    // 有磁盘缓存, 写入内存
    UIImage * cache = [UIImage imageWithContentsOfFile:urlStringMD5.filePathInCaches];
    if (cache != nil) {
        [self.imageCache setObject:cache forKey:urlStringMD5];
        return true;
    }
    return false;
}




- (NSMutableDictionary *)imageCache {
    if (_imageCache == nil) {
        _imageCache = [NSMutableDictionary dictionary];
    }
    return _imageCache;
}

- (NSOperationQueue *)downloadOperationQueue {
    if (_downloadOperationQueue == nil) {
        _downloadOperationQueue = [[NSOperationQueue alloc] init];
    }
    return _downloadOperationQueue;
}

- (NSOperationQueue *)writeToDiskQueue {
    if (_writeToDiskQueue == nil) {
        _writeToDiskQueue = [[NSOperationQueue alloc] init];
    }
    return _writeToDiskQueue;
}


- (NSMutableDictionary *)downloadOperationCache {
    if (_downloadOperationCache == nil) {
        _downloadOperationCache = [NSMutableDictionary dictionary];
    }
    return _downloadOperationCache;
}



@end
