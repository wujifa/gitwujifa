//
//  ViewController.m
//  ScoketPractise
//
//  Created by Jifa on 16/1/6.
//  Copyright © 2016年 Jifa. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"
#define HOST_IP @"192.168.0.13"
//#define HOST_PORT 5677
//#define HOST_IP @"192.168.0.153"
#define HOST_PORT 8080
@interface ViewController ()<GCDAsyncSocketDelegate>{

GCDAsyncSocket *_socket;

}
@property (strong,nonatomic)NSArray *arr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)conectionserver:(id)sender {
    
    _socket=[[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    //连接
    NSError *error = nil;
    [_socket connectToHost:HOST_IP onPort:HOST_PORT error:&error];
    
    if (error) {
        NSLog(@"%@",error);
    }
    //<066DFF505052675187055242>
    //AYK004227
    

    
}
- (IBAction)login:(id)sender {
    
    //拼接登录的指令 iam:zhangsan
    //ws://192.168.0.13:8080/core/user/login?userMobile=15710065647&passWord=111111
    NSString *loginStr = @"core/user/login?userMobile=15710065647&passWord=111111";

    NSLog(@"111");
    //-1不设置超时
    [_socket writeData:[loginStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:101];
}
    
#pragma mark -socket的代理
#pragma mark 连接成功
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"1112$$$$$%s",__func__);
    //发送登录请求 使用输出流
    
    
}


#pragma mark 断开连接
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    
    if (err) {
        NSLog(@"连接失败");
    }else{
        NSLog(@"正常断开");
    }
}
#pragma mark 数据发送成功
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"呵呵%s",__func__);
    
    //发送完数据手动读取
    [sock readDataWithTimeout:-1 tag:tag];
}


#pragma mark 读取数据
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    //发送完数据手动读取
    [sock readDataWithTimeout:-1 tag:tag];
    //代理是在子线程调用
    NSLog(@"%@",[NSThread currentThread]);
    
    NSError *error;
    NSLog(@"%@",data);
    
    //1.
     self.arr = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error:&error];
    if(error!=nil){
        NSLog(@"error :%@",[error localizedDescription]);
    }else{
        NSLog(@"arr :%@",self.arr);
        
    }
//2.
    NSString *receiverStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
   ;
    
    
    NSLog(@"%s %@",__func__,receiverStr);
    
    
    //3.
    NSArray *newarr=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"%@",newarr);
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
