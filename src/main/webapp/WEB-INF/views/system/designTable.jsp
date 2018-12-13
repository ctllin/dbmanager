<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>  

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title></title>
<%@ include file="/WEB-INF/views/include/easyui.jsp"%>
<script src="${ctx}/static/plugins/My97DatePicker/WdatePicker.js" type="text/javascript"></script>

</head>
<body>

 <div id="tb3" style="padding:5px;height:auto">
                         <div>
                          
	       		           <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-table-row-insert" plain="true" id="addRowButton"  onclick="addRow2()"> 添加</a>
	       		           <span class="toolbar-item dialog-tool-separator"></span>
	                       <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-table-row-delete" plain="true" id="delButton"   onclick="deleteTableColumn()">删除</a>
	        	           <span class="toolbar-item dialog-tool-separator"></span>
	                       <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-table-edit" plain="true" id="editRowButton" onclick="editRow2()">修改</a>
	                       <span class="toolbar-item dialog-tool-separator"></span>
	                     
	                       <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-hamburg-up" plain="true" id="editRowButton" onclick="MoveUp()">上移</a>
	                       <span class="toolbar-item dialog-tool-separator"></span>
	                       <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-hamburg-down" plain="true" id="editRowButton" onclick="MoveDown()">下移</a>
	                       <span class="toolbar-item dialog-tool-separator"></span>
	                      
	                       <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-standard-arrow-refresh" plain="true" onclick="refresh()">刷新</a>
	                       <span class="toolbar-item dialog-tool-separator"></span>
                         
                           <a href="javascript:void(0)" class="easyui-linkbutton"  plain="true"  >&nbsp;</a>
	                       <span class="toolbar-item dialog-tool-separator"></span>
                         
                           <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" plain="true" id="editRowButton" onclick="saveRow()">保存</a>
	                       <span class="toolbar-item dialog-tool-separator"></span>
	                       <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" plain="true" id="editRowButton" onclick="cancelChange()">取消</a>
	                       <span class="toolbar-item dialog-tool-separator"></span>
	                      
                         </div> 
                       
  </div>
  
 <input type="hidden" id="databaseName" value="${databaseName}" >
 <input type="hidden" id="tableName"  value="${tableName}">
 <input type="hidden" id="databaseConfigId"  value="${databaseConfigId}">
<table id="dg3"></table> 
 
 
<script type="text/javascript">

var dgg;
var tableName;
var databaseName;
var databaseConfigId;

$(function(){  
	databaseName = $("#databaseName").val();
	tableName = $("#tableName").val();
	databaseConfigId = $("#databaseConfigId").val();
    initData();
});


function initData(){
	
	var ISNULLABLE = new Array();
	ISNULLABLE.push( { "value": "YES", "text": "YES" }   );
	ISNULLABLE.push( { "value": "NO", "text": "NO" }   );
	
	var ISPRIMARY = new Array();
	ISPRIMARY.push( { "value": "", "text": "" }   );
	ISPRIMARY.push( { "value": "PRI", "text": "YES" }   );
	ISPRIMARY.push( { "value": "NO", "text": "NO" }   );
	
	var Address = new Array();
	//Address.push( { "value": "varchar", "text": "varchar" }  );
	//Address.push( { "value": "int", "text": "int" }   );
	//Address.push( { "value": "datetime", "text": "datetime" }   );
	
	Address.push( { "value": "char", "text": "char" }   );
	Address.push( { "value": "character", "text": "character" }   );
	Address.push( { "value": "character varying", "text": "character varying" }   );
	Address.push( { "value": "clob", "text": "clob" }   );
	
    Address.push( { "value": "binary", "text": "binary" }   );
    Address.push( { "value": "bigint", "text": "bigint" }   );
    Address.push( { "value": "bit", "text": "bit" }   );
    Address.push( { "value": "blob", "text": "blob" }   );
    Address.push( { "value": "date", "text": "date" }   );
    Address.push( { "value": "datetime", "text": "datetime" }   );
    Address.push( { "value": "double", "text": "double" }   );
    Address.push( { "value": "decimal", "text": "decimal" }   );
    
    Address.push( { "value": "enum", "text": "enum" }   );
    Address.push( { "value": "float", "text": "float" }   );
    Address.push( { "value": "int", "text": "int" }   );
	Address.push( { "value": "integer", "text": "integer" }   );
	Address.push( { "value": "longtext", "text": "longtext" }   );
    Address.push( { "value": "longblob", "text": "longblob" }   );
    Address.push( { "value": "mediumint", "text": "mediumint" }   );
    Address.push( { "value": "mediumblob", "text": "mediumblob" }   );
    Address.push( { "value": "mediumtext", "text": "mediumtext" }   );
    Address.push( { "value": "number", "text": "number" }   );
    Address.push( { "value": "numeric", "text": "numeric" }   );
    Address.push( { "value": "nvarchar", "text": "nvarchar" }  );
   
    Address.push( { "value": "real", "text": "real" }   );
    Address.push( { "value": "set", "text": "set" }   );
    Address.push( { "value": "smallint", "text": "smallint" }   );
    Address.push( { "value": "tinyint", "text": "tinyint" }   );
    Address.push( { "value": "tinytext", "text": "tinytext" }   );
    Address.push( { "value": "text", "text": "text" }   );
    Address.push( { "value": "tinyblob", "text": "tinyblob" }   );
    Address.push( { "value": "timestamp", "text": "timestamp" }   );
    Address.push( { "value": "time", "text": "time" }   );
    Address.push( { "value": "varchar", "text": "varchar" }   );
    Address.push( { "value": "varchar2", "text": "varchar2" }   );
    Address.push( { "value": "varbinary", "text": "varbinary" }   );
    Address.push( { "value": "year", "text": "year" }   );
	
	dgg=$('#dg3').datagrid({     
	method: "get",
    url: '${ctx}/system/permission/i/designTableData/'+tableName+'/'+databaseName +'/'+databaseConfigId, 
    fit : true,
	fitColumns : true,
	border : false,
	idField : 'TREESOFTPRIMARYKEY',
	striped:true,
	pagination:true,
	rownumbers:true,
	pageNumber:1,
	pageSize : 20,
	pageList : [ 10, 20, 30, 40, 50 ],
	singleSelect:false,
    columns:[[    
		{field:'TREESOFTPRIMARYKEY',checkbox:true}, 		  
		{field:'COLUMN_NAME',title:'字段名',sortable:true,width:30 , editor: { type: 'text', options: { required: true }}  },
		{field:'DATA_TYPE',title:'类型',sortable:true,width:30,editor: { type: 'combobox', options: { data: Address, valueField: "value", textField: "text" } }    },
      	{field:'CHARACTER_MAXIMUM_LENGTH',title:'长度',sortable:true,width:10, editor:'numberbox'},
      	 
      	{field:'COLUMN_COMMENT',title:'注释',width:50 , sortable:true, editor:'text'},
        {field:'IS_NULLABLE',title:'允许空值', width:10, editor:{  type:'checkbox',options:{ on: 'YES',off: '' } } , formatter:function(value,row,index){   
	       if (value == 'YES') {
              return '<input type="checkbox"  checked    onclick=changeNullAble(this,'+index +') >'; 
          }else{
        	  return '<input type="checkbox"    onclick=changeNullAble(this,'+index +') >'; 
          }
         }},   
      	{field:'COLUMN_KEY',title:'主键设置', width:10,editor:{  type:'checkbox',  options:{ on: 'PRI',off: '' } } , formatter:function( value,row,index ){   
	       if (value == 'PRI') {
              return '<input type="checkbox"   checked  onclick=changePrimaryKey(this,'+index +') >'; 
          }else{
        	  return '<input type="checkbox"   onclick=changePrimaryKey(this,'+index +') >'; 
          }
         }}
      	
    ]], 
    checkOnSelect:true,
    selectOnCheck:true,
    extEditing:false,
    toolbar:'#tb3',
    autoEditing: true,     //该属性启用双击行时自定开启该行的编辑状态
    singleEditing: true,
    onAfterEdit:function(rowIndex, rowData, changes){
        	//alert("edit");
    	  // submitUpdate(rowData);
    },
    onLoadSuccess: function (data) {
    	if( data.status=='fail'){
    		 parent.$.messager.show({ title : "提示",msg: data.mess , position: "center" });
    	}
      },
    onDblClickCell: function(index,field,value){
		  $(this).datagrid('beginEdit', index);
		  var ed = $(this).datagrid('getEditor', {index:index,field:field});
		  $(ed.target).focus();
	  } 
	}); 
}

 function addRow2(){
	var data=$('#dg3').datagrid('getData');
	var length =  data.rows.length;
	$('#dg3').datagrid('insertRow',{
	   index: length,	// 索引从0开始
	  row: { }
    });
	 $('#dg3').datagrid("beginEdit", length );
   }


 //编辑 一行数据
   function editRow2(){
	    
	   var checkedItems = $('#dg3').datagrid('getChecked');
	    
	   if(checkedItems.length == 0 ){
	    	parent.$.messager.show({ title : "提示",msg: "请先选择一行数据！", position: "bottomRight" });
		    return;
	   }
	    
	   $.each(checkedItems, function(index, item){
               var  index = $('#dg3').datagrid("getRowIndex", item );
               $('#dg3').datagrid("beginEdit",index );
      }); 
	 
   }
 
 //保存修改,包括新增行,修改行.
   function saveRow(){  
	   endEdit()
	   var inserted = $('#dg3').datagrid('getChanges', 'inserted');
       var updated =  $('#dg3').datagrid('getChanges', 'updated');
	   var effectRow = new Object();
	   
	   effectRow["databaseName"] = databaseName;
	   effectRow["tableName"] = tableName;
	  // effectRow["primary_key"] = primary_key;
	    
       if (inserted.length) {
    	  // alert( JSON.stringify(inserted) );
           effectRow["inserted"] = JSON.stringify(inserted);
        }
         
       if (updated.length) {
    	 //   alert( JSON.stringify(updated) );
          effectRow["updated"] = JSON.stringify(updated);
       }
      
       if ( !inserted.length&& !updated.length  ) {
    	   parent.$.messager.show({ title : "提示",msg: "没有变更内容！", position: "bottomRight" });
    	   return;
       }
       
       $.post("${ctx}/system/permission/i/designTableUpdate/"+databaseConfigId, effectRow, function(rsp) {
                            if(rsp.status =="success"){
                            	$('#dg3').datagrid('acceptChanges');
                            	parent.$.messager.show({ title : "提示",msg: rsp.mess, position: "bottomRight" });
                                //$.messager.alert("提示", "保存成功！");
                               // $dg.datagrid('acceptChanges');
                               // endEdit();
                               // cancelChange();
                            }else{
                            	 $.messager.alert("提示", rsp.mess );
                            }
                        }, "JSON").error(function() {
                            $.messager.alert("提示", "提交错误了！");
       });
       
   }
 
 

  function MoveUp() {
    var row = $("#dg3").datagrid('getSelected');
    var index = $("#dg3").datagrid('getRowIndex', row);
    mysort(index, 'up', 'dg3');
     
  }
  
  //下移
  function MoveDown() {
    var row = $("#dg3").datagrid('getSelected');
    var index = $("#dg3").datagrid('getRowIndex', row);
    mysort(index, 'down', 'dg3');
     
  }

  function mysort(index, type, gridname) {
    if ("up" == type) {
        if (index != 0) {
            var toup = $('#' + gridname).datagrid('getData').rows[index];
            var todown = $('#' + gridname).datagrid('getData').rows[index - 1];
            $('#' + gridname).datagrid('getData').rows[index] = todown;
            $('#' + gridname).datagrid('getData').rows[index - 1] = toup;
            $('#' + gridname).datagrid('refreshRow', index);
            $('#' + gridname).datagrid('refreshRow', index - 1);
            
            $('#' + gridname).datagrid('unselectRow', index );
            $('#' + gridname).datagrid('selectRow', index - 1);
            
            var column_name =  toup.treeSoftPrimaryKey;
            var column_name2 = "";
            if(index >1){
            	var cunn = $('#' + gridname).datagrid('getData').rows[index - 2];
            	column_name2 = cunn.treeSoftPrimaryKey;
            }
            
            dosort( column_name, column_name2);
        }
    } else if ("down" == type) {
        var rows = $('#' + gridname).datagrid('getRows').length;
        if (index != rows - 1) {
            var todown = $('#' + gridname).datagrid('getData').rows[index];
            var toup = $('#' + gridname).datagrid('getData').rows[index + 1];
            $('#' + gridname).datagrid('getData').rows[index + 1] = todown;
            $('#' + gridname).datagrid('getData').rows[index] = toup;
            $('#' + gridname).datagrid('refreshRow', index);
            $('#' + gridname).datagrid('refreshRow', index + 1);
            
            $('#' + gridname).datagrid('unselectRow', index );
            $('#' + gridname).datagrid('selectRow', index + 1);
            
            var column_name =  todown.treeSoftPrimaryKey;
            var column_name2 = toup.treeSoftPrimaryKey;   
            
            dosort( column_name, column_name2);
        }
    }
  }

   function refresh(){
	    $('#dg3').datagrid('reload');
	    $("#dg3").datagrid('clearSelections').datagrid('clearChecked');
   }
 

   //取消 修改
   function  cancelChange(){
	 endEdit();
	 refresh();
   }

   //关闭编辑
   function endEdit(){
	     var rows = $('#dg3').datagrid('getRows');
         for ( var i = 0; i < rows.length; i++) {
            $('#dg3').datagrid('endEdit', i);
         }
     }

   //删除表字段
   function deleteTableColumn(){
	 
	 //表的主键字段
	//  var temp =  $('#dg3').datagrid('options') ;
	   
	  var checkedItems = $('#dg3').datagrid('getChecked');
	  var length = checkedItems.length;
	  
	 // alert( length );
	  if(checkedItems.length == 0 ){
		 parent.$.messager.show({ title : "提示",msg: "请先选择一行数据！", position: "bottomRight" });
		 return ;
	  }
	 
	  var ids = [];
      $.each( checkedItems, function(index, item){
    	//  alert( item["treeSoftPrimaryKey"] );
    	  ids.push( item["TREESOFTPRIMARYKEY"] );
     }); 
	 
	 $.easyui.messager.confirm("操作提示", "您确定要删除"+length+"行数据？", function (c) {
                if (c) {
                	
                   $.ajax({
			        type:'POST',
		          	contentType:'application/json;charset=utf-8',
                    url:"${ctx}/system/permission/i/deleteTableColumn/"+databaseConfigId,
                    data: JSON.stringify( { 'databaseName':databaseName, 'tableName':tableName, 'ids':ids } ),
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

   function changeNullAble( obj, index ){
	   var row = $('#dg3').datagrid('getData').rows[index];
	   var column_name = row.TREESOFTPRIMARYKEY;
	   var is_nullable = obj.checked ;
	   
	   $.ajax({
			        type:'POST',
		          	contentType:'application/json;charset=utf-8',
                    url:"${ctx}/system/permission/i/designTableSetNull/"+databaseConfigId,
                    data: JSON.stringify( { 'databaseName':databaseName, 'tableName':tableName, 'column_name':column_name, 'is_nullable':is_nullable } ),
                    datatype: "json", 
                   //成功返回之后调用的函数             
                    success:function(data){
                       var status = data.status ;
            	       if(status == 'success' ){
            	    	 //  $('#dg3').datagrid('reload');
            	    	   $("#dg3").datagrid('clearSelections').datagrid('clearChecked');
            	            parent.$.messager.show({ title : "提示",msg: "保存成功！", position: "bottomRight" });
            	       }else{
            	    	    parent.$.messager.show({ title : "提示",msg: data.mess, position: "bottomRight" });
            	       }
            	     }  
         });
	   
   }
   
   function changePrimaryKey( obj, index ){
	   var row = $('#dg3').datagrid('getData').rows[index];
	   var column_name = row.TREESOFTPRIMARYKEY;
	   var column_key = obj.checked ;
	   
	   $.ajax({
			        type:'POST',
		          	contentType:'application/json;charset=utf-8',
                    url:"${ctx}/system/permission/i/designTableSetPimary/"+databaseConfigId,
                    data: JSON.stringify( { 'databaseName':databaseName, 'tableName':tableName, 'column_name':column_name, 'column_key':column_key } ),
                    datatype: "json", 
                   //成功返回之后调用的函数             
                    success:function(data){
                       var status = data.status ;
            	       if(status == 'success' ){
            	    	 //  $('#dg3').datagrid('reload');
            	    	   $("#dg3").datagrid('clearSelections').datagrid('clearChecked');
            	            parent.$.messager.show({ title : "提示",msg: "保存成功！", position: "bottomRight" });
            	       }else{
            	    	    parent.$.messager.show({ title : "提示",msg: data.mess, position: "bottomRight" });
            	       }
            	     }  
         });
	   
   }
   
   function dosort( column_name, column_name2 ){
	   
	   $.ajax({
			type:'POST',
		    contentType:'application/json;charset=utf-8',
            url:"${ctx}/system/permission/i/upDownColumn/"+databaseConfigId,
            data: JSON.stringify( { 'databaseName':databaseName, 'tableName':tableName, 'column_name':column_name, 'column_name2':column_name2 } ),
            datatype: "json", 
            //成功返回之后调用的函数             
            success:function(data){
               var status = data.status ;
               if(status == 'success' ){
                  // $('#dg3').datagrid('reload');
                  parent.$.messager.show({ title : "提示",msg: data.mess, position: "bottomRight" });
               }else{
                  parent.$.messager.show({ title : "提示",msg: data.mess, position: "bottomRight" });
               }
           }  
         });
	   
   }
   
   
</script>

</body>
</html>