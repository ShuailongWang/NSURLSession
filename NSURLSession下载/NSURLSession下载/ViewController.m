//
//  ViewController.m
//  NSURLSession下载
//
//  Created by czbk on 16/7/17.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLSessionDownloadDelegate>


@property (strong,nonatomic) NSURLSession *downSession;
@property (strong,nonatomic) NSURLSessionDownloadTask *task;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}


-(IBAction)clickButton:(UIButton*)sender{
    NSLog(@"123");
    //服务器文件
    NSURL *url = [NSURL URLWithString:@"http://localhost/hao456.zip"];
    
    //这两句代码不管用,NSURLSession做下载的时候,block和代理不能够同时使用
//    NSURLSessionDownloadTask *task = [self.session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        //
//        if(error == nil){
//            NSLog(@"%@",location.path);
//        }else{
//            NSLog(@"123");
//        }
//    }];
//    [task resume];
    //
    self.task = [self.downSession downloadTaskWithURL:url];
    [self.task resume];
}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSLog(@"下载进度 %.2f",(float)totalBytesWritten/totalBytesExpectedToWrite);
    
}
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"didFinish %@",location.path);
    
    //保存到本地桌面上
    [[NSFileManager defaultManager]copyItemAtPath:location.path toPath:@"/users/czbk/desktop/456.zip" error:nil];
}


#pragma mark -懒加载
-(NSURLSession *)downSession{
    if(nil == _downSession){
        //配置信息
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        //
        _downSession = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _downSession;
}


@end
