<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title></title>
<%@ include file="/WEB-INF/views/include/easyui.jsp"%>
<script src="${ctx}/static/plugins/My97DatePicker/WdatePicker.js" type="text/javascript"></script>
</head>

<body>
 <div id="tb2" style="padding:5px;height:auto">
                         <div>
                         
	       		           <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-table-row-insert" plain="true" id="addRowButton"  onclick="addRow2()"> 添加 </a>
	       		           <span class="toolbar-item dialog-tool-separator"></span>
	       		           
	       		            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-table-edit" plain="true" id="copyRowButton" onclick="copyRow()">复制</a>
	                       <span class="toolbar-item dialog-tool-separator"></span>
	                       	       		           
	                       <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-table-row-delete" plain="true" id="delButton"   onclick="del()">删除</a>
	        	           <span class="toolbar-item dialog-tool-separator"></span>
	        	           <!--  
	                       <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-table-edit" plain="true" id="editRowButton" onclick="editRow2()">修改</a>
	                       <span class="toolbar-item dialog-tool-separator"></span>
	                       -->
	                       <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-table-gear" plain="true" id="editTableButton" onclick="designTable()">设计表</a>
	                       <span class="toolbar-item dialog-tool-separator"></span>
	                        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-table-save" plain="true" id="exportDataToSQLButton" onclick="exportDataToSQL()" title="导出SQL">导出</a>
	                       <span class="toolbar-item dialog-tool-separator"></span>
	                       
	                       <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-standard-arrow-refresh" id="refreshButton" plain="true" onclick="refresh()">刷新</a>
	                       <span class="toolbar-item dialog-tool-separator"></span>
                        
                           <a href="javascript:void(0)" class="easyui-linkbutton"  plain="true"  >&nbsp;</a>
	                       <span class="toolbar-item dialog-tool-separator"></span>
                        
                            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" plain="true" id="saveRowButton"  onclick="saveRow()"> 保存 </a>
	       		           <span class="toolbar-item dialog-tool-separator"></span>
                          
                           <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" plain="true" id="cancelButton"  onclick="cancelChange()"> 取消 </a>
	       		           <span class="toolbar-item dialog-tool-separator"></span>
                        
                            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-tip" plain="true" title="可双击行编辑数据. &#13;钩选行进行复制."></a>
                          
                         </div> 
                       
  </div>
 <input type="hidden" id="databaseConfigId" value="${databaseConfigId}" >
 <input type="hidden" id="databaseName"    value="${databaseName}" >
 <input type="hidden" id="tableName"       value="${tableName}">
 <input type="hidden" id="objectType"      value="${objectType}">
<table id="dg2"></table> 

<div id="dlg2"></div>  
<div id="dlgg"   ></div>  
<div id="addRow" ></div>
 
<form id="form2" method="post"  action="${ctx}/system/permission/i/exportDataToSQL/${databaseConfigId}"  style="display:none"   >
   <input type="hidden" id="databaseName" name="databaseName" value="${databaseName}" >
   <input type="hidden" id="tableName"    name="tableName" value="${tableName}">
   <input type="hidden" id="checkedItems" name="checkedItems" >
   <input type="hidden" id="primary_key"  name="primary_key" >
</form>

<script type="text/javascript">
var dg;
var d;
var primary_key;
var selectRowCount = 0;
var columnsTemp = new Array();
var databaseName;
var tableName;
var add;
var obj ;
var isCopy= false;
var isAdd = false;
var isSuccessSave = true;
var updatedRowIndex; 
var willChangeRow = new Array();
var databaseConfigId;

$(function(){ 
	databaseConfigId = $("#databaseConfigId").val();
	databaseName = $("#databaseName").val();
	tableName = $("#tableName").val();		
	query();
	
	//为视图时，禁用相关按钮
	if( $("#objectType").val()=='view'){
		$('#addRowButton').linkbutton('disable');
		$('#copyRowButton').linkbutton('disable');
		$('#delButton').linkbutton('disable');
		$('#editTableButton').linkbutton('disable');
		$('#saveRowButton').linkbutton('disable');
		$('#cancelButton').linkbutton('disable');
		$('#refreshButton').linkbutton('disable');
		$('#exportDataToSQLButton').linkbutton('disable');
	}
	
});


//查询方法  
function query() {  
    var url = "${ctx}/system/permission/i/table/"+tableName+"/"+databaseName+"/"+databaseConfigId  ;
    $.post(url, null ,showGrid, "json");  
}  

//处理返回结果，并显示数据表格  
function showGrid( data ) {  
	
    var options = {  
    	// method: "POST",
        url:"${ctx}/system/permission/i/table/"+tableName+"/"+databaseName +"/"+databaseConfigId ,
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
        selectOnCheck:true,
        extEditing:false,
        toolbar:'#tb2',
        
        autoEditing: false,          //该属性启用双击行时自定开启该行的编辑状态
        singleEditing: false,
        onBeginEdit:function( index, row ){
         	// alert('index = ' + index );
         	
        	 obj = JSON.stringify( row ) ;
        	 updatedRowIndex = index; 
        	
        },
         
        onAfterEdit:function( index, row, changes ){
        	 if( Object.keys( changes ).length >0 ){
        		  willChangeRow.push(  {"oldData": eval('('+obj+')') ,"changesData":  changes }  );
        	 }
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
    	   saveRow();
    	   
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
             // alert( col.editor );
           }  
	   }
    };  
    if( data.status=='fail'){
    		 parent.$.messager.show({ title : "提示",msg: data.mess , position: "center" });
   	}    
    options.columns = eval(data.columns);//把返回的数组字符串转为对象，并赋于datagrid的column属性  
    options.idField = data.primaryKey ;
    primary_key = data.primaryKey ;
    dg = $("#dg2");  
    dg.datagrid(options);//根据配置选项，生成datagrid  
    dg.datagrid("loadData", data.rows); //载入本地json格式的数据  
}  


//确认修改  --delete
function submitUpdate(row){
	parent.$.messager.confirm('提示', '确定要修改数据？', function(data){
		if (data){
			$.ajax({
				type:'get',
				//url:"${ctx}/system/scheduleJob/"+row.name+"/"+row.group+"/update",
			    url:"${ctx}/system/permission/i/updateRow/"+tableName+"/"+databaseName ,
				data:"cronExpression="+row.cronExpression,
				success: function(data){
					if(data=='success'){
						dg.datagrid('reload');
						parent.$.messager.show({ title : "提示",msg: "操作成功！", position: "bottomRight" });
					}else{
						parent.$.messager.alert(data);
					}  
				}
			});
			d.panel('close');
		}else{
			dg.datagrid('rejectChanges');
		}
	});
  }
 
   
   //编辑 一行数据 , 目前版本没有使用20171209
   function editRow(){
	   
	   var idValues;
	    var checkedItems = $('#dg2').datagrid('getChecked');
	    
	    if(checkedItems.length == 0 ){
	    	parent.$.messager.show({ title : "提示",msg: "请先选择一行数据！", position: "bottomRight" });
		    return;
	    }
	    
	    $.each(checkedItems, function(index, item){
                  // id = item.id  ;
                      idValues = item[primary_key]  ;
                     
        }); 
 	   
	    add = $("#addRow").dialog({   
	    title: "编辑数据",    
	    width: 380,    
	    height: 350,  
	 //   href:"${ctx}/system/permission/i/editRows/"+tableName+"/"+databaseName +"/"+id+"/"+idValues,
	    href:"${ctx}/system/permission/i/editRows/"+tableName+"/"+databaseName +"/"+primary_key +"/"+idValues +"/"+ databaseConfigId,
	    maximizable:true,
	    modal:true,
	    buttons:[ 
	    	{
			text:'确认',
			iconCls:'icon-edit',
			handler:function(){
				$("#mainform").submit(); 
			}
		},{
			text:'取消',
			iconCls:'icon-cancel',
			handler:function(){
					add.panel('close');
				}
		}]
	});
  }
   
  
 //删除行时,先判断一下有没新增或编辑的数据行,如果有,必须先提交才允许删.
 function del(){
	 
	 //表的主键字段
	  var temp =  $('#dg2').datagrid('options') ;
	  var primary_key =  temp.idField ;
	 // alert(  primary_key  );
	 
	  var inserted = $('#dg2').datagrid('getChanges', 'inserted');
      var updated =  $('#dg2').datagrid('getChanges', 'updated');
	   
      if (  inserted.length||updated.length  ) {
          parent.$.messager.show({ title : "提示",msg: "请先保存变更内容！", position: "bottomRight" });
          return;
      }
	 
	 var checkedItems = $('#dg2').datagrid('getChecked');
	 
	 var length = checkedItems.length;
	 	  
	 if(checkedItems.length == 0 ){
		 parent.$.messager.show({ title : "提示",msg: "请先选择一行数据！", position: "bottomRight" });
		 return ;
	 }
	 
	 $.easyui.messager.confirm("操作提醒", "您确定要删除"+length+"行数据？", function (c) {
                if (c) {
                   $.ajax({
			        type:'POST',
		          	contentType:'application/json;charset=utf-8',
                    url:"${ctx}/system/permission/i/deleteRows/" + databaseConfigId ,
                    
                   // data: JSON.stringify( { 'databaseName':databaseName, 'tableName':tableName,'primary_key':primary_key, 'ids':ids } ),
                    data: JSON.stringify( { 'databaseName':databaseName, 'tableName':tableName,'primary_key':primary_key, 'checkedItems':JSON.stringify( checkedItems ) } ),
                    
                    datatype: "json", 
                   //成功返回之后调用的函数             
                    success:function(data){
                       var status = data.status ;
            	       if(status == 'success' ){
            	    	    $('#dg2').datagrid('reload');
            	    	    $("#dg2").datagrid('clearSelections').datagrid('clearChecked');
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
 
   function refresh(){
	    $("#dg2").datagrid('reload');
	    $("#dg2").datagrid('clearSelections').datagrid('clearChecked');
   }

   //设计表结构
   function designTable(){  
	   parent.window.mainpage.mainTabs.addModule( "设计"+tableName+" @"+databaseName ,'${ctx}/system/permission/i/designTable/'+tableName+'/'+databaseName +'/'+databaseConfigId ,'icon-hamburg-config');
   }
      
   //导出数据to SQL
   function exportDataToSQL(){  
    	var checkedItems = $('#dg2').datagrid('getChecked');
    	//alert(JSON.stringify( JSON.stringify( checkedItems )));
    	if(checkedItems.length == 0 ){
		    parent.$.messager.show({ title : "提示",msg: "请先选择一行数据！", position: "center" });
		    return ;
	    }
    	$('#checkedItems').val( JSON.stringify( checkedItems )); 
    	$('#primary_key').val( primary_key ); 
    	$('#form2').submit();  
   }
   
  //保存修改,包括新增行,修改行.
   function saveRow(){ 
	   endEditAll( );
	   var inserted = $('#dg2').datagrid('getChanges', 'inserted');
       // var updated =  $('#dg2').datagrid('getChanges', 'updated');
       var updated = willChangeRow ;
	   var effectRow = new Object();
	   effectRow["databaseName"] = databaseName;
	   effectRow["tableName"] = tableName;
	   effectRow["primary_key"] = primary_key;
	    
       if (inserted.length) {
    	    // alert( JSON.stringify(inserted) );
           effectRow["inserted"] = JSON.stringify(inserted);
        }
         
       if (updated.length && !isCopy) {
    	   //   alert( JSON.stringify(updated) );
          effectRow["updated"] = JSON.stringify(updated);
       }
       
       if ( !inserted.length&& !updated.length  ) {
    	  // parent.$.messager.show({ title : "提示",msg: "没有变更内容！", position: "bottomRight" });
    	   return;
       }
       $.post("${ctx}/system/permission/i/saveData/"+databaseConfigId, effectRow, function(rsp) {
    	                    willChangeRow = new Array();
                            if(rsp.status =="success"){
                            	parent.$.messager.show({ title : "提示",msg: "保存成功！", position: "bottomRight" });
                                if(isAdd ){
                                	$('#dg2').datagrid('acceptChanges');
                                }
                                isAdd = false;
                                isCopy = false;    
                            }else{
                            	 //alert('ddd');
                            	 $.messager.alert("提示", rsp.mess );                            	 
                            	 $('#dg2').datagrid("beginEdit",updatedRowIndex );
                            	 
                            }
                        }, "JSON").error(function() {
                            $.messager.alert("提示", "提交错误了！");
       });
   }
  
  //保存修改,包括新增行,修改行.
   function saveRowForEdit2( index3 ){ 
	   var inserted = $('#dg2').datagrid('getChanges', 'inserted');
       // var updated =  $('#dg2').datagrid('getChanges', 'updated');
       var updated = willChangeRow ;
       
	   var effectRow = new Object();
	   effectRow["databaseName"] = databaseName;
	   effectRow["tableName"] = tableName;
	   effectRow["primary_key"] = primary_key;
	    
       if (inserted.length) {
    	   //  alert( JSON.stringify(inserted) );
           effectRow["inserted"] = JSON.stringify(inserted);
        }
         
       if (updated.length && !isCopy) {
    	    //   alert( JSON.stringify(updated) );
          effectRow["updated"] = JSON.stringify(updated);
       }
       
       if ( !inserted.length&& !updated.length  ) {
    	  // parent.$.messager.show({ title : "提示",msg: "没有变更内容！", position: "bottomRight" });
    	   return;
       }
       
       $.post("${ctx}/system/permission/i/saveData/"+databaseConfigId, effectRow, function(rsp) {
    	                    willChangeRow = new Array();
                            if(rsp.status =="success"){
                            	parent.$.messager.show({ title : "提示",msg: "保存成功！", position: "bottomRight" });
                                //$.messager.alert("提示", "保存成功！");
                                
                                if(isAdd ){
                                	$('#dg2').datagrid('acceptChanges');
                                }
                                isAdd = false;
                                isCopy = false;
                                isSuccessSave = true;
                            }else{
                            	 $.messager.alert("提示", rsp.mess );
                            	 isSuccessSave = false;
                            }
                        }, "JSON").error(function() {
                            $.messager.alert("提示", "提交错误了！");
       });
       
   }
  
   function addRow2(){
	isAdd = true;	   
	$('#dg2').datagrid('insertRow',{
	  index: 0,	// 索引从0开始
	  row: { }
    });
	$('#dg2').datagrid("beginEdit",0 );
   }
   
   function copyRow(){
	   isCopy = true;
	   var checkedItems = $('#dg2').datagrid('getChecked');
	   if(checkedItems.length == 0 ){
	    	parent.$.messager.show({ title : "提示",msg: "请先选择数据！", position: "bottomRight" });
		    return;
	   }
	  
	   $.each(checkedItems, function(index, item){
		    $('#dg2').datagrid('insertRow',{
	          index: 0,	// 索引从0开始
	          row:item
            });		   
           $('#dg2').datagrid("beginEdit",0 );
      }); 
   }   
   
 //编辑 一行数据
   function editRow2(){
	   
	   var checkedItems = $('#dg2').datagrid('getChecked');
	   if(checkedItems.length == 0 ){
	    	parent.$.messager.show({ title : "提示",msg: "请先选择一行数据！", position: "bottomRight" });
		    return;
	    }
	    
	    $.each(checkedItems, function(index, item){
               var  index = $('#dg2').datagrid("getRowIndex", item );
               $('#dg2').datagrid("beginEdit",index );
        }); 
	 
   }
 
   //取消 修改
   function  cancelChange(){
	 endEditAll();
	 refresh();
   }
 
   //关闭编辑 All
   function endEditAll(){	   
	     var rows = $('#dg2').datagrid('getRows');
         for ( var i = 0; i < rows.length; i++) {
            $('#dg2').datagrid('endEdit', i);
         }
     }
   
    //关闭编辑 index
   function endEditByIndex( index ){
        $('#dg2').datagrid('endEdit', index );
     }
   
</script>
</body>
</html>