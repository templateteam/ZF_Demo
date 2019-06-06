/********* ICBCPayPlugin.m Cordova Plugin Implementation *******/


#import <Cordova/CDVPlugin.h>

@interface ICBCPayPlugin : CDVPlugin {
  // Member variables go here.
}

- (void)callJHBank:(CDVInvokedUrlCommand*)command;
@end
