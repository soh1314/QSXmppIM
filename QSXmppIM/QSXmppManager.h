//
//  QSXmppManager.h
//  QSXmppIM
//
//  Created by jingshuihuang on 16/6/23.
//  Copyright © 2016年 QS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
#import "XMPPMessageArchiving.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
@interface QSXmppManager : NSObject


@property (nonatomic ,strong) XMPPStream *stream;
@property (nonatomic ,strong) XMPPRoster *roster;
// XMPP聊天消息本地化处理对象
@property (nonatomic ,strong) XMPPMessageArchiving *messageArchiving;
@property (nonatomic ,strong) NSManagedObjectContext *messageContext;
// 单例
+ (QSXmppManager *)defaultManager;
// 登陆:用于传值(用户名和密码)
- (void)loginWithUserName:(NSString *)name andPassWord:(NSString *)passWord;
// 注册:用于传值(用户名和密码)
- (void)registerWithUserName:(NSString *)name andPassWord:(NSString *)passWored;

@end
