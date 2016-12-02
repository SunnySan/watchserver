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

String UUID		= getJsonValue(session.getAttribute("UserProfile"), "UUID");

if (beEmpty(UUID)){
	obj.put("resultCode", gcResultCodeNoLoginInfoFound);
	obj.put("resultText", gcResultTextNoLoginInfoFound);
	out.print(obj);
	out.flush();
	writeLog("error", obj.toString());
	return;
}

String GeoFence					= nullToString(request.getParameter("GeoFence"), "");

Hashtable	ht					= new Hashtable();
String		sResultCode			= gcResultCodeParametersValidationError;
String		sResultText			= gcResultTextParametersValidationError;
String		sNow				= getDateTimeNow(gcDateFormatSlashYMDTime);
String		s[][]				= null;
String		s1[][]				= null;
String		a[]					= null;
String		sSQL				= "";
String		sWhere				= "";

String		ss					= "";
int			i					= 0;
int			j					= 0;

List<String> sSQLList	= new ArrayList<String>();

sSQL = "UPDATE iot_device SET";
sSQL += " GeoFence='" + GeoFence + "'";
sSQL += " WHERE UUID='" + UUID + "'";
sSQLList.add(sSQL);
writeLog("debug", "Save GeoFence setting: " + sSQL);

ht = updateDBData(sSQLList, gcDataSourceNameCMSIOT, false);
sResultCode = ht.get("ResultCode").toString();
sResultText = ht.get("ResultText").toString();
if (!ht.get("ResultCode").toString().equals(gcResultCodeSuccess)){
	writeLog("error", "Save GeoFence setting失敗：" + sResultCode + "-" + sSQL);
}

obj.put("resultCode", sResultCode);
obj.put("resultText", sResultText);

out.print(obj);
out.flush();

writeLog("debug", obj.toString());
%>