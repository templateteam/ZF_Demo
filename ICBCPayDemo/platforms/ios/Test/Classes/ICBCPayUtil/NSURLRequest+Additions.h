//
//  NSURLRequest+Additions.h
//  ICBCPayDemo
//
//  Created by BYYBMAC28 on 2018/3/16.
//  Copyright © 2018年 wq. All rights reserved.
//
//私有api 针对测试环境中AFN策略，生产环境无需将此文件放入工程
#import <Foundation/Foundation.h>

@interface NSURLRequest (Additions)
+ (BOOL) allowsAnyHTTPSCertificateForHost:(NSString *) host;

@end

