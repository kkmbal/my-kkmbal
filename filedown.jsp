<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
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
	String no = request.getParameter("no");
	System.out.println(no);
	Class.forName("oracle.jdbc.driver.OracleDriver");
	con = DriverManager.getConnection("jdbc:oracle:thin:@127.0.0.1:1521:XE", "PX_PORTAL", "PX_PORTAL");
	pstmt = con.prepareStatement("SELECT NO,CONTS,NAME FROM TEST WHERE NO = ?");
	pstmt.setString(1, no);
	rs = pstmt.executeQuery();
	if(rs.next()){
		BLOB clob = ((OracleResultSet)rs).getBLOB("CONTS");
		//FileCopyUtils.copy(clob.getBytes(), new File("Y:\\Documents\\"+rs.getString("NAME")));
		//FileCopyUtils.copy(clob.getBytes(), new File("C:\\temp\\"+rs.getString("NAME")));
		
	    byte[] buffer = new byte[1024];
	
	    response.setContentType("application/octet-stream" + "; charset=UTF-8");
	    response.setHeader("Content-Disposition", "attachment; filename="+ rs.getString("NAME") + ";");		
		
	    BufferedInputStream fin = null;
	    BufferedOutputStream outs = null;
	    
	    try {
	      out.clear();
	      pageContext.pushBody();
	      //fin = new BufferedInputStream(new ByteArrayInputStream(clob.getBytes()));
	      fin = new BufferedInputStream(clob.binaryStreamValue());
	      outs = new BufferedOutputStream(response.getOutputStream());
	      int read = 0;
	      int idx=0;
	      while ((read = fin.read(buffer,0,1024)) != -1) {
	        outs.write(buffer, 0, read);
	        idx++;
	      }
	      //outs.write(clob.getBytes());
	      System.out.println("idx down============================="+idx);	
	      
	    } finally {
	      try {
	    	outs.flush();
	        outs.close();
	      } catch (Exception ex1) {
	      }

	      try {
	        fin.close();
	      } catch (Exception ex2) {

	      }
	    }	    
		
		
System.out.println("============================="+clob.getBytes().length);		
	}
		
	pstmt.close();
	rs.close();
	con.close();
		
}catch(Exception e){
	e.printStackTrace();
}finally{
	if(pstmt != null) try{ pstmt.close(); }catch (Exception e){}
	if(rs != null) try{ rs.close(); }catch(Exception e){}
	if(con != null) try{ con.close(); }catch(Exception e){}
}
%>