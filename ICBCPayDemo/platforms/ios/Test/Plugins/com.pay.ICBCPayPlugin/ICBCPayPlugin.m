/********* ICBCPayPlugin.m Cordova Plugin Implementation *******/
#import "ICBCPayPlugin.h"
#import  <ICBCPaySDK/ICBCPaySDK.h>
#import "Base64.h"
@interface ICBCPayPlugin ()<ICBCPaySDKDelegate>{
    NSString *_callbackId;

}

@end

@implementation ICBCPayPlugin

- (void)callJHBank:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSDictionary* order = [command.arguments objectAtIndex:0];
    if (order) {
        _callbackId = command.callbackId;
        [self pay:order];
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
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:_callbackId];
}
- (void)pay:(NSDictionary *)order{
    NSString *urlScheme =[@"dev.cn.com.icbc.iphoneRongE" stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *interfaceName =[@"ICBC_WAPB_B2C" stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *interfaceVersion =[@"1.0.0.6" stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *orignData = order[@"orign"];
    NSString *tranData = [[orignData base64EncodedString]stringByReplacingOccurrencesOfString:@" " withString:@""];

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
 
    shareSDK.urlPortal = @"https://mywap2.icbc.com.cn";
    shareSDK.urlListMain= @"https://b2c.icbc.com.cn";
    
    shareSDK.urlListMain =   @"https://myipad.dccnet.com.cn";
    shareSDK.urlPortal =  @"https://mywap2.dccnet.com.cn:447";

    shareSDK.sdkDelegate = self;
    
    [shareSDK presentICBCPaySDKInViewController:[UIApplication sharedApplication].keyWindow.rootViewController  andTraderInfo:testDic];
}
@end
