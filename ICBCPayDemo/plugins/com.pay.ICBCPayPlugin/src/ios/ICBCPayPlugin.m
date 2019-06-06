/********* ICBCPayPlugin.m Cordova Plugin Implementation *******/
#import "ICBCPayPlugin.h"
#import  <ICBCPaySDK/ICBCPaySDK.h>
@interface ICBCPayPlugin ()<ICBCPaySDKDelegate>

@end

@implementation ICBCPayPlugin

- (void)callJHBank:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* order = [command.arguments objectAtIndex:0];
    if (order != nil && [order length] > 0) {
        if([order isEqualToString:@"isJHPayAvailable"]){
            NSURL *url = [NSURL URLWithString:@"mbspay://"];
            
            ICBCPaySDK *shareSDK = [ICBCPaySDK sharedSdk];
            shareSDK.sdkDelegate = self;
            shareSDK.urlListMain =   @"https://b2c.icbc.com.cn"; //请务必配置此生产地址（支付平台地址）
            shareSDK.urlPortal =  @"https://mywap2.icbc.com.cn";  //请务必配置此生产地址（手机银行地址）
            [self pay];
        }else{
            //龙支付接口只能使用建行手机银行APP支付，如未安装，提醒客户安装建行手机银行。
//            [[CCBNetPay defaultService] payAppOrder:order callback:^(NSDictionary *dic) {
//                NSLog(@"dic---%@",dic);
//                if ([dic[@"epayStatus"] isEqualToString:@"Y"] || [dic[@"SUCCESS"] isEqualToString:@"Y"]) {
//                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"SUCCESS"];
//                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//                }else if ([dic[@"epayStatus"] isEqualToString:@""]){
//
//                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"CANCEL"];
//                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//
//                }else if ([dic[@"SUCCESS"] isEqualToString:@"N"]){
//                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"FAILURE|%@",dic[@"ERRORMSG"]]];
//                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//                }
//            }];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [super touchesBegan:touches withEvent:event];
//    [self.scrollView endEditing:YES];
}

- (void)paymentEndwithResultDic:(NSDictionary*)dic{
    //  回调结果
    NSLog(@"pass the pkpaymentAuthorizationstatus to the page");
    NSLog(@"%@  dic",dic);
//    [self.view makeToast:@"商户端自行处理"];
}
- (void)pay{
    NSString *urlScheme =[@"dev.cn.com.icbc.iphoneRongE" stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *interfaceName =[@"ICBC_WAPB_B2C" stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *interfaceVersion =[@"1.0.0.6" stringByReplacingOccurrencesOfString:@" " withString:@""];
    //    NSString *tranData = PercentEscapedStringFromString([self.tranDataTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""]);
    //    NSString *merSignMsg =PercentEscapedStringFromString([self.merSignMsgTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""]);
    //    NSString *merCert = PercentEscapedStringFromString([self.merCertTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""]);
    
    NSString *tranData = [@"PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iR0JLIiBzdGFuZGFsb25lPSJubyI/PjxCMkNSZXE+PGludGVyZmFjZU5hbWU+SUNCQ19XQVBCX0IyQzwvaW50ZXJmYWNlTmFtZT48aW50ZXJmYWNlVmVyc2lvbj4xLjAuMC42PC9pbnRlcmZhY2VWZXJzaW9uPjxvcmRlckluZm8+PG9yZGVyRGF0ZT4yMDE5MDEyMTE2MjAxNDwvb3JkZXJEYXRlPjxvcmRlcmlkPjIwMTkwMTIxMTYyMDE0MDwvb3JkZXJpZD48YW1vdW50PjE2MjA8L2Ftb3VudD48aW5zdGFsbG1lbnRUaW1lcz4xPC9pbnN0YWxsbWVudFRpbWVzPjxjdXJUeXBlPjAwMTwvY3VyVHlwZT48bWVySUQ+MDIwMEVDMjMzMzUxNDk8L21lcklEPjxtZXJBY2N0PjAyMDAwMjQxMDkwMzE1NDg1Njk8L21lckFjY3Q+PC9vcmRlckluZm8+PGN1c3RvbT48dmVyaWZ5Sm9pbkZsYWc+MDwvdmVyaWZ5Sm9pbkZsYWc+PExhbmd1YWdlPnpoX0NOPC9MYW5ndWFnZT48L2N1c3RvbT48bWVzc2FnZT48Z29vZHNJRD4wMDE8L2dvb2RzSUQ+PGdvb2RzTmFtZT6z5Na1v6g8L2dvb2RzTmFtZT48Z29vZHNOdW0+MjwvZ29vZHNOdW0+PGNhcnJpYWdlQW10PjEwMDA8L2NhcnJpYWdlQW10PjxtZXJIaW50PrjDyczGt7K7u7uyu83LPC9tZXJIaW50PjxyZW1hcmsxPjwvcmVtYXJrMT48cmVtYXJrMj48L3JlbWFyazI+PG1lclVSTD5odHRwOi8vMTIyLjE5LjE0MS44My9lbXVsYXRvci9XYXBfc2hvcF9yZXN1bHQxLmpzcDwvbWVyVVJMPjxtZXJWQVI+PC9tZXJWQVI+PG5vdGlmeVR5cGU+SFM8L25vdGlmeVR5cGU+PHJlc3VsdFR5cGU+MTwvcmVzdWx0VHlwZT48YmFja3VwMT48L2JhY2t1cDE+PGJhY2t1cDI+PC9iYWNrdXAyPjxiYWNrdXAzPjwvYmFja3VwMz48YmFja3VwND48L2JhY2t1cDQ+PC9tZXNzYWdlPjwvQjJDUmVxPg==" stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *merSignMsg = [@"X7WAtQIxCZlR+wnbG+b6ZYIyjkha5xK1QiaCb+RNYxH33CQWRy9CDZDtBLGwi9rbYJnNKnsR6JvFj+jO5BJDNp8qEd3b4KsYfzZWdvgHh1epkLzCVnfFV2sQi4eXMQC/dcgWXTWDwZAoXhMQhUs1KEt7da71RV4vWOEPyEoJfUg=" stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *merCert = [@"MIIChjCCAe+gAwIBAgIKbaHKEE0tAAAH3zANBgkqhkiG9w0BAQUFADA2MRkwFwYDVQQDExBjb3JiYW5rNDMgc2RjIENOMRkwFwYDVQQKExBjb3JiYW5rNDMuY29tLmNuMB4XDTE1MTEzMDAyMzczMloXDTE2MTEzMDAyMzczMlowPzETMBEGA1UEAxMKQjJDLmUuMDIwMDENMAsGA1UECxMEMDIwMDEZMBcGA1UEChMQY29yYmFuazQzLmNvbS5jbjCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAwV4bOl8ByDx1So1smhCWvzCegIVze5T6qreQyUiBYI6B5hnkd6ke3ToxFUDRawdN8JWAGW+0Ze02irfg4cnZs3f8PHZ5IEiLYOGrHUWfEsk3QhKrSCLyyzIACeceNMVlIcjzYtemziNej5NZsv787WQSpY5gy+2vNUDt+f/Hj6ECAwEAAaOBkTCBjjAfBgNVHSMEGDAWgBS+7/FOAOQ4De97QGDOvMygCG34YzBMBgNVHR8ERTBDMEGgP6A9pDswOTENMAsGA1UEAxMEY3JsMzENMAsGA1UECxMEY2NybDEZMBcGA1UEChMQY29yYmFuazQzLmNvbS5jbjAdBgNVHQ4EFgQUfTKD6Q/uHEN8zthhoVr3/KCJiQcwDQYJKoZIhvcNAQEFBQADgYEALHBcTTjXI5fgd/b60y8ObhxMGWiDDpb2f9gMoKYmkGhFCf2+KGSBpPuYc9u3J8P0CUQ9znyYpxSGXKzVHh34PYxvGLpCQZ/liSKsfgD/JXvNqwgBmMXq0MzoMrYc6JMaMvSmfy/jVq9D6YFM5AnzsKLG+FQPckNx6O7pRqNzL1E=" stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    NSMutableDictionary *testDic = [[NSMutableDictionary alloc] init];
    testDic[@"urlScheme"] = urlScheme;
    testDic[@"interfaceName"] =interfaceName;
    testDic[@"interfaceVersion"] = interfaceVersion;
    testDic[@"tranData"] = tranData;
    testDic[@"merSignMsg"] = merSignMsg;
    testDic[@"merCert"] = merCert;
    
    ICBCPaySDK *shareSDK = [ICBCPaySDK sharedSdk];
    //    shareSDK.urlPortal = @"http://122.19.125.55:10790";
    //    shareSDK.urlListMain = @"https://122.19.125.60:11452";
    
    //    shareSDK.urlPortal = @"http://122.19.125.208:10790";
    //    shareSDK.urlListMain = @"https://122.19.141.61:11452";
    
    shareSDK.urlPortal = @"https://mywap2.icbc.com.cn";
    shareSDK.urlListMain= @"https://b2c.icbc.com.cn";
    
    //    shareSDK.urlPortal = @"http://82.201.45.50:8080";
    //    shareSDK.urlListMain= @"https://122.20.205.82:11452";
    
    shareSDK.sdkDelegate = self;
    
    [shareSDK presentICBCPaySDKInViewController:[UIApplication sharedApplication].keyWindow.rootViewController  andTraderInfo:testDic];
}
@end
