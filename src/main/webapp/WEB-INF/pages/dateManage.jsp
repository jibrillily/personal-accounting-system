<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/common/Head.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Insert title here</title>
    <link class="uiTheme" rel="stylesheet" type="text/css" href="${basePath}jquery-easyui-1.3.3/themes/<%=themeName %>/easyui.css">
    <link rel="stylesheet" type="text/css" href="${basePath}jquery-easyui-1.3.3/themes/icon.css">
    <style type="text/css">
        #date{
            width: 350px;
            height: 40px;
        }
    </style>
    <script type="text/javascript" src="${basePath}jquery-easyui-1.3.3/jquery.min.js"></script>
    <script type="text/javascript" src="${basePath}jquery-easyui-1.3.3/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="${basePath}jquery-easyui-1.3.3/locale/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript" src="${basePath}jquery-easyui-1.3.3/jquery.cookie.js"></script>
    <script type="text/javascript">
        var url;

        function searchSecurity() {
            var s_searchStarttime = $("#s_searchStarttime").datetimebox("getValue");
            var s_searchEndtime = $("#s_searchEndtime").datetimebox("getValue");
            if((s_searchStarttime!="")&&(s_searchEndtime!="")&&(s_searchStarttime>s_searchEndtime)){
                $.messager.alert("系统提示","起始时间不能大于截止时间！");
                return;
            }
            $("#dg").datagrid('load',{
                "username" : $("#s_username").val(),
                "company" : $("#s_company").val(),
                "dataid" : $("#s_dataid").combobox("getValue"),
                "searchStarttime":s_searchStarttime,
                "searchEndtime":s_searchEndtime
            });
        }

        function resetSearch() {
            $("#s_username").val("");
            $("#s_company").val("");
            $("#s_dataid").combobox("setValue", "");
            $("#s_searchStarttime").datetimebox("setValue","");
            $("#s_searchEndtime").datetimebox("setValue","");
        }

        function deleteSecurity() {
            var selectedRows = $("#dg").datagrid('getSelections');
            if (selectedRows.length == 0) {
                $.messager.alert("系统提示", "请选择要删除的数据！");
                return;
            }
            var strIds = [];
            for (var i = 0; i < selectedRows.length; i++) {
                strIds.push(selectedRows[i].id);
            }
            var ids = strIds.join(",");
            $.messager.confirm("系统提示", "您确认要删除这<font color=red>"
                + selectedRows.length + "</font>条数据吗？", function(r) {
                if (r) {
                    $.post("${basePath}/securitydelete.do", {
                        ids : ids
                    }, function(result) {
                        if (result.errres) {
                            $.messager.alert("系统提示", result.errmsg);
                            $("#dg").datagrid("reload");
                        } else {
                            $.messager.alert("系统提示", "数据删除失败！");
                        }
                    }, "json");
                }
            });
        }

        function openSecurityAddDialog() {
            $("#dlg").dialog("open").dialog("setTitle", "添加便条");
            url = "${basePath}securitysave.do";
        }

        function openSecurityModifyDialog() {
            var selectedRows = $("#dg").datagrid('getSelections');
            if (selectedRows.length != 1) {
                $.messager.alert("系统提示", "请选择一条要编辑的数据！");
                return;
            }
            var row = selectedRows[0];
            $("#dlg").dialog("open").dialog("setTitle", "编辑便条信息");
            $('#fm').form('load', row);
            url = "${basePath}securitysave.do?id=" + row.id;
        }

        function saveSecurity() {
            $("#fm").form("submit",{
                url : url,
                onSubmit : function() {
                    if ($("#dataid").combobox("getValue") == "" || $("#dataid").combobox("getValue") == null) {
                        $.messager.alert("系统提示", "请选择便条类型！");
                        return false;
                    }
                    var starttime = $("#starttime").datetimebox("getValue");
                    var endtime = $("#endtime").datetimebox("getValue");
                    if((starttime!="")&&(endtime!="")&&(starttime>endtime)){
                        $.messager.alert("系统提示","开始时间不能大于截止时间！");
                        return false;
                    }
                    return $(this).form("validate");
                },
                success : function(result) {
                    var result = eval('(' + result + ')');
                    if (result.errres) {
                        $.messager.alert("系统提示", result.errmsg);
                        resetValue();
                        $("#dlg").dialog("close");
                        $("#dg").datagrid("reload");
                    } else {
                        $.messager.alert("系统提示", result.errmsg);
                        return;
                    }
                }
            });
        }

        function resetValue() {
            $("#userid").val("");
            $("#securityname").val("");
            $("#securitypassward").val("");
            $("#company").val("");
            $("#starttime").datetimebox("setValue", "");
            $("#endtime").datetimebox("setValue", "");
            $("#dataid").combobox("setValue", "");
        }

        function closeSecurityDialog() {
            $("#dlg").dialog("close");
            resetValue();
        }
        function openSecurityFindDialog(){
            var selectedRows=$("#dg").datagrid('getSelections');
            if(selectedRows.length!=1){
                $.messager.alert("系统提示","请选择一条要查看的数据！");
                return;
            }
            var row=selectedRows[0];
            $("#finddlg").dialog("open").dialog("setTitle","查看便条信息");
            $("#fusername").text(row.username);
            $("#fsecurityname").text(row.securityname);
            $("#fsecuritypassward").text(row.securitypassward);
            $("#fcompany").text(row.company);
            $("#fdatadicvalue").text(row.datadicvalue);
            $("#fstarttime").text(row.starttime);
            $("#fendtime").text(row.endtime);
            $("#fcreatetime").text(row.createtime);
            $("#fupdatetime").text(row.updatetime);
        }

        function closeFindDialog(){
            $('#finddlg').dialog('close');
        }

    </script>
    <style>
        .findtable{
            border-width: 1px;
            border-color: #666666;
            border-collapse: collapse;
        }
        .findtable td{
            border-width: 1px;
            padding: 8px;
            border-style: solid;
            border-color: #666666;
            background-color: #ffffff;
        }
    </style>
</head>
<body style="margin: 1px;">
<table id="dg" title="便条管理" class="easyui-datagrid" fitColumns="true"
       pagination="true" rownumbers="true" url="${basePath}securitylist.do?roleid=${currentUser.roleid}&userid=${currentUser.id}"
       fit="true" toolbar="#tb" remoteSort="false" multiSort="true">
    <thead>
    <tr>
        <th field="cb" checkbox="true" align="center"></th>
        <th field="id" width="50" align="center" sortable="true">便条编号</th>
        <th field="username" width="100" align="center" sortable="true">便条标题</th>
        <th field="securityname" width="50" align="center" sortable="true">便条类型</th>
        <%--				<th field="securitypassward" width="100" align="center"  sortable="true">证券密码</th>--%>
        <%--				<th field="company" width="100" align="center" sortable="true">证券公司</th>--%>
        <th field="starttime" width="100" align="center" sortable="true">便条提醒开始时间</th>
        <th field="endtime" width="100" align="center" sortable="true">便条提醒结束时间</th>
        <th field="createtime" width="100" align="center" sortable="true">便条创建时间</th>
        <th field="company" width="100" align="center" sortable="true">便条创建者</th>
        <%--				<!-- <th field="createtime" width="100" align="center" sortable="true">创建时间</th>--%>
        <%--				<th field="updatetime" width="100" align="center" sortable="true">修改时间</th> -->--%>
    </tr>
    <tr>
        <th field="cb" checkbox="true" align="center"></th>
        <th field="id" width="50" align="center" sortable="true">2</th>
        <th field="username" width="100" align="center" sortable="true">腾讯游戏推广</th>
        <th field="securityname" width="50" align="center" sortable="true">工作提醒</th>
        <%--				<th field="securitypassward" width="100" align="center"  sortable="true">证券密码</th>--%>
        <%--				<th field="company" width="100" align="center" sortable="true">证券公司</th>--%>
        <th field="starttime" width="100" align="center" sortable="true">2022-05-12 00：00：01</th>
        <th field="endtime" width="100" align="center" sortable="true">2022-05-13 00：00：01</th>
        <th field="createtime" width="100" align="center" sortable="true">2022-05-01 09：14：24</th>
        <th field="company" width="100" align="center" sortable="true">1771404334xk </th>
        <%--				<!-- <th field="createtime" width="100" align="center" sortable="true">创建时间</th>--%>
        <%--				<th field="updatetime" width="100" align="center" sortable="true">修改时间</th> -->--%>
    </tr>

    <tr>
        <th field="cb" checkbox="true" align="center"></th>
        <th field="id" width="50" align="center" sortable="true">3</th>
        <th field="username" width="100" align="center" sortable="true">周末家庭聚会</th>
        <th field="securityname" width="50" align="center" sortable="true">个人提醒</th>
        <%--				<th field="securitypassward" width="100" align="center"  sortable="true">证券密码</th>--%>
        <%--				<th field="company" width="100" align="center" sortable="true">证券公司</th>--%>
        <th field="starttime" width="100" align="center" sortable="true">2022-05-14 00：00：01</th>
        <th field="endtime" width="100" align="center" sortable="true">2022-05-15 00：00：01</th>
        <th field="createtime" width="100" align="center" sortable="true">2022-05-05 11：24：51</th>
        <th field="company" width="100" align="center" sortable="true">1771404334xk </th>
        <%--				<!-- <th field="createtime" width="100" align="center" sortable="true">创建时间</th>--%>
        <%--				<th field="updatetime" width="100" align="center" sortable="true">修改时间</th> -->--%>
    </tr>

    <tr>
        <th field="cb" checkbox="true" align="center"></th>
        <th field="id" width="50" align="center" sortable="true">4</th>
        <th field="username" width="100" align="center" sortable="true">MySql知识讲座</th>
        <th field="securityname" width="50" align="center" sortable="true">学习提醒</th>
        <%--				<th field="securitypassward" width="100" align="center"  sortable="true">证券密码</th>--%>
        <%--				<th field="company" width="100" align="center" sortable="true">证券公司</th>--%>
        <th field="starttime" width="100" align="center" sortable="true">2022-05-13 00：00：01</th>
        <th field="endtime" width="100" align="center" sortable="true">2022-05-14 00：00：01</th>
        <th field="createtime" width="100" align="center" sortable="true">2022-05-08 17：35：47</th>
        <th field="company" width="100" align="center" sortable="true">1771404334xk </th>
        <%--				<!-- <th field="createtime" width="100" align="center" sortable="true">创建时间</th>--%>
        <%--				<th field="updatetime" width="100" align="center" sortable="true">修改时间</th> -->--%>
    </tr>

    <tr>
        <th field="cb" checkbox="true" align="center"></th>
        <th field="id" width="50" align="center" sortable="true">5</th>
        <th field="username" width="100" align="center" sortable="true">与女朋友看电影</th>
        <th field="securityname" width="50" align="center" sortable="true">个人提醒</th>
        <%--				<th field="securitypassward" width="100" align="center"  sortable="true">证券密码</th>--%>
        <%--				<th field="company" width="100" align="center" sortable="true">证券公司</th>--%>
        <th field="starttime" width="100" align="center" sortable="true">2022-05-19 00：00：01</th>
        <th field="endtime" width="100" align="center" sortable="true">2022-05-20 00：00：01</th>
        <th field="createtime" width="100" align="center" sortable="true">2022-05-15 13：17:45</th>
        <th field="company" width="100" align="center" sortable="true">1771404334xk </th>
        <%--				<!-- <th field="createtime" width="100" align="center" sortable="true">创建时间</th>--%>
        <%--				<th field="updatetime" width="100" align="center" sortable="true">修改时间</th> -->--%>
    </tr>
    </thead>
</table>
<div id="tb">
    <div>
        <a href="javascript:openSecurityAddDialog()" class="easyui-linkbutton"
           iconCls="icon-add" plain="true">添加</a> <a
            href="javascript:openSecurityModifyDialog()" class="easyui-linkbutton"
            iconCls="icon-edit" plain="true">修改</a> <a
            href="javascript:deleteSecurity()" class="easyui-linkbutton"
            iconCls="icon-remove" plain="true">删除</a>
        <a href="javascript:openSecurityFindDialog()" class="easyui-linkbutton" iconCls="icon-lsdd" plain="true">查看详细</a>
    </div>
    <div>
        &nbsp;便条创建者：&nbsp;<input type="text" id="s_username" size="12" onkeydown="if(event.keyCode==13) searchSecurity()" />
        &nbsp;便条标题：&nbsp;<input type="text" id="s_company" size="12" onkeydown="if(event.keyCode==13) searchSecurity()" />
        &nbsp;便条类型：&nbsp;<select class="easyui-combobox" id="s_dataid" editable="false" style="width: 100px;">
        <option value="">请选择...</option>
        <c:forEach items="${securitys }" var="security">
            <option value="${security.id }">${security.datadicvalue }</option>
        </c:forEach>
    </select>&nbsp;
        &nbsp;便条的开始和结束时间：&nbsp;<input type="text" id="s_searchStarttime" class="easyui-datetimebox" size="18" onkeydown="if(event.keyCode==13) searchSecurity()"/>
        <span style="font-weight:bold;">&sim;</span>&nbsp;<input type="text" id="s_searchEndtime" class="easyui-datetimebox" size="18" onkeydown="if(event.keyCode==13) searchSecurity()"/>
        <a href="javascript:searchSecurity()" class="easyui-linkbutton" iconCls="icon-search" plain="true">搜索</a>
        <a href="javascript:resetSearch()" class="easyui-linkbutton" iconCls="icon-reset" plain="true">清空</a>
    </div>
</div>

<div id="dlg" class="easyui-dialog" style="width: 730px; height: 250px; padding: 10px 20px" closed="true" buttons="#dlg-buttons">
    <form id="fm" method="post">
        <table cellspacing="8px">
            <tr>
                <td>便条创建者：</td>
                <td><select class="easyui-combobox" id="userid" name="userid" editable="true" style="width: 175px;">
                    <option value="">请选择...</option>
                    <c:forEach items="${allUsers }" var="alluser">
                        <option value="${alluser.id }">${alluser.username }</option>
                    </c:forEach>
                </select>&nbsp;<font color="red">*</font>
                </td>
                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                <td>便条标题：</td>
                <td><input type="text" id="securityname" name="securityname"
                           class="easyui-validatebox easyui-textbox" required="true" />&nbsp;<font
                        color="red">*</font></td>
            </tr>
            <%--				<tr>--%>
            <%--					<td>证券密码：</td>--%>
            <%--					<td><input type="text" id="securitypassward" name="securitypassward"--%>
            <%--						class="easyui-validatebox easyui-textbox" required="true" />&nbsp;<font--%>
            <%--						color="red">*</font></td>--%>
            <%--					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>--%>
            <%--					<td>证券公司：</td>--%>
            <%--					<td><input type="text" id="company" name="company"--%>
            <%--						class="easyui-validatebox easyui-textbox" required="true" />&nbsp;<font--%>
            <%--						color="red">*</font></td>--%>
            <%--				</tr>--%>
            <tr>
                <td>便条类型：</td>
                <td><select class="easyui-combobox" id="dataid" name="dataid"
                            editable="false" style="width: 175px;">
                    <option value="">请选择便条类型...</option>
                    <c:forEach items="${securitys }" var="security">
                        <option value="${security.id }">${security.datadicvalue }</option>
                    </c:forEach>
                </select>&nbsp;<font color="red">*</font></td>
                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                <td>便条提醒开始时间：</td>
                <td><input id="starttime" name="starttime" class="easyui-datetimebox" required="true" style="width:175px">&nbsp;<font
                        color="red">*</font></td>
            </tr>
            <tr>
                <td>便条提醒结束时间：</td>
                <td><input id="endtime" name="endtime" class="easyui-datetimebox" required="true" style="width:175px">&nbsp;<font
                        color="red">*</font></td>
            </tr>
        </table>
        <tr>
            <td>便条内容:</td>
            <td><input id="date" name="date" type="text"  srequired="true" >&nbsp;<font
                    color="red">*</font></td>
        </tr>
    </form>
</div>
<div id="dlg-buttons">
    <a href="javascript:saveSecurity()" class="easyui-linkbutton" iconCls="icon-ok">保存</a>
    <a href="javascript:closeSecurityDialog()" class="easyui-linkbutton" iconCls="icon-cancel">关闭</a>
</div>
<div id="finddlg" class="easyui-dialog" style="width: 670px;height:300px;padding: 10px 20px" closed="true" buttons="#finddlg-buttons">
    <table cellspacing="8px" class="findtable" width="100%">
        <tr>
            <td>便条创建者：</td>
            <td><span id="fusername"></span></td>
            <td>便条标题：</td>
            <td><span id="fsecurityname"></span></td>
        </tr>
        <%--	 		<tr>--%>
        <%--	 			<td>证券密码：</td>--%>
        <%--	 			<td><span id="fsecuritypassward"></span></td>--%>
        <%--	 			<td>证券公司：</td>--%>
        <%--	 			<td><span id="fcompany"></span></td>--%>
        <%--	 		</tr>--%>
        <tr>
            <td>便条类型：</td>
            <td><span id="fdatadicvalue"></span></td>
            <td>便条提醒开始时间：</td>
            <td><span id="fstarttime"></span></td>
        </tr>
        <tr>
            <td>便条提醒结束时间：</td>
            <td><span id="fendtime"></span></td>
            <td>便条创建时间：</td>
            <td><span id="fcreatetime"></span></td>
        </tr>
        <tr>
            <td>修改时间：</td>
            <td><span id="fupdatetime"></span></td>
        </tr>
    </table>
</div>
<div id="finddlg-buttons">
    <a href="javascript:closeFindDialog()" class="easyui-linkbutton" iconCls="icon-ok">确定</a>
</div>
</body>
</html>