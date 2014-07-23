<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<html>
	<title>Home</title>

<body>
	    <form id="bbsImgform3" name="bbsImgform3" enctype="multipart/form-data" method="post" action="fileup.jsp">
		<input type="file" size="10" title="이미지추가" id="apndImg3" name="file">
		<input type="submit" value="upload">
		</form>
		
	    <form id="bbsImgform3" name="bbsImgform3" method="post" action="filedown.jsp">
		<input type="text" size="10" title="이미지추가" name="no">
		<input type="submit" value="download">
		</form>		
</body>
</html>
