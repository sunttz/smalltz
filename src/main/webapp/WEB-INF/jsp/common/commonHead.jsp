<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<c:set var="base" scope="session" value="${pageContext.request.contextPath}"/>
<!-- jqGrid组件基础样式包-必要 -->
<link rel="stylesheet" href="${base }/plugin/jqgrid/css/ui.jqgrid.css" />
<!-- jqGrid主题包-非必要 -->
<!-- 在jqgrid/css/css这个目录下还有其他的主题包，可以尝试更换看效果 -->
<link rel="stylesheet" href="${base }/plugin/jqgrid/css/css/hot-sneaks/jquery-ui-1.8.16.custom.css" />
<!-- jquery插件包-必要 -->
<!-- 这个是所有jquery插件的基础，首先第一个引入 -->
<script type="text/javascript" src="${base }/plugin/jquery-3.1.1.min.js"></script>
<!-- jqGrid插件包-必要 -->
<script type="text/javascript" src="${base }/plugin/jqgrid/js/jquery.jqGrid.src.js"></script>
<!-- jqGrid插件的多语言包-非必要 -->
<!-- 在jqgrid/js/i18n下还有其他的多语言包，可以尝试更换看效果 -->
<script type="text/javascript" src="${base }/plugin/jqgrid/js/i18n/grid.locale-cn.js"></script>

<!-- 新 Bootstrap 核心 CSS 文件 -->
<link rel="stylesheet" href="${base }/plugin/bootstrap/css/bootstrap.min.css">
<!-- 可选的Bootstrap主题文件（一般不用引入） -->
<link rel="stylesheet" href="${base }/plugin/bootstrap/css/bootstrap-theme.min.css">
<!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
<script src="${base }/plugin/bootstrap/js/bootstrap.min.js"></script>

<!-- 引入 ECharts 文件 -->
<script type="text/javascript" src="${base }/plugin/echarts/echarts.min.js"></script>
<!-- 引入 主题 -->
<script type="text/javascript" src="${base }/plugin/echarts/theme/vintage.js"></script>
<script type="text/javascript" src="${base }/plugin/echarts/theme/dark.js"></script>
<script type="text/javascript" src="${base }/plugin/echarts/theme/macarons.js"></script>
<script type="text/javascript" src="${base }/plugin/echarts/theme/infographic.js"></script>
<script type="text/javascript" src="${base }/plugin/echarts/theme/shine.js"></script>
<script type="text/javascript" src="${base }/plugin/echarts/theme/roma.js"></script>
<!-- 引入地图 -->
<script type="text/javascript" src="${base }/plugin/echarts/map/china.js"></script>
<script type="text/javascript" src="${base }/plugin/echarts/map/anhui.js"></script>

<style type="text/css">
	html, body {
		height: 100%;
		overflow: auto;
	}
	
	body {
		padding: 0;
		margin: 0;
	}
</style>