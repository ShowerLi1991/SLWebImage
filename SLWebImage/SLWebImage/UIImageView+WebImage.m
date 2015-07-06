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
#import "NSString+SLExtension.h"


@implementation UIImageView (WebImage)

- (void)setCurrentURLStringMD5:(NSString *)currentURLStringMD5 {
    // 1. 关联到得对象
    // 2. 属性的key
    // 3. 记录属性的值
    // 4. 属性的引用关系
    objc_setAssociatedObject(self, @"helloKey", currentURLStringMD5, OBJC_ASSOCIATION_COPY);
}

- (NSString *)currentURLStringMD5 {
    return objc_getAssociatedObject(self, @"helloKey");
}


- (void)setimageWithURLString:(NSString *)urlString {
    
    DownloadManager * manager = [DownloadManager sharedDownloadManager];
    
    NSString * urlStringMD5 = urlString.md5String;
    
    if (![urlStringMD5 isEqualToString:self.currentURLStringMD5]) {
        [manager cancelDownloadOperationWithURLString:self.currentURLStringMD5];
        
        // 清空原有图片
        self.image = nil;
        // self.image = placeHolderImage;
    }
    
    self.currentURLStringMD5 = urlStringMD5;
    
    [manager downloadOperationWithURLString:urlString didFinished:^(UIImage * image) {
        self.image = image;
        [manager.downloadOperationCache removeObjectForKey:urlStringMD5];
        [manager.imageCache setObject:image forKey:urlStringMD5];
    }];
    
    
    
}

@end
