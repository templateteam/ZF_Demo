package com.pay.ICBCPayPlugin;

import android.widget.Toast;

import com.alibaba.fastjson.JSON;
import com.icbc.paysdk.ICBCAPI;
import com.icbc.paysdk.constants.Constants;
import com.icbc.paysdk.model.PayReq;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * This class echoes a string called from JavaScript.
 */
public class ICBCPayPlugin extends CordovaPlugin {

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
//        Toast.makeText(cordova.getActivity(), "AA"+action, Toast.LENGTH_SHORT).show();
        if (action.equals("callJHBank")) {
            String message = args.getString(0);
            this.callJHBank(message, callbackContext);
            return true;
        }
        return false;
    }

    private void callJHBank(String message, CallbackContext callbackContext) {
        if (message != null && message.length() > 0) {
            Constants.PAY_LIST_IP = "https://b2c4.dccnet.com.cn";
            PayReq req = JSON.parseObject(message,PayReq.class);
            ICBCAPI.getInstance().sendReq(cordova.getActivity(),req);
            callbackContext.success(message);
        } else {
            callbackContext.error("Expected one non-empty string argument.");
        }
    }
}
