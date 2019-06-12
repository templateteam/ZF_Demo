package com.icbc.pay;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.TextView;

import com.icbc.paysdk.ICBCAPI;
import com.icbc.paysdk.IPayEventHandler;
import com.icbc.paysdk.constants.Constants;
import com.icbc.paysdk.model.PayResp;
import com.icbc.paysdk.model.ReqErr;
import com.pay.ICBCPayPlugin.ICBCPayPlugin;

/**
 * Created by zxp on 2019/6/11.
 */

public class PayResultHandler extends Activity implements IPayEventHandler {

	TextView result_text;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);

//      setContentView(R.layout.pay_result_handler_layout);
//      result_text = (TextView) findViewById(R.id.pay_result);

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

		result_text.setText("支付错误："+ err.getErrorType());

	}


	@Override
	public void onResp(PayResp resp) {
		// TODO Auto-generated method stub
		Log.i(Constants.LogFlag, "onResp() ...... ");
		String tranCode = resp.getTranCode();
		String tranMsg = resp.getTranMsg();
		String orderNo = resp.getOrderNo();
		result_text.setText("交易码：" + tranCode + "\n交易信息：" + tranMsg + "\n订单号："+ orderNo);
	}


}
