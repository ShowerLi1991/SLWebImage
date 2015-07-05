//
//  AppInfos.h
//  SLWebImage
//
//  Created by SL🐰鱼子酱 on 15/7/4.
//  Copyright © 2015年 SL🐰鱼子酱. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppInfos : NSObject

@property (copy, nonatomic) NSString * name;
@property (copy, nonatomic) NSString * icon;
@property (copy, nonatomic) NSString * download;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)appInfosWithDict:(NSDictionary *)dict;

+ (NSArray *)appList;


@end
