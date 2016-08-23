//
//  ViewController.m
//  NSURLSession的post使用
//
//  Created by czbk on 16/7/17.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self loadData];
}

- (void)loadData {
    //服务器
    NSURL *url = [NSURL URLWithString:@"http://localhost/login.php"];
    
    //请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //设置请求方式
    request.HTTPMethod = @"POST";
    
    //设置请求体
    NSString *data = [NSString stringWithFormat:@"username=zhangsan&password=zhang"];
    request.HTTPBody = [data dataUsingEncoding:NSUTF8StringEncoding];
    
    //session
    NSURLSession *session = [NSURLSession sharedSession];
    
    //
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //
        if(error == nil){
            id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"%@",result);
        }
    }];
    
    //
    [task resume];
}

@end
