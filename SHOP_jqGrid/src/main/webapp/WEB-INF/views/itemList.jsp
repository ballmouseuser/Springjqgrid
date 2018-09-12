<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<c:url value='resources/css/jquery-ui.css'/>" />
<link rel="stylesheet" type="text/css" href="<c:url value='resources/css/ui.jqgrid.css'/>" />

<script src="<c:url value='resources/js/jquery-1.11.0.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='resources/js/i18n/grid.locale-kr.js'/>" type="text/javascript"></script>
<script src="<c:url value='resources/js/jquery.jqGrid.min.js'/>" type="text/javascript"></script>
<title>Insert title here</title>
</head>
<script type="text/javascript">
$(function(){
	function view_grid(){
		
	    var code = $("#1st_categoryList option:selected").val(); 
	    
	    //jqGrid껍데기 생성
	    $.jgrid.gridUnload('#list');

	    $("#list").jqGrid({
	        url: "get_Category_Result.do",
	        datatype: "JSON",
	        postData: {"itemclscd":code},
	        //그리드 높이
	        height: 250,
	        //컬럼명들
	        colNames:['상품코드','상품명', '제조사코드', '제조사명','단위코드','단위명','재고수량','재고여부','사용여부'],
	        //컬럼모델
	        colModel:[
	            {name:'itemcd'},
	            {name:'itemname'},
	            {name:'madenmcd'},
	            {name:'madename'},
	            {name:'itemunitcd'},
	            {name:'itemunitname'},
	            {name:'stockamt'},
	            {name:'stockyn', formatter: 'checkbox', edittype: 'checkbox', editoptions: {value: 'Y:N'}},
	            {name:'useyn', formatter: 'checkbox', edittype: 'checkbox', editoptions: {value: 'Y:N'}}
	        ],
	        //그리드타이틀
	        caption: "상품 관리"
	    });
	     
/* 	    // 스크립트 변수에 담겨있는 json데이터의 길이만큼
	    for(var i=0;i<=gridData.length;i++){
	            //jqgrid의 addRowData를 이용하여 각각의 row에 gridData변수의 데이터를 add한다
	            $("#list").jqGrid('addRowData',i+1,gridData[i]);
	    } */
	}
	
	$("#selectbtn").click(function(){
    	console.log($("#1st_categoryList option:selected").val());
    	var code = $("#1st_categoryList option:selected").val();
    	
    	if($("#categoryList option:selected").val()=="none"){
    		alert('카테고리를 모두 선택해주세요.');
    	}else{
    		view_grid();
    	}
    });
    
    $("#categoryList").on("change", function(){ // 카테고리 변경시 서브카테고리 값 리로드
    	var upcd = $(this).val();
        console.log(upcd);
        
        $.ajax({
    		type: 'GET',
    		url: 'get_1st_categoryList.do',
    		dataType: "json",
    		data: {
    			"upcd" : upcd,
    		},
            success: function(data){
            	$('#1st_categoryList').empty();
            	var temp = "";
            	var idcnt = 0;
            	for(var i=0;i<data.length;i++){
            		temp += "<option id='p"+idcnt+"' value='"+data[i]['cdno']+"'>"+data[i]['cdname']+"</option>";
            		idcnt++;
            	}
            	$('#1st_categoryList').append(temp);
            }
    	 });
    });
});
</script>
<body>
	<select id="categoryList" name="categoryList">
			<option value="none">선택</option>
	 		<c:forEach items="${itemCategoryList}" var="category">
	  			<option value="${category.cdno}">${category.cdname}</option>
	   		</c:forEach>
	</select>
	<select id="1st_categoryList" name="1st_categoryList">
	</select>
	<input type="button" id="selectbtn" name="selectbtn" value="조회"><br>
	<table id="list"></table>
</body>
</html>