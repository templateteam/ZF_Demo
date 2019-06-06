//
//  NSURLRequest+Additions.m
//  ICBCPayDemo
//
//  Created by BYYBMAC28 on 2018/3/16.
//  Copyright © 2018年 wq. All rights reserved.
//

#import "NSURLRequest+Additions.h"

@implementation NSURLRequest (Additions)
+ (BOOL) allowsAnyHTTPSCertificateForHost:(NSString *) host
{
    return YES;
}
@end

