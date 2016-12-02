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


session.removeAttribute("UserProfile");	//先清除 session 中的用戶資料

String UUID				= nullToString(request.getParameter("UUID"), "");
String User_Password	= nullToString(request.getParameter("User_Password"), "");

if (beEmpty(UUID) || beEmpty(User_Password)){
	obj.put("resultCode", gcResultCodeParametersNotEnough);
	obj.put("resultText", gcResultTextParametersNotEnough);
	out.print(obj);
	out.flush();
	return;
}

Hashtable	ht					= new Hashtable();
String		sResultCode			= gcResultCodeSuccess;
String		sResultText			= gcResultTextSuccess;
String		s[][]				= null;
String		s1[][]				= null;
String		a[]					= null;
String		sSQL				= "";
String		sWhere				= "";

String		ss					= "";
int			i					= 0;
int			j					= 0;

String		Default_Page		= "";

sSQL = "SELECT A.User_Name, A.User_Password, A.UUID";
sSQL += " FROM iot_device A";
sSQL += " WHERE A.UUID='" + UUID + "'";

//writeLog("info", sSQL);
ht = getDBData(sSQL, gcDataSourceNameCMSIOT);

sResultCode = ht.get("ResultCode").toString();
sResultText = ht.get("ResultText").toString();

sSQL = "";
if (sResultCode.equals(gcResultCodeSuccess)){	//有資料
	s = (String[][])ht.get("Data");
	sSQL = "";
	if (s[0][1].equals(User_Password)){	//密碼相同，登入成功
		obj.put("User_Name", s[0][0]);
		obj.put("UUID", UUID);
		session.setAttribute("UserProfile", obj);	//將登入用戶資料存入 session 中
		writeLog("info", "用戶登入成功：" + UUID);
	}else{	//密碼不同，檢查一共失敗幾次
		sResultCode = gcResultCodeNoDataFound;
		sResultText = gcResultTextNoDataFound;
		writeLog("info", "用戶登入失敗：" + UUID);
	}	//if (s[0][1].equals(User_Password)){	//密碼相同，登入成功
}	//if (sResultCode.equals(gcResultCodeSuccess)){	//有資料

obj.put("resultCode", sResultCode);
obj.put("resultText", sResultText);

out.print(obj);
out.flush();

writeLog("debug", obj.toString());
%>