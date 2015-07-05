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
    
    if (self.downloadOperationCache[urlString] != nil) {
        NSLog(@"正在下载中, 已经在下载操作缓存中");
        return;
    }
    
#warning 有缓存返回缓存
    if ([self checkImageIsInCache:urlString]) {
        didFinished(self.imageCache[urlString]);
        return;
    }
    
    DownloadOperation * downloadOperation = [DownloadOperation downloadOperationWithURLString:urlString didFinished:^(UIImage *image) {
        didFinished(image);
    }];
    
    
    [self.downloadOperationCache setObject:downloadOperation forKey:urlString];
    [self.downloadOperationQueue addOperation:downloadOperation];
}

- (BOOL)checkImageIsInCache:(NSString *)urlString {
    if ([self checkImageIsInMemoryCache:urlString]) {
        return true;
    }
    if ([self checkImageIsInDiskCache:urlString]) {
        return true;
    }
    return false;
}

- (BOOL)checkImageIsInMemoryCache:(NSString *)urlString {
    
    if (self.imageCache[urlString] != nil) {
        NSLog(@"内存缓存");
        return true;
    }
    return false;
}

- (BOOL)checkImageIsInDiskCache:(NSString *)urlString {

    // 有磁盘缓存, 写入内存
    UIImage * cache = [UIImage imageWithContentsOfFile:urlString.filePathInCaches];
    if (cache != nil) {
        [self.imageCache setObject:cache forKey:urlString];
        NSLog(@"磁盘缓存");
        return true;
    }
    return false;
}

- (void)cancelDownloadOperationWithURLString:(NSString *)urlString {
    
    DownloadOperation * downloadOperation = self.downloadOperationCache[urlString];
    
    if (downloadOperation == nil) {
        return;
    }
    
    [downloadOperation cancel];
    
    [self.downloadOperationCache removeObjectForKey:urlString];
    
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

- (NSMutableDictionary *)downloadOperationCache {
    if (_downloadOperationCache == nil) {
        _downloadOperationCache = [NSMutableDictionary dictionary];
    }
    return _downloadOperationCache;
}

@end
