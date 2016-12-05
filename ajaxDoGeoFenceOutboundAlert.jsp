<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>

<%@page import="java.net.InetAddress" %>
<%@page import="org.json.simple.JSONObject" %>
<%@page import="java.util.*" %>

<%@include file="00_constants.jsp"%>
<%@include file="00_utility.jsp"%>

<%
/***************輸入範例********************************************************
http://127.0.0.1:8080/demo/ajaxGetTariffProfile.jsp
*******************************************************************************/

/***************輸出範例********************************************************
{"tariffs":[{"TariffEName":"Feelanga Free tariff","TariffTCName":"","TariffID":"Feelanga Free tariff","TariffSCDesc":"","TariffEDesc":"airtel to airtel calls\n6am - 6pm: 2 cents\/second\n6pm - 6am: 6.7 cents\/second\nairtel to other networks in Kenya: 6.7 cents\/second","TariffSCName":"","TariffTCDesc":""},{"TariffEName":"KLUB 254","TariffTCName":"","TariffID":"KLUB 254","TariffSCDesc":"","TariffEDesc":"airtel to airtel (within 10 friends): 2 cents\/second\nother airtel to airtel\n6am - 10pm: 6.7 cents\/second\n10pm - 6am: 2 cents\/second\nairtel to other networks in Kenya: 6.7 cents\/second","TariffSCName":"","TariffTCDesc":""},{"TariffEName":"Vuka tariff","TariffTCName":"","TariffID":"Vuka tariff","TariffSCDesc":"","TariffEDesc":"airtel to airtel calls\n6am - 6pm: 6.7 cents\/second\n6pm - 6am: 2 cents\/second\nairtel to other networks in Kenya: 6.7 cents\/second","TariffSCName":"","TariffTCDesc":""}],"resultCode":"00000","resultText":"Success"}
*******************************************************************************/
%>

<%
request.setCharacterEncoding("utf-8");
response.setContentType("text/html;charset=utf-8");
response.setHeader("Pragma","no-cache"); 
response.setHeader("Cache-Control","no-cache"); 
response.setDateHeader("Expires", 0); 

out.clear();	//注意，一定要有out.clear();，要不然client端無法解析XML，會認為XML格式有問題

/*********************開始做事吧*********************/
JSONObject obj=new JSONObject();

String UUID					= nullToString(request.getParameter("uuid"), "");
if (beEmpty(UUID)){
	obj.put("resultCode", gcResultCodeParametersValidationError);
	obj.put("resultText", gcResultTextParametersValidationError);
	out.print(obj);
	out.flush();
	return;
}

Hashtable	ht					= new Hashtable();
String		sResultCode			= gcResultCodeSuccess;
String		sResultText			= gcResultTextSuccess;
String		sNow				= getDateTimeNow(gcDateFormatSlashYMDTime);
String		s[][]				= null;
String		s1[][]				= null;
String		a[]					= null;
String		sSQL				= "";
String		sWhere				= "";

String		ss					= "";
int			i					= 0;
int			j					= 0;

String		sSMSC				= "gsmmodem";
String		SMS_Body			= "Your device " + UUID + " is out of GeoFence. please visit http://cms.gslssd.com/watchserver/ to check it's location.";
String		MSISDN1				= "886986123101";
String		MSISDN2				= "886921355656";

ht = sendSMSFromSSD(sSMSC, SMS_Body, MSISDN1, "", "", "");
ht = sendSMSFromSSD(sSMSC, SMS_Body, MSISDN2, "", "", "");

sResultCode = ht.get("ResultCode").toString();
sResultText = ht.get("ResultText").toString();

if (sResultCode.equals(gcResultCodeSuccess)){	//成功
	writeLog("info", "簡訊發送成功，UUID=" + UUID + "，Body=" + SMS_Body);
}else{
	writeLog("info", "簡訊發送失敗，UUID=" + UUID + "，Body=" + SMS_Body + "，ResultText=" + sResultText);
}

/*
List<String> sSQLList	= new ArrayList<String>();

sSQL = "UPDATE iot_device SET";
sSQL += " GeoFence='" + "" + "'";
sSQL += " WHERE UUID='" + UUID + "'";
sSQLList.add(sSQL);
writeLog("debug", "Send GeoFence outbound alert: " + sSQL);

ht = updateDBData(sSQLList, gcDataSourceNameCMSIOT, false);
sResultCode = ht.get("ResultCode").toString();
sResultText = ht.get("ResultText").toString();
if (!ht.get("ResultCode").toString().equals(gcResultCodeSuccess)){
	writeLog("error", "Save GeoFence setting失敗：" + sResultCode + "-" + sSQL);
}
*/
obj.put("resultCode", sResultCode);
obj.put("resultText", sResultText);

out.print(obj);
out.flush();

writeLog("debug", obj.toString());
%>