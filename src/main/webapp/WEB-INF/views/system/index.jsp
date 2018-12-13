<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>TreeSoft数据库管理系统</title>
<meta name="Keywords" content="Treesoft数据库管理系统">
<meta name="Description" content="Treesoft数据库管理系统">
<%@ include file="/WEB-INF/views/include/easyui.jsp"%>
<%@ include file="/WEB-INF/views/include/codemirror.jsp"%>
<script src="${ctx}/static/plugins/My97DatePicker/WdatePicker.js" type="text/javascript"></script>
<script src="${ctx}/static/plugins/easyui/jeasyui-extensions/jeasyui.extensions.datatime.js" type="text/javascript"></script>

<!--导入首页启动时需要的相应资源文件(首页相应功能的 js 库、css样式以及渲染首页界面的 js 文件)-->
<script src="${ctx}/static/plugins/easyui/common/index.js" type="text/javascript"></script>
<script src="${ctx}/static/plugins/easyui/common/indexSearch.js" type="text/javascript"></script>
<link href="${ctx}/static/plugins/easyui/common/index.css" rel="stylesheet" />
<script src="${ctx}/static/plugins/easyui/common/index-startup.js"></script>

<link type="text/css" rel="stylesheet" href="${ctx}/static/css/eclipse.css">  
<link type="text/css" rel="stylesheet" href="${ctx}/static/css/codemirror.css" />  
<link type="text/css" rel="stylesheet" href="${ctx}/static/css/show-hint.css" /> 
<link rel="icon" href="${ctx}/favicon.ico" mce_href="${ctx}/favicon.ico" type="image/x-icon">  
<link rel="shortcut icon" href="${ctx}/favicon.ico" mce_href="${ctx}/favicon.ico" type="image/x-icon">
  
<script type="text/javascript" src="${ctx}/static/js/codemirror.js"> </script> 
<script type="text/javascript" src="${ctx}/static/js/sql.js"> </script>  
<script type="text/javascript" src="${ctx}/static/js/show-hint.js"> </script>  
<script type="text/javascript" src="${ctx}/static/js/sql-hint.js"> </script>  
 
<style>  
  .CodeMirror { border: 1px solid #cccccc;  height: 98%;  }  
</style> 

</head>
<body>
	<!-- 容器遮罩 -->
    <div id="maskContainer">
        <div class="datagrid-mask" style="display: block;"></div>
        <div class="datagrid-mask-msg" style="display: block; left: 50%; margin-left: -52.5px;">
            正在加载...
        </div>
    </div>
    
    <div id="mainLayout" class="easyui-layout hidden" data-options="fit: true">
    
        <div id="northPanel"   data-options="region: 'north', border: false" style="height: 80px; overflow: hidden;">
           
            <div id="topbar"  style="width: 100%;height:52px; background: #0092dc url('${ctx}/static/images/mosaic-pattern.png') repeat;opacity:0.8;">
            
                <div class="top-bar-left">
                    <h1 style="margin-left: 10px; margin-top: 10px;color: #fff"> <img src="${ctx}/static/images/logo.png" >TreeSoft数据库管理系统<span style="color:#00824D;font-size:14px; font-weight:bold;"> TreeDMS</span>  <span style="color: #fff;font-size:12px;">V2.2.6</span>  </h1>
                </div>
                
                <div class="top-bar-right" >
                    <div id="timerSpan"> 
                    
                     <div id="operator" style="padding:5px;height:auto">
                      <div style="padding-right:20px;height:auto">
                       
                         <c:if test="${fn:contains(permission,'synchronize')}">    
                           <div style="padding-right:20px; display:inline; cursor:pointer;">
                                 <img   src="${ctx}/static/images/btn_synchronize.gif" onclick="javascript:dataSynchronize()"  title="数据交换同步"/>
                           </div>
                         </c:if>
                         
                         <c:if test="${fn:contains(permission,'monitor')}"> 
                           <div style="padding-right:20px; display:inline; cursor:pointer;">
                                 <img   src="${ctx}/static/images/alarm.gif" onclick="javascript:monitor()"  title="状态监控"/>
                           </div> 
                         </c:if>
                         
                         <c:if test="${fn:contains(permission,'backdatabase')}">    
                         <div style="padding-right:20px; display:inline; cursor:pointer;">
                                 <img   src="${ctx}/static/images/btn_hd_backup.gif" onclick="javascript:backupDatabase()"  title="备份/还原"/>
                         </div> 
                         </c:if>
                         
                        <c:if test="${fn:contains(permission,'json')}">  
                         <div style="padding-right:20px; display:inline; cursor:pointer;">
                                 <img   src="${ctx}/static/images/btn_json.gif" onclick="javascript:jsonFormat()"  title="Json格式化"/>
                          </div> 
                         </c:if>
                         
                          <div style="padding-right:20px; display:inline; cursor:pointer;">
                                 <img   src="${ctx}/static/images/btn_hd_heart.gif" onclick="javascript:contribute()"  title="捐赠"/>
                          </div>
                          
                           
                          <c:if test="${fn:contains(permission,'config')}">  
                           <div style="padding-right:20px; display:inline; cursor:pointer;">
                                 <img   src="${ctx}/static/images/btn_hd_support.gif" onclick="javascript:ShowConfigPage()"  title="参数配置"/>
                          </div>  
                          </c:if>
                           <div style="padding-right:20px; display:inline;cursor:pointer; ">
                               <img    src="${ctx}/static/images/btn_hd_pass.gif" onclick="javascript:ShowPasswordDialog()"  title="修改用户密码"  />
                          </div>  
                          <!--  
                          <div style="padding-right:20px; display:inline;cursor:pointer;">
                             <img   src="${ctx}/static/images/btn_hd_help.gif" onclick="javascript:help()"  title="帮助"   />
                          </div>
                           -->  
                          <div style=" display:inline;cursor:pointer; ">
                             <img id="btnExit"   src="${ctx}/static/images/btn_hd_exit.gif" title="注销"   /> 
	       		          </div> 
	       		      </div> 
                      </div>
                    </div>
                    
                    <div id="themeSpan">
                        <a id="btnHideNorth" class="easyui-linkbutton" data-options="plain: true, iconCls: 'layout-button-up'"> </a>
                    </div>
                </div>
            </div>
            
            <div id="toolbar" class="panel-header panel-header-noborder top-toolbar">
                <div id="infobar">
                    <span class="icon-hamburg-user" style="padding-left: 25px; background-position: left center;">
                      ${username}，您好 
                    </span>
                </div>
               
                <div id="buttonbar">
                    <a href="javascript:void(0);"  id="btnFullScreen" class="easyui-linkbutton easyui-tooltip" title="全屏切换" data-options="plain: true, iconCls: 'icon-standard-arrow-inout'"  >全屏切换</a> 
                
                    <span>更换皮肤：</span>
                    <select id="themeSelector"></select>					
                    <a id="btnShowNorth" class="easyui-linkbutton" data-options="plain: true, iconCls: 'layout-button-down'" style="display: none;"></a>
               
                </div>
            </div>
        </div>

        <div data-options="region: 'west', title: '数据库选择', iconCls: 'icon-standard-map', split: true, minWidth: 200, maxWidth: 400" style="width: 220px; padding: 1px;">
			  
			<div id="eastLayout" class="easyui-layout" data-options="fit: true">
                <div data-options="region: 'north', split: false, border: false" style="height: 34px;">
                    <select class="combobox-f combo-f" style="width:200px;margin:5px; " id="databaseSelect"  >   </select> 
                </div>
                
                <div   data-options="region: 'center', border: false, title: '数据库', iconCls: 'icon-hamburg-database', tools: [{ iconCls: 'icon-hamburg-refresh', handler: function () {  dg.treegrid('reload'); } }]">
                       <input id="pid" name="pid" />  
                </div>
            </div>
			  
        </div>

        <div data-options="region: 'center'">
            <div id="mainTabs_tools" class="tabs-tool">
                <table>
                    <tr>
                        <td><a id="mainTabs_jumpHome" class="easyui-linkbutton easyui-tooltip" title="跳转至主页选项卡" data-options="plain: true, iconCls: 'icon-hamburg-home'"></a></td>
                        <td><div class="datagrid-btn-separator"></div></td>
						<td><a id="mainTabs_toggleAll" class="easyui-linkbutton easyui-tooltip" title="展开/折叠面板使选项卡最大化" data-options="plain: true, iconCls: 'icon-standard-arrow-out'"></a></td>
                        <td><div class="datagrid-btn-separator"></div></td>
                        <td><a id="mainTabs_refTab" class="easyui-linkbutton easyui-tooltip" title="刷新当前选中的选项卡" data-options="plain: true, iconCls: 'icon-standard-arrow-refresh'"></a></td>
                        <td><div class="datagrid-btn-separator"></div></td>
                        <td><a id="mainTabs_closeTab" class="easyui-linkbutton easyui-tooltip" title="关闭当前选中的选项卡" data-options="plain: true, iconCls: 'icon-standard-application-form-delete'"></a></td>
                    </tr>
                </table>
            </div>

            <div id="mainTabs" class="easyui-tabs" data-options="fit: true, border: false, showOption: true, enableNewTabMenu: true, tools: '#mainTabs_tools', enableJumpTabMenu: true">
                <div id="homePanel" data-options="title: '运行及展示', iconCls: 'icon-hamburg-home'">
                    
           
            <div id="eastLayout" class="easyui-layout" data-options="fit: true">
            
                <div data-options="region: 'north',split: true, border: false" style="height:280px">
                     <div id="operator"  class="panel-header panel-header-noborder  " style="padding:5px;height:auto"  >
                            <div>
	       		              <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-run" plain="true" onclick="run();">执行(F8)</a>
	       		             <span class="toolbar-item dialog-tool-separator"></span>
	        	             
	        	              <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-redo" plain="true" onclick="clearSQL()">清空(F7)</a>
	                         <span class="toolbar-item dialog-tool-separator"></span>
	                         
	                         <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-save" plain="true" onclick="saveSearchDialog()">SQL保存</a>
	                         <span class="toolbar-item dialog-tool-separator"></span>
	                         
	                         <%--<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-hamburg-drawings" plain="true" onclick="selectTheme('eclipse')">样式一</a>
	                         <span class="toolbar-item dialog-tool-separator"></span>
	                         
	                         <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-hamburg-equalizer" plain="true" onclick="selectTheme('ambiance')">样式二</a>
	                         <span class="toolbar-item dialog-tool-separator"></span>
	                        
	                         <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-hamburg-showreel" plain="true" onclick="selectTheme('erlang-dark')">样式三</a>
	                         <span class="toolbar-item dialog-tool-separator"></span>
	                         --%>
	                         
	                         <span class="l-btn-left l-btn-icon-left" style="margin-top: 4px"><span class="l-btn-text">更换样式:</span><span class="l-btn-icon icon-hamburg-drawings">&nbsp;</span></span>
										<select id="codeThemeSelector" onchange="selectTheme()"
											style="margin-top: 4px">
											<option selected>
												default
											</option>
											<option>
												3024-day
											</option>
											<option>
												3024-night
											</option>
											<option>
												abcdef
											</option>
											<option>
												ambiance
											</option>
											<option>
												base16-dark
											</option>
											<option>
												base16-light
											</option>
											<option>
												bespin
											</option>
											<option>
												blackboard
											</option>
											<option>
												cobalt
											</option>
											<option>
												colorforth
											</option>
											<option>
												dracula
											</option>
											<option>
												eclipse
											</option>
											<option>
												elegant
											</option>
											<option>
												erlang-dark
											</option>
											<option>
												hopscotch
											</option>
											<option>
												icecoder
											</option>
											<option>
												isotope
											</option>
											<option>
												lesser-dark
											</option>
											<option>
												liquibyte
											</option>
											<option>
												material
											</option>
											<option>
												mbo
											</option>
											<option>
												mdn-like
											</option>
											<option>
												midnight
											</option>
											<option>
												monokai
											</option>
											<option>
												neat
											</option>
											<option>
												neo
											</option>
											<option>
												night
											</option>
											<option>
												paraiso-dark
											</option>
											<option>
												paraiso-light
											</option>
											<option>
												pastel-on-dark
											</option>
											<option>
												railscasts
											</option>
											<option>
												rubyblue
											</option>
											<option>
												seti
											</option>
											<option>
												solarized dark
											</option>
											<option>
												solarized light
											</option>
											<option>
												the-matrix
											</option>
											<option>
												tomorrow-night-bright
											</option>
											<option>
												tomorrow-night-eighties
											</option>
											<option>
												ttcn
											</option>
											<option>
												twilight
											</option>
											<option>
												vibrant-ink
											</option>
											<option>
												xq-dark
											</option>
											<option>
												xq-light
											</option>
											<option>
												yeti
											</option>
											<option>
												zenburn
											</option>
										</select>

										<%--
	                         <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="format()">SQL输入提示</a>
	                         <span class="toolbar-item dialog-tool-separator"></span>
                            --%>
                            <span class="toolbar-item dialog-tool-separator"></span>
                              <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-tip" plain="true" title="F8   执行SQL语句 &#13;F7   清空SQL语句 &#13;可选中部分SQL执行 &#13;注释请以;分号结束"></a>
                            </div> 
                       </div>
		                <div  style="width:100%;height:85%; " >
		                   
		                    <input type="hidden" id="searchHistoryId">
		                    <input type="hidden" id="searchHistoryName">
		                      <textarea  id="sqltextarea" style="margin:10px; font-size:14px;font-family: '微软雅黑';width:97%;height:95%; "> </textarea>
	                    </div>
                </div>
                
                <div  id="searchHistoryPanel"   data-options="region: 'center',split: true, collapsed: false,   border: false, title: '运行结果', iconCls: 'icon-standard-application-view-icons'  ">
                    
                     <div id="searchTabs" class="easyui-tabs" data-options="fit: true, border: false, showOption: true, enableNewTabMenu: true, enableJumpTabMenu: true">
                        <div id="searcHomePanel" data-options="title: '消息', iconCls: 'icon-hamburg-issue'">
                            
                            <textarea  id="executeMessage" style="margin:10px; font-size:14px;font-family: '微软雅黑';width:97%;height:95%; " readonly >   </textarea>
                           
                        </div>
                    </div>
                       
                </div>
            
            </div>

                </div>
            </div>
        </div>
        
        <div data-options="region: 'east', title: '常用SQL', iconCls: 'icon-standard-book', split: true,collapsed: true, minWidth: 160, maxWidth: 500" style="width: 220px;">
            <div id="eastLayout" class="easyui-layout" data-options="fit: true">
               
                <div data-options="region: 'north', split: true, border: false" style="height: 220px;">
                     <input id="sqlStudyList"   />  
                </div>
                
                <div id="searchHistoryPanel" data-options="region: 'center', split: true,  border: false, title: '我的SQL', iconCls: 'icon-standard-book-key', tools: [{ iconCls: 'icon-hamburg-refresh', handler: function () {  searchBG.treegrid('reload'); } }]">
                       <input id="searchHistoryList"   />  
                </div>
            </div>
        </div>

        <div data-options="region: 'south', title: '关于...', iconCls: 'icon-standard-information', collapsed: true, border: false" style="height: 70px;">
            <div style="color: #4e5766; padding: 6px 0px 0px 0px; margin: 0px auto; text-align: center; font-size:12px; font-family:微软雅黑;">
                <img src="http://www.treesoft.cn/picture/logo.png"  onerror="imgerror(this)" >TreeSoft<sup>®</sup>&nbsp;CopyRight@2018 福州青格软件 版权所有  <a href="http://www.treesoft.cn" target="_blank" style="text-decoration:none;" > www.treesoft.cn </a> &nbsp;&nbsp; 本软件禁止第三方企业或个人修改源码后再发布, Email:treesoft@qq.com
                &nbsp; 
            </div>
            
        </div>
    </div>
  
  <div id='tb3' style='padding:5px;height:auto'>    
    <div  >    
        <a href='#' class='easyui-linkbutton' iconCls='icon-add' plain='true'></a>    
        <a href='#' class='easyui-linkbutton' iconCls='icon-edit' plain='true'></a>           
    </div>  
</div> 
  
<div id="dlgg"   ></div>  
<div id="addRow" ></div> 
<input type="hidden" id="currentTableName" >

<div id="databaseMenu" class="easyui-menu" style="width:120px;">
        <div onclick="backupDatabase()" data-options="iconCls:'icon-table-save'">备份数据库</div>
		<div onclick="dropDatabase()" data-options="iconCls:'icon-table-delete'">删除数据库</div>
		<div class="menu-sep"></div>
		<div onclick="" data-options="iconCls:'icon-table-gear'">数据库属性</div>
</div>


<div id="tableMenu" class="easyui-menu" style="width:120px;">
        <div onclick="clickTable(tableName )" data-options="iconCls:'icon-table-edit'">打开表</div>
		<div onclick="designTable()" data-options="iconCls:'icon-table-gear'">设计表</div>
		<div onclick="addNewTable()" data-options="iconCls:'icon-table-add'">新增表</div>
		<div onclick="exportTable()" data-options="iconCls:'icon-table-go'">导出表</div>
		<div onclick="copyTable()" data-options="iconCls:'icon-table-lightning'">复制表</div>
		<div onclick="renameTable()" data-options="iconCls:'icon-table-relationship'">重命名</div>
		<div class="menu-sep"></div>
		<div onclick="dropTable()" data-options="iconCls:'icon-table-delete'">删除表</div>
		<div onclick="clearTable()" data-options="iconCls:'icon-table-row-delete'" >清空表</div>
		<div onclick="tableMess()" data-options="iconCls:'icon-table-gear'">表信息</div>
</div>

<div id="viewMenu" class="easyui-menu" style="width:120px;">
        <div onclick="openView(tableName)" data-options="iconCls:'icon-search'">打开视图</div>
		<div onclick="showViewSQL(databaseName,tableName)" data-options="iconCls:'icon-edit'">设计视图</div>
		<div class="menu-sep"></div>
		<div onclick="" data-options="iconCls:'icon-tip'">视图信息</div>
</div>

<iframe id="exeframe" name="exeframe" style="display:none"> </iframe>
<form id="form1" method="post" target="exeframe" action="${ctx}/system/permission/i/exportExcel"   accept-charset="utf-8" onsubmit="document.charset='utf-8'" >
   <input type="hidden" id="sContent" name="sContent" value=""/>
</form>

<form id="form3" method="post"  action="${ctx}/system/permission/i/exportDataToSQLFromSQL"  style="display:none"   >
   <input type="hidden" id="databaseConfigId"    name="databaseConfigId"  >
   <input type="hidden" id="databaseName" name="databaseName"   >
   <input type="hidden" id="sql"    name="sql"  >
   <input type="hidden" id="exportType" name="exportType"  >
   
</form>

<script>
  
var dg;
var d;
var pwd;
var config;
var tableName;
var type;
var rowtype;
var colums ="";
var searchBG
var databaseName;
var add;
var primary_key;
var saveSearch;

var selectRowCount = 0;
var heightStr=300;  //新增 ，编辑 对话框的高度。
 var sqlArray = new Array();

var columnsTemp = new Array();
var index =0; 
var messTemp ="";
var isAdd = false;
var databaseConfigId;


//树右键菜单 使用临时变量。
//var tempTableName = "";

 function imgerror(img){
    img.src="${ctx}/static/images/logo.png";
    img.onerror=null;   
 }
   
 //左侧菜单
  $(function(){
	initSqlStudyTree();
	init3();
  });
 
 function init3(){
   $.ajax({
		type:'get',
		url:"${ctx}/system/permission/i/allDatabaseList",
		success: function(data){
			 $("#databaseSelect").empty();
			 $.each( data, function(index,value){
				 //$("#databaseSelect").append("<option value='"+data[index].SCHEMA_NAME+"'>"+ data[index].SCHEMA_NAME +" </option>");
				 $("#databaseSelect").append("<option value='"+data[index].id+"' title='"+data[index].name+"'   >"+"【"+  data[index].databaseType +"】"+data[index].ip +":"+data[index].port +"/"+data[index].databaseName+ " </option>");
			 });
			 databaseName = data[0].databaseName ;
		   initDataBase();
		} 
		
	});
 }
  
 
 //更改当前 数据库
 $("#databaseSelect").change(function(){
     databaseConfigId =  $('#databaseSelect').val();
	 initDataBase();
	 //清空操作的提示信息
	 $("#executeMessage").val("");
	 executeMessage.setValue("");
	 sql_autocomplete = false;
	 getDataBaseConfig();
  })
  
  //取得数据库配置信息,设定默认数据库
  function getDataBaseConfig(){
	 $.ajax({
		type:'get',
		url:"${ctx}/system/permission/i/getDataBaseConfig/"+databaseConfigId,
		success: function(data){
			databaseName= data.databaseName;
		}
     });
  }
  
  //左侧菜单 库表 展示
 function initDataBase(){
	
	//databaseName =  $('#databaseSelect').val();
	databaseConfigId =  $('#databaseSelect').val();
	dg=$('#pid').treegrid({
	method: "GET",
    url:"${ctx}/system/permission/i/databaseList/"+databaseConfigId,
    fit : true,
	fitColumns : true,
	border : false,
	idField : 'id',
	treeField:'name',
	parentField : 'pid',
	iconCls: 'icon',
	animate:true, 
	rownumbers:false,
	singleSelect:true,
	striped:true,
    columns:[[    
        {field:'name',title:'&nbsp;&nbsp;详情',width:210}
    ]],
    enableHeaderClickMenu: false,
    enableHeaderContextMenu: false,
    enableRowContextMenu: false,
    onContextMenu: onContextMenu,
    dataPlain: false,
    onClickRow:function(rowData){
    	 tableName =rowData.name;
    	 type = rowData.type;
    	 
    	 columnsTemp.length = 0;
    	 $('#searchHistoryId').val('');
    	 $('#searchHistoryName').val('');
    	 
    	 var rootNode = $('#pid').treegrid('getRoot', rowData.id );
    	 var dbName = rootNode.name;
    	 
    	 if( type == 'db'){
    		dbName = rowData.name;
    		databaseName = rowData.name
    	 }
    	 
    	 if( type == 'direct'){
    		var parent = $("#pid").treegrid("getParent", rowData.id );
    		dbName = parent.name;
    		databaseName = parent.name;
    	 }
    	
    	//表
    	if( type == 'table'){
    		var parent2 = $("#pid").treegrid("getParent", rowData.id );
    		var parent3 = $("#pid").treegrid("getParent", parent2.id );
    		dbName = parent3.name;
    		databaseName = dbName;
    		//alert( dbName );
    		selectRowCount = 0;
    	//	getTableColumns( tableName ,dbName );
    	    $("#currentTableName").val(tableName );
    	     
    		//showSQL( tableName ,dbName );
    		clickTable( tableName );
    	}
    	
    	//视图
    	if( type =='view'){
    		selectRowCount = 0;
    		//getTableColumns( tableName ,dbName );
    		//showViewSQL(  dbName, tableName )
    		openView(tableName)
    	}
    }
  });
 }
 
 //设计表结构
   function designTable(){  
	   parent.window.mainpage.mainTabs.addModule( "设计"+tableName+" @"+databaseName ,'${ctx}/system/permission/i/designTable/'+tableName+'/'+databaseName +'/'+ databaseConfigId,'icon-hamburg-config');
   }
   
 
 //新增表
   function addNewTable(){  
	   parent.window.mainpage.mainTabs.addModule( "新增表" ,'${ctx}/system/permission/i/addNewTable/'+databaseName+'/'+ databaseConfigId,'icon-hamburg-config');
   }
 
 //导出表
   function exportTable(){  
	  $.easyui.loading({ msg: "导出中，请稍等！" });
	 // parent.$.messager.show({ title : "提示",msg: "导出中，请稍等！" , position: "bottomRight" });
     // databaseName = $("#databaseSelect",window.parent.document).val();
	  $.ajax({
			        type:'POST',
		          	contentType:'application/json;charset=utf-8',
                    url:"${ctx}/system/permission/i/exportTable/"+ databaseConfigId ,
                    data: JSON.stringify( { 'databaseName':databaseName ,'tableName':tableName  } ),
                    datatype: "json", 
                   //成功返回之后调用的函数             
                    success:function(data){
                       var status = data.status ;
                       $.easyui.loaded();
            	       if(status == 'success' ){
            	            parent.$.messager.show({ title : "提示",msg: data.mess , position: "bottomRight" });
            	            window.mainpage.mainTabs.addModule( '备份/导出' ,'${ctx}/system/permission/i/backupDatabase/'+databaseName +'/'+databaseConfigId ,'icon-berlin-calendar');
            	           // window.setTimeout(function () { $('#dg3').datagrid('reload'); }, 1000);
            	            $('#dg3').datagrid('reload')
            	       }else{
            	    	    parent.$.messager.show({ title : "提示",msg: data.mess , position: "bottomRight" });
            	       }
            	     }  
       });
   }
   
   //复制表
   function copyTable(){  
	  $.easyui.loading({ msg: "复制中，请稍等！" });
     // databaseName = $("#databaseSelect",window.parent.document).val();
	  $.ajax({
			        type:'POST',
		          	contentType:'application/json;charset=utf-8',
                    url:"${ctx}/system/permission/i/copyTable/"+ databaseConfigId ,
                    data: JSON.stringify( { 'databaseName':databaseName ,'tableName':tableName  } ),
                    datatype: "json", 
                   //成功返回之后调用的函数             
                    success:function(data){
                       var status = data.status ;
                       $.easyui.loaded();
            	       if(status == 'success' ){
            	            parent.$.messager.show({ title : "提示",msg: data.mess , position: "bottomRight" });
            	           $('#pid').treegrid('reload');
            	       }else{
            	    	    parent.$.messager.show({ title : "提示",msg: data.mess , position: "bottomRight" });
            	       }
            	     }  
       });
   }
 
   
   // 表重命名
   function renameTable(){ 
	 $.easyui.messager.prompt("提示", "新表名 :", function (c) {
      if (c) {
	      $.easyui.loading({ msg: "操作中，请稍等！" });
	      $.ajax({
			        type:'POST',
		          	contentType:'application/json;charset=utf-8',
                    url:"${ctx}/system/permission/i/renameTable/"+ databaseConfigId ,
                    data: JSON.stringify( { 'databaseName':databaseName ,'tableName':tableName,'newTableName':c  } ),
                    datatype: "json", 
                   //成功返回之后调用的函数             
                    success:function(data){
                       var status = data.status ;
                       $.easyui.loaded();
            	       if(status == 'success' ){
            	            parent.$.messager.show({ title : "提示",msg: data.mess , position: "bottomRight" });
            	           $('#pid').treegrid('reload');
            	       }else{
            	    	    parent.$.messager.show({ title : "提示",msg: data.mess , position: "bottomRight" });
            	       }
            	     }  
             });
       }
     });
  }  
   //删除表
 function dropTable( ){
	  $.easyui.messager.confirm("操作提醒", "您确定要删除表 "+tableName+"吗？", function (c) {
                if (c) {
                   $.ajax({
			        type:'POST',
		          	contentType:'application/json;charset=utf-8',
                    url:"${ctx}/system/permission/i/dropTable/"+databaseConfigId ,
                    data: JSON.stringify({ 'databaseName':databaseName ,'tableName':tableName } ),
                    datatype: "json", 
                   //成功返回之后调用的函数             
                    success:function(data){
            	      $('#pid').treegrid('reload');
            	      parent.$.messager.show({ title : "提示",msg: data.mess, position: "bottomRight" });
                    }  
                   });
                }
            });
   }
    
   //删除数据库
 function dropDatabase( ){
	  $.easyui.messager.confirm("操作提醒", "您确定要删除数据库 "+ databaseName +" 吗？", function (c) {
                if (c) {
                   $.ajax({
			        type:'POST',
		          	contentType:'application/json;charset=utf-8',
                    url:"${ctx}/system/permission/i/dropDatabase/"+databaseConfigId ,
                    data: JSON.stringify({ 'databaseName':databaseName } ),
                    datatype: "json", 
                   //成功返回之后调用的函数             
                    success:function(data){
            	      $('#pid').treegrid('reload');
            	      parent.$.messager.show({ title : "提示",msg: data.mess, position: "bottomRight" });
                    }  
                   });
                }
            });
   }
   
   //清空表
 function clearTable( ){
	  $.easyui.messager.confirm("操作提醒", "您确定要清空表 "+tableName+"吗？", function (c) {
                if (c) {
                   $.ajax({
			        type:'POST',
		          	contentType:'application/json;charset=utf-8',
                    url:"${ctx}/system/permission/i/clearTable/"+ databaseConfigId ,
                    data: JSON.stringify({ 'databaseName':databaseName ,'tableName':tableName } ),
                    datatype: "json", 
                   //成功返回之后调用的函数             
                    success:function(data){
            	     
            	      parent.$.messager.show({ title : "提示",msg: data.mess, position: "bottomRight" });
                    }  
                   });
                }
            });
   }
 
   //表信息
 function tableMess(){
	  window.mainpage.mainTabs.addModule( tableName+'信息' ,'${ctx}/system/permission/i/showTableMess/'+tableName+'/'+databaseName+'/'+databaseConfigId,'icon-berlin-calendar');
 }
    
  function onContextMenu(e,rowData){
		e.preventDefault();
		$(this).treegrid('select', rowData.id);
		var  tableName2 = rowData.name;
    	var  type = rowData.type;
    	    
		if( type == 'db'){
    		databaseName = rowData.name
    		$('#databaseMenu').menu('show',{
			left: e.pageX,
			top: e.pageY
		    });
    	}
		if( type == 'direct'){
    		var parent = $("#pid").treegrid("getParent", rowData.id );    		 
    		databaseName = parent.name;
    	 }
		
		if( type=='table'){
			$('#tableMenu').menu('show',{
			left: e.pageX,
			top: e.pageY
		    });
		   tableName = tableName2;
		   var parent2 = $("#pid").treegrid("getParent", rowData.id );
    	   var parent3 = $("#pid").treegrid("getParent", parent2.id );
    	   databaseName = parent3.name;
	    }
			
		if( type=='view'){
		    $('#viewMenu').menu('show',{
		  	left: e.pageX,
			top: e.pageY
		    });
		   tableName = tableName2;
		   var parent2 = $("#pid").treegrid("getParent", rowData.id );
    	   var parent3 = $("#pid").treegrid("getParent", parent2.id );
    	   databaseName = parent3.name;
		}
  }
 
 function initSqlStudyTree(){
	 
    $('#sqlStudyList').treegrid({
	method: "GET",
    url:"${ctx}/system/permission/i/selectSqlStudy" ,
    fit : true,
	fitColumns : true,
	border : false,
	idField : 'id',
	treeField:'title',
	parentField : 'pid',
	iconCls: 'icon',
	animate:true, 
	rownumbers:false,
	singleSelect:true,
	striped:true,
    columns:[[    
        {field:'title',title:'&nbsp;&nbsp;详情',width:210}
    ]],
    enableHeaderClickMenu: false,
    enableHeaderContextMenu: false,
    enableRowContextMenu: true,
   
    dataPlain: false,
    onClickRow:function(rowData){
    	 $("#mainTabs").tabs("select", 0 ); //TAB切换到第一项
    	 var content =rowData.content;
    	 var str =  $('#sqltextarea').val();
	     $('#sqltextarea').val( str +'\n'+  content);
    	  editor.setValue(  str +'\n'+  content );
    	 $('#searchHistoryId').val('');
    	 $('#searchHistoryName').val('');
    }
  });
 }
 
 function  clickTable( tableName ){
	 window.mainpage.mainTabs.addModule( tableName+' @'+databaseName ,'${ctx}/system/permission/i/showTableData/'+tableName+'/'+databaseName+'/'+databaseConfigId +'/table','icon-berlin-calendar');
 }
 
 function  openView( tableName ){
	 window.mainpage.mainTabs.addModule( tableName+' @'+databaseName ,'${ctx}/system/permission/i/showTableData/'+tableName+'/'+databaseName+'/'+databaseConfigId +'/view','icon-berlin-calendar');
 }
 
 function  jsonFormat( ){
	 window.mainpage.mainTabs.addModule( 'Json格式化' ,'${ctx}/system/permission/i/jsonFormat','icon-berlin-calendar');
 }
 
 //库备份
  function  backupDatabase(){
	 window.mainpage.mainTabs.addModule( '备份' ,'${ctx}/system/permission/i/backupDatabase/'+databaseName+'/'+databaseConfigId ,'icon-berlin-database');
 }
 
 // 数据库配置 列表
  function  ShowConfigPage(){
	 window.mainpage.mainTabs.addModule( '数据库配置' ,'${ctx}/system/permission/i/config','icon-berlin-calendar');
 }
 
  //状态监控
  function  monitor(){
	 window.mainpage.mainTabs.addModule( '状态监控' ,'${ctx}/system/permission/i/monitor/'+databaseName +'/'+databaseConfigId,'icon-berlin-current-work');
 }
  
  //数据交换
  function  dataSynchronize(){
	 window.mainpage.mainTabs.addModule( '数据交换' ,'${ctx}/system/permission/i/dataSynchronize/','icon-berlin-current-work');
 }
 
 // 整理成SQL ,  SQL提交到后台， 返回的DATA在列表中展示。
 //在命令编辑区，显示SQL
 function showSQL( tableName , dbName ){
	 var sql = "select * from "+tableName +";";
	 var str =  editor.getValue();
	 $('#sqltextarea').val( str +'\n'+  sql);	 
	  editor.setValue(  str +'\n'+  sql );
	 
	  //setTimeout(function(){
      //   editor.refresh();
      //   editor.focus();
      // },600);
	  	  
	   //清空操作的提示信息
	 $("#executeMessage").html("");
	  executeMessage.setValue("");
 }
 
 //显示视图 的SQL
 function  showViewSQL(  dbName, tableName ){
	  $("#mainTabs").tabs("select", 0 ); //TAB切换到第一项
	  $.ajax({
			type:'POST',
		   	contentType:'application/json;charset=utf-8',
            url:"${ctx}/system/permission/i/getViewSql/"+ databaseConfigId,
            data: JSON.stringify({ 'databaseName':dbName ,'tableName':tableName } ),
            datatype: "json", 
            //成功返回之后调用的函数             
            success:function(data){
            	var status = data.status ;
            	if(status == 'success' ){
            	  //  d.datagrid('reload');
            	    selectRowCount = 0;
            	    //$('#sqltextarea').val( data.viewSql ); 
            	    
            	    var str =  $('#sqltextarea').val();
	                $('#sqltextarea').val( str +'\n'+  data.viewSql);
	                editor.setValue(  str +'\n'+  data.viewSql );
            	    
            	}else{
            	     parent.$.messager.show({ title : "提示",msg: data.mess, position: "bottomRight" });
            	}
            }  
     });
	 
 }
 
 //判断 执行的SQL是什么 类型，有没返回 结果集。
 function run(){
     var sql = $.trim( editor.getValue() );
     var selectSql =  editor.getSelection();
     if (selectSql != '') {
         sql = selectSql;
     }
	 
	 var sqlArray = new Array();
	 
	 messTemp ="";
	 
	 if(sql==""||sql==null ){
		 parent.$.messager.show({ title : "提示", msg: "亲，请输入SQL语句！" });
		 return;
	 }
	 if( databaseName==""|| databaseName==null ){
		 parent.$.messager.show({ title : "提示", msg: "亲，请点击左侧指定数据库！" });
		 return;
	 }
	 
	 var arry = new Array();
	 
	 var tempSql2 = sql.replace(' ','');
	 if( tempSql2.indexOf("createfunction")==0 || tempSql2.indexOf("CREATEFUNCTION")==0 || tempSql2.indexOf("createprocedure")== 0 || tempSql2.indexOf("CREATEPROCEDURE")== 0 || tempSql2.indexOf("DELIMITER")== 0 ){
		 arry.push( sql  );
		 
	 }else{
		 arry = sql.split(";");//以换行符为分隔符将内容分割成数组
	 }
	 
	 var tempStr;
	 var isDanger;
	 for (var i = 0; i < arry.length; i++) {  
		 tempStr = $.trim( arry[i] );
       
        //判断注释的行 
        if( tempStr.indexOf("--")==0  ){
        	continue;
        }
        if( tempStr.indexOf("/*")==0  ){
        	continue;
        }
        if( tempStr == "" || tempStr == null ){
        	continue;
        }
        
        if( tempStr.indexOf("update ") >=0 || tempStr.indexOf("UPDATE ") >=0 || tempStr.indexOf("delete ") >=0 || tempStr.indexOf("DELETE ") >=0 || tempStr.indexOf("drop ") >=0 || tempStr.indexOf("DROP ") >=0 || tempStr.indexOf("truncate ") >=0 ){
        	isDanger=true;
        }
        
        sqlArray.push( tempStr );
     }   
  
  //caution 操作警示
  var cautionValue = $.cookie("noCaution");
   // alert( cautionValue );
  if( cautionValue ){
    //操作不警示  
    isDanger =false;
  }
	 
  if ( isDanger ) {
     $.easyui.messager.defaults ={ ok:"确认",cancel:"不再提示"  }; 
	 $.easyui.messager.confirm("操作提醒", "SQL语句中包含update、delete、drop等操作，您确定执行吗？", function (c) {
	 
	// alert(c );
	   if (c) {
	      //支持多行SQL执行，每行用分号 结束 
	     // var tempSql;
	     // var selectCount=1;
	      window.mainpage.searchTabs.closeAllTabs();
	      executeSQLArray( sqlArray , index );
	   }else{
	     //操作不警示
	     $.cookie("noCaution", true, { expires: 30,path:"/"}); 
	   }
	  });
	  
	  $.easyui.messager.defaults ={ ok:"确认",cancel:"取消"  }; 
	  
    }else{
          window.mainpage.searchTabs.closeAllTabs();
	      executeSQLArray( sqlArray , index );
    }
 }
 
   //searchVersion();
  
   //打开 保存 查询 对话框
   function saveSearchDialog(){
	    saveSearch = $("#dlgg").dialog({   
	    title: '保存查询',    
	    width: 380,    
	    height: 160,    
	    href:'${ctx}/system/permission/i/searchHistory',
	    maximizable:true,
	    modal:true,
	    buttons:[ 
	    	{
			text:'保存',
			iconCls:'icon-ok',
			handler:function(){
	    		saveSearchHistory2();
				//$("#mainform").submit(); 
			}
		},{
			text:'取消',
			iconCls:'icon-cancel',
			handler:function(){
				saveSearch.panel('close');
			 }
		}]
	});
  }
 
 
 //删除 查询条件
 function deleteSearchHistory( id ){
	  $.easyui.messager.confirm("操作提醒", "您确定要删除？", function (c) {
                if (c) {
                   $.ajax({
			        type:'POST',
		          	contentType:'application/json;charset=utf-8',
                    url:"${ctx}/system/permission/i/deleteSearchHistory",
                    data: JSON.stringify({'id':id } ),
                    datatype: "json", 
                   //成功返回之后调用的函数             
                    success:function(data){
            	      searchBG.treegrid('reload');
            	      parent.$.messager.show({ title : "提示",msg: data.mess, position: "bottomRight" });
                    }  
                   });
                }
            });
   }
 
   selectSearchHistory2();
 
 //右侧 查询历史框数据。
 function selectSearchHistory2(){
	//alert("selectSearchHistory2");
	searchBG=$('#searchHistoryList').treegrid({
	method: "GET",
    url:"${ctx}/system/permission/i/selectSearchHistory",
    fit : true,
	fitColumns : true,
	border : false,
	idField : 'id',
	treeField:'name',
	parentField : 'pid',
	iconCls: 'icon',
	animate:true, 
	rownumbers:false,
	singleSelect:true,
	striped:true,
    columns:[[    
        {field:'sqls',title:'sqls',hidden:true,width:0}, 
        {field:'database',title:'database',hidden:true,width:0},
        {field:'name',title:'&nbsp;&nbsp;详情',width:210},
        {field:'_opt',title:'&nbsp;操作',width: 30,
           formatter : function(value, row, index) {
               return '<a href="javascript:deleteSearchHistory('+row.id+')"><div class="icon-remove" style="width:16px;height:16px" title="delete"></div></a>';
           }
        }
    ]],
    enableHeaderClickMenu: false,
    enableHeaderContextMenu: false,
    enableRowContextMenu: false,
   
    dataPlain: false,
    onClickRow:function(rowData){
    	 var str =  editor.getValue();
    	 editor.setValue(  str +'\n'+  rowData.sqls  );
    	 $('#searchHistoryId').val( rowData.id  );
    	 $('#searchHistoryName').val( rowData.name  ); 
    	 
    	 var database = rowData.database;
    	 
    	 //if( database!=null && database!='' ){
    		//var count = $('#databaseSelect').find('option').length;
    		//for(var i=0;i<count ;i++){
    		//	if( $('#databaseSelect').get(0).options[i].value == database ){
    		//		   $('#databaseSelect').val( database  );
    		//		   initDataBase();
    		//		   break;
    		//	}
    		//}
    	 //}
     }
  });
 }
  
 
 function  ShowPasswordDialog(){
	  pwd = $("#dlgg").dialog({   
	    title: '修改密码',    
	    width: 380,    
	    height: 160,    
	    href:'${ctx}/system/permission/i/changePass',
	    maximizable:true,
	    modal:true,
	    //openAnimation:'fade',
	    //closeAnimation:'slide',
	    //closeDuration:900,
	    buttons:[ 
	    	{
			text:'保存',
			iconCls:'icon-ok',
			handler:function(){
	    		changePass();				 
			}
		},{
			text:'取消',
			iconCls:'icon-cancel',
			handler:function(){
					pwd.panel('close');
				}
		}]
	});
	 
 }
   
   function refresh(){
	    d.datagrid('reload');
   }
   
   function exportExcel4() {
	 
	   var rows = $('#dg').datagrid("getRows");
       if (rows.length == 0) {
       
        parent.$.messager.show({ title : "提示",msg: "没有数据可供导出！", position: "bottomRight" });
		return;
       }

       //定制DataGrid的columns信息,只返回{field:,title:}
       var columns = new Array();
       var fields = $('#dg').datagrid('getColumnFields');
       for (var i = 0; i < fields.length; i++) {
          var opts = $('#dg').datagrid('getColumnOption', fields[i]);
          var column = new Object();
          column.field = opts.field;
          column.title = opts.title;
          columns.push(column);
        }
       var excelWorkSheet = new Object();
       excelWorkSheet.rows = rows;
       excelWorkSheet.columns = columns;
       excelWorkSheet.sheetName = "TreeSoft Export data to Excel";
       
       $('#sContent').val( JSON.stringify(excelWorkSheet)  );
       $('#form1').submit();
   }
  
  function clearSQL(){
	   $('#sqltextarea').val("");
	   $('#executeMessage').val("");
	   $('#searchHistoryId').val("");
	   $('#searchHistoryName').val("");
	   editor.setValue("");
	   executeMessage.setValue("");
  }
     
  function contribute(){
	   
	    $("#addRow").dialog({   
	    title: "捐赠",    
	    width: 480,    
	    height: 500,  
	    href:"${ctx}/system/permission/i/contribute" ,
	    maximizable:true,
	    modal:true,
	    buttons:[ 	    	 
		 {
			text:'关闭',
			iconCls:'icon-cancel',
			handler:function(){
			 	$("#addRow").panel('close');
			}
		}]
	});
	  
  }
  
   //用户信息
   function  persons(){
	 window.mainpage.mainTabs.addModule( '用户信息' ,'${ctx}/system/permission/i/person' ,'icon-hamburg-user');
   }
  
   function help(){
	  $("#addRow").dialog({   
	    title: "帮助",    
	    width: 500,    
	    height: 600,  
	    href:"${ctx}/system/permission/i/help" ,
	    maximizable:true,
	    modal:true,
	    buttons:[ 	    	 
		 {
			text:'关闭',
			iconCls:'icon-cancel',
			handler:function(){
			    $("#addRow").panel('close');
			}
		}]
	});
  }
   
    var sql_autocomplete_in_progress = false;
    var sql_autocomplete = false;
    
    var editor = CodeMirror.fromTextArea(document.getElementById('sqltextarea'), {
    	 lineNumbers: true,
         matchBrackets: true,         
         hintOptions: {
    	     "completeSingle": false,
    	     "completeOnSingleClick": true},
         indentUnit: 4,
         mode: "text/x-mysql",
         lineWrapping: true,
         theme: "eclipse", //主题  
         autofocus: true,
         extraKeys: {
    	       "ctrl": "autocomplete",
               "F7":function(){
                	clearSQL();
                },
               "F8":function(){
                	 run();
                }
         },   
      });
      editor.on("inputRead", codemirrorAutocompleteOnInputRead);
      editor.refresh();
      editor.focus();
      $(editor.getWrapperElement()).bind(
         'keydown',catchKeypressesFromSqlTextboxes
      );
          
    function codemirrorAutocompleteOnInputRead(instance) {
       if (!sql_autocomplete_in_progress
        && (!instance.options.hintOptions.tables || !sql_autocomplete)) {

        if (!sql_autocomplete) {
            // Reset after teardown
           // instance.options.hintOptions.tables = false;
            instance.options.hintOptions.defaultTable = '';

            sql_autocomplete_in_progress = true;
             
            $.ajax({
                type: 'GET',
                url : "${ctx}/system/permission/i/allTableAndColumn/"+databaseName +"/"+ databaseConfigId ,
                success: function (data) {
                     sql_autocomplete = [];
                     instance.options.hintOptions.tables =  data  ;
                },
                complete: function () {
                    sql_autocomplete_in_progress = false;
                }
            });
        }else {
            instance.options.hintOptions.tables = sql_autocomplete;
            instance.options.hintOptions.defaultTable = sql_autocomplete_default_table;
        }
      }
      if (instance.state.completionActive) {
          return;
      }
      var cur = instance.getCursor();
      var token = instance.getTokenAt(cur);
      var string = '';
      if (token.string.match(/^[.`\w@]\w*$/)) {
        string = token.string;
      }
      if (string.length > 0) {
        CodeMirror.commands.autocomplete(instance);
      }
   }
      
    function catchKeypressesFromSqlTextboxes(event) {
    // ctrl-enter is 10 in chrome and ie, but 13 in ff
       if (event.ctrlKey && (event.keyCode == 13 || event.keyCode == 10)) {
        if ($('#sqltextarea').length > 0) {
           // $("#sql_query_edit_save").trigger('click');
        } else if ($('#sqltextarea').length > 0) {
        //    $("#button_submit_query").trigger('click');
                run();
        }
      }
    }
   
    var executeMessage = CodeMirror.fromTextArea(document.getElementById('executeMessage'), {
      mode: "text/x-mysql",
      theme: "eclipse", //主题 
    
     lineNumbers: true,
     autofocus: false,
     readOnly :true
   });
     
    
   function selectTheme( theme ) {
      editor.setOption("theme", theme);
      executeMessage.setOption("theme", theme);
   }
 
  function selectTheme() {
    var input = document.getElementById("codeThemeSelector");
    var theme = input.options[input.selectedIndex].textContent;
    editor.setOption("theme", theme);
    executeMessage.setOption("theme", theme);
  }
   
   //执行多行SQL时,需要顺序动态生成多个结果TAB页面
   //1 将SQL分组
   //2 AJAX请求一行SQL数据,
   //3 动态生成TAB,动态生成datagrid,将数据赋给datagrid.
   //4 AJAX执行成功后,递归调用方法自己,执行下一名SQL
   //5 动态生成TAB,动态生成datagrid,将数据赋给datagrid.
   //6 直到处理完 全部的SQL.
 var executeSQLArray = function( sqlArray , index ){
	 if(index >= sqlArray.length) {
		
		 parent.$.messager.show({ title : "提示",msg: "执行完成！", position: "bottomRight" });
		//$("#searchTabs").tabs("select", 0 ); //TAB切换到第一项
		executeMessage.setValue( messTemp ); //显示执行后的信息
		return;
     }
	 
	 var sql = sqlArray[index] ;
	   
	 $.ajax({
		type:'post',
		timeout:3600000 ,
		url : "${ctx}/system/permission/i/executeSqlTest/"+databaseConfigId,
		data:{'sql':sql,'databaseName':databaseName},
		success: function(data){
			//var messTemp = executeMessage.getValue() ;
			var status = data.status ;
			if( data.status== null ){
				// alert(data);
				messTemp = messTemp + data +' \n\n'; 
			}else if(status == 'success' ){
            	//写执行的结果,时间 信息
            	messTemp = messTemp + '【命令】 '+sql+ '\n 影响 '+data.totalCount +' 行， \n 运行时间：'+data.time+'毫秒。\n\n' ;
                
            	if( data.rows != null){
            	   showResultTabGrid(data,sql , index );
            	}
            }else{
            	messTemp = messTemp + '【命令】 '+sql+  "\n 信息："+data.mess  +' \n\n';
            }
			//递归调用 自己 .
			executeSQLArray( sqlArray , index+1 );
		}
	 });
 }
   
 var obj ;
 var willChangeRow = new Array();

 //处理返回结果，并显示数据表格  
function showResultTabGrid( data,sql ,index ) {  
    var tableTempId = "selectDg"+index;
	
    if (data.rows.length == 0) {  
       // $.messager.alert("结果", "没有数据!", "info", null);  
    }else{
    	// alert( data.primaryKey  );
    }  
		   
    var toolbarHtml =' <div id="tb'+index+'" style="padding:5px;height:auto"> <div> ' +
    ' <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-table-row-insert" plain="true" id="addRowButton'+index+'"  onclick="addRow2('+ index +')"> 添加 </a> ' +
    ' <span class="toolbar-item dialog-tool-separator"></span> ' +
    ' <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-table-row-delete" plain="true" id="delButton'+index+'"   onclick="del( '+ index +')">删除</a> ' +
    ' <span class="toolbar-item dialog-tool-separator"></span> ' +
    ' <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-table-edit" plain="true" id="editRowButton'+index+'" onclick="editRow2('+ index +' )">修改</a> ' +
    ' <span class="toolbar-item dialog-tool-separator"></span> ' +
    ' <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-table-link" plain="true" title="全部导出json"  id="editRowButton'+index+'" onclick="exportDataToSQLFromSQL('+ index +' )">导出</a> ' +
    ' <span class="toolbar-item dialog-tool-separator"></span> ' +
   ' <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-standard-page-excel" plain="true" title="全部导出excel"  id="editRowButton'+index+'" onclick="exportDataToExcelFromSQL('+ index +' )">导出</a> ' +
    ' <span class="toolbar-item dialog-tool-separator"></span> ' +
     ' <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-standard-chart-bar" plain="true" title="图表显示"  id="editRowButton'+index+'" onclick="graphicView('+ index +' )">图表</a> ' +
    ' <span class="toolbar-item dialog-tool-separator"></span> ' +
   
    ' <a href="javascript:void(0)" class="easyui-linkbutton"  plain="true"  >&nbsp;</a> ' +
    ' <span class="toolbar-item dialog-tool-separator"></span> ' +
    ' <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" plain="true" id="saveRowButton'+index+'"  onclick="saveRow('+ index +' )"> 保存 </a> ' +
    ' <span class="toolbar-item dialog-tool-separator"></span> ' +
    ' <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" plain="true" id="cancelButton'+index+'"  onclick="cancelChange('+ index +')"> 取消 </a> ' +
    ' <span class="toolbar-item dialog-tool-separator"></span> ' +
    ' </div>  </div> ';
    
    //动态 创建TAB页面
     $("#searchTabs").tabs('add', {
        title: '结果'+ (index + 1) ,
        content: toolbarHtml + ' <table id='+ tableTempId +'></table>',
        closable: true,
        tools: [{
            iconCls: 'icon-berlin-calendar',
            handler: function() {
              //  alert('refresh');
            }
        }]
    });
     
   // var currentTabPanel = $("#searchTabs").tabs('getSelected');
    //var dynamicTable = $('<table id='+ tableTempId +'></table>');
    //这里一定要先添加到currentTabPanel中，因为dynamicTable.datagrid()函数需要调用到parent函数
   // currentTabPanel.html(  dynamicTable);
    var options = {  
        url:"${ctx}/system/permission/i/executeSqlTest/"+databaseConfigId,
        method: "POST",
        queryParams: { 'sql':sql , 'databaseName': databaseName },
        rownumbers: true ,
        fit : true,
	    fitColumns : true,
	    border : false,
	    striped:true,
	    pagination:true,
	    pageNumber:1,
	    pageSize : 20,
	    pageList : [ 10, 20, 30, 40, 50 ],
	    singleSelect:false,
        checkOnSelect:true,
        toolbar:'#tb'+index,
        extEditing:false,
        autoEditing: true,     //该属性启用双击行时自定开启该行的编辑状态
        singleEditing: true,
        selectOnCheck:true ,
        
        onBeginEdit:function( index, row ){
        	 obj =  JSON.stringify( row ) ;
        },
        onAfterEdit:function( index, row, changes ){
        	  willChangeRow.push( {"oldData": eval('('+obj+')') ,"changesData":  changes } );
    	     // submitUpdate(rowData);
    	   
        },
         
        onSelect:function( index, row ){
    	   selectRowCount++;
    	  // alert( selectRowCount );
    	  //修改按钮只有选一行时 才有效
	      if(selectRowCount == 1){
		    $("#editRowButton").linkbutton("enable"); 
	      }else{
	        $("#editRowButton").linkbutton("disable"); 
	      }
       },
   
        onUnselect:function(index, row){
	      selectRowCount--;
	     // alert( selectRowCount );
	  	  //修改按钮只有选一行时 才有效
	  	  
	  	 // alert( selectRowCount );
	     if(selectRowCount == 1){
		    $("#editRowButton").linkbutton("enable"); 
	     }else{
	        $("#editRowButton").linkbutton("disable"); 
	     }
      },
       
       onDblClickCell: function(index,field,value){
		//  $(this).datagrid('beginEdit', index);
		 // var ed = $(this).datagrid('getEditor', {index:index,field:field});
		 // $(ed.target).focus();
		 // saveRow(0); //这行如果启用，双击修改后，换行将自动保存
		   var fields = $(this).datagrid('getColumnFields', true).concat($(this).datagrid('getColumnFields'));  
           //下面for循环，设定列能够编辑。当不能编辑时，editor的值为undefined，能够编辑值为text;  
           for (var i = 0; i < fields.length; i++) {  
              var col = $(this).datagrid('getColumnOption', fields[i]);  
              col.editor1 = col.editor;  
              //循环到的列，不等于鼠标点击的那一列时，设定列的editor的值为null；  
               if (fields[i] != field ) {  
                    col.editor = null;  
                }  
           }  
             
           //开始对一行进行编辑。param.index 为行号；对选中的一行进行编辑；  
          $(this).datagrid('beginEdit',  index);  
            
           //for循环，设置col  
          for (var i = 0; i < fields.length; i++) {  
              //getColumnOption:返回指定列的选项。  
              var col = $(this).datagrid('getColumnOption', fields[i]);  
              //给列的editor属性赋值；text 或者其他；  
              col.editor = col.editor1;  
          }  
		  
	  }
    };  
    options.columns = eval(data.columns);//把返回的数组字符串转为对象，并赋于datagrid的column属性  
    options.idField = data.primaryKey ;
    options.tableName = data.tableName ;
   // alert( data.tableName );
   // primary_key = data.primaryKey ;
   //  var dataGrid = $("#selectDg0");  
     var dataGrid=$('#'+tableTempId );
   // var dataGrid = document.getElementById( tableTempId );
    
   if(index>0){
	 // options.autoEditing=false;
	 // options.singleEditing=false;
	  options.onDblClickCell=null;
   }
   
    dataGrid.datagrid(options);//根据配置选项，生成datagrid  
    dataGrid.datagrid("loadData", data.rows); //载入本地json格式的数据  
   // alert( index) ;
    if( data.tableName==""  ){
    	$("#addRowButton"+index).linkbutton("disable"); 
        $("#delButton"+index).linkbutton("disable"); 
        $("#editRowButton"+index).linkbutton("disable"); 
        $("#saveRowButton"+index).linkbutton("disable"); 
        $("#cancelButton"+index).linkbutton("disable"); 
    }
    if( index>0  ){
    	$("#addRowButton"+index).linkbutton("disable"); 
        $("#delButton"+index).linkbutton("disable"); 
        $("#editRowButton"+index).linkbutton("disable"); 
        $("#saveRowButton"+index).linkbutton("disable"); 
        $("#cancelButton"+index).linkbutton("disable"); 
    }
  }   
    
   //导出数据to SQL 20180205
   function exportDataToSQLFromSQL( index  ){  
	    var temp = index;
	    var sql = $('#selectDg'+temp ).datagrid('options').queryParams.sql;
	    var databaseName =$('#selectDg'+temp ).datagrid('options').queryParams.databaseName;
    	$('#sql').val( sql ); 
    	$('#exportType').val( "json" );
    	$('#databaseName').val( databaseName ); 
    	$('#databaseConfigId').val( databaseConfigId ); 
    	$('#form3').submit();  
   }
   
    //导出数据to excel 20180205
   function exportDataToExcelFromSQL( index  ){  
	    var temp = index;
	    var sql = $('#selectDg'+temp ).datagrid('options').queryParams.sql;
	    var databaseName =$('#selectDg'+temp ).datagrid('options').queryParams.databaseName;
    	$('#sql').val( sql ); 
    	$('#exportType').val( "excel" ); 
    	$('#databaseName').val( databaseName ); 
    	$('#databaseConfigId').val( databaseConfigId ); 
    	$('#form3').submit();  
   }
 
   //图表显示
   function graphicView( index  ){  
	    var temp = index;
	    var sql = $('#selectDg'+temp ).datagrid('options').queryParams.sql;
	    var databaseName =$('#selectDg'+temp ).datagrid('options').queryParams.databaseName;
	    
	    window.mainpage.mainTabs.addModule( '图表显示' ,'${ctx}/system/graphic/graphicPage/'+databaseName +'/'+databaseConfigId+'/'+sql,'icon-standard-chart-bar');
   }
   
    function addRow2( index ){
      isAdd = true;
	  $('#selectDg'+index ).datagrid('insertRow',{
	  index: 0,	// 索引从0开始
	  row: { }
      });
	  $('#selectDg'+index ).datagrid("beginEdit",0 );
    }
    
   //删除行 
   //删除行时,先判断一下有没新增或编辑的数据行,如果有必须先提交才允许删.
 function del( index ){
	 
	 //表的主键字段
	  var temp =  $('#selectDg'+index ).datagrid('options') ;
	  var primary_key =  temp.idField ;
	  var tableName =  temp.tableName ;
	//  alert( tableName +"   "+ primary_key  );
	 
	  var inserted = $('#selectDg'+index ).datagrid('getChanges', 'inserted');
      var updated =  $('#selectDg'+index ).datagrid('getChanges', 'updated');
	   
      if (  inserted.length||updated.length  ) {
          parent.$.messager.show({ title : "提示",msg: "请先保存变更内容！", position: "bottomRight" });
          return;
      }
	 
	 var checkedItems = $('#selectDg'+index ).datagrid('getChecked');
	 
	 var length = checkedItems.length;
	 
	 //alert( length );
	  
	 if(checkedItems.length == 0 ){
		 parent.$.messager.show({ title : "提示",msg: "请先选择一行数据！", position: "bottomRight" });
		 return ;
	 }
	 
	 $.easyui.messager.confirm("操作提醒", "您确定要删除"+length+"行数据？", function (c) {
                if (c) {
                   $.ajax({
			        type:'POST',
		          	contentType:'application/json;charset=utf-8',
                    url:"${ctx}/system/permission/i/deleteRows/"+databaseConfigId ,
                    
                    data: JSON.stringify( { 'databaseName':databaseName, 'tableName':tableName,'primary_key':primary_key, 'checkedItems':JSON.stringify( checkedItems ) } ),
                    
                    datatype: "json", 
                   //成功返回之后调用的函数             
                    success:function(data){
                       var status = data.status ;
            	       if(status == 'success' ){
            	    	    $('#selectDg'+index ).datagrid('reload');
            	    	    $('#selectDg'+index ).datagrid('clearSelections').datagrid('clearChecked');
            	    	    selectRowCount = 0;
            	            parent.$.messager.show({ title : "提示",msg: "删除成功！", position: "bottomRight" });
            	       }else{
            	    	    parent.$.messager.show({ title : "提示",msg: data.mess, position: "bottomRight" });
            	       }
            	     }  
                   });
                }
            });
   }
    
  //保存修改,包括新增行,修改行.
   function saveRow( index ){  
	   endEdit( index );
	   var inserted = $('#selectDg'+index ).datagrid('getChanges', 'inserted');
      // var updated =  $('#dg2').datagrid('getChanges', 'updated');
       var updated = willChangeRow ;
       
	   var effectRow = new Object();
	   
	   var temp =  $('#selectDg'+index ).datagrid('options') ;
	   var primary_key =  temp.idField ;
	   var tableName =  temp.tableName ;
	 //  alert( tableName );
	   
	   effectRow["databaseName"] = databaseName;
	   effectRow["tableName"] = tableName;
	   effectRow["primary_key"] = primary_key;
	    
       if (inserted.length) {
    	  // alert( JSON.stringify(inserted) );
           effectRow["inserted"] = JSON.stringify(inserted);
        }
         
       if (updated.length) {
    	   // alert( JSON.stringify(updated) );
          effectRow["updated"] = JSON.stringify(updated);
       }
       
      // alert( JSON.stringify(effectRow ) );
       if ( !inserted.length&& !updated.length  ) {
    	  // parent.$.messager.show({ title : "提示",msg: "没有变更内容！", position: "bottomRight" });
    	   return;
       }
       
       $.post("${ctx}/system/permission/i/saveData/"+databaseConfigId , effectRow, function(rsp) {
    	                    willChangeRow = new Array();
                            if(rsp.status =="success"){
                            	parent.$.messager.show({ title : "提示",msg: "保存成功！", position: "bottomRight" });
                                //$.messager.alert("提示", "保存成功！");
                                //$('#dg2').datagrid('reload');
                                if( isAdd ){
                                	$('#selectDg'+index ).datagrid('acceptChanges');
                                }
                            }else{
                            	 $.messager.alert("提示", rsp.mess );
                            }
                            isAdd = false;
                        }, "JSON").error(function() {
                            $.messager.alert("提示", "提交错误了！");
       });
   }
    
    function refresh( index ){
	    $('#selectDg'+index ).datagrid('reload');
	    $('#selectDg'+index ).datagrid('clearSelections').datagrid('clearChecked');
   }
    
    //关闭编辑
   function endEdit( index ){
	     var rows = $('#selectDg'+index ).datagrid('getRows');
         for ( var i = 0; i < rows.length; i++) {
            $('#selectDg'+index ).datagrid('endEdit', i);
         }
   }
 
    //编辑 一行数据
   function editRow2( index ){
	   var temp = index;
      // if( primary_key == ""){
		  // alert("表主键为空！");
		//   return;
	  // }
	   
	   var checkedItems = $('#selectDg'+temp ).datagrid('getChecked');
	   if(checkedItems.length == 0 ){
	    	parent.$.messager.show({ title : "提示",msg: "请先选择一行数据！", position: "bottomRight" });
		    return;
	    }
	    
	    $.each(checkedItems, function(index, item){
               var  index = $('#selectDg'+temp ).datagrid("getRowIndex", item );
               $('#selectDg'+temp ).datagrid("beginEdit",index );
        }); 
	 
   }
    
     //取消 修改
   function  cancelChange( index ){
	 endEdit(index );
	 refresh( index );
   }
    
   function refresh( index ){
	    $('#selectDg'+index ).datagrid('reload');
	    $('#selectDg'+index ).datagrid('clearSelections').datagrid('clearChecked');
   }
   
  // searchVersion();
   
 // 新版本查询
 function searchVersion( ){
         $.ajax({
			type:'GET',
		    timeout : 1000, //超时时间设置，单位毫秒
            url:"http://www.treesoft.cn/treesoft/system/searchVersion",
            datatype: "json", 
            //成功返回之后调用的函数             
            success:function(data){
             // parent.$.messager.show({ title : "提示",msg:  data.mess, position: "bottomRight" });
           },
            error:function(data){
             // parent.$.messager.show({ title : "提示",msg:  data.mess, position: "bottomRight" });
           }  
          });
   }
 
</script>
    
</body>
</html>
