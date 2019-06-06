/********* ICBCPayPlugin.m Cordova Plugin Implementation *******/
#import "ICBCPayPlugin.h"
#import  <ICBCPaySDK/ICBCPaySDK.h>
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

- (void)paymentEndwithResultDic:(NSDictionary*)dic{
    //  回调结果
    NSLog(@"pass the pkpaymentAuthorizationstatus to the page");
    NSLog(@"%@  dic",dic);
    NSInteger tranCode = [dic[@"tranCode"]integerValue];
    CDVPluginResult *pluginResult = nil;
    if (tranCode == 1) {
         pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }else{
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:tranCode];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:_callbackId];
}
- (void)pay:(NSDictionary *)order{
    NSString *urlScheme =[order[@"urlScheme"] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *interfaceName =[order[@"interfaceName"] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *interfaceVersion =[order[@"interfaceVersion"] stringByReplacingOccurrencesOfString:@" " withString:@""];
   NSString *tranData = [order[@"tranData"] stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSString *merSignMsg = [order[@"merSignMsg"] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *merCert = [order[@"merCert"] stringByReplacingOccurrencesOfString:@" " withString:@""];
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
    if ([order[@"env"]integerValue] == 0) {
        shareSDK.urlListMain =   @"https://myipad.dccnet.com.cn";
        shareSDK.urlPortal =  @"https://mywap2.dccnet.com.cn:447";
    }
    shareSDK.sdkDelegate = self;
    [shareSDK presentICBCPaySDKInViewController:[UIApplication sharedApplication].keyWindow.rootViewController  andTraderInfo:testDic];
}
@end
