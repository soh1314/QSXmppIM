//
//  ViewController.m
//  QSXmppIM
//
//  Created by jingshuihuang on 16/6/23.
//  Copyright © 2016年 QS. All rights reserved.
//

#import "ViewController.h"
#import "QSXmppManager.h"
@interface ViewController ()<XMPPStreamDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[QSXmppManager defaultManager].stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
//    [[QSXmppManager defaultManager] registerWithUserName:@"天气好热" andPassWord:@"123456"];
    [[QSXmppManager defaultManager] loginWithUserName:@"天气好热" andPassWord:@"123456"];

   
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    XMPPPresence *presen = [XMPPPresence presenceWithType:@"available"];
    [[QSXmppManager defaultManager].stream sendElement:presen];
    NSLog(@"登录");
}
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    NSLog(@"登录失败");
}
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    NSLog(@"注册成功");
}
// 注册失败的时候调用
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    NSLog(@"注册失败");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
