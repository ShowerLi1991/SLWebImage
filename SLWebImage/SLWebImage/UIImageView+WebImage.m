//
//  UIImageView+WebImage.m
//  SLWebImage
//
//  Created by SL🐰鱼子酱 on 15/7/5.
//  Copyright © 2015年 SL🐰鱼子酱. All rights reserved.
//

#import "UIImageView+WebImage.h"
#import "DownloadManager.h"
#import <objc/runtime.h>


@implementation UIImageView (WebImage)

- (void)setCurrentURLString:(NSString *)currentURLString {
    // 1. 关联到得对象
    // 2. 属性的key
    // 3. 记录属性的值
    // 4. 属性的引用关系
    objc_setAssociatedObject(self, @"helloKey", currentURLString, OBJC_ASSOCIATION_COPY);
}

- (NSString *)currentURLString {
    return objc_getAssociatedObject(self, @"helloKey");
}


- (void)setimageWithURLString:(NSString *)urlString {
    
    DownloadManager * manager = [DownloadManager sharedDownloadManager];
    
    if (![urlString isEqualToString:self.currentURLString]) {
        [manager cancelDownloadOperationWithURLString:self.currentURLString];
        
        // 清空原有图片
        self.image = nil;
//        self.image = placeHolderImage;
    }
    
    self.currentURLString = urlString;
    
    [manager downloadOperationWithURLString:urlString didFinished:^(UIImage * image) {
        self.image = image;
        [manager.downloadOperationCache removeObjectForKey:urlString];
        [manager.imageCache setObject:image forKey:urlString];
    }];
    
    
    
}

@end
