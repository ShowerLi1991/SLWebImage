//
//  DownloadManager.h
//  SLWebImage
//
//  Created by SL🐰鱼子酱 on 15/7/5.
//  Copyright © 2015年 SL🐰鱼子酱. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadManager : NSObject

@property (strong, nonatomic) NSMutableDictionary * downloadOperationCache;
@property (strong, nonatomic) NSMutableDictionary * imageCache;
@property (strong, nonatomic) NSOperationQueue * writeToDiskQueue;

+ (instancetype)sharedDownloadManager;

- (void)downloadOperationWithURLString:(NSString *)urlString didFinished:(void (^)(UIImage * image))didFinished;
- (void)cancelDownloadOperationWithURLString:(NSString *)urlString;
@end
