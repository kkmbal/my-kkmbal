<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="oracle.jdbc.*" %>
<%@ page import="oracle.sql.*" %>
<%@ page import="org.springframework.util.*" %>
<%
Connection con = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

try{
//	MultipartRequest multi = new MultipartRequest(request, "Y:/Downloads/aaaa/", 1000*1024*1024, "UTF-8", new DefaultFileRenamePolicy());
	MultipartRequest multi = new MultipartRequest(request, "C:/Temp/", 1000*1024*1024, "UTF-8", new DefaultFileRenamePolicy());
	Enumeration files = multi.getFileNames();
	if(files.hasMoreElements())
	{
		Class.forName("oracle.jdbc.driver.OracleDriver");
		con = DriverManager.getConnection("jdbc:oracle:thin:@127.0.0.1:1521:XE", "PX_PORTAL", "PX_PORTAL");
		con.setAutoCommit(false);
		
		String name =(String)files.nextElement();
		File file = multi.getFile(name);
		byte[] conts = FileCopyUtils.copyToByteArray(file);
		pstmt = con.prepareStatement("INSERT INTO TEST(NO,NAME,CONTS) VALUES (SEQ_TEST.NEXTVAL, ?, EMPTY_BLOB())");
		pstmt.setString(1, file.getName());
		pstmt.executeUpdate();
		pstmt.close();
		
		pstmt = con.prepareStatement("SELECT CONTS FROM TEST WHERE NO = (SELECT MAX(NO) FROM TEST) FOR UPDATE");
		rs = pstmt.executeQuery();
		
		if(rs.next()){
			BLOB clob = ((OracleResultSet)rs).getBLOB("CONTS");
			//OutputStream writer = clob.getAsciiOutputStream();
		    System.out.println(">>>>>"+conts.length);
			//writer.write(conts);
			OutputStream writer = clob.getBinaryOutputStream();
			//byte[] buff = new byte[1024];
			//InputStreamReader src = new InputStreamReader(new ByteArrayInputStream(conts));
			ByteArrayInputStream src = new ByteArrayInputStream(conts);
			
			
			//CharArrayReader src = new CharArrayReader();
			byte[] buf = new byte[1024];
			int read=0;
			int idx=0;
			while((read=src.read(buf,0,1024)) != -1){
				writer.write(buf,0,read);
				idx++;
			}
			
			writer.close();
			System.out.println("idx up============================="+idx);		
		}
		pstmt.close();
		rs.close();
		con.commit();
		con.setAutoCommit(true);
		
		con.close();
		
		
	  }
}catch(Exception e){
	e.printStackTrace();
}finally{
	if(pstmt != null) try{ pstmt.close(); }catch (Exception e){}
	if(rs != null) try{ rs.close(); }catch(Exception e){}
	if(con != null) try{ con.close(); }catch(Exception e){}
}
%>
