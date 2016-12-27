<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" pageEncoding="UTF-8"%>
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
			jQuery("#pageGrid").jqGrid('navGrid', '#pageGridPager', {edit : false,add : false,del : false,search: false});
			var newHeight = $(window).height() - 440;
			$(".ui-jqgrid .ui-jqgrid-bdiv").css("cssText","height: "+newHeight+"px!important;");
			$(window).resize(function() {
				$("#pageGrid").setGridWidth($(window).width()-200);
			});

			$("#searchBtn").bind("click",function () {
				var name = $("#name").val();
				if(name != null && name != ""){
					$("#pageGrid").jqGrid('setGridParam',{  // 重新加载数据
						datatype:'json',
						postData: {name:name},
						page:1
					}).trigger("reloadGrid");

					// 用户性别比例饼图加载
					getSexPie(name);
					// 用户年龄分布图加载
					getBirLine(name)
					// 获取地域分布统计数据
					getAreaMap(name);
				}
			});
			
			
			// 柱图
	        var myChart = echarts.init(document.getElementById('main'),'vintage');
	        // 指定图表的配置项和数据
	        var option = {
	            title: {
	                text: '年龄分布'
	            },
	            tooltip: {},
	            legend: {
	                data:['年龄段']
	            },
	            xAxis: {
	                data: [/*"90后","80后","70后","60后","50后","其他"*/],
	            },
	            yAxis:{
				}
				,
	            series: [{
	                name: '数量',
	                type: 'bar',
					label: {
						normal: {
							show: true,
							position: 'inside'
						}
					},
	                data: [/*0, 0, 0, 0, 0, 0*/]
	            }]
	        };
	        // 使用刚指定的配置项和数据显示图表。
	        myChart.setOption(option);
	        
	        // 饼图
	        var myChart2 = echarts.init(document.getElementById('main2'),'vintage');
	        option = {
	        	    title : {
	        	        text: '性别比例',
	        	        //subtext: '仅供参考',
	        	        x:'center'
	        	    },
	        	    tooltip : {
	        	        trigger: 'item',
	        	        formatter: "{a} <br/>{b} : {c} ({d}%)"
	        	    },
	        	    legend: {
	        	        orient: 'vertical',
	        	        left: 'left',
	        	        data: ['男','女','未知']
	        	    },
	        	    series : [
	        	        {
	        	            name: '性别',
	        	            type: 'pie',
	        	            radius : '55%',
	        	            center: ['50%', '60%'],
	        	            data:[
	        	                /*{value:385, name:'男'},
	        	                {value:310, name:'女'},
	        	                {value:234, name:'未知'}*/
	        	            ],
	        	            itemStyle: {
	        	                emphasis: {
	        	                    shadowBlur: 10,
	        	                    shadowOffsetX: 0,
	        	                    shadowColor: 'rgba(0, 0, 0, 0.5)'
	        	                },
								normal:{
									label:{
										show: true,
										formatter: '{b} : {c} ({d}%)'
									},
									labelLine :{show:true}
								}
							}
	        	        }
	        	    ]
	        	};
	        myChart2.setOption(option);
	        
	        // 分布图
	        var myChart3 = echarts.init(document.getElementById('main3'),'vintage');
	        var option3 = {
	            title: {
	                text: '地域分布',
	                //subtext: '纯属虚构',
	                left: 'center'
	            },
	            tooltip: {
	                trigger: 'item'
	            },
	            legend: {
	                orient: 'vertical',
	                left: 'left',
	                data:['人数']
	            },
	            visualMap: {
	                min: 0,
	                max: 2500,
	                left: 'left',
	                top: 'bottom',
	                text: ['高','低'],           // 文本，默认为数值文本
	                calculable: true
	            },
	            toolbox: {
	                show: true,
	                orient: 'vertical',
	                left: 'right',
	                top: 'center',
	                feature: {
	                    dataView: {readOnly: false},
	                    restore: {},
	                    saveAsImage: {}
	                }
	            },
	            series: [
	                {
	                    name: '人数',
	                    type: 'map',
	                    mapType: 'china',
	                    roam: true,
	                    label: {
	                        normal: {
	                            show: true
	                        },
	                        emphasis: {
	                            show: true
	                        }
	                    },
	                    data:[
	                        /*{name: '北京',value: 10000 },
	                        {name: '天津',value: 5 },
	                        {name: '上海',value: randomData() },
	                        {name: '重庆',value: randomData() },
	                        {name: '河北',value: randomData() },
	                        {name: '河南',value: randomData() },
	                        {name: '云南',value: randomData() },
	                        {name: '辽宁',value: randomData() },
	                        {name: '黑龙江',value: randomData() },
	                        {name: '湖南',value: randomData() },
	                        {name: '安徽',value: randomData() },
	                        {name: '山东',value: randomData() },
	                        {name: '新疆',value: randomData() },
	                        {name: '江苏',value: randomData() },
	                        {name: '浙江',value: randomData() },
	                        {name: '江西',value: randomData() },
	                        {name: '湖北',value: randomData() },
	                        {name: '广西',value: randomData() },
	                        {name: '甘肃',value: randomData() },
	                        {name: '山西',value: randomData() },
	                        {name: '内蒙古',value: randomData() },
	                        {name: '陕西',value: randomData() },
	                        {name: '吉林',value: randomData() },
	                        {name: '福建',value: randomData() },
	                        {name: '贵州',value: randomData() },
	                        {name: '广东',value: randomData() },
	                        {name: '青海',value: randomData() },
	                        {name: '西藏',value: randomData() },
	                        {name: '四川',value: randomData() },
	                        {name: '宁夏',value: randomData() },
	                        {name: '海南',value: randomData() },
	                        {name: '台湾',value: randomData() },
	                        {name: '香港',value: randomData() },
	                        {name: '澳门',value: randomData() } */
	                    ]
	                }
	            ]
	        };
	        //myChart3.showLoading();
	        myChart3.setOption(option3);
			
	        myChart3.on('click', function (params) {
	            var city = params.name;
	            getCityMap('',city); 
	        });
	        
	      	//ajax获取全国分布统计数据
			function getAreaMap(name){
				myChart3.setOption({
					series: [{
			                    data:[{name: '北京',value: 10000 },
				                      {name: '天津',value: 5 }]
			                }]
				});
				//myChart3.showLoading();
				// 填入数据
				/* $.ajax({
					url: '${base}/scuser/selectSex.do',
					sync: false,
					type: 'post',
					data: {
						name: name
					},
					dataType: "json",
					error: function (data) {
						return false;
					},
					success: function (data) {
						myChart3.hideLoading();
						data = eval(data);
						var sexPie = new Array();

						for (var i = 0; i < data.length; i++) {
							var item = eval(data[i]);
							var it = {};
							if (item.hasOwnProperty('gender')) {
								it.name = item.gender;
							}
							if (item.hasOwnProperty('num')) {
								it.value = item.num;
							}
							sexPie.push(it);
						}
						myChart3.setOption({
							series: [{
								data: sexPie
							}]
						});
					}
				}); */
			}
	      	
			//ajax获取某省统计数据
			function getCityMap(name,city){
				var myChart4 = echarts.init(document.getElementById('main4'),'vintage');
		        var option3 = {
			            title: {
			                text: '省市分布',
			                left: 'center'
			            },
			            tooltip: {
			                trigger: 'item'
			            },
			            legend: {
			                orient: 'vertical',
			                left: 'left',
			                data:['人数']
			            },
			            visualMap: {
			                min: 0,
			                max: 1000,
			                left: 'left',
			                top: 'bottom',
			                text: ['高','低'],           // 文本，默认为数值文本
			                calculable: true
			            },
			            toolbox: {
			                show: true,
			                orient: 'vertical',
			                left: 'right',
			                top: 'center',
			                feature: {
			                    dataView: {readOnly: false},
			                    restore: {},
			                    saveAsImage: {}
			                }
			            },
			            series: [
			                {
			                    name: '人数',
			                    type: 'map',
			                    mapType: city,
			                    roam: true,
			                    label: {
			                        normal: {
			                           show: true
			                        },
			                        emphasis: {
			                           show: true
			                        }
			                    },
			                    data:[]
			                }
			            ]
			        };
			        myChart4.setOption(option3);
			}

			//ajax获取性别比例统计数据
			function getSexPie(name){
				myChart2.showLoading();
				// 填入数据
				$.ajax({
					url: '${base}/scuser/selectSex.do',
					sync: false,
					type: 'post',
					data: {
						name: name
					},
					dataType: "json",
					error: function (data) {
						return false;
					},
					success: function (data) {
						myChart2.hideLoading();
						data = eval(data);
						var sexPie = new Array();

						for (var i = 0; i < data.length; i++) {
							var item = eval(data[i]);
							var it = {};
							if (item.hasOwnProperty('gender')) {
								it.name = item.gender;
							}
							if (item.hasOwnProperty('num')) {
								it.value = item.num;
							}
							sexPie.push(it);
						}
						myChart2.setOption({
							series: [{
								data: sexPie
							}]
						});
					}
				});
			}

			//ajax获取年龄分布统计数据
			function getBirLine(name){
				myChart.showLoading();
				// 填入数据
				$.ajax({
					url: '${base}/scuser/selectBir.do',
					sync: false,
					type: 'post',
					data: {
						name: name
					},
					dataType: "json",
					error: function (data) {
						return false;
					},
					success: function (data) {
						myChart.hideLoading();
						data = eval(data);
						var titles = new Array();
						var list = new Array();

						for (var i = 0; i < data.length; i++) {
							var item = eval(data[i]);
							titles.push(item.bir);
							list.push(item.num);
						}
						myChart.setOption({
							xAxis: {
								data: titles
							},
							series: [{
								data: list
							}]
						});
					}
				});
			}









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
			<br/>
		</div>
		<div class="container" style="margin: 10px 10px 10px 10px">
			<div class="form-group col-sm-5">
				<!-- 为 ECharts 准备一个具备大小（宽高）的 DOM -->
	    		<div id="main" style="width: 430px;height:290px;"></div>
			</div>
			<div class="form-group col-sm-5">
	    		<div id="main2" style="width: 430px;height:290px;"></div>
			</div>
			<div class="form-group col-sm-8">
	    		<div id="main3" style="width: 750px;height:500px;"></div>
			</div>
			<div class="form-group col-sm-4">
	    		<div id="main4" style="width: 400px;height:500px;"></div>
			</div>
		</div>
	</form>
</body>
</html>
