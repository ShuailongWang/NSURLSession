//
//  ViewController.m
//  NSUELSession文件断点续传
//
//  Created by czbk on 16/7/17.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLSessionDownloadDelegate>

@property (strong,nonatomic) NSURLSession *downSession;
@property (strong,nonatomic) NSURLSessionDownloadTask *task;

@property (strong,nonatomic) NSData *myData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//下载
- (IBAction)downButton:(UIButton *)sender {
    //判断
    if(self.task == nil){
        if(self.myData == nil){
            //服务器文件地址
            NSURL *url = [NSURL URLWithString:@"http:127.0.0.1/hao456.zip"];
            
            //
            self.task = [self.downSession downloadTaskWithURL:url];
            
            [self.downSession downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                //
                [[NSFileManager defaultManager]copyItemAtPath:location.path toPath:@"" error:nil];
            }];
            
            [self.task resume];
        }else{
            NSLog(@"继续下载");
            //
            self.task = [self.downSession downloadTaskWithResumeData:self.myData];
            
            //
            [self.task resume];
        }
    }
}

//暂停
- (IBAction)pauseButton:(UIButton *)sender {
    /**
     *  暂停
     *  @param resumeData 已经传输的文件大小
     */
    [self.task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        //保存已经接受的文件
        self.myData = resumeData;
        
        self.task = nil;
    }];
}

#pragma mark -代理方法
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    NSLog(@"didFinish");
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes{

}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    NSLog(@"%0.2f",(float)totalBytesWritten/totalBytesExpectedToWrite);
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
