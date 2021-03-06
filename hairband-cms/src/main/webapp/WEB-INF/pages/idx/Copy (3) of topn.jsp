<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@include file="../commons/commons.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
<div>
		<div id="selectgoodsTopPagation">
		</div>
		<div class="easyui-window" title="新增人气商品" data-options="closed:true,modal:true,width:500,height:400" id="addgoodsTopDiv" >
		<div style="padding:50px 0 50px 30%">
			<form id="addgoodsTopForm" method="post" data-options="novalidate:true" action="${dynUrl }/idx/addGoodsTop.htm">
				<div class="form-group">
				<label style="width:70px">商品Id：</label>
						<input class="easyui-textbox" type="text" readonly="readonly" name="goodsId"
							></input>
				</div>	
				<div class="form-group">
				<label style="width:70px">排序：</label>
						<input class="easyui-numberbox" type="text" name="sort"
						 data-options="required:true,min:0,precision:0"></input>
				</div>
				<label style="width:70px">状态：</label>
						<span><input type="radio" name="isDel" value="1" checked="checked"/>正常</span>
							<span><input type="radio" name="isDel" value="127"/>删除</span>
			<div style="padding-left:70px">
				<a href="javascript:void(0)" class="btn btn-default" id="addgoodsTop_submit">提交</a> 
				<a href="javascript:void(0)" class="btn btn-default" id="addgoodsTop_clear">重置</a>
			</div>
			</form>
		</div>
	</div>
	<div id="updateGoodsTopDiv" style="width:300px;height:300px;" class="easyui-window" title="修改人气商品信息" data-options="modal:true,closed:true">
		<form id="updateGoodsTopForm" method="post" data-options="novalidate:true" action="${dynUrl }/idx/updateGoodsTop.htm" style="padding-left:30px;padding-top:30px">
				<input type="hidden" name="id"/>
				<table>
					<tr>
						<td>商品ID：</td>
						<td><input class="easyui-textbox " type="text" readonly="readonly" name="goodsId" ></input></td>
					</tr>
					<tr>
						<td>商品名称：</td>
						<td><input class="easyui-textbox " type="text" readonly="readonly" name="goodsName" ></input></td>
					</tr>
					<tr>
						<td>排序：</td>
						<td><input class="easyui-numberbox st"  type="text" name="sort"
							data-options="required:true,min:0,precision:0"></input></td>
					</tr>
					<tr>
						<td>状态:</td>
						<td>
							<span><input type="radio" name="isDel" value="1" checked="checked"/>正常</span>
							<span><input type="radio" name="isDel" value="127"/>删除</span>
						</td>
					</tr>
				</table>
				
				<div style="padding-left:70px">
					<a href="javascript:void(0)" class="btn btn-default" id="updateGoodsTop_submit">提交</a> 
				<!-- 	<a href="javascript:void(0)" class="btn btn-default" id="updatebroadcast_clear">重置</a>  -->
				</div>
			</form>
	</div>
	</div>
	<div id="goods">
		<div class="form-inline" role="form">
		  <div class="form-group">
		    <label>商品id：</label>
		    <input type="text" class="form-control" id="g_goodsId" placeholder="商品id">
		  </div>
		  <div class="form-group">
		      <label>商品货号：</label>
		      <input class="form-control" type="text" id="g_sku" placeholder="商品货号">
		  </div>
		   <div class="form-group">
		      <label>商品名称：</label>
		      <input class="form-control" type="text" id="g_name" placeholder="商品名称">
		  </div>
		   <div class="form-group">
		      <label>供货商：</label>
		      <select class="easyui-combobox" id="g_provider" style="width:100px" data-options="valueField:'v',textField:'k',url:'${dynUrl }/provider/getProvidersList.htm',mode:'remote',method:'post'">
		      </select>
		  </div>
		  <div class="form-group">
		      <label>价格区间：</label>
			  <input class="easyui-numberbox" id="g_price" style="width:50px" data-options="min:0,precision:2"/>-<input class="easyui-numberbox" id="g_price2" style="width:50px" data-options="min:0,precision:2"/>		     
		  </div>
		  <button type="submit" class="btn btn-default" onclick="goodsSubmit()">查询</button>
		</div>
		<div id="goods_datagrid"></div>
	</div>
	
	<script type="text/javascript">
		$(document).ready(function(){
			goodsSubmit = function(){
				goods_datagrid.datagrid("load");
			}
			
			
			submit = function(){
				var param = {};
				var datas = detailTip_dg.datagrid("getData").rows;
				param.goodsId="";
				if(datas){
					$.each(datas,function(i,d){
						console.log(d);
						param.goodsId = param.goodsId + d.goodsId + ",";
					});
				}
				return ;
				framework.startMask();
				
				$.post(framework.dynUrl+"",param,function(d){
					if(d.success){
						framework.alert("保存成功");
						flush();
					}else{
						framework.alert(d.errMsg);
					}
					framework.closeMask();
				},"json");
			}
			flush = function(){
				cur_select = undefined;
				var len = detailTip_dg.datagrid("getData").rows.length;
				for(var i=len;i>0;i--){
					detailTip_dg.datagrid("deleteRow",i-1);
				}
			}
			var goods_datagrid;
			function goodsFun(){
				goods_datagrid = $('#goods_datagrid').datagrid({ 
					title:"商品列表",
			        pageSize:framework.pageNum,
			        pageList:[20,30,40,50],
			        method: 'post',
			        border: true, 
			        url:'${dynUrl}/goods/filter.htm', 
			        pagination:true, 
			        singleSelect:true,
			        fitColumns:true,
			        rownumbers:true,
			        checkOnSelect:false,
			        selectOnCheck:false,
			        columns:[[{
			        	field:"id",title:"商品id",width:20
			        },{
			        	field:"sku",title:"商品货号",width:20
			        },{
			        	field:"goodsName",title:"商品名称",width:20,formatter:function(value,rowData,rowIndex){
			        		return '<a href="'+framework.detailUrl+rowData.id+'" target="_blank">'+value+'</a>';
			        	}
			        },{
			        	field:"isSale",title:"状态",width:20,formatter:function(value){if(value==1){return '上架'}else if(value==2){return '下架'} else {return '删除'}}
			        },{
			        	field:"price",title:"价格",width:20
					},{
			        	field:"marketPrice",title:"市场价格",width:20
					},{
			        	field:"barCode",title:"条形码",width:20
					},{
			        	field:"operatorName",title:"操作人",width:20
					},{
			        	field:"providerName",title:"供货商",width:20
					},{
			        	field:"isReal",title:"是否虚拟",width:20,formatter:function(value){if(value==0){return '否'}else if(value==1){return '是'}}
					},{
						field:'virtualNumber',title:'库存',width:20
					},{
						field:'limittype',title:'限制级别',width:20,formatter:function(value){switch(value){case 0:return '不限制';case 1:return '省';case 2:return '市';case 3:return '区';case 4:return '商圈';case 5:return '亭子'}}
					},{
			        	field:"place",title:"场地",width:20
					},{
			        	field:"remark",title:"备注",width:20
					},{
						field:'brandName',title:'品牌名称',width:20
					},{
			        	field:"areaName",title:"范围",width:20
					},{
			        	field:"createtime",title:"创建时间",width:20
					},{
			        	field:"modifytime",title:"修改时间",width:20
					}]],
			        onBeforeLoad: function (param) {
			        	param.goodsId = $.trim($("#g_goodsId").val());
			        	param.sku=$.trim($("#g_sku").val());
			        	param.name=$.trim($("#g_name").val());
			        	param.provider=$("#g_provider").combobox("getValue");
			        	param.price=$.trim($("#g_price").val());
			        	param.price2=$.trim($("#g_price2").val());
			        },
			        onLoadSuccess: function () {
			            
			        },
			        onLoadError: function () {
			            
			        },
			        onClickCell: function (rowIndex, field, value) {
			        	
			        },
			        onDblClickRow: function (rowIndex, rowData) {
			        	var map = {};
			        	map.goodsId=rowData.id;
			        	$("#addgoodsTopForm").form("load",map);
			        	$("#addgoodsTopDiv").window("open");
			        },
			        onClickRow:function(rowIndex,rowData){
			        	
			        },
			        loadFilter:function(data){
			        	if(!data.success){
			        		framework.dialog(data);
			        		return [];
			        	}else{
			        		var result = {
				        			total:data.result.total,
				        			rows:data.result.entry,
				        	};
				        	return result;
			        	}
			        }
			    }); 
			}
			
			goodsFun();
			
			$('#selectgoodsTopPagation').datagrid({ 
		        pageSize:framework.pageNum,
		        method: 'post',
		        border: true, 
		        url:'${dynUrl}/idx/goodsTopSearch.htm', 
		        pagination:true, 
		        fitColumns:true,
		        singleSelect:true,
		        rownumbers:true,
		        columns:[[{
		        	field:"goodsId",title:"商品Id",width:100
		        },{
		        	field:"goodsName",title:"商品名称",width:100
		        },{
		        	field:"sort",title:"排序",width:100
		        },{
		        	field:"isDel",title:"是否删除",formatter:function(value){
		        		if(value == 1){
		        			return	"正常";	
		        		}else{
		        			return	"删除";	
		        		}
		        	},width:50
		        }]],
		        onBeforeLoad: function (param) {
		        },
		        onLoadSuccess: function (data) {
		        	
		        },
		        onLoadError: function () {
		            
		        },
		        onClickCell: function (rowIndex, field, value) {
		            
		        },
		        onDblClickRow: function (rowIndex, rowData) {
		        	$("#updateGoodsTopForm").form("load",rowData);
		        	$("#updateGoodsTopDiv").window("open");
		        },
		        onClickRow:function(rowIndex,rowData){
		        	
		        },
		        loadFilter:function(data){
		        	if(!data.success){
		        		framework.dialog(data);
		        		return {};
		        	}else{
		        		var result = {
			        			total:data.result.total,
			        			rows:data.result.entry,
			        	};
			        	return result;
		        	}
		        }
		    });
			
			$("#addgoodsTop_submit").click(function(){
				$('#addgoodsTopForm').form('submit',
					{
					 onSubmit:function(){
						 
						return $(this).form('enableValidation').form('validate');
					 },
					 success:function(data){
						 window.framework.dialog(data);
						 data = $.parseJSON(data);
						 if (data.success) {
							 $('#selectgoodsTopPagation').datagrid("reload");
							 $("#addgoodsTopDiv").window("close");
						 }
						
						
					 }
				 });
			});
			
			$("#updateGoodsTop_submit").click(function(){
				$('#updateGoodsTopForm').form('submit',{
					 onSubmit:function(){
						return $(this).form('enableValidation').form('validate');
					 },
					 success:function(data){
						 $('#updateGoodsTopForm').form('clear');
						 $("#updateGoodsTopDiv").window("close");
						 $('#selectgoodsTopPagation').datagrid("reload");
						 window.framework.dialog(data);
					 }
				 });
			});
			
		});
	</script>
</body>
</html>