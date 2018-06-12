<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Language" content="ko" >
<title>게시판 목록</title>
<style type="text/css">
	h1 {font-size:12px;}
	caption {visibility:hidden; font-size:0; height:0; margin:0; padding:0; line-height:0;}
	
	A:link    { color: #000000; text-decoration:none; }
	A:visited { color: #000000; text-decoration:none; }
	A:active  { color: #000000; text-decoration:none; }
	A:hover   { color: #fa2e2e; text-decoration:none; }
	
	#map {
        width: 100%;
        height: 400px;
        background-color: grey;
      }	
</style>
<script src="https://code.jquery.com/jquery-1.10.2.js"></script>
<script type="text/javascript">
	var myVar;
	var innerHtml="";
	function fn_startReload(){
		myVar = setInterval(fn_reload, 30000);
		$("#reloadContBtn").text("Stop Reload");
    	$("#reloadContBtn").attr("onclick","fn_stopReload()");
	}
	
    function initMap() {
    	var lat = "${resultList[0].lat}";
    	var lng = "${resultList[0].lng}";
		setInfo(lat,lng);
    }
    
    function setInfo(lat,lng){
		var where = {lat: parseFloat(lat), lng: parseFloat(lng)}; 
		var map = new google.maps.Map(document.getElementById('map'), {
			  zoom: 15,
			  center: where
			});
			var marker = new google.maps.Marker({
			  position: where,
			  map: map
			});
			selectAjax('201870')
    }
    
    function selectAjax(v){
    	$.ajax({
  	    	url: 'http://tktapi.melon.com/api/product/schedule/list.json?callback=scheduleList&prodId='+v+'&pocCode=SC0002&perfTypeCode=GN0001&sellTypeCode=ST0001&v=1',
  	    	dataType: 'jsonp',
  	    	async:true,
  	    	jsonpCallback: "scheduleList",
  	    	success: function(data){
  	    		if(data.code == '0000'){
  	    			if(v == '201870'){
	  	    			selectAjax('201871');
  	    			}else if(v == '201871'){
  	    				selectAjax('201872');
  	    			}else if(v == '201872'){
  	    				selectAjax('201873');
  	    			}else{
	  	    			$("#concertData").html(innerHtml);
  	    			}
  	    		}
  	    	}
  	  	});
    }
    
    function scheduleList(data){
    	var dtArr = new Array('20180707', '20180708','20180714','20180715','20180721','20180722');
    	for(var i = 0; i<data.data.perfDaylist.length; i++){
    		if(dtArr.indexOf(data.data.perfDaylist[i].perfTimelist[0].perfDay) > -1){
				innerHtml +='<tr>';
	  			innerHtml +='<td nowrap="nowrap"><strong>'+data.data.perfDaylist[i].perfTimelist[0].perfDay+'</strong></td>';
	  			innerHtml +='<td nowrap="nowrap"><strong>'+data.data.perfDaylist[i].perfTimelist[0].seatGradelist[0].lockSeatCntlk+'</strong></td>';
	  			innerHtml +='<td nowrap="nowrap"><strong>'+data.data.perfDaylist[i].perfTimelist[0].seatGradelist[0].seatCount+'</strong></td>';
	  			innerHtml +='</tr>';
    		}
		}
    }
    
    
    function fn_reload(){
    	$("#frm").attr("action","/egovApiList.do").submit();
    }
    
    function fn_stopReload() {
        clearInterval(myVar);
    	$("#reloadContBtn").text("Start Reload");
    	$("#reloadContBtn").attr("onclick","fn_startReload()");
    }
    
    function fn_egov_select_apiList(pageIndex){
    	$("#pageIndex").val(pageIndex);
    	$("#frm").attr("action","/egovApiList.do").submit();
    }
</script>
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBZZXJa0zsScjz5FE1vp7yqkemvbJApptU&callback=initMap" async defer></script>
</head>
<body onload="fn_startReload()">
<div id="map"></div>
<noscript class="noScriptTitle">자바스크립트를 지원하지 않는 브라우저에서는 일부 기능을 사용하실 수 없습니다.</noscript>
<!-- 전체 레이어 시작 -->
<div id="wrap">
    <!-- container 시작 -->
    <div id="container">
            <!-- 현재위치 네비게이션 시작 -->
            <div id="content">
                <!-- 검색 필드 박스 시작 -->
                <div id="search_field"> 
                    <button id="reloadContBtn" onclick="fn_stopReload()">Stop Reload</button>
                    <div id="search_field_loc"><h2><strong>게시판 정보</strong></h2></div>
					<form name="frm" id="frm" method="post">
                        <input name="pageIndex" id="pageIndex" type="hidden" value="<c:out value='${searchVO.pageIndex}'/>"/>
                        <input name="uuid" id="uuid" type="hidden" value="<c:out value='${resultList[0].uuid}'/>"/>
                        <fieldset><legend>조건정보 영역</legend>    
                        <div class="sf_start">
                        </div>          
                        </fieldset>
                    </form>
                </div>
                <!-- //검색 필드 박스 끝 -->
                
                <!-- table add start -->
                <div class="default_tablestyle">
                    <table summary="번호,uuid,위도,경도,등록일 목록입니다" cellpadding="0" cellspacing="0" border="1">
                    <caption>사용자목록관리</caption>
                    <colgroup>
                    <col width="50%">
                    <col width="25%">
                    <col width="25%">
                    </colgroup>
                    <thead>
                    <tr>
                        <th scope="col" class="f_field" nowrap="nowrap">날짜</th>
                        <th scope="col" nowrap="nowrap">예약 중인 좌석</th>
                        <th scope="col" nowrap="nowrap">빈 좌석</th>
                    </tr>
                    </thead>
                    <tbody id="concertData">                 
			        </tbody>
	                </table>
                </div>

                <!-- table add start -->
                <div class="default_tablestyle">
                    <table summary="번호,uuid,위도,경도,등록일 목록입니다" cellpadding="0" cellspacing="0" border="1">
                    <caption>사용자목록관리</caption>
                    <colgroup>
                    <col width="5%">
                    <col width="15%">
                    <col width="15%">
                    <col width="15%">
                    <col width="15%">
                    </colgroup>
                    <thead>
                    <tr>
                        <th scope="col" class="f_field" nowrap="nowrap">번호</th>
                        <th scope="col" nowrap="nowrap">위도</th>
                        <th scope="col" nowrap="nowrap">경도</th>
                        <th scope="col" nowrap="nowrap">정확도</th>
                        <th scope="col" nowrap="nowrap">등록일</th>
                    </tr>
                    </thead>
                    <tbody>                 

                    <c:forEach var="result" items="${resultList}" varStatus="status"> 
                    <!-- loop 시작 -->                                
					  <tr>
					    <td nowrap="nowrap" onclick="setInfo('${result.lat}','${result.lng}')"><strong><c:out value="${result.seq}"/></strong></td>		    
					    <td nowrap="nowrap"><c:out value="${result.lat}"/></td>
					    <td nowrap="nowrap"><c:out value="${result.lng}"/></td>
					    <td nowrap="nowrap"><c:out value="${result.accuracy}"/></td>
					    <td nowrap="nowrap"><c:out value="${result.regDt}"/></td>					    
					  </tr>
	                </c:forEach>	  
					<c:if test="${fn:length(resultList) == 0}">
					  <tr>
					    <td nowrap colspan="5">데이터가 없습니다.</td>  
					  </tr>		 
					</c:if>
			        </tbody>
	                </table>
                </div>
		        <!-- 페이지 네비게이션 시작 -->
		        <div id="paging_div">
                    <ul class="paging_align">
                       <ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_egov_select_apiList"  />
                    </ul>
		        </div>                          
                </div>
                <!-- //페이지 네비게이션 끝 -->  
            <!-- //content 끝 -->    
        </div>  
        <!-- //container 끝 -->
	    <!-- footer 시작 -->
        <div id="footer"><c:import url="/EgovPageLink.do?link=main/inc/EgovIncFooter" /></div>
	    <!-- //footer 끝 -->
    </div>
    <!-- //전체 레이어 끝 -->
 </body>
</html>