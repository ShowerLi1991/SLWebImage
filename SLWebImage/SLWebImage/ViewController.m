//
//  ViewController.m
//  SLWebImage
//
//  Created by SL🐰鱼子酱 on 15/7/4.
//  Copyright © 2015年 SL🐰鱼子酱. All rights reserved.
//

#import "ViewController.h"
#import "AppInfos.h"
#import "DownloadManager.h"
#import "UIImageView+WebImage.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSArray * appList;


@end

@implementation ViewController

- (NSArray *)appList {
    if (_appList == nil) {
        _appList = [AppInfos appList];
    }
    return _appList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

static dispatch_once_t onceToken = 0;
static int theIndex = 0;

- (void)touchesBegan:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    
    dispatch_once(&onceToken, ^{
        NSLog(@"%@", NSHomeDirectory());
    });
    
    AppInfos * app = self.appList[theIndex++%10];
    
    [self.imageView setimageWithURLString:app.icon];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    DownloadManager * manager = [DownloadManager sharedDownloadManager];

    NSLog(@"%@", manager.downloadOperationCache);
}

@end
