<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, Model.Option" %>
<%
    List<Option> list = (List<Option>) request.getAttribute("variantList");
    if (list != null && !list.isEmpty()) {
        for (Option opt : list) {
%>
    <tr>
        <td>#<%= opt.getId() %></td>
        <td><%= opt.getOption_name() %></td>
        <td><%= opt.getPrice() %></td>
        <td><%= opt.getQuantity() %></td>
        <td>
            <button type='button' class='btn-delete' onclick="deleteVariant(<%= opt.getId() %>)">Xoá</button>
        </td>
    </tr>
<%
        }
    } else {
%>
    <tr><td colspan='5' style='text-align:center;color:#6b7280;'>Chưa có biến thể nào.</td></tr>
<%
    }
%>