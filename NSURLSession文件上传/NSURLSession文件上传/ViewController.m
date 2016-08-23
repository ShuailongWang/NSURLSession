//
//  ViewController.m
//  NSURLSession文件上传
//
//  Created by czbk on 16/7/17.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

#import "ViewController.h"

#define kBoundary @"myData"

@interface ViewController ()<NSURLSessionDataDelegate>

@property (strong,nonatomic) NSURLSession *uploadSession;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self loadData];
}

- (void)loadData {
    //获取文件路径
    NSString *path = [[NSBundle mainBundle]pathForResource:@"mm.jpg" ofType:nil];
    
    //从路径获取文件,并转换成二进制
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    //调用文件上传方法
    [self uploadData:data serverName:@"userfile" fileName:@"meinv.jpg"];
}

/**
 *  上传的方法
 *
 *  @param data       上传的文件
 *  @param serverName 服务器上对应的字段
 *  @param fileName   上传到服务器后的名字
 */
-(void)uploadData:(NSData*)data serverName:(NSString*)serverName fileName:(NSString*)fileName{
    //服务器地址
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/post/upload.php"];
    
    //请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //设置请求方式
    request.HTTPMethod = @"POST";
    
    //设置请求头
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",kBoundary] forHTTPHeaderField:@"Content-Type"];
    
    //设置请求体
    request.HTTPBody = [self fromHTTPBodyWithData:data serverName:serverName fileName:fileName];
    
    //session
    NSURLSessionUploadTask *task = [self.uploadSession uploadTaskWithRequest:request fromData:request.HTTPBody completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //
        if(error == nil){
            //
            id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@"%@",result);
        }
    }];
    //调用resume
    [task resume];
    
}
/**
 *  数据传输方法
 *
 *  @param session                  session
 *  @param task                     哪个task
 *  @param bytesSent                每次发送给服务器的字节数
 *  @param totalBytesSent           当前已经发送给服务器的字节数
 *  @param totalBytesExpectedToSend 要发送给服务器的总大小
 */
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    
    NSLog(@"session -> %@",session);
    NSLog(@"task -> %@",task);
    NSLog(@"bytesSent -> %lld",bytesSent);
    NSLog(@"totalBytesSent -> %lld",totalBytesSent);
    NSLog(@"totalBytesExpectedToSend -> %lld",totalBytesExpectedToSend);
    
    //
    NSLog(@"%0.2f",(float)totalBytesSent/totalBytesExpectedToSend);
}

/**
 *  拼接请求体
 *
 *  @param data       要上传的文件
 *  @param serverName 服务器上对应的字段
 *  @param fileName   上传到服务器上的名字
 */
-(NSData *)fromHTTPBodyWithData:(NSData*)data serverName:(NSString*)serverName fileName:(NSString*)fileName{
    //创建可变data
    NSMutableData *dataM = [NSMutableData data];
    NSMutableString *strM = [NSMutableString string];
    
    //开始追加字符串
    [strM appendFormat:@"--%@\r\n",kBoundary];
    [strM appendFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n",serverName,fileName];
    [strM appendFormat:@"Content-Type: application/octet-stream\r\n\r\n"];
    
    //把追加的字符串转换成二进制
    NSData *strData = [strM dataUsingEncoding:NSUTF8StringEncoding];
    
    //dataM添加上面的字符串,要上传的数据,还有小尾巴
    [dataM appendData:strData];
    [dataM appendData:data];
    [dataM appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n\r\n",kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //返回所有的拼接字符串
    return dataM.copy;
}


#pragma mark -懒加载
-(NSURLSession *)uploadSession{
    if(nil == _uploadSession){
        //配置信息
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        /**
         *  配置信息
         *  代理
         *  队列
         */
        _uploadSession = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _uploadSession;
}


@end
