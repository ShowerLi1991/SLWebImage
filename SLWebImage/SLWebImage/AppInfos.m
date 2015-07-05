//
//  AppInfos.m
//  SLWebImage
//
//  Created by SL🐰鱼子酱 on 15/7/4.
//  Copyright © 2015年 SL🐰鱼子酱. All rights reserved.
//

#import "AppInfos.h"

@implementation AppInfos

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)appInfosWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}


+ (NSArray *)appList {
    
    NSURL * url = [[NSBundle mainBundle] URLForResource:@"apps" withExtension:@"plist"];
    if (!url) {
        NSAssert(0, @"\n\nClass\t: %@\n_cmd\t\t: %@\nself\t\t: %@\nError\t: \"url为空\"\n", self.class, NSStringFromSelector(_cmd), self);
    }

    NSArray * arrDicts = [NSArray arrayWithContentsOfURL:url];
    NSMutableArray * arrModels = [NSMutableArray arrayWithCapacity:arrDicts.count];
    for (NSDictionary * dict in arrDicts) {
        AppInfos * model = [AppInfos appInfosWithDict:dict];
        [arrModels addObject:model];
    }
    
    return arrModels.copy;
}


@end
