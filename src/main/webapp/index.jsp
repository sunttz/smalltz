<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<html lang="cn">
<jsp:include page="/WEB-INF/jsp/common/commonHead.jsp" flush="true"/>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<script type="text/javascript">
		$(function(){
			var jqOption = {
								url : 'scuser/userList.do',//组件创建完成之后请求数据的url
								datatype : "json",//请求数据返回的类型。可选json,xml,txt
								postData: {name:$("#name").val()},
								colNames : [ '姓名', '性别', '证件类型', '证件号', "生日",'地址', "邮编",'手机', "电话","传真","邮箱",'记录时间' ],//jqGrid的列显示名字
								colModel : [ //jqGrid每一列的配置信息。包括名字，索引，宽度,对齐方式.....
								             {name : 'name',index : 'name',width : '5%',align : "center"},
								             {name : 'gender',index : 'GENDER',width : '5%',align : "center",formatter:'select', editoptions:{value:"F:女;M:男"}},
								             {name : 'ctftp',index : 'CTFTP, invdate',width : '5%',align : "center"},
								             {name : 'ctfid',index : 'CTFID',width : '10%',align : "center"},
											 {name : 'birthday',index : 'birthday',width : '5%',align : "center"},
								             {name : 'address',index : 'ADDRESS',width : '15%',align : "center"},
											 {name : 'zip',index : 'zip',width : '5%',align : "center"},
								             {name : 'mobile',index : 'MOBILE',width : '5%',align : "center"},
											{name : 'tel',index : 'tel',width : '5%',align : "center"},
											{name : 'fax',index : 'fax',width : '5%',align : "center"},
											{name : 'email',index : 'email',width : '10%',align : "center"},
								             {name : 'version',index : 'VERSION',width : '10%',align : "center",sortable : false,formatter:function(cellvalue, options, row){return new Date(cellvalue).toLocaleString()},}
								           ],
								rowNum : 20,//一页显示多少条
								rownumbers:true,
								rowList : [ 20, 50, 100 ],//可供用户选择一页显示多少条
								pager : '#pageGridPager',//表格页脚的占位符(一般是div)的id
								sortname : 'id',//初始化的时候排序的字段
								sortorder : "desc",//排序方式,可选desc,asc
								mtype : "post",//向后台请求数据的ajax的类型。可选post,get
								viewrecords : true,
								caption : "检索结果",//表格的标题名字
								autoWidth: true,
								jsonReader : {
									root: "list",   // json中代表实际模型数据的入口
									page: "pageNum",   // json中代表当前页码的数据
									total: "pages", // json中代表页码总数的数据
									records: "total" // json中代表数据行总数的数据
								}
			};
			//创建jqGrid组件
			jQuery("#pageGrid").jqGrid(jqOption).setGridWidth($(window).width()-200);
			/*创建jqGrid的操作按钮容器*/
			/*可以控制界面上增删改查的按钮是否显示*/
			jQuery("#pageGrid").jqGrid('navGrid', '#pageGridPager', {edit : false,add : false,del : false});
			var newHeight = $(window).height() - 440;
			$(".ui-jqgrid .ui-jqgrid-bdiv").css("cssText","height: "+newHeight+"px!important;");
			$(window).resize(function() {
				$("#pageGrid").setGridWidth($(window).width()-200);
			});

			$("#searchBtn").bind("click",function () {
				$("#pageGrid").jqGrid('setGridParam',{  // 重新加载数据
					datatype:'json',
					postData: {name:$("#name").val()},
					page:1
				}).trigger("reloadGrid");
			});
		});
	</script>
</head>

<body>
	<form action="">
		<div class="container" style="margin: 10px 10px 10px 10px">
			<div class="form-group">
				<div class="col-sm-12" style="margin-bottom: 5px;">
					<label for="name" class="control-label pull-left" style="margin: 5px 0px 0px 10px;">姓名：</label>
					<div class="col-sm-3">
						<input type="text" name="name" class="form-control" id="name"
							placeholder="请输入姓名" value="" />
					</div>
					<div class="col-sm-2">
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
		</div>
	</form>
</body>
</html>
