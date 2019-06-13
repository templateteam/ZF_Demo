package com.pay.ICBCPayPlugin;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.util.Log;

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

                registerBroadCast();
                doPayICBC(message);

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
        PluginResult result;
        if (tranCode.equals("1")){
             result = new PluginResult(PluginResult.Status.OK, tranCode);
        }else {
            result = new PluginResult(PluginResult.Status.ERROR, tranCode);
        }
        result.setKeepCallback(false);
        this.pcbContext.sendPluginResult(result);
    }
}
