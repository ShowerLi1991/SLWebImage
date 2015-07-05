//
//  DownloadOperation.h
//  SLWebImage
//
//  Created by SL🐰鱼子酱 on 15/7/4.
//  Copyright © 2015年 SL🐰鱼子酱. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadOperation : NSOperation

@property (copy, nonatomic) NSString * urlString;
@property (copy, nonatomic) void(^didFinished)(UIImage *);

+ (instancetype)downloadOperationWithURLString:(NSString *)urlString didFinished:(void(^)(UIImage * image))didFinished;

@end
