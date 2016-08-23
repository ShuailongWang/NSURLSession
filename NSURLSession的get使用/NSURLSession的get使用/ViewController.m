//
//  ViewController.m
//  NSURLSession的get使用
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


-(void)loadData{
    //服务器地址
    NSURL *url = [NSURL URLWithString:@"http://localhost/demo.json"];
    
    //session
    NSURLSession *session = [NSURLSession sharedSession];
    
    //
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //判断
        if(error == nil){
            //
            id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@"%@",result);
        }
    }];
    
    //调用resume
    [task resume];
}




@end
