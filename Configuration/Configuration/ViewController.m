//
//  ViewController.m
//  Configuration
//
//  Created by czbk on 16/7/17.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong,nonatomic) NSURLSession *session;
@property (weak, nonatomic) IBOutlet UIWebView *myWeb;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self loadData];
}


-(void)loadData{
    //
    //NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    NSURL *url = [NSURL URLWithString:@"http://www.qiushibaike.com"];
    
    NSURLSessionDataTask *tak = [self.session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error == nil){
            NSString *html = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",html);
            
            [self.myWeb loadHTMLString:html baseURL:url];
        }
    }];
    [tak resume];
}


#pragma mark -懒加载
-(NSURLSession *)session{
    if(nil == _session){
        //配置信息
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.HTTPAdditionalHeaders = @{@"User-Agent":@"iphone"};
        
        _session = [NSURLSession sessionWithConfiguration:configuration];
    }
    return _session;
}

@end
