//
//  ViewController.m
//  08-NSURLSession的https使用
//
//  Created by apple on 16/7/17.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLSessionDataDelegate>
@property (nonatomic, strong) NSURLSession *session;
@end

@implementation ViewController
-(NSURLSession *)session
{
    if (_session == nil) {
        NSURLSessionConfiguration *Configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:Configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self loadWeb];
}
- (void)loadWeb{
    //url
    NSURL *url = [NSURL URLWithString:@"https://mail.itcast.cn"];
    
  
    NSURLSessionDataTask *task = [self.session dataTaskWithURL:url];
    [task resume];
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    NSLog(@"%@",data);
}
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    
}
//信任服务器
-(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    NSLog(@"didReceiveChallenge");
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        /*
        NSURLSessionAuthChallengeUseCredential
        NSURLSessionAuthChallengePerformDefaultHandling
        NSURLSessionAuthChallengeCancelAuthenticationChallenge
        NSURLSessionAuthChallengeRejectProtectionSpace

         */
         // 从受保护空间内获取到身份质询的证书
        NSURLCredential * credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        
        //completionHandler
        completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
    }
}
@end
