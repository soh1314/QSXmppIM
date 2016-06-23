//
//  QSXmppManager.m
//  QSXmppIM
//
//  Created by jingshuihuang on 16/6/23.
//  Copyright © 2016年 QS. All rights reserved.
//

#import "QSXmppManager.h"

typedef enum :NSUInteger {
    DoLogin,
    DoRegister,
}ConnectType;


@interface QSXmppManager () <XMPPStreamDelegate, XMPPRosterDelegate>

@property (nonatomic ,copy) NSString *passWord;
@property (nonatomic ,copy) NSString *registerWord;
@property (nonatomic ,assign) ConnectType connectType;
@end

@implementation QSXmppManager

+ (QSXmppManager *)defaultManager
{
    static QSXmppManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[QSXmppManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.stream = [[XMPPStream alloc] init];
        self.stream.hostName = @"127.0.0.1";
        self.stream.hostPort = 5222;
        // 设置stream的代理
        [self.stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        /** 下面的操作其实是在对Roster对象进行初始化*/
        
        // 系统写好的xmpp存储对象
        XMPPRosterCoreDataStorage *rosterStorage = [XMPPRosterCoreDataStorage sharedInstance];
        self.roster = [[XMPPRoster alloc] initWithRosterStorage:rosterStorage dispatchQueue:dispatch_get_global_queue(0, 0)];
        // 激活roster
        [self.roster activate:self.stream];
        // 给roster对象指定代理
        [self.roster addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        // 初始化聊天记录管理对象
        XMPPMessageArchivingCoreDataStorage *archiving = [XMPPMessageArchivingCoreDataStorage sharedInstance];
        self.messageArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:archiving dispatchQueue:dispatch_get_main_queue()];
        // 激活管理对象
        [self.messageArchiving activate:self.stream];
        // 给管理对象添加代理
        [self.messageArchiving addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        self.messageContext = archiving.mainThreadManagedObjectContext;
        
    }
    return self;
}

// 与服务器建立链接
- (void)connectToSercerWithUser:(NSString *)user
{
    if ([self.stream isConnected]) {
        [self disconnectWithSercer];
    }
    // jid 就是jabberID, 是基于Jabber协议的由用户名生成的唯一ID
    self.stream.myJID = [XMPPJID jidWithUser:user domain:@"127.0.0.1" resource:@"iphone6s"];
    NSError *error = nil;
    [self.stream connectWithTimeout:30.0 error:&error];
    if (error != nil) {
        NSLog(@"出现问题");
    }
}
// 与服务器断开链接
- (void)disconnectWithSercer
{
    [self.stream disconnect];
}
// 登陆
- (void)loginWithUserName:(NSString *)name andPassWord:(NSString *)passWord
{
    self.connectType = DoLogin;
    self.passWord = passWord;
    [self connectToSercerWithUser:name];
}

// 与服务器建立链接成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    switch (self.connectType) {
        case DoLogin:
        {
            NSLog(@"chenggong");
            // 与服务器进行登录认证
            NSError *error = nil;
            [self.stream authenticateWithPassword:self.passWord error:&error];
            if (error != nil) {
                NSLog(@"出现问题");
            }
            break;
        }
        case DoRegister:
        {
            // 与服务器进行登录认证
            NSError *error1 = nil;
            [self.stream registerWithPassword:self.registerWord error:&error1];
            if (error1 != nil) {
                NSLog(@"出现问题");
            }
            break;
        }
        default:
            break;
    }
    
}
// 抛出异常(手动让程序崩溃)
- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender
{
    NSLog(@"shibai");
    @throw [NSException exceptionWithName:@"CQ_Error" reason:@"与服务器建立链接失败, 请查看代码" userInfo:nil];
}

// 注册
- (void)registerWithUserName:(NSString *)name andPassWord:(NSString *)passWored
{
    self.connectType = DoRegister;
    self.registerWord = passWored;
    [self connectToSercerWithUser:name];
}
@end
