<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<html lang="cn">
<jsp:include page="/WEB-INF/jsp/common/commonHead.jsp" flush="true"/>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<script type="text/javascript">
		$(function(){
			//页面加载完成之后执行
			var jqOption = {
								url : 'data/JSONData.json',//组件创建完成之后请求数据的url
								datatype : "json",//请求数据返回的类型。可选json,xml,txt
								colNames : [ 'Inv No', 'Date', 'Client', 'Amount', 'Tax','Total', 'Notes' ],//jqGrid的列显示名字
								colModel : [ //jqGrid每一列的配置信息。包括名字，索引，宽度,对齐方式.....
								             {name : 'id',index : 'id',width : 55}, 
								             {name : 'invdate',index : 'invdate',width : 90}, 
								             {name : 'name',index : 'name asc, invdate',width : 100}, 
								             {name : 'amount',index : 'amount',width : 80,align : "right"}, 
								             {name : 'tax',index : 'tax',width : 80,align : "right"}, 
								             {name : 'total',index : 'total',width : 80,align : "right"}, 
								             {name : 'note',index : 'note',width : 150,sortable : false} 
								           ],
								rowNum : 10,//一页显示多少条
								rowList : [ 10, 20, 30 ],//可供用户选择一页显示多少条
								pager : '#pageGridPager',//表格页脚的占位符(一般是div)的id
								sortname : 'id',//初始化的时候排序的字段
								sortorder : "desc",//排序方式,可选desc,asc
								mtype : "post",//向后台请求数据的ajax的类型。可选post,get
								viewrecords : true,
								caption : "表格",//表格的标题名字
								autoWidth: true
							};
			//创建jqGrid组件
			jQuery("#pageGrid").jqGrid(jqOption).setGridWidth($(window).width()-200);
			/*创建jqGrid的操作按钮容器*/
			/*可以控制界面上增删改查的按钮是否显示*/
			jQuery("#pageGrid").jqGrid('navGrid', '#pageGridPager', {edit : false,add : false,del : false});
			
			
			$(window).resize(function() {
				$("#pageGrid").setGridWidth($(window).width()-200);
			});
		});
	</script>
</head>

<body>
	<div class="container" style="margin: 10px 10px 10px 10px">
		<form class="form-horizontal" id="jqgridForm" role="form"
			action="${ctx}/deal/datablePayDealOrdersList" method="post">
			<div class="form-group">
				<div class="col-sm-12">
					<label for="name" class="control-label pull-left">项目名称：</label>
					<div class="col-sm-3">
						<input type="text" name="name" class="form-control" id="name"
							placeholder="请输入项目名称" value="" />
					</div>
					<div class="col-sm-3">
						<button type="button" class="btn btn-primary pull-right"
							id="searchBtn">检索</button>
					</div>
				</div>
			</div>
			<div class="form-group">
				<div class="col-sm-12">
					<table id="pageGrid" rel="jqgridForm" class="jqgrid"></table>
					<div id="pageGridPager"></div>
				</div>
			</div>
		</form>
	</div>
</body>
</html>
