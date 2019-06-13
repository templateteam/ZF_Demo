package com.pay.ICBCPayPlugin;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.util.Log;
import android.widget.Toast;

import com.alibaba.fastjson.JSON;
import com.icbc.paysdk.ICBCAPI;
import com.icbc.paysdk.constants.Constants;
import com.icbc.paysdk.model.PayReq;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.Console;


/**
 * This class echoes a string called from JavaScript.
 */
public class ICBCPayPlugin extends CordovaPlugin {

    private CallbackContext pcbContext;
    private BroadcastReceiver receiver;

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("callJHBank")) {
            if (this.pcbContext!=null){
                removeTranListener();
            }
            this.pcbContext = callbackContext;
            String message = args.getString(0);
            if (message != null && message.length() > 0) {

                registerBroadCast();//***
                doPayICBC(message);//***

                // Don't return any result now,
                PluginResult pluginResult = new PluginResult(PluginResult.Status.NO_RESULT);
                pluginResult.setKeepCallback(true);
                this.pcbContext.sendPluginResult(pluginResult);
            } else {
                callbackContext.error("Expected one non-empty string argument.");
            }
            return true;
        }
        return false;
    }

    //调用ICBC的sdk进行支付
    private void doPayICBC(String message){
        if (message==null||message.length()==0){
            return;
        }
        Constants.PAY_LIST_IP = "https://b2c4.dccnet.com.cn";
        PayReq req = JSON.parseObject(message,PayReq.class);

//        String interfaceName = "ICBC_WAPB_B2C";
//        String interfaceVersion = "1.0.0.6";
//        String tranData = "PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iR0JLIiBzdGFuZGFsb25lPSJubyI/PjxCMkNSZXE+PGludGVyZmFjZU5hbWU+SUNCQ19XQVBCX0IyQzwvaW50ZXJmYWNlTmFtZT48aW50ZXJmYWNlVmVyc2lvbj4xLjAuMC42PC9pbnRlcmZhY2VWZXJzaW9uPjxvcmRlckluZm8+PG9yZGVyRGF0ZT4yMDE5MDEyMTE2MjAxNDwvb3JkZXJEYXRlPjxvcmRlcmlkPjIwMTkwMTIxMTYyMDE0MDwvb3JkZXJpZD48YW1vdW50PjE2MjA8L2Ftb3VudD48aW5zdGFsbG1lbnRUaW1lcz4xPC9pbnN0YWxsbWVudFRpbWVzPjxjdXJUeXBlPjAwMTwvY3VyVHlwZT48bWVySUQ+MDIwMEVDMjMzMzUxNDk8L21lcklEPjxtZXJBY2N0PjAyMDAwMjQxMDkwMzE1NDg1Njk8L21lckFjY3Q+PC9vcmRlckluZm8+PGN1c3RvbT48dmVyaWZ5Sm9pbkZsYWc+MDwvdmVyaWZ5Sm9pbkZsYWc+PExhbmd1YWdlPnpoX0NOPC9MYW5ndWFnZT48L2N1c3RvbT48bWVzc2FnZT48Z29vZHNJRD4wMDE8L2dvb2RzSUQ+PGdvb2RzTmFtZT6z5Na1v6g8L2dvb2RzTmFtZT48Z29vZHNOdW0+MjwvZ29vZHNOdW0+PGNhcnJpYWdlQW10PjEwMDA8L2NhcnJpYWdlQW10PjxtZXJIaW50PrjDyczGt7K7u7uyu83LPC9tZXJIaW50PjxyZW1hcmsxPjwvcmVtYXJrMT48cmVtYXJrMj48L3JlbWFyazI+PG1lclVSTD5odHRwOi8vMTIyLjE5LjE0MS44My9lbXVsYXRvci9XYXBfc2hvcF9yZXN1bHQxLmpzcDwvbWVyVVJMPjxtZXJWQVI+PC9tZXJWQVI+PG5vdGlmeVR5cGU+SFM8L25vdGlmeVR5cGU+PHJlc3VsdFR5cGU+MTwvcmVzdWx0VHlwZT48YmFja3VwMT48L2JhY2t1cDE+PGJhY2t1cDI+PC9iYWNrdXAyPjxiYWNrdXAzPjwvYmFja3VwMz48YmFja3VwND48L2JhY2t1cDQ+PC9tZXNzYWdlPjwvQjJDUmVxPg==";
//        String merSignMsg = "X7WAtQIxCZlR+wnbG+b6ZYIyjkha5xK1QiaCb+RNYxH33CQWRy9CDZDtBLGwi9rbYJnNKnsR6JvFj+jO5BJDNp8qEd3b4KsYfzZWdvgHh1epkLzCVnfFV2sQi4eXMQC/dcgWXTWDwZAoXhMQhUs1KEt7da71RV4vWOEPyEoJfUg=";
//        String merCert = "MIIChjCCAe+gAwIBAgIKbaHKEE0tAAAH3zANBgkqhkiG9w0BAQUFADA2MRkwFwYDVQQDExBjb3JiYW5rNDMgc2RjIENOMRkwFwYDVQQKExBjb3JiYW5rNDMuY29tLmNuMB4XDTE1MTEzMDAyMzczMloXDTE2MTEzMDAyMzczMlowPzETMBEGA1UEAxMKQjJDLmUuMDIwMDENMAsGA1UECxMEMDIwMDEZMBcGA1UEChMQY29yYmFuazQzLmNvbS5jbjCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAwV4bOl8ByDx1So1smhCWvzCegIVze5T6qreQyUiBYI6B5hnkd6ke3ToxFUDRawdN8JWAGW+0Ze02irfg4cnZs3f8PHZ5IEiLYOGrHUWfEsk3QhKrSCLyyzIACeceNMVlIcjzYtemziNej5NZsv787WQSpY5gy+2vNUDt+f/Hj6ECAwEAAaOBkTCBjjAfBgNVHSMEGDAWgBS+7/FOAOQ4De97QGDOvMygCG34YzBMBgNVHR8ERTBDMEGgP6A9pDswOTENMAsGA1UEAxMEY3JsMzENMAsGA1UECxMEY2NybDEZMBcGA1UEChMQY29yYmFuazQzLmNvbS5jbjAdBgNVHQ4EFgQUfTKD6Q/uHEN8zthhoVr3/KCJiQcwDQYJKoZIhvcNAQEFBQADgYEALHBcTTjXI5fgd/b60y8ObhxMGWiDDpb2f9gMoKYmkGhFCf2+KGSBpPuYc9u3J8P0CUQ9znyYpxSGXKzVHh34PYxvGLpCQZ/liSKsfgD/JXvNqwgBmMXq0MzoMrYc6JMaMvSmfy/jVq9D6YFM5AnzsKLG+FQPckNx6O7pRqNzL1E=";
//
//        PayReq req = new PayReq();
//        req.setInterfaceName(interfaceName);
//        req.setInterfaceVersion(interfaceVersion);
//        req.setTranData(tranData);
//        req.setMerSignMsg(merSignMsg);
//        req.setMerCert(merCert);
//        ICBCAPI.getInstance().sendReq(MainActivity.this,req);
//
        ICBCAPI.getInstance().sendReq(cordova.getActivity(),req);
    }

    //注册广播，处理交易结果
    private void registerBroadCast(){
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("ICBC_TRANSACTION_RESULT");
        if (this.receiver == null) {
            this.receiver = new BroadcastReceiver() {
                @Override
                public void onReceive(Context context, Intent intent) {
                    updateTranInfo(intent);
                }
            };
            webView.getContext().registerReceiver(this.receiver, intentFilter);
        }
    }

    //清空广播的响应
    private  void removeTranListener(){
        if (this.receiver != null) {
            try {
                webView.getContext().unregisterReceiver(this.receiver);
                this.receiver = null;
            } catch (Exception e) {
                Log.e("error", "Error unregistering battery receiver: " + e.getMessage(), e);
            }
        }
    }

    //将订单结果传递给js
    private  void updateTranInfo(Intent intent){
        if (this.pcbContext == null) {
            return;
        }
        Boolean success = intent.getBooleanExtra("success",false);
        if (!success){
            String error=intent.getStringExtra("err");
            PluginResult result = new PluginResult(PluginResult.Status.ERROR, error);
            result.setKeepCallback(false);
            this.pcbContext.sendPluginResult(result);
            return;
        }
        String tranCode=intent.getStringExtra("tranCode");
        String tranMsg=intent.getStringExtra("tranMsg");
        String orderNo=intent.getStringExtra("orderNo");
        JSONObject jsonObject = new JSONObject();
        try{
            jsonObject.put("tranCode",tranCode);
            jsonObject.put("tranMsg",tranMsg);
            jsonObject.put("orderNo",orderNo);
        }catch (Exception e){
            //todo
        }

        PluginResult result = new PluginResult(PluginResult.Status.OK, jsonObject==null?null:jsonObject);
        result.setKeepCallback(false);
        this.pcbContext.sendPluginResult(result);
    }
}
