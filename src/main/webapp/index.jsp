<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" pageEncoding="UTF-8"%>
<html lang="cn">
<jsp:include page="/WEB-INF/jsp/common/commonHead.jsp" flush="true"/>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<script type="text/javascript">
		$(function(){
			// 跑马灯
			$("#marquee").marquee({pauseSpeed: 1000});

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

			// 初始化提示信息框
			$("#dialog").dialog({
		      autoOpen: false,
		      modal: true,
		      show: {
		        effect: "blind",
		        duration: 400
		      },
		      hide: {
		        effect: "explode",
		        duration: 400
		      },
		      buttons: {
		          '确定': function () {
		              $(this).dialog("close");
		              $("#name").css("border","1px solid red");
		              $("#name")[0].focus();
		          }
		      }
		    });
			
			$("#searchBtn").bind("click",function () {
				var name = $("#name").val();
				if(name == null || name == ""){
					$("#content").text("姓名不能为空！");
					$("#dialog").dialog("open");
					return false;
				}
				
				$("#pageGrid").jqGrid('setGridParam', { // 重新加载数据
					datatype : 'json',
					postData : {
						name : name
					},
					page : 1
				}).trigger("reloadGrid");

				// 用户性别比例饼图加载
				getSexPie(name);
				// 用户年龄分布图加载
				getBirLine(name)
				// 获取地域分布统计数据
				getAreaMap(name);
				// 清空省地图数据
				myChart4.setOption({
					series : [ {
						name : '人数',
						type : 'map',
						mapType : '',
						roam : true,
						label : {
							normal : {
								show : true
							},
							emphasis : {
								show : true
							}
						},
						data : []
					} ]
				});
				//ajax获取名字排行
				getNameRank(name);
			});

			// 柱图
			var myChart = echarts.init(document.getElementById('main'),
					'vintage');
			// 指定图表的配置项和数据
			var option = {
				title : {
					text : '年龄分布'
				},
				tooltip : {},
				legend : {
					data : [ '年龄段' ]
				},
				xAxis : {
					data : [/*"90后","80后","70后","60后","50后","其他"*/],
				},
				yAxis : {},
				series : [ {
					name : '数量',
					type : 'bar',
					label : {
						normal : {
							show : true,
							position : 'inside'
						}
					},
					data : [/*0, 0, 0, 0, 0, 0*/]
				} ]
			};
			// 使用刚指定的配置项和数据显示图表。
			myChart.setOption(option);

			// 饼图
			var myChart2 = echarts.init(document.getElementById('main2'),
					'vintage');
			option = {
				title : {
					text : '性别比例',
					//subtext: '仅供参考',
					x : 'center'
				},
				tooltip : {
					trigger : 'item',
					formatter : "{a} <br/>{b} : {c} ({d}%)"
				},
				legend : {
					orient : 'vertical',
					left : 'left',
					data : [ '男', '女', '未知' ]
				},
				series : [ {
					name : '性别',
					type : 'pie',
					radius : '55%',
					center : [ '50%', '60%' ],
					data : [
					/*{value:385, name:'男'},
					{value:310, name:'女'},
					{value:234, name:'未知'}*/
					],
					itemStyle : {
						emphasis : {
							shadowBlur : 10,
							shadowOffsetX : 0,
							shadowColor : 'rgba(0, 0, 0, 0.5)'
						},
						normal : {
							label : {
								show : true,
								formatter : '{b} : {c} ({d}%)'
							},
							labelLine : {
								show : true
							}
						}
					}
				} ]
			};
			myChart2.setOption(option);

			// 分布图
			var myChart3 = echarts.init(document.getElementById('main3'),
					'vintage');
			var option3 = {
				title : {
					text : '地域分布',
					subtext: '数据不全，仅供参考',
					left : 'center'
				},
				tooltip : {
					trigger : 'item'
				},
				legend : {
					orient : 'vertical',
					left : 'left',
					data : [ '人数' ]
				},
				visualMap : {
					min : 0,
					max : 100,
					left : 'left',
					top : 'bottom',
					text : [ '高', '低' ], // 文本，默认为数值文本
					calculable : true
				},
				toolbox : {
					show : true,
					orient : 'vertical',
					left : 'right',
					top : 'center',
					feature : {
						dataView : {
							readOnly : false
						},
						restore : {},
						saveAsImage : {}
					}
				},
				series : [ {
					name : '人数',
					type : 'map',
					mapType : 'china',
					roam : true,
					label : {
						normal : {
							show : true
						},
						emphasis : {
							show : true
						}
					},
					data : [
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
				} ]
			};
			//myChart3.showLoading();
			myChart3.setOption(option3);

			myChart3.on('click', function(params) {
				var prov = params.name;
				var name = $("#name").val();
				getCityMap(name, prov);
			});

			var myChart4 = echarts.init(document.getElementById('main4'),'vintage');
			var option4 = {
				title : {
					text : '省市分布',
					left : 'center'
				},
				tooltip : {
					trigger : 'item'
				},
				legend : {
					orient : 'vertical',
					left : 'left',
					data : [ '人数' ]
				},
				visualMap : {
					min : 0,
					max : 50,
					left : 'left',
					top : 'bottom',
					text : [ '高', '低' ], // 文本，默认为数值文本
					calculable : true
				},
				toolbox : {
					show : true,
					orient : 'vertical',
					left : 'right',
					top : 'center',
					feature : {
						dataView : {
							readOnly : false
						},
						restore : {},
						saveAsImage : {}
					}
				},
				series : [ {
					name : '人数',
					type : 'map',
					//mapType : city,
					roam : true,
					label : {
						normal : {
							show : true
						},
						emphasis : {
							show : true
						}
					},
					data : []
				} ]
			};
			myChart4.setOption(option4);

			//ajax获取全国分布统计数据
			function getAreaMap(name) {
				myChart3.showLoading();
				// 填入数据
				$.ajax({
					url : '${context}/scuser/selectMap.do',
					sync : false,
					type : 'post',
					data : {
						name : name
					},
					dataType : "json",
					error : function(data) {
						return false;
					},
					success : function(data) {
						myChart3.hideLoading();
						data = eval(data);
						myChart3.setOption({
							series : [ {
								data : data
							} ]
						});

					}
				});
			}

			//ajax获取某省统计数据
			function getCityMap(name, prov) {
				if(name == null || name == "" || prov == null || prov == ""){
					return false;
				}
				myChart4.showLoading();
				// 填入数据
				$.ajax({
					url : '${context}/scuser/selectCityMap.do',
					sync : false,
					type : 'post',
					data : {
						name : name,
						province : prov
					},
					dataType : "json",
					error : function(data) {
						return false;
					},
					success : function(data) {
						myChart4.hideLoading();
						data = eval(data);
						myChart4.setOption({
							series : [ {
								name : '人数',
								type : 'map',
								mapType : prov,
								roam : true,
								label : {
									normal : {
										show : true
									},
									emphasis : {
										show : true
									}
								},
								data : data
							} ]
						});
					}
				});
			}

			//ajax获取性别比例统计数据
			function getSexPie(name) {
				myChart2.showLoading();
				// 填入数据
				$.ajax({
					url : '${context}/scuser/selectSex.do',
					sync : false,
					type : 'post',
					data : {
						name : name
					},
					dataType : "json",
					error : function(data) {
						return false;
					},
					success : function(data) {
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
							series : [ {
								data : sexPie
							} ]
						});
					}
				});
			}

			//ajax获取年龄分布统计数据
			function getBirLine(name) {
				myChart.showLoading();
				// 填入数据
				$.ajax({
					url : '${context}/scuser/selectBir.do',
					sync : false,
					type : 'post',
					data : {
						name : name
					},
					dataType : "json",
					error : function(data) {
						return false;
					},
					success : function(data) {
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
							xAxis : {
								data : titles
							},
							series : [ {
								data : list
							} ]
						});
					}
				});
			}
			
			//ajax获取名字排行
			function getNameRank(name) {
				$.ajax({
					url : '${context}/scuser/selectRank.do',
					sync : false,
					type : 'post',
					data : {
						name : name
					},
					dataType : "json",
					error : function(data) {
						return false;
					},
					success : function(data) {
						data = eval(data);
						data = data[0];
						var rowno = data.rowno;
						var name = data.name;
						var num = data.num;
						var str = "姓名【"+name+"】，共有【"+num+"】人使用此名，全国重复率排名【"+rowno+"】，";
						if(num==1){
							str += "请珍惜此人，Ta就是那位独一无二的人！";
						}else if(num > 1 && num <= 10){
							str += "此人是稀有动物，请好好呵护Ta！";
						}else if(num > 10 && num < 100){
							str += "此名字普普通通简简单单！";
						}else if(num >= 100){
							str += "已经烂大街的"+name+"，多你一个也无妨！";
						}
						$("#marquee").html("<li><strong>"+str+"</strong></li>").marquee({pauseSpeed: 1000});
					}
				});
			}

		});
	</script>
</head>

<body>

	<form action="">
		<div class="container" style="margin: 10px 10px 10px 10px">
			<div id="dialog" title="提示">
			  <p id="content"></p>
			</div>
			<div class="form-group">
				<div class="col-sm-12" style="margin-bottom: 5px;">
					<label for="name" class="control-label pull-left" style="margin: 5px 0px 0px 10px;">姓名：</label>
					<div class="col-sm-3">
						<input type="text" name="name" class="form-control" id="name"
							placeholder="请输入姓名" value="" />
					</div>
					<div class="col-sm-3">
						<button type="button" class="btn btn-primary"
							id="searchBtn">检索</button>
						<button type="button" class="btn btn-primary"
								id="searchTop">搜索排行</button>
					</div>
					<div class="col-sm-5">
						<div class="container" style="margin-top:3px;width:500px;">
						    <ul id="marquee" class="marquee well">
						      <li><strong>全国重名排行榜TOP10：No10.刘洋【7016】 No9.张勇【7301】 No8.王勇【7411】 No7.李强【7576】 No6.刘伟【8288】 No5.张磊【9093】 No4.李伟【9247】 No3.王磊【9756】 No2.王伟【11319】 No1.张伟【11640】</strong></li>
						    </ul>
						</div>
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
		<dir style="clear:both;"></dir>
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


	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
		<div class="modal-dialog" role="document" style="width: 800px;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">搜索排行</h4>
				</div>
				<div class="modal-body">
                    <div id="top66" style="width: 760px;height:500px;"></div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				</div>
			</div>
		</div>
	</div>

</body>
</html>
<script>
    $(document).ready(function(){
        $("#searchTop").bind("click",function(){
            $('#myModal').modal();
            top10();
        });
            var myChart10 = echarts.init(document.getElementById('top66'),'vintage');
            var spirit = 'image://data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAHUAAACUCAYAAACtHGabAAAACXBIWXMAABcSAAAXEgFnn9JSAAAKTWlDQ1BQaG90b3Nob3AgSUNDIHByb2ZpbGUAAHjanVN3WJP3Fj7f92UPVkLY8LGXbIEAIiOsCMgQWaIQkgBhhBASQMWFiApWFBURnEhVxILVCkidiOKgKLhnQYqIWotVXDjuH9yntX167+3t+9f7vOec5/zOec8PgBESJpHmomoAOVKFPDrYH49PSMTJvYACFUjgBCAQ5svCZwXFAADwA3l4fnSwP/wBr28AAgBw1S4kEsfh/4O6UCZXACCRAOAiEucLAZBSAMguVMgUAMgYALBTs2QKAJQAAGx5fEIiAKoNAOz0ST4FANipk9wXANiiHKkIAI0BAJkoRyQCQLsAYFWBUiwCwMIAoKxAIi4EwK4BgFm2MkcCgL0FAHaOWJAPQGAAgJlCLMwAIDgCAEMeE80DIEwDoDDSv+CpX3CFuEgBAMDLlc2XS9IzFLiV0Bp38vDg4iHiwmyxQmEXKRBmCeQinJebIxNI5wNMzgwAABr50cH+OD+Q5+bk4eZm52zv9MWi/mvwbyI+IfHf/ryMAgQAEE7P79pf5eXWA3DHAbB1v2upWwDaVgBo3/ldM9sJoFoK0Hr5i3k4/EAenqFQyDwdHAoLC+0lYqG9MOOLPv8z4W/gi372/EAe/tt68ABxmkCZrcCjg/1xYW52rlKO58sEQjFu9+cj/seFf/2OKdHiNLFcLBWK8ViJuFAiTcd5uVKRRCHJleIS6X8y8R+W/QmTdw0ArIZPwE62B7XLbMB+7gECiw5Y0nYAQH7zLYwaC5EAEGc0Mnn3AACTv/mPQCsBAM2XpOMAALzoGFyolBdMxggAAESggSqwQQcMwRSswA6cwR28wBcCYQZEQAwkwDwQQgbkgBwKoRiWQRlUwDrYBLWwAxqgEZrhELTBMTgN5+ASXIHrcBcGYBiewhi8hgkEQcgIE2EhOogRYo7YIs4IF5mOBCJhSDSSgKQg6YgUUSLFyHKkAqlCapFdSCPyLXIUOY1cQPqQ28ggMor8irxHMZSBslED1AJ1QLmoHxqKxqBz0XQ0D12AlqJr0Rq0Hj2AtqKn0UvodXQAfYqOY4DRMQ5mjNlhXIyHRWCJWBomxxZj5Vg1Vo81Yx1YN3YVG8CeYe8IJAKLgBPsCF6EEMJsgpCQR1hMWEOoJewjtBK6CFcJg4Qxwicik6hPtCV6EvnEeGI6sZBYRqwm7iEeIZ4lXicOE1+TSCQOyZLkTgohJZAySQtJa0jbSC2kU6Q+0hBpnEwm65Btyd7kCLKArCCXkbeQD5BPkvvJw+S3FDrFiOJMCaIkUqSUEko1ZT/lBKWfMkKZoKpRzame1AiqiDqfWkltoHZQL1OHqRM0dZolzZsWQ8ukLaPV0JppZ2n3aC/pdLoJ3YMeRZfQl9Jr6Afp5+mD9HcMDYYNg8dIYigZaxl7GacYtxkvmUymBdOXmchUMNcyG5lnmA+Yb1VYKvYqfBWRyhKVOpVWlX6V56pUVXNVP9V5qgtUq1UPq15WfaZGVbNQ46kJ1Bar1akdVbupNq7OUndSj1DPUV+jvl/9gvpjDbKGhUaghkijVGO3xhmNIRbGMmXxWELWclYD6yxrmE1iW7L57Ex2Bfsbdi97TFNDc6pmrGaRZp3mcc0BDsax4PA52ZxKziHODc57LQMtPy2x1mqtZq1+rTfaetq+2mLtcu0W7eva73VwnUCdLJ31Om0693UJuja6UbqFutt1z+o+02PreekJ9cr1Dund0Uf1bfSj9Rfq79bv0R83MDQINpAZbDE4Y/DMkGPoa5hpuNHwhOGoEctoupHEaKPRSaMnuCbuh2fjNXgXPmasbxxirDTeZdxrPGFiaTLbpMSkxeS+Kc2Ua5pmutG003TMzMgs3KzYrMnsjjnVnGueYb7ZvNv8jYWlRZzFSos2i8eW2pZ8ywWWTZb3rJhWPlZ5VvVW16xJ1lzrLOtt1ldsUBtXmwybOpvLtqitm63Edptt3xTiFI8p0in1U27aMez87ArsmuwG7Tn2YfYl9m32zx3MHBId1jt0O3xydHXMdmxwvOuk4TTDqcSpw+lXZxtnoXOd8zUXpkuQyxKXdpcXU22niqdun3rLleUa7rrStdP1o5u7m9yt2W3U3cw9xX2r+00umxvJXcM970H08PdY4nHM452nm6fC85DnL152Xlle+70eT7OcJp7WMG3I28Rb4L3Le2A6Pj1l+s7pAz7GPgKfep+Hvqa+It89viN+1n6Zfgf8nvs7+sv9j/i/4XnyFvFOBWABwQHlAb2BGoGzA2sDHwSZBKUHNQWNBbsGLww+FUIMCQ1ZH3KTb8AX8hv5YzPcZyya0RXKCJ0VWhv6MMwmTB7WEY6GzwjfEH5vpvlM6cy2CIjgR2yIuB9pGZkX+X0UKSoyqi7qUbRTdHF09yzWrORZ+2e9jvGPqYy5O9tqtnJ2Z6xqbFJsY+ybuIC4qriBeIf4RfGXEnQTJAntieTE2MQ9ieNzAudsmjOc5JpUlnRjruXcorkX5unOy553PFk1WZB8OIWYEpeyP+WDIEJQLxhP5aduTR0T8oSbhU9FvqKNolGxt7hKPJLmnVaV9jjdO31D+miGT0Z1xjMJT1IreZEZkrkj801WRNberM/ZcdktOZSclJyjUg1plrQr1zC3KLdPZisrkw3keeZtyhuTh8r35CP5c/PbFWyFTNGjtFKuUA4WTC+oK3hbGFt4uEi9SFrUM99m/ur5IwuCFny9kLBQuLCz2Lh4WfHgIr9FuxYji1MXdy4xXVK6ZHhp8NJ9y2jLspb9UOJYUlXyannc8o5Sg9KlpUMrglc0lamUycturvRauWMVYZVkVe9ql9VbVn8qF5VfrHCsqK74sEa45uJXTl/VfPV5bdra3kq3yu3rSOuk626s91m/r0q9akHV0IbwDa0b8Y3lG19tSt50oXpq9Y7NtM3KzQM1YTXtW8y2rNvyoTaj9nqdf13LVv2tq7e+2Sba1r/dd3vzDoMdFTve75TsvLUreFdrvUV99W7S7oLdjxpiG7q/5n7duEd3T8Wej3ulewf2Re/ranRvbNyvv7+yCW1SNo0eSDpw5ZuAb9qb7Zp3tXBaKg7CQeXBJ9+mfHvjUOihzsPcw83fmX+39QjrSHkr0jq/dawto22gPaG97+iMo50dXh1Hvrf/fu8x42N1xzWPV56gnSg98fnkgpPjp2Snnp1OPz3Umdx590z8mWtdUV29Z0PPnj8XdO5Mt1/3yfPe549d8Lxw9CL3Ytslt0utPa49R35w/eFIr1tv62X3y+1XPK509E3rO9Hv03/6asDVc9f41y5dn3m978bsG7duJt0cuCW69fh29u0XdwruTNxdeo94r/y+2v3qB/oP6n+0/rFlwG3g+GDAYM/DWQ/vDgmHnv6U/9OH4dJHzEfVI0YjjY+dHx8bDRq98mTOk+GnsqcTz8p+Vv9563Or59/94vtLz1j82PAL+YvPv655qfNy76uprzrHI8cfvM55PfGm/K3O233vuO+638e9H5ko/ED+UPPR+mPHp9BP9z7nfP78L/eE8/sl0p8zAAAAIGNIUk0AAHolAACAgwAA+f8AAIDpAAB1MAAA6mAAADqYAAAXb5JfxUYAABvgSURBVHja7J17dBPXnce/dzR6WH7IwTbYxPgBBJsAtgwJXcchCM5ZEtJwcHqaRxs4hXQh+4dT3O1hd9ukJ05LT/dsT4lTyO7JSbfrQHabbdqNE/qgTjcR5KTOsxjCK4QGGwgy2ARJtoSec/ePGUkzo9HLGj2MdTk62PLM6KffZ76/+7u/e2eGUEoxHduota0BQA+ATgAm0Z9GAPQD6K22HBnGDGxkOkIdtbb1AHgqwWYOAN3VliN9Baj5D7QPwDdS2GXrTAM7raCOWts6Abw6hV3bqi1HhmYKVGaa2dub5f0KUDOsUguA+inuvlpIrApQ86xZ0tzfXIB647UC1Hxr77m0zSi0Gwcq2bvO/K5b25nmYQrZbx4BLQfQf8Ch16d5KGsBav60fgD1JzwsBl3aqR7jxWrLEXsBan6otAfA6tDv37eVTOUwDvA14kKfmgdALZDVd094WHR/XpoqUMtMK+znZZlQ6EeHIZ19Cbd7yrx49uYJlGni2j4CoHMmlQdDjc3jftQU648HnXrc7tJhfZkX95T6sLQogFptEBf9Gpg03BulDP3vmTg7k7dKJXvXdQN4Zqr7064BUhin5tl4NB2gAI4WSg/5lyilGzLtBaR5BFUYvrQWkNwgUIWw+1QBx42lVLUyVXMBaR5AVTnsmoSixYxuOR3SkL3rGsDPnphUPKwDgJl2DQwXlJq7sGtS+ZgmAEMzWbE5UyrZu64TU1sZmEp7DUD3TFNtTqAKtd0hTH0hWartEIBe2jXQX4Ca2eQoF0OYESHk993I6s06VCE5OpcH3/2QALifdg3YC1DTg9qH1C6byEZ7UYDbX4CaOlALgLfy2B83RHjONlQrRMtT8rxN2+Qqa1CngUrjqbdXUK+9AHX6qlSpOQS4vfkONytQs1RoKMAVWrbKhL030IjBJIyxh4WlNzNPqdO4L02lz91CuwasM0mpPbixWz2At8jedb1C+fPGVuoMUGleqjbTSu3GzGoh1fbckErNoxpvLosXnbnIkDOp1B7M7LYagFVYVDf9lZroWpgZ1hwALLRrYGi6K7WzAFQyrs2qYjMFtbvAMndgVYcqGF5YaZ9DsExBpVkH25fpIkUmoHYW2MVtreCvv50eUIXZmEKClMRwJ5MFCrWVuqXAK+n2VKYWnKs2ThX6iWsFVim1EfCXiNjzVamWAqOUWz0yUHlTE2ohQZpa26H2MKcANT9ab95BFTr8QtabXjasWvel1n2U8rY/vcPviXrvOKuDk+Tdzd561PKjKtkv2btuCDksDS4J+NDh82Ae58fSgA9L/T6YKJdwPwdhcFyrwwWGxQWNFu/oDPiz1pBLsGvUWDWRNtRcDGXKKIf1Xjfu9bpwh8+TFMBU2js6A/6gK8bv9UZc1GT1pnCHaNeAJR+gdiJLa3of8kziXq8L673urHn5OKvDy4ZSvFxUkq2Q3Zbu3KsaVpozrcqdLjs+HRvBHudYVoECwNKAD7smr+Kj8Qv4mXMMtcFApj+yOx+UakUGLqcooxweczux3e1QPbym2142lOBfi2/KVGh2AGhIp8qUl0p9yDOJj8YvYKfrWt4BBYCHPZN464vPsdNlz8ThTemO+Zk0Vdqg5vi0NhjAq3Yb9jjHcFPJrLweWJooh52ua/jo6gXFYVOaLXdQ1VTpQ8LZ3+HzgKmsg/HBXWAbl+cEGNEZk952XjCA/ms2tVW7MZ2J9LyA+sPJq9jjHIOJcjzQjd8D0RnBNqzICVRty93QNt2ZfAXnlnbsdF3Dq3YbytTrLjqnJdQyyuFVuw2PuZ28MSKgAKBtXgWmoi7rULmrIzCs3Z40WMZUDcPa7ejwedB/zYYlAZ8aZlhyBbU8HaD912zo8HkUgYZa0drtWYdKhWFTsmC5qyPQNt0JbfMqLA341AKbM6ir0wG6VPjiTGmlItAQbMOabVmFGrx0OvxzMmDDJ8GabWAbV8AkfL80wdYLiWhOhjRpASV6I4rWd8dNTrTNq1Lq49RuicBy4+dF224DU1mnFlhzVqFOdapo18TVMFAA0HdsSqrfTKWPEzd9xyNgSiunoNZTUZ8fK2JQn1uSORet3Q6iN8JEOexxjqWTPJnzXqk7XXY87JmMZI2NK1ICZVi7Hbrb7k8tk21aBeMDu1JOuKhCOVLbvComWLFamYq6sJ1LAz7scY5NG6gpJUl3+D3Y6YpM5jCllTCsTb2v1N9+PwxrtiU1liQ6I4iefxU/uCulEygogpQMWOpzSX7XtdwNzdzFAID1Xje2Cxl+NhLRdKAmfRaVCWFIGhY3pTTIlzvWuPF7CdXHVNZFKV3f8UhyH+Jzx/18OVilk8CwdhuInv+OuyavTqV/XZ1tqCmE3WuYJ5rdYBtXpF0tYirrUPzgrrjhWFMZfedZXcvdKLpnR8ITKjg+kvDEEoNVCtdMaSV0LXdH8onJqxn1s8c22OCxDXZnHGptMBAuLoSy3aTVkmQ4Ln5gFzRzFR6EHAMc27iCV3qcBIpOjCcVMUJguavKJ4HutvvDn9Ph8+AhUU6RZELakATMco9tsAf8PZQ7Mw51z8RYlFKmko0mUq1x4/dQdM8OybHZm5vj7xMngeKSgCoGS+PM8+o7NoV//kdXyotEGhIA3QL+Au+nIEyuZBRqaO2QWKVaUThSu7GNK1C8aTcMa7aBKa0EKa2Kr4IECVQqYHVxvhfbuDycNM0LBlJWawyYZo9tcAjAf0I6UzbECHG4IRNOfsztUC05SjWRKt60O+mIECuBohNjKZ1QibqJNNQqD7W9AI5AebGfnRHkfc5jG+zz2AbL1XJsGeUkY1KmtDKnVaFETSmBijWsmUrTzG2WqPWeKSzL8dgGLUK/uSPOZnZGiMcAf7fsYaHDTbs9fF0aYjIZdtUM3+IEiqq8Hkocor/mmZiKOt9C4odJDDGGmvZh0RsmAE95bIPDHttgZ1pQRUYTvRHa5lVxyjc0uVcWmjiBCme0KtnHNi4PnzDrve6kyodfq2tdCMCaQJ3iNhwrUaoH8KrHNtg/lf62NhiQ1Hd1LXdH96VTgZUlwERvRPEDPwTbsFx1+3S3fyVSZfMlXgazud7cixQWyhtq2sNQYz1MdiOAIY9tsFtJ5rEO3CFbs8M2rUoeSrJnfyYAy46pbVqlun1s4/JwlanDfz2hSWtmzy9O4RscEg9p7HE2NAF4xmMbtMoSqZj7LA14Jf0UU1Kh7ACJg8C/QKSv0PuUIuZy1nThxto/A/YRnTGcKXf4Ulyw5k+45nhIDHUoyTpkUn2tOPRqF92p8B1DX1JwDCFRvop+EZCwE2M4cCpgFfbJtH2hhGlpglpwnTGiIc4xCf9nF1OCOpykC0xCX9sb70Ke8BKVkkpJjZcKZzwJOYp/N2ECcnH4HM6cOImLI+dkDlRwXjzFJFCn3L6r42M4c/Ikzpw4kWSiRJOyj8yaF55siFfkry/moVK3B953joAxlST6VlYgcinjUIrn9w6PbdBCQJwUtEw+Po0akIdCD4QzPhTOFJVChHjG/7/v+efx3tuH+V8BLGy+FX//D99GkbGEdx4VHUM4UUjouOETJ4E6Fez79b59ePOPB4VjAbX19eh+4kkUGYsl9sVJt+Lap120Ct7x/4q7WL3VVA34A/C+fxxEy0JTHbeYcjQ0kmGmCBUAWldW1Oriht7mOyNhLORgpUSDRl403H9R/O5/f4P33z4s2ebsqZP43a9/E1E4RP1csgqN+l1q39EPP8BbBw8KQPi3L46M4PnduyX2UZHd0REgvn2hCBavX603lMHzzhCocxKauppE36wvPCwT0mB7nAyY76M/iY7Qt5RUxLyYk6moAzNrnuAwRH9RsUMER1BKQUTArQcPil0Sbm/98aDUeaGwJwebCHIYqNS+N0WfC1F3evb0KXw+MqwcejkqBZzAPqa0MuF88K1Xg6DOSYDVQDu/NhHUfglUcTyO1YK2cQQujEqlWl6tUA/TCsOBO6UOi1ImD5FSitA/yXuUwuN2S2CK85IzJ09KwdEkwEb9rGzfX0+dCn8uodLPd0+6wvZF+kzhG4Rs5xS6FwX7FIdMotY+zodmdsE8QBv3YqxD4iJS0lDZBbXwHzmN4Ghk5qLFFB0SiKEEoOBX1xNEweS/sAARsuFCjDEgUVBrRWVVRPhKjosXdpWAiuybVVkZ+7MV7KRi+wWaoTAdz754CwU6CJ8kkSJ9MiqVlHYZUSWiH/xldMpQqysBVgPfX06Bc/B13buqootNTJGJDy1lldEOE37mVSlyBCcKX1zk99p5dSBU6lQCYFZFJWZVVkSGHnLHxVOoJB9Ttu+W5sVRnxl61dbVSmwM2yyyhYTUm8A+prQSmjkLFP19JykHWA10K5clo1KrIlR5XI5qWhaamiogEIT3nSNhsC0mWQjW6qFdskaWPEQcRiD6khwncgbHv0Sd7fqNnYrh96uPPCJ0UxFVSBQR+iQFwDSk0jj23dv5FRQZjfzniU6qezZ2oqjIKMvsOGmfynGioVFi+yZMcxTdfS9TBe2yW5IZxkRNwDCxMihFrk0NAKsBAkH4jpwG/IEotb49PgJ2/u2SpEjssPCXk4csmUrBUSw1t+GbXY+HFVs7rw5/17UDy9qWR1QBCknAFY0XSbxhSxz7ZlVW4Fv/9F20mJeDEOCmigrc//DXsX7DRol9NKxWMWBIVZvAvmMKM0FlhMVtFgvYedWJgD4rVymfB8hCkzCb3hovCw4ImTApK8EbC4rw4Pu/kmxz/f6nopMisULlMOVhWR4lCRG6IiJKSUlkoK/wXsSNVCxIHipo3tj3pTf/HccclyXH3DSvFS+s/EoioCMAzMLIJa5SgQR339I2NYCp4FdPUOck1l2KHjwfHh9OyWGhzBFcrCREllQhOqGiMlUGvNdx6aP38PEv9+PM738Lj8PO93VEGnZzZV/oHTlQANiceKWlA0CnElBFqIaa9r5QtT9W069cBlLGx3pudBxfNt4s+fsx+6jEb8oDc1FJjxP3q5AmIUKfxf9J7jhxZKXhvizg9eLjl/fjszffgOPiCK6cPIpzb74R3ZfmyL6wn5yjivVepQRUBtRiqGmPWTCKNZ/aHfc80bIwdJjDYNd7SqX1KsdotOfCYV7mMPngnRMlSxwn6ns5IMpxkCpMaJ+9OQDXlSuRAEkpNHqDtNacQ/vCEe3KsNL8aaKpNXM8oDGhCjs9nRDs6hVgmxpwn0ypB2yno8Zt8moLhWxaCzG2lTiPd5xoAIgoOpRi7MSxyN8IMHtJKxatv08x9ObCvtBnHB6PfsDW5oY2xbougK2GmnaLbKVKSkqFoaa9J1HpMNTHzlm3ChtqImtsHX4vjjlGlepy0jM4/L/SeE+kEHHBIJRBywsBMWLq3LbbeaAgSZQOs2efw+/BAdsn0gSp3oz6IlMoxB4ShNVmqGk3C91iUi3Rul9LMmCVwsb+80dFJ7i0EEBlWWV00UBh1QCBgnIgmjER9fllkWWwprr6eAhzYh8AvC4DCgAvf3Zk+bs3dzCGmvZyQZU9iUJtylCF7MoC4MVEhfENNc2SSd19F4YUx4lSb5LoaTgiSmaIOIGR9ns0TtVo8f1fham2HrNvbUHFLU0KfiXRb2XRPv6kj2J1aKj7T1OZLUtZqTDUtNsNNe1bAKxJlBWL1er0e7H/wtHEsyREoXQnfkNxvlWxuhuOksVV1Vj28CYsuve+WGkuSLKrIjJg34jbjrdlF2BpOPo0VGpJX3ZhqGm3GmraLQDaADwrDH4l7fGFfyP5fdfpQ6lZk51VoLFcnjX75H5hKPad3fEna9ahijNjQ017t6GmvcFwcwdDg9xa6g+sRSCwtozRPdpoLB8IbXv+uiNKrRK/kOhxY7jiQoTKT2jyOlyJoYgU36L3JUnSoTEYZdq+8247XpL6xFHsU0+lQJp35rYCuLVulVUHQFOzklwqcxxyPnrzYRg1Z0Pb/OiTw9hc2yI4iIqKdwQAF3EEhXR1BES/y5alhH0tfp+QlIQZVUTMkn07jw/IVfrs6Z+eGPapCDXtq97GwK8VnQC/Iv/Pz50dZij2idX6ozNvi6REQMU10JAHCJE6SfIzJNtQSWGepBYyFQBE3susfYfHR3BgVJL1joy+MPo0bKLhhgq3SlfvUkabHRzDgGVZLL3s+Y54bvZHZw7j2MRlSYgMF7mVQljoxYgcxjDSArncqZAVzaO4UkWpUrl0M2Sfw+/B9iOvS4deAfroBMPgKiZgBLAkH5RqoZRWATACuIoJ6HU6GAjBb188Z2c5+gPxttuGDsjCFeE/nQjOYBgF1YW2Y8JnPREvHIISWJEEhTtpE8iGjlKZRqs4A/btOnMY5687xGH3B5f+bcQ6cQkoxSTG8in8zhZCcCkmKTfKIMiylDIMPfnj4z8jwOHQdh87L2PnyQGJFIjccQT82c8wojM/ohCeEZEpR2pPwOuRqZEK6pGGzqufnoHHYVdMctS2b/+Fo3jus/cjVTiKE5d2f/qDMYZB1fUr4dPNmi9QxYYYXaOgDAMty4LVaDDLFXiUAQlf/vbcuQ+w//NjUY4jjEhZktXwDAjDKM9JylfPg8B58Tw+fGFvBKy8jk546B+/vB+nXnsFH/38OXidjlAPKJsPVce+YxNXsPNEJDkyBYGjQxptRdvC8lk6HeyTE+H76lhUevBe2lAlIXjShoBXB71GQzUaDR3sPTWiC3Bbxds/dvS3OPzFeVnnxSuJMLwSiPACA1ACXmWEifRhiPRp4nVExbPn8NNu//MSAj7+eh7CMJK+9bP/ewOOC+fDww4eKv85kv5SBftGPA7c/ed9cPoj1xb1n9Zg8XVmUdCo2++4wsKISfq5iv2paolSJASDGq5cwSTLQsuyKNJoMPwvp19jOfxQvP2DH74iJE7ihIN3DBHFNAICogQztE84xPIZK2swYPaSVriuXMGHz+/B5RNHw6r1OOw43f9rXDkurcTpTSYhNBPh0CIlpmGfI+jFgx+8AocI6C/OMrA4eLv1FOvnr55jLleIeGmXVtRQvJUQcqvw82WAFM9vRbnGDb/fTxxeL/EHdKT1+4v+I0iwObRPGavHwB2b0VI6R1oojzXQlGWg4SW0gopCkvU4HRh68ecIeL3Kox0aqfrOXX475q/9W8miMMk6KkC2fjc5+0auO/DQB6/gmDOyqmGHjUHvOUZSIemuDz637cd/fHwJf3yaV1CFBIScAFAMQIcSol3WCKfbTbR+P1i/n7hICVn8zw1SsFo9fnLrOmye1yJxdswCghgsEA6LkRjMK8g1NoqPf7kPAZ8vZk13/tp1mLtipaQgL1nxCIU1u0nYd8x5GetkIfcbVwj6zmokQCmlWLA8iAs6bu2nO/5kbchHqGK1ugFyzbgQhnotdD4f0fl84AIBMhkgpPX7SyRgAeCJRXfhiaa7FGczpFUZEUwIC76IfDs+iw34vLj04Xu4fPxYuN/Ul5lQsbAJc1eshMFULi3QC+uNSHj6TSnTim/fgcufYNuR1xMCBaU4WgK0LQsABA7KPxh3OP+UCmCYEOICcDOACYCML2yDQeuBzucjQb8fPr+fGDkOi55o+YUc7KqKevxq5QMwaQ3RU1uyX4hcsTKgiFVCjLdKH9Ehl1KqXJZSsG/n8QHJsCUeUArgm7dw6KvkQknaUdo1YM5LqOIwzIMtIeNzboFhFg+2JBjEpN9PuGAQi7+79FtBhvxUvKtJq8cLbRtxX3WTAlOiXMtVWg4aryacLNio/lSZ6THHKLYdeV3SfwLAM+cYdNuYKKAA4GAJGtv8sLNC1s23Z2nXQHdeQu0jhGwBcEKsWONC1M4uwjWtB2wwSAKBAILBILntO82r3VrmN5A922ZDdRN+suxu1Ism3RUrRpLqeRJABfWRGImTTKZxa8gOvwe7Th/C3s/ek7xvCgK95xhsuaKRzRxQoTxM8GIVh60LgmKgoZYfT2WMFYYbRGDtALwoIZ6qBdBV+qAJBMAGg6SY49Cxtb6cM+r+cM6A2+XH6VrwJTzZvJoPyUrAaGQijcgBxpu1iXnpPlGuKYq2d/g92PPX97D3r+9KhisA0Oriw63ZJS1bUiq1b35bAOcMin5X5cHzGYEqD8VVfPKECYDoUANP1WzMrebwhc+HRW3zzYSQN60matqyMIgRvdQek1aPDTXNeHKxBfXGmyTdpiLMREDjwI2omEBeNHb4Pdhz9l1FmKEhS89FDcoDsWECwGuzOHQ2BeNZ9RrtGujMX6iCao1CcSIEFwBxowZN9y8r1xjYv4BE7uLVMy+I3hoODk30sTbUNGPD3CZsqjMrw0wFaALVhoLyAdsneP3SabwUvaYIAFDv5dVpcZKoMKvU1iwJwFqW0OdpheGMQ1WCCyEsl3/93rcopatlM5ywa4HemthwTVoD7qpswIa5zbirqoHvewlJz8BQEuP34PDYMF63ncaBS6fhiPEcN1MQ6L7EoOcCI02e4thxqIzCsiSpR3WmFYazBlXe3+Jr93aDYHfCxKuKQ99sDofinN11xnK0llejxVSNu6oaASDRpQsA+MtD7H4PDo+dw4jbjmP20RjrlWUwbQy6bdJQq3ieyFKwJFUaak/TroGeaQEVAPDIlxvA3zwk6Sc6Dusp+mdR9FVxOFqcms11xnLUF5fD4fMkhBar1XsJum0MtowxcWHGqjuloFJxa5xKUYJFbtoWOdAEN69Bg5eg28Y7dlhPYS2jsJr4/+XJlbydd9tx3p16JGt1EXReI+j8gkGri8S0lSD2yEucK0yh9Qi+yn+lPv7kPd++bZLsNruJxFlTbXYWGDJSDBVT2FmKISNgZynsGiRU9WohwSkPEJjdwv8uEkl8VGhJZLyqqjXrUIUb/YdDb3kAMLsJLA4GFifvUFMQN1RrXB7AsH7Kfn6Rdg1syXeoViR43orZRQTQ/P9qqDlX7elabqqhN1zvQIrPKM8qVLJ3XTeAZ6ayr8U5/dQ8oqcwtwRgTz9z2Uq7BvryLlESHsfcM9X9rWUU1rKgopotToJ6b/6pubuBUwMowF+kln9Qwd9LQrWH0g8V84lRn/CUkvIAYHHySrY4cx+yX5vFoX+Wao+ybkhJQNkIv0JydC6bTpUnYKud2YOsYtiNDKO6Bki+KbUn20qxs9EhW9wvZxJyZ1NQVaBQuMIwp1CFvvQb+dDHZQPy1oVBDBWrHv2s+VZR2oI8bbEgm92AxcGknGFvXRhEXxWntpmOVCPdjIYaH3IwnGGbXfwrlpodGqC7MWNALXlVUcpFgpTpZnYRlAd5JQPAsIGi/yZO7T4U4G+gsoV2DQylumOmlWrBDdZC/aU4bGdAnb1TnXbLBtQGFFpKMAWg9nQOlGmo5gKrpIYrvQD60oWZLai9Qgg2FdhFqbJfUOWQ2gfPeEVJGKd2Cy/TDFdkP4B+Ndb25hSqDHAngNDLNAPUaBVAWtW8ViavoMoAW4TQbEGC+dVp0o6Cn/y3Zhti3kCNA9ksZM2teQzwEPjn4w0BGMp0OJ22UOOALhdAm0U/m7IEDoLy7ALA4Vwq8IaAmkQCFhoylacxfAoBAwB7JrLRbLf/HwBxI17fueoAtgAAAABJRU5ErkJggg==';
            //var maxData = 100;
            var option = {
                tooltip: {
                },
                xAxis: {
                    //max: maxData,
                    splitLine: {show: false},
                    offset: 10,
                    axisLine: {
                        lineStyle: {
                            color: '#999'
                        }
                    },
                    axisLabel: {
                        margin: 10
                    }
                },
                yAxis: {
                    data: ['张三', '李四', '王五'],
                    inverse: true,
                    axisTick: {show: false},
                    axisLine: {show: false},
                    axisLabel: {
                        margin: 10,
                        textStyle: {
                            color: '#999',
                            fontSize: 15
                        }
                    }
                },
                grid: {
                    top: 'center',
                    height: 400,
                    left: 70,
                    right: 100
                },
                series: [{
                    // current data
                    type: 'pictorialBar',
                    symbol: spirit,
                    symbolRepeat: 'fixed',
                    symbolMargin: '5%',
                    symbolClip: true,
                    symbolSize: 30,
                    //symbolBoundingData: maxData,
                    data: [98, 50, 32],
                    markLine: {
                        symbol: 'none',
                        label: {
                            normal: {
                                formatter: '最多: {c}次',
                                position: 'start'
                            }
                        },
                        lineStyle: {
                            normal: {
                                color: 'green',
                                type: 'dotted',
                                opacity: 0.2,
                                width: 2
                            }
                        },
                        data: [{
                            type: 'max'
                        }]
                    },
                    z: 10
                }, {
                    // full data
                    type: 'pictorialBar',
                    itemStyle: {
                        normal: {
                            opacity: 0.2
                        }
                    },
                    label: {
                        normal: {
                            show: true,
                            formatter: function (params) {
                                return params.value;
                            },
                            position: 'outside',
                            offset: [10, 0],
                            textStyle: {
                                color: 'green',
                                fontSize: 18
                            }
                        }
                    },
                    animationDuration: 0,
                    symbolRepeat: 'fixed',
                    symbolMargin: '5%',
                    symbol: spirit,
                    symbolSize: 30,
                    //symbolBoundingData: maxData,
                    data: [98, 50, 32],
                    z: 5
                }]
            };
            myChart10.setOption(option);

        //ajax获取top10统计数据
        function top10(name) {
            myChart10.showLoading();
            // 填入数据
            $.ajax({
                url : '${context}/scuser/top10.do',
                sync : false,
                type : 'post',
                data : {
                    name : name
                },
                dataType : "json",
                error : function(data) {
                    return false;
                },
                success : function(data) {
                    myChart10.hideLoading();
                    data = eval(data);
                    var titles = new Array();
                    var list = new Array();

                    for (var i = 0; i < data.length; i++) {
                        var item = eval(data[i]);
                        titles.push(item.NAME);
                        list.push(item.NUM);
                    }
                    myChart10.setOption({
                        yAxis : {
                            data : titles
                        },
                        series : [ {
                            data : list
                        }, {data : list} ]
                    });
                }
            });
        }

    });
</script>