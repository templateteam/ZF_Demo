package com.icbc.pay;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.View;
import android.widget.TextView;

import com.icbc.paysdk.ICBCAPI;
import com.icbc.paysdk.IPayEventHandler;
import com.icbc.paysdk.constants.Constants;
import com.icbc.paysdk.model.PayResp;
import com.icbc.paysdk.model.ReqErr;
import com.qdccb.bqd.R;

public class PayResultHandler extends Activity implements IPayEventHandler {
    TextView result_text;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

//        setContentView(R.layout.activity_pay_result_handler);
//        result_text = (TextView) findViewById(R.id.textView);

        ICBCAPI.getInstance().handleIntent(getIntent(), this);

    }

    @Override
    protected void onNewIntent(Intent intent) {
        // TODO Auto-generated method stub
        super.onNewIntent(intent);
        setIntent(intent);
        ICBCAPI.getInstance().handleIntent(intent, this);
    }



    @Override
    public void onErr(ReqErr err) {
        // TODO Auto-generated method stub
        Log.i(Constants.LogFlag, "onErr() ...... ");

        Intent intent = new Intent("ICBC_TRANSACTION_RESULT");
        intent.putExtra("success",false);
        intent.putExtra("err",err.getErrorType());
        sendBroadcast(intent);
    }


    @Override
    public void onResp(PayResp resp) {
        // TODO Auto-generated method stub
        Log.i(Constants.LogFlag, "onResp() ...... ");
        String tranCode = resp.getTranCode();
        String tranMsg = resp.getTranMsg();
        String orderNo = resp.getOrderNo();

        Intent intent = new Intent("ICBC_TRANSACTION_RESULT");
        intent.putExtra("success",true);
        intent.putExtra("tranCode",tranCode);
        intent.putExtra("tranMsg",tranMsg);
        intent.putExtra("orderNo",orderNo);
        sendBroadcast(intent);
        finish();

    }

}
