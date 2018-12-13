<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>  

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Expires" content="0">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Cache-control" content="no-cache">
<meta http-equiv="Cache" content="no-cache">
<title></title>
<%@ include file="/WEB-INF/views/include/easyui.jsp"%>

</head>
<body>

 <div id="tb3" style="padding:5px;height:auto">
                         <div>
	       		           <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" id="addRowButton"  onclick="addConfigForm()"> 添加 </a>
	       		           <span class="toolbar-item dialog-tool-separator"></span>
	                       <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" id="delButton"   onclick="deleteConfig()">删除</a>
	        	           <span class="toolbar-item dialog-tool-separator"></span>
	                       <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" id="editRowButton" onclick="editConfigForm()">修改</a>
	                       <span class="toolbar-item dialog-tool-separator"></span>
	                       <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-run" plain="true" id="editRowButton" onclick="startDataTask()">运行任务</a>
	                       <span class="toolbar-item dialog-tool-separator"></span>
	                        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-run" plain="true" id="editRowButton" onclick="startDataTaskOne()" title="立即运行一次">运行一次</a>
	                       <span class="toolbar-item dialog-tool-separator"></span>
	                       
	                       <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-no" plain="true" id="editRowButton" onclick="stopDataTask()">停止任务</a>
	                       <span class="toolbar-item dialog-tool-separator"></span>
	                       
	                       <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-standard-arrow-refresh" plain="true" onclick="refresh()">刷新</a>
	                       <span class="toolbar-item dialog-tool-separator"></span>
	                       <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-tip" plain="true" title="支持多种关系型数据库、NoSQL数据库之间的数据交换.&#13;启用状态的任务将自动运行."></a>
	                       
                         </div> 
                       
  </div>
  <div id="dlgg" ></div>  
  <div id="dlgg2" ></div> 
 <table id="dg3"></table> 
<script type="text/javascript">
var dgg;
var dataSynchronize;
var dataSynchronizeLog;

$(function(){  
	
    initData();
});

function initData(){
	dgg=$('#dg3').datagrid({     
	method: "get",
    url: '${ctx}/system/permission/i/dataSynchronizeList', 
    fit : true,
	fitColumns : true,
	border : false,
	idField : 'id',
	striped:true,
	pagination:true,
	rownumbers:true,
	pageNumber:1,
	pageSize : 20,
	pageList : [ 10, 20, 30, 40, 50 ],
	singleSelect:false,
    columns:[[    
	  	{field:'TREESOFTPRIMARYKEY',checkbox:true}, 
	  	{field:'id',title:'操作',width:100,sortable:true,formatter: function(value,row,index){
				 return ' <img src="${ctx}/static/plugins/easyui/jquery-easyui-theme/icons/search.png" style="cursor: pointer;" />&nbsp; <a style="text-decoration:none;" class="easyui-linkbutton"   href="javascript:viewLog(\'' +row["id"]+  ' \')">日志查看</a>';
				 // return '<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-no" plain="true" id="editRowButton" >日志查看</a>';
				 
		}},
	  	{field:'name',title:'名称',width:100 },
	  	{field:'souceConfig',title:'数据来源',sortable:true,width:100 },
	  	{field:'souceDataBase',title:'来源库名',sortable:true,width:100 },
        {field:'targetConfig',title:'同步目标',sortable:true,width:100},
        {field:'targetDataBase',title:'目标库名',sortable:true,width:100},
        {field:'targetTable',title:'目标表名',sortable:true,width:100},
        {field:'operation',title:'执行动作',sortable:true,formatter: function(value,row,index){
				if (row.operation =='0'){
					return '<font >新增</font>';
				}else if (row.operation =='1'){
					return '<font >更新</font>';
				}else if (row.operation =='2'){
					return '<font >覆盖</font>';
				} else {
					return '';
				}
		}},
        
        {field:'state',title:'是否启用',sortable:true,formatter: function(value,row,index){
				if (row.state =='0'){
					return '<font color="green">启用</font>';
				}else if (row.state =='1'){
					return '<font color="red">禁用</font>';
				} else {
					return '';
				}
		}},
        {field:'status',title:'当前运行状态',sortable:true,formatter: function(value,row,index){
				if (row.status =='0'){
					return '<font color="red">停止</font>';
				}else if (row.status =='1'){
					return '<font color="green">运行中</font>';
				} else {
					return '';
				}
		}}
	  	
    ] ], 
    checkOnSelect:true,
    selectOnCheck:true,
    extEditing:false,
    toolbar:'#tb3',
    autoEditing: false,     //该属性启用双击行时自定开启该行的编辑状态
    singleEditing: false,
    
    onDblClickRow: function (rowIndex, rowData) {  
    	var id =rowData.id  ;
	    dataSynchronize = $("#dlgg").dialog({   
	    title: '查看',    
	    width: 550,    
	    height: 480,    
	    href:'${ctx}/system/permission/i/editDataSynchronizeForm/'+id,
	    maximizable:true,
	    modal:true,
	    buttons:[
	    	{
			text:'关闭',
			iconCls:'icon-cancel',
			handler:function(){
					dataSynchronize.panel('close');
				}
		 }]
	  });
    }
   }); 
  }
     

   //打开 新增 编辑 对话框
   function addConfigForm(){
	    dataSynchronize = $("#dlgg").dialog({   
	    title: ' 新增',    
	    width: 550,    
	    height: 500,    
	    href:'${ctx}/system/permission/i/addDataSynchronizeForm',
	    maximizable:true,
	    modal:true,
	    buttons:[ {
			text:'保存',
			iconCls:'icon-ok',
			handler:function(){
				$("#mainform").submit(); 
			}
		   },{
			text:'关闭',
			iconCls:'icon-cancel',
			handler:function(){
					dataSynchronize.panel('close');
				}
		 }]
	  });
  }
   
 function editConfigForm(){
	
	var checkedItems = $('#dg3').datagrid('getChecked');
	if(checkedItems.length == 0 ){
	      parent.$.messager.show({ title : "提示",msg: "请先选择一行数据！", position: "bottomRight" });
		  return;
	 }
	    
	 if(checkedItems.length >1 ){
	      parent.$.messager.show({ title : "提示",msg: "请选择一行数据！", position: "bottomRight" });
		  return;
	 }
	 
	 var id = checkedItems[0]['id']  ;
	 
	 dataSynchronize= $("#dlgg").dialog({   
	    title: '编辑',    
	    width: 550,    
	    height: 500,    
	    href:'${ctx}/system/permission/i/editDataSynchronizeForm/'+id,
	    maximizable:true,
	    modal:true,
	    buttons:[{
			text:'保存',
			iconCls:'icon-ok',
			handler:function(){
				$("#mainform").submit(); 
			}
		   },{
			text:'关闭',
			iconCls:'icon-cancel',
			handler:function(){
					dataSynchronize.panel('close');
				}
		 }]
	});
 }
 
   //删除  
   function deleteConfig(){
	 
	  var checkedItems = $('#dg3').datagrid('getChecked');
	  var length = checkedItems.length;
	  
	  var data2=$('#dg3').datagrid('getData');
	  var totalLength = data2.total;
	  
	  // alert('总数据量:'+data.total)
	  
	   if(totalLength - length <= 0 ){
		 parent.$.messager.show({ title : "提示",msg: "必须保留一行配置信息！", position: "bottomRight" });
		 return ;
	  }
	  
	  if(checkedItems.length == 0 ){
		 parent.$.messager.show({ title : "提示",msg: "请先选择一行数据！", position: "bottomRight" });
		 return ;
	  }
	 
	  var ids = [];
      $.each( checkedItems, function(index, item){
    	  ids.push( item["id"] );
     }); 
       
	 $.easyui.messager.confirm("操作提示", "您确定要删除"+length+"行数据吗？", function (c) {
                if (c) {
                	
                   $.ajax({
			        type:'POST',
		          	contentType:'application/json;charset=utf-8',
                    url:"${ctx}/system/permission/i/deleteDataSynchronize",
                    data: JSON.stringify( { 'ids':ids } ),
                    datatype: "json", 
                   //成功返回之后调用的函数             
                    success:function(data){
                       var status = data.status ;
            	       if(status == 'success' ){
            	    	   $('#dg3').datagrid('reload');
            	    	   $("#dg3").datagrid('clearSelections').datagrid('clearChecked');
            	            parent.$.messager.show({ title : "提示",msg: "删除成功！", position: "bottomRight" });
            	       }else{
            	    	    parent.$.messager.show({ title : "提示",msg: data.mess, position: "bottomRight" });
            	       }
            	     }  
                   });
                }
            });
   }
    
   // 启动 数据交换任务  
   function startDataTask(){
	 
	  var checkedItems = $('#dg3').datagrid('getChecked');
	  var length = checkedItems.length;
	  
	  var data2=$('#dg3').datagrid('getData');
	  var totalLength = data2.total;
	  
	  if(checkedItems.length == 0 ){
		 parent.$.messager.show({ title : "提示",msg: "请选择一行数据！", position: "bottomRight" });
		 return ;
	  }
	 
	  var ids = [];
      $.each( checkedItems, function(index, item){
    	  ids.push( item["id"] );
     }); 
              	
      $.ajax({
		 type:'POST',
		 contentType:'application/json;charset=utf-8',
         url:"${ctx}/system/permission/i/startDataTask",
         data: JSON.stringify( { 'ids':ids } ),
         datatype: "json", 
         //成功返回之后调用的函数             
         success:function(data){
           var status = data.status ;
           if(status == 'success' ){
              $('#dg3').datagrid('reload');
            	  $("#dg3").datagrid('clearSelections').datagrid('clearChecked');
            	  parent.$.messager.show({ title : "提示",msg: data.mess, position: "bottomRight" });
            }else{
            	  parent.$.messager.show({ title : "提示",msg: data.mess, position: "bottomRight" });
            }
          }  
      });
                
   }
   
    // 启动运行一次 数据交换任务  
   function startDataTaskOne(){
	 
	  var checkedItems = $('#dg3').datagrid('getChecked');
	  var length = checkedItems.length;
	  
	  var data2=$('#dg3').datagrid('getData');
	  var totalLength = data2.total;
	  
	  if(checkedItems.length == 0 ){
		 parent.$.messager.show({ title : "提示",msg: "请选择一行数据！", position: "bottomRight" });
		 return ;
	  }
	 
	  var ids = [];
      $.each( checkedItems, function(index, item){
    	  ids.push( item["id"] );
     }); 
              	
      $.ajax({
		 type:'POST',
		 contentType:'application/json;charset=utf-8',
         url:"${ctx}/system/permission/i/startDataTaskOne",
         data: JSON.stringify( { 'ids':ids } ),
         datatype: "json", 
         //成功返回之后调用的函数             
         success:function(data){
           var status = data.status ;
           if(status == 'success' ){
              $('#dg3').datagrid('reload');
            	  $("#dg3").datagrid('clearSelections').datagrid('clearChecked');
            	  parent.$.messager.show({ title : "提示",msg: data.mess, position: "bottomRight" });
            }else{
            	  parent.$.messager.show({ title : "提示",msg: data.mess, position: "bottomRight" });
            }
          }  
      });
                
   }
   
   // 停止 数据交换任务  
   function stopDataTask(){
	  var checkedItems = $('#dg3').datagrid('getChecked');
	  var length = checkedItems.length;
	  
	  var data2=$('#dg3').datagrid('getData');
	  var totalLength = data2.total;
	  
	  if(checkedItems.length == 0 ){
		 parent.$.messager.show({ title : "提示",msg: "请选择一行数据！", position: "bottomRight" });
		 return ;
	  }
	 
	  var ids = [];
      $.each( checkedItems, function(index, item){
    	  ids.push( item["id"] );
     }); 
              	
      $.ajax({
		 type:'POST',
		 contentType:'application/json;charset=utf-8',
         url:"${ctx}/system/permission/i/stopDataTask",
         data: JSON.stringify( { 'ids':ids } ),
         datatype: "json", 
         //成功返回之后调用的函数             
         success:function(data){
           var status = data.status ;
           if(status == 'success' ){
              $('#dg3').datagrid('reload');
            	  $("#dg3").datagrid('clearSelections').datagrid('clearChecked');
            	  parent.$.messager.show({ title : "提示",msg: data.mess, position: "bottomRight" });
            }else{
            	  parent.$.messager.show({ title : "提示",msg: data.mess, position: "bottomRight" });
            }
          }  
      });
   }
   
   function refresh(){
	    $('#dg3').datagrid('reload');
	    $("#dg3").datagrid('clearSelections').datagrid('clearChecked');
   }
   
   
   //打开 日志查看   对话框
   function viewLog( dataSynchronizeId ){
	    dataSynchronizeLog = $("#dlgg2").dialog({   
	    title: '日志查看',    
	    width: 550,    
	    height: 480,    
	    href:'${ctx}/system/permission/i/dataSynchronizeLogForm/'+dataSynchronizeId ,
	    maximizable:true,
	    modal:true,
	    buttons:[{
			text:'关闭',
			iconCls:'icon-cancel',
			handler:function(){
					dataSynchronizeLog.panel('close');
				}
		 }]
	  });
  }
    
</script>

</body>
</html>