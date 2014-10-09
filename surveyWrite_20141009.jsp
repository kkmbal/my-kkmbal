<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<title>설문조사</title>
<%@ include file="/WEB-INF/jsp/portalxpert/common/inc/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/portalxpert/common/inc/jsLibs.jsp"%>
<%
String uploadFileExecutePath = "";
try{
	egovframework.rte.fdl.property.EgovPropertyService propertiesService = (egovframework.rte.fdl.property.EgovPropertyService)kr.or.gwp.cmmn.util.SpringContextManager.getBean("propertiesService");
	uploadFileExecutePath = propertiesService.getString("namo.uploadFileExecutePath");
}catch(Exception ex){}
%>

<script type="text/javascript">
    
    var loadingComplete = false;
    
    var write_apnd_kind = '010';
    var jsonAppendImgList = [];  //이미지 리스트
    var jsonAppendMovList = [];  //동영상 리스트
    var jsonAppendResearchList = [];//설문 보기 리스트
    var jsonAppendFileList = [];  //첨부 리스트
    var deptName = '${deptName}';
    var tmpNotiSeq = '${tmpNotiSeq}';
    var boardId = '${boardId}';
    var userId = '${userId}';
    var nojoYn = '${nojoYn}';
    var notiWriteId = '${notiWriteId}';
    var boardKind = '${boardKind}';
    var moblOpenYN = '${moblOpenYN}';
    var moblOpenDiv = '${moblOpenDiv}';
    var editDiv = '${editDiv}';
    var opnWrteDiv = '${opnWrteDiv}';
    var replyPrmsDiv = '${replyPrmsDiv}';
    var nickUseYn = '${nickUseYn}';
    var makrDispDiv = '${makrDispDiv}';  //작성자 표기 구분
    var agrmOppUseYn = '${agrmOppUseYn}';  //찬/반 구분
    var pnum = '${pnum}';
    
    var isAdmin = '${isAdmin}';
    var notiId = '${notiId}';
    var basicCloseDttm = '${basicCloseDttm}';
    var boardForm = '${boardForm}';
    var boardFormSpec = '${boardFormSpec}';
    var notiReadmanAsgnYn = '${notiReadmanAsgnYn}';
    var kind = '${kind}';
    var pageIndex = '${pageIndex}';
    var WEB_DIR = '${WEB_DIR}';
    var SAVE_DIR = '${SAVE_DIR}';
    var tempWeb = '${tempWeb}';
    var userDiv ;
    var userName;
    var insertMode = "insert";
    
    var imgUploadMax = ${imgUploadMax};
    var imgUploadSize = ${imgUploadSize};
    var apndUploadMax = ${apndUploadMax};
    var apndUploadSize = ${apndUploadSize};
    var surveyUploadMax = ${surveyUploadMax};
    var surveyUploadView = ${surveyUploadView};
    var surveyGrpQuestionCnt = 10;
    
    var upNotiId = '${upNotiId}';
    
    var apndFileSz = '${apndFileSz}';  //파일 업로드 제한사이즈
    
    if (boardId == 'BBS999999')
    {
        apndFileSz = 50000;
    }
    
    var boardExplUseYn = '${boardExplUseYn}';
    var boardExpl = '${boardExpl}';
    var webMovieDir = "";
    var WEB_MOVIE_DIR = '${WEB_MOVIE_DIR}';
    
    //파일업로드목록
    var savedApndList = ${apndList};
    var userMapList = ${userMapList};
    
    //임시
    var tmpNotiList = ${tmpNotiList};
    var tmpApndList = ${tmpApndList};
    var tmpUserList = ${tmpUserList};
    var tmpSurveyList = ${tmpSurveyList};
    var tmpSurveyExmplList = ${tmpSurveyExmplList};
    
    //글수정
    var notiList = ${notiList};
    var surveyList = ${surveyList};
    var surveyExmplList = ${surveyExmplList};
    var surveyAnswList = ${surveyAnswList};
    
    //답글
    var reply_list = ${reply_list};
    
    var itemCnt = 0;
    var no = 0;
    var c_no = 0;//생성시 사용 넘버: 추가시 증가만 되고, 삭제로인해 변경되지 않음
    var arNo = new Array();
    var arSelBoxVal = new Array();
    
    var modifyFlag = 'N';
    var scrollheight = "700";
</script>

<script type="text/javascript">
var fnLoadPage = function()
{
    fnFrameReload();
};



//
var fnUnLoadPage = function()
{
};

// rePaint
var fnFrameReload = function()
{
	scrollheight = $('.container').height();
   // parent.document.getElementById("bbsFrame").height = "700px";
    parent.document.getElementById("bbsFrame").height = scrollheight+100+"px"; //document.body.scrollHeight+400+"px";  
};

//선택한 이미지 삭제
var fnImgListRemove = function(id)
{

    for(var i=0; i < jsonAppendImgList.length; i++)
    {
        var json = jsonAppendImgList[i];
        var fileId = json.apndFileName;
        var arrFileId = fileId.split(".");
        if (arrFileId[0] == id)
        {
            jsonAppendImgList.splice(i,1);
            break;
        }
    }
    $("#"+id).remove();
    
    
    fnFrameReload();
};

//동영상 리스트 삭제
var fnMovieListRemove = function(id)
{
    for(var i=0; i < jsonAppendMovList.length; i++)
    {
        var json = jsonAppendMovList[i];
        var fileId = json.mvpKey;
        if(fileId == id)
        {
            jsonAppendMovList.splice(i,1);
            break;
        }
    }
    $("#del_movie_apnd-"+id).remove();   
    fnFrameReload();
}


//설문에서 선택한 이미지 삭제
var fnResearchListRemove = function(id, cnt)
{
    for(var i=0; i < jsonAppendResearchList.length; i++)
    {
        var json = jsonAppendResearchList[i];
        if (json.apndFileId == id)
        {
            jsonAppendResearchList.splice(i,1);
            break;
        }
    }
    //첨부파일 경로 삭제 후 이미지 객체 삭제
    
    //$("#"+id).prev().children().children().val("");
    $('#txt_view-'+cnt).val("(이미지: 가로240px, 세로180px)");
    $('#viewFile-'+cnt).val("");
    $("#"+id).remove();
}

//두자리 리턴
var fnTwoDigit = function(ddd)
{
    var Result = '00';
    if (ddd.length == 1){
        Result = '0'+ddd;
    }else{
        Result = ddd;
    }
    return Result;
};

var fnSetCalendar = function()
{
    $('#openCloseDate').datepicker(
    {
            showOn: "button",     
            buttonImage: RES_HOME+'/images/ico_calendar_off.png',      
            buttonImageOnly: true,
            buttonText: "게시종료일자",
            showButtonPanel: true,
            onSelect:function (dateText, inst){
                var nowdate = new Date();                        
                var date_str = nowdate.getFullYear() + '-' + fnTwoDigit(''+(nowdate.getMonth()+1)) + '-' + fnTwoDigit(''+nowdate.getDate());
                if (dateText < date_str)
                {
                    alert('현재 일자 보다 작을 수 없습니다.');
                    $( "#openCloseDate" ).datepicker( "setDate", new Date() );
                }
            }
    });     
    $( "#openCloseDate" ).datepicker( "setDate", basicCloseDttm );
    
    /*
    $('img.ui-datepicker-trigger').attr('style','margin-left:-7px; vertical-align:middle; cursor:pointer;');
    
     $('img.ui-datepicker-trigger').click(function(){
        $('.ui-datepicker').css('left', $(this).position().left+150);
    }); 
    */  
     
     $('#openReserveDate').datepicker(
                {
                    showOn: "button",     
                    buttonImage: RES_HOME+'/images/ico_calendar_off.png',      
                    buttonImageOnly: true,
                    buttonText: "게시시작일자",
                    showButtonPanel: true,
                    onSelect:function (dateText, inst){
                        var nowdate = new Date();                        
                        var date_str = nowdate.getFullYear() + '-' + fnTwoDigit(''+(nowdate.getMonth()+1)) + '-' + fnTwoDigit(''+nowdate.getDate());
                        if (dateText < date_str)
                        {
                            alert('현재 일자 보다 작을 수 없습니다.');
                            $( "#openReserveDate" ).datepicker( "setDate", new Date() );
                        }
                    }
                }
    );
    $( "#openReserveDate" ).datepicker( "setDate", new Date() );
    
    /*
    $('img.ui-datepicker-trigger').attr('style','margin-left:-7px; vertical-align:middle; cursor:pointer;');
        
     $('img.ui-datepicker-trigger').click(function(){
            $('.ui-datepicker').css('margin-left', $(this).position().left-400+"px");
    });
    */
     
    $('#start_date').datepicker(
                {
                    showOn: "button",     
                    buttonImage: RES_HOME+'/images/ico_calendar_off.png',      
                    buttonImageOnly: true,
                    buttonText: "설문시작일자",
                    showButtonPanel: true,
                    beforeShow: function (input, inst){
                        
                    },
                    onSelect:function (dateText, inst){
                        var nowdate = new Date();                        
                        var date_str = nowdate.getFullYear() + '-' + fnTwoDigit(''+(nowdate.getMonth()+1)) + '-' + fnTwoDigit(''+nowdate.getDate());
                        if (dateText < date_str)
                        {
                            alert('현재 일자 보다 작을 수 없습니다.');
                            $( "#start_date" ).datepicker( "setDate", new Date() );
                        }
                    },
                     onChangeMonthYear: function (){
                         $('.ui-datepicker').append('<iframe  frameborder="1" ></iframe>');
    
                    }
                }
    );
     
     $( "#start_date" ).datepicker( "setDate", new Date() );
     
     $('#close_date').datepicker(
                {
                    showOn: "button",     
                    buttonImage: RES_HOME+'/images/ico_calendar_off.png',      
                    buttonImageOnly: true,
                    buttonText: "설문마감일자",
                    showButtonPanel: true,
                    beforeShow: function (input, inst){
                        
                    },
                    onSelect:function (dateText, inst){
                        var nowdate = new Date();                        
                        var date_str = nowdate.getFullYear() + '-' + fnTwoDigit(''+(nowdate.getMonth()+1)) + '-' + fnTwoDigit(''+nowdate.getDate());
                        if (dateText < date_str)
                        {
                            alert('현재 일자 보다 작을 수 없습니다.');
                            $( "#close_date" ).datepicker( "setDate", new Date() );
                        }
                    },
                     onChangeMonthYear: function (){
                         $('.ui-datepicker').append('<iframe  frameborder="1" ></iframe>');

                    }
                }
    );
     
     $( "#close_date" ).datepicker( "setDate", new Date() );
        
    /*
     $('img.ui-datepicker-trigger').attr('style','margin-left:-7px; vertical-align:middle; cursor:pointer;');
    
     $('img.ui-datepicker-trigger').click(function(){
            
            var id =$(this).parent().find("input").attr("id");
            
            $('.ui-datepicker').css('margin-left', '0px');
            $('.ui-datepicker').css('margin-top', '0px');
            
            if (id == 'close_date')
            {
                $('.ui-datepicker').css('left', $(this).position().left+20);
                $('.ui-datepicker').css('top', $(this).position().top-100);
                

            }
            else if (id == 'openCloseDate')
            {
                $('.ui-datepicker').css('left', $(this).position().left+20);
                $('.ui-datepicker').css('top', $(this).position().top-10);
            }
            else
            {
                $('.ui-datepicker').css('left', $(this).position().left+20);
                $('.ui-datepicker').css('top', $(this).position().top-110);
            }
                        
            
            var ifm_h = $('.ui-datepicker').height()+2;
            var ifm_w = $('.ui-datepicker').width();
            $('.ui-datepicker iframe').remove();
            $('.ui-datepicker').append('<iframe  frameborder="0" ></iframe>');
            $('.ui-datepicker iframe').css({
                'height':ifm_h,
                'width':'200px',
                'position':'absolute',
                'top':'-1px',
                'left':'-1px',
                'z-index':'-1'
            });
    });
    */
     $('img.ui-datepicker-trigger').attr('style','margin-left:-7px; vertical-align:middle; cursor:pointer;');
};

//공개여부 부서지정 삭제
var fnOpenDeptListRemove = function(id)
{
    $("#OpenDeptCategories #"+id).remove();
};

//공개여부 개인지정 삭제
var fnOpenPersonListRemove = function(id)
{
   $("#OpenEmpCategories #"+id).remove();
};

//공개여부 조직도(부서)
var callbackOpenDept = function(data){
    
    var json = $.parseJSON(data);       
    for (var i=0; i < json.length; i++)
    {
        var contains = false;
        $obj = $('#OpenDeptCategories li');
        for( var j=0; j < $obj.length; j++)
        {
            if ($obj.eq(j).attr("id") == json[i].id)
            {
                contains = true;
                break;
            }
        }           
        if (!contains) $('#OpenDeptCategories').append('<li id="'+json[i].id+'"><a class="ico_del" style="cursor:pointer;" onclick="javascript:fnOpenDeptListRemove(\''+json[i].id+'\')" ></a>'+json[i].name+'</li>');
    }
};

//공개여부 조직도(개인)
var callbackOpenPerson = function(data){

    var json = $.parseJSON(data);       
    for (var i=0; i < json.length; i++)
    {
        var contains = false;
        $obj = $('#OpenEmpCategories li');
        for( var j=0; j < $obj.length; j++)
        {
            if ($obj.eq(j).attr("id") == json[i].id)
            {
                contains = true;
                break;
            };
        };  
        if (!contains) $('#OpenEmpCategories').append('<li id="'+json[i].id+'"><a class="ico_del" style="cursor:pointer;" onclick="javascript:fnOpenPersonListRemove(\''+json[i].id+'\')" ></a>'+json[i].ou+' '+json[i].name+'</li>');
    };
};

//부서코드 콜백 함수
var callbackCdlnDeptFname = function(data)
{
    var json = $.parseJSON(data);
    
    //$('#cdlnDeptFname').val(json[0].name); 
}

//게시물 저장
var fnBoardNotiCreate = function()
{
    var notiTitle = $("#txt_title").val().replace(/</g,"&lt;").replace(/>/g,"&gt;");
    var notiTitleOrgn = $("#txt_title").val().replace(/</g,"&lt;").replace(/>/g,"&gt;"); 
    
    var titleBoldYn = "N";
    var titleColorDiv = " ";
    
    if ($("#rt1").is(":checked")){
        titleBoldYn = "Y";
        notiTitle = "<b>"+notiTitle+"</b>";
    }
    
    if ($("#rt3").is(":checked")){      
        titleColorDiv = "RED";
        notiTitle = "<font color='red'>"+notiTitle+"</font>";
    }
    else
    {
        if ($("#rt2").is(":checked")){      
            titleColorDiv = "BLU";
            notiTitle = "<font color='blue'>"+notiTitle+"</font>";
        }
    }
    
    //var notiConts = tinymce.activeEditor.getContent();
    var notiConts = CrossEditor.GetBodyValue();

    var linkUrl = "";
    var notiTP = "010";
    
    var moblOpenDiv = $(':radio[name="moblOpenDiv"]:checked').val();
    var notiKind = write_apnd_kind;
    if(!notiKind){
        notiKind = "010";
    }
    var nickUseYn = "N";

    if ($("#nickUseYn").is(":checked")){
        nickUseYn = "Y";
    }
    
    var userNick = $("#txt_nickname").val();
    
    var editDiv = "010";
    var rsrvYN = 'N';
    
    var nowdate = new Date();   
    var openReserveDate = '';
    var openReserveHour = fnTwoDigit(''+nowdate.getHours());
    var openReserveMin = fnTwoDigit(''+nowdate.getMinutes())+":"+ fnTwoDigit(''+nowdate.getSeconds());
    
    if ($("#chkReserveDate").is(":checked")){
        rsrvYN = 'Y';
        if($('#openReserveHour').length > 0){
            openReserveHour = $('#openReserveHour option:selected').val();
        }
        if($('#openReserveMin').length > 0){
            openReserveMin = $('#openReserveMin option:selected').val()+':00';
        }
    }
    
    var openReserveDate = $('#openReserveDate').val();
    var notiBgnDttm = openReserveDate+' '+openReserveHour+":"+openReserveMin;//$('#openReserveDate').val();
    
    var notiEndDttm = null;
    if($('#openCloseDate').val()){
        notiEndDttm = $('#openCloseDate').val()+' 23:59:59';
    }else{
        notiEndDttm = "9999-12-31 23:59:59";
    }
    
    if(write_apnd_kind == '040')//설문일 경우 게시일자=설문일자
    {
        var startDate = $('#start_date').val();;
        var startHour = $('#start_hour option:selected').val();
        var startMin = $('#start_min option:selected').val()+':00';
        notiBgnDttm = startDate+' '+startHour+":"+startMin;
        var limit_day  = $("#close_date").val();  
        var limit_hour = $('#inp_hour option:selected').val(); 
        var limit_min  = $('#inp_min option:selected').val();  
        notiEndDttm = limit_day+' '+limit_hour+":"+limit_min;
    }
    
    //var notiOpenDiv = $(':radio[name="notiOpenDiv"]:checked').val();
    var notiOpenDiv = $('#notiOpenDiv').val();
    
    var agrmOppYn = 'N';
    if ($("#agrmOppYN").is(":checked")){
        agrmOppYn = 'Y';
    }
    
    var anmtYn = 'N';
    
    if ($("#rt4").is(":checked")){
        anmtYn = 'Y';
    };
    
    var notiOpenDivSpec='';
    if (userDiv == 'ALL'){
        notiOpenDivSpec = '010';
    }else if (userDiv == 'PUB'){
        notiOpenDivSpec = '020';
    }else if (userDiv == 'SGU'){
        notiOpenDivSpec = '030';
    }else if (userDiv == 'ADM'){
		notiOpenDivSpec = '040';
	}
    
    var opnPrmsYN = 'N';    
    if ($("#opnPrmsYN").is(":checked")){
        opnPrmsYN = 'Y';
    };
    
    
    var replyPrmsYn = 'N';  
    if ($("#replyPrmsYn").is(":checked")){
        replyPrmsYn = 'Y';
    };
    
    
    var opnMakrRealnameYn = $(':radio[name="opnMarkRealNameYN"]:checked').val();
    
    var notiTagLst = $("#txt_tag").val();
    if(notiTagLst){
        if (notiTagLst == '태그는 10개 이하로 입력 가능하며 쉼표로 구분합니다.')
        {
            notiTagLst = '';
        }
        
        var notiTagLstArr = notiTagLst.split(",");
        
        if (notiTagLstArr.length > 9)
        {
            alert('태그는 10개 이하로 입력 가능합니다. ');
            return;
        }
    }
    

    if (upNotiId == '') upNotiId = '*';
    
    
    var cdlnEvntCode = '';
    var cdlnObjrName = '';
    var cdlnDeptFname = '';
    var cdlnDeptName = '';
    var cdlnDeptCode = '';
    
    if (boardKind == '030')
    {
        cdlnEvntCode =  $('#cdlnEvntCode option:selected').val();
        
        if (cdlnEvntCode == 'null')
        {
            alert('경조사 구분을 선택하세요');
            return;
        }
        
        cdlnObjrName =  $('#cdlnObjrName').val();   
        if (cdlnObjrName == "")
        {
            alert('대상자를 입력하세요');
            return;
        }
        
        cdlnDeptFname =  $('#cdlnDeptFname').val();
        if (cdlnDeptFname == "")
        {
            alert('소속기관을 입력하세요');
            return;
        }
        
        cdlnDeptName =  $('#cdlnDeptName').val();
        if (cdlnDeptName == "")
        {
            alert('소속부서를 입력하세요');
            return;
        }
        
    }
    
    var jsonWriteObject = {
         'notiId' : notiId
        , 'upNotiId' : upNotiId
        , 'sortSeq' : '0'
        , 'boardId' : boardId
        , 'emgcYn' : 'N'
        , 'anmtYn' : anmtYn
        , 'popupYn' : 'N'  
        , 'briefYn' : 'N'
        , 'moblOpenDiv' : moblOpenDiv
        , 'notiTitle' : notiTitle
        , 'notiTitleOrgn' : notiTitleOrgn
        , 'titleBoldYn' : titleBoldYn
        , 'titleColorDiv' : titleColorDiv
        , 'notiConts' : notiConts
        //, 'notiConts' : ''
        , 'linkUrl' : linkUrl
        , 'notiTp' : notiTP
        , 'notiKind' : notiKind
        , 'nickUseYn' : nickUseYn
        , 'userId' : userId
        , 'userNick' : userNick
        , 'userName' : userName
        , 'editDiv' : editDiv
        , 'rsrvYn' : rsrvYN
        , 'notiBgnDttm' : notiBgnDttm
        , 'notiEndDttm' : notiEndDttm
        , 'notiOpenDiv' : notiOpenDiv
        , 'notiOpenDivSpec' : notiOpenDivSpec
        , 'publAsgnDiv' : ''
        , 'publAsgnDivSpec' : ''
        , 'replyPrmsYn' : replyPrmsYn
        , 'replyMakrRealnameYn' : 'N'  
        , 'opnPrmsYn' : opnPrmsYN   //작성자 실명여부
        , 'opnMakrRealnameYn' : opnMakrRealnameYn  //실명여부
        , 'notiTagLst' : notiTagLst  
        , 'notiReadCnt' : '0'
        , 'notiOpnCnt' : '0'
        , 'notiAgrmCnt' : '0'
        , 'notiOppCnt' : '0'
        , 'notiLikeCnt' : '0'
        , 'moblSendCnt' : '0'
        , 'bfBoardId' : ''
        , 'bfNotiId' : ''
        , 'statCode' : ''
        , 'deptCode' : ''
        , 'deptName' : ''
        , 'deptFname' : ''
        , 'makrIp' : ''
        , 'brghCode' : ''
        , 'cdlnDeptCode' : cdlnDeptCode
        , 'cdlnDeptName' : cdlnDeptName
        , 'cdlnDeptFname' : cdlnDeptFname
        , 'cdlnObjrName' : cdlnObjrName
        , 'cdlnEvntCode' : cdlnEvntCode
        , 'delYn' : 'N'
        , 'regrId' : notiWriteId
        , 'regrName' : ''
        , 'regDttm' : ''
        , 'updrId' : notiWriteId
        , 'updrName' : ''
        , 'updDttm' : ''
        , 'oldBrdId' : ''
        , 'oldHeaderId' : ''
        , 'oldOrignalId' : ''
        , 'oldNoticeSeq' : ''
        , 'agrmOppYn' : agrmOppYn
        , 'notiReadmanAsgnYn' : notiReadmanAsgnYn
        , 'isAdmin' : isAdmin
        , 'AppendList' : []         
        , 'AppendFileList' : []  //첨부 리스트
        , 'NotiOpenDivDeptList' : []  // 조회자 지정 부서
        , 'NotiOpenDivEmpList' : []   // 조회자 지정 개인
        
    };
    
    //게시자 지정 부서지정
    $obj = $('#OpenDeptCategories li'); 
    for( var i=0; i < $obj.length; i++)
    {
        var jsonObject = {
                'id' : $obj.eq(i).attr("id"),
                'name' : $obj.eq(i).text(),
                'div'  : 'DPT',
                'auth' : 'RED'
        };
        jsonWriteObject.NotiOpenDivDeptList[i] = jsonObject;
    }

    //게시자 지정 개인지정
    $obj = $('#OpenEmpCategories li');  
    for( var i=0; i < $obj.length; i++)
    {
        var jsonObject = {
                'id' : $obj.eq(i).attr("id"),
                'name' : $obj.eq(i).text(),
                'div'  : 'EMP',
                'auth' : 'RED'
        };
        jsonWriteObject.NotiOpenDivEmpList[i] = jsonObject;
    }

    if (write_apnd_kind == '020')  //이미지
    {
       if (jsonAppendImgList.length == 0)
       {
          alert('추가한 이미지가 없습니다. 이미지를 추가하세요');
          return;
       }
       jsonWriteObject.AppendList=jsonAppendImgList;
    }
    else if (write_apnd_kind == '030')  //동영상
    {
        
        if (jsonAppendMovList.length == 0)
        {
            alert('추가한 동영상이 없습니다. 동영상을 추가하세요');
            return;
        }
        jsonWriteObject.AppendList=jsonAppendMovList;
    }
    else if (write_apnd_kind == '040')  //설문
    {
        var jsonSurveyObjectList = [];                  
        var start_day  = $("#start_date").val();  //시작 일자
        var start_hour = $('#start_hour option:selected').val(); //시간             
        var start_min  = $('#start_min option:selected').val();   //분
        var limit_day  = $("#close_date").val();  //마감 일자
        var limit_hour = $('#inp_hour option:selected').val(); //시간         
        var limit_min  = $('#inp_min option:selected').val();   //분

        var rshOpenYn  = $(':radio[name="researchOpenYn"]:checked').val(); //공개여부
       
        for(var i=0; i < arNo.length; i++)  //질문갯수
        {                                            
            var tableCnt = $('#tableCnt-'+arNo[i]).val();               
            for(var j=1; j<=tableCnt; j++)
            {
         	 //설문 기본정보
                var surveyJsonObject = {
                 'surveyNo' : '0'
                , 'relaNotiKind' : ''
                , 'notiId' : ''
                , 'tmpNotiSeq' : '0'
                , 'tmlnSeq' : '0'
                , 'userNotiSeq' : '0'
                , 'surveyOpenDttm' : ''
                , 'surveyClosDttm' : ''
                , 'surveyRsltOpenYn' : ''
                , 'surveyConts' : ''
                , 'surveyTp' : ''
                , 'delYn' : 'N'
                , 'regrId' : ''
                , 'regrName' : ''
                , 'regDttm' : ''
                , 'updrId' : ''
                , 'updrName' : ''
                , 'updDttm' : ''
                , 'surveyForm' : ''
                , 'grpSurveyNo' : '0'
                , 'grpSurveyCnt' : '0'
           	   , 'exmplTp' : ''
   			   , 'inputAddYn' : ''
   		       , 'skipPermitYn' : ''
   		       , 'multiSelPermitYn' : ''      		    	
                , 'apndExmpList' : []
                };            	             	 
         	 
         	   var surveyConts = $('#txt_area-'+arNo[i]+'-'+j).val();  
         	   var view_type = $(':radio[name="radio_name-'+arNo[i]+'-'+j+'"]:checked').val();
         	   var inputAddYn = '';
         	   if($('#input_plus-'+arNo[i]+'-'+j).is(":checked"))
         	   {
         		   inputAddYn = 'Y';
         	   }
         	   else
         	   {
         		   inputAddYn = 'N';
         	   }
         	   var skipPermitYn = '';
                if($('#chk_skip-'+arNo[i]+'-'+j).is(":checked"))
                {
             	   skipPermitYn = 'Y';
                }
                else
                {
             	   skipPermitYn = 'N';
                }
                var multiSelPermitYn = '';
                if($('#chk_multi-'+arNo[i]+'-'+j).is(":checked"))
                {
             	   multiSelPermitYn = 'Y';
                }
                else
                {
             	   multiSelPermitYn = 'N';
                }
         	   
         	   surveyJsonObject.surveyOpenDttm = start_day+start_hour+start_min+'00';  //설문시작일시
                surveyJsonObject.surveyClosDttm = limit_day+limit_hour+limit_min+'00';  //설문마감일시
                surveyJsonObject.surveyRsltOpenYn = rshOpenYn; //공개여부
                surveyJsonObject.surveyConts = surveyConts;  //설문내용
                surveyJsonObject.surveyTp = view_type;    //설문유형(텍스트/이미지)
                surveyJsonObject.surveyForm = $(':radio[name="question_type'+arNo[i]+'"]:checked').val(); //설문형태(개별질문/그룹질문)
                if($('#grp_question'+arNo[i]).is(":checked"))
                {
                    surveyJsonObject.grpSurveyNo = $('#question_no-'+arNo[i]).val()*1; //그룹번호
                    surveyJsonObject.grpSurveyCnt = $('#question_cnt'+arNo[i]).val()*1; //그룹문제 갯수
                }                    
                surveyJsonObject.exmplTp = $(':radio[name="question_type-'+arNo[i]+'-'+j+'"]:checked').val(); //질문유형(객관식/주관식)
                surveyJsonObject.inputAddYn = inputAddYn; //직접입력추가여부
                surveyJsonObject.skipPermitYn = skipPermitYn; //스킵허용여부
                surveyJsonObject.multiSelPermitYn = multiSelPermitYn; //복수선택허용여부
                
				var view_type = '020';  //보기유형            
                if($('#radio_txt-'+arNo[i]+'-'+j).is(":checked"))
                {
                    view_type = '010';
                }
                
                if(!$('#radio_single-'+arNo[i]+'-'+j).is(":checked"))
                {
	                var txtViewCnt = $('#hid_txt_view1-'+arNo[i]+'-'+j).val();            
	                for(var k=1; k<=txtViewCnt; k++)
	                {
	             	   var jsonObject = {
	                            'surveyNo' : '0'
	                           , 'exmplNo' : '0'
	                           , 'exmplConts' : ''
	                           , 'imgPath' : ''
	                           , 'imgName' : ''
	                           , 'prvwPath' : ''
	                           , 'prvwName' : ''
	                           , 'totCnt' : '0'
	                           , 'rsltCnt' : '0'
	                           , 'rsltRto' : '0'
	                           , 'delYn' : 'N'
	                           , 'regrId' : ''
	                           , 'regrName' : ''
	                           , 'regDttm' : ''
	                           , 'updrId' : ''
	                           , 'updrName' : ''
	                           , 'updDttm' : ''
	                           , 'moveExmplNo' : ''
	                    };
	             	   
	             	  
	             	   if(view_type == '010')  //텍스트
	                    {
	             		   jsonObject.exmplConts = $('#txt_view-'+arNo[i]+'-'+j+'-'+k).val();
	             		   /*
	             		   if(!$('#chk_skip-'+cnt+'-'+i).is(":checked"))
	                        {
	             			   jsonObject.exmplConts = $('#txt_view1-'+arNo[i]+'-'+j+'-'+k).val();
	                        }
	             		   else
	             		   {
	             			   jsonObject.exmplConts = $('#txt_view2-'+arNo[i]+'-'+j+'-'+k).val();
	             		   }
	             		   */
	                    }
	             	   else
	            	   {
	             		   var tmpStr = $('#rshimg-'+arNo[i]+'-'+j+'-'+k).attr("src");
	                        var filePath = tmpStr.substring(0, tmpStr.lastIndexOf('/'));
	                        var fileName = tmpStr.substring(tmpStr.lastIndexOf('/')+1,  tmpStr.length);
	                        jsonObject.imgPath = filePath;
	                        jsonObject.imgName = fileName;
	                        
	                        tmpStr = $('#txt_view-'+arNo[i]+'-'+j+'-'+k).val();
	                        /*
	                        if(!$('#chk_skip-'+cnt+'-'+i).is(":checked"))
	                        {
	                     	   tmpStr = $('#txt_view1-'+arNo[i]+'-'+j+'-'+k).val(); 
	                        }
	                        else
	                        {
	                     	   tmpStr = $('#txt_view2-'+arNo[i]+'-'+j+'-'+k).val(); 
	                        }
	                        */
	                        filePath = tmpStr.substring(0, tmpStr.lastIndexOf("\\"));
	                        fileName = tmpStr.substring(tmpStr.lastIndexOf("\\")+1,  tmpStr.length);
	                        
	                        jsonObject.prvwPath = filePath;
	                        jsonObject.prvwName = fileName;
	            	   }
	             	
	             	   if($('#chk_skip-'+arNo[i]+'-'+j).is(":checked"))
	                   {
	                       jsonObject.moveExmplNo = $('#sel_view-'+arNo[i]+'-'+j+'-'+k).val();
	                   }
	             	   surveyJsonObject.apndExmpList.push(jsonObject);
	                }
                }
                jsonSurveyObjectList.push(surveyJsonObject); 
            }   
                          
        }
        
        jsonWriteObject.AppendList = jsonSurveyObjectList;
    }

    if (jsonAppendFileList.length > 0)
    {
        jsonWriteObject.AppendFileList = jsonAppendFileList; 
    }
    
    //전체 공개면
    if (notiOpenDiv == '010')
    {
        jsonWriteObject.NotiOpenDivDeptList = [];
        jsonWriteObject.NotiOpenDivEmpList = [];
        
        var jsonObject = {
                'id' : 'ALL',
                'name' : '',
                'div'  : 'PUB',
                'auth' : 'RED'
        };
        jsonWriteObject.NotiOpenDivDeptList[0] = jsonObject;
    }
	//운영자만 공개면
	if (notiOpenDiv == '040')
	{
		jsonWriteObject.NotiOpenDivDeptList = [];
		jsonWriteObject.NotiOpenDivEmpList = [];
		
		var jsonObject = {
				'id' : 'ALL',
				'name' : '',
				'div'  : 'PUB',
				'auth' : 'RED'
		};
		jsonWriteObject.NotiOpenDivDeptList[0] = jsonObject;
		
		var jsonObject = {
				'id' : 'ALL',
				'name' : '',
				'div'  : 'ADM',
				'auth' : 'RED'
		};
		jsonWriteObject.NotiOpenDivDeptList[1] = jsonObject;
	}
	
    //보드 권한 지정이면 게시물 권한 지정 X
    if (notiReadmanAsgnYn == 'N')
    {
        jsonWriteObject.NotiOpenDivDeptList = [];
        jsonWriteObject.NotiOpenDivEmpList = [];
        
    }

    fnNotiInsert(JSON.stringify(jsonWriteObject));
};

var fnModify = function()
{
	$('#page3').css("display","none");
	$('#page1').css("display","");  
    $('#box3 a').attr("class","");
    $('#box1 a').attr("class","on"); 
    
    modifyFlag = 'Y';
    fnFrameReload();
    $("#box1").attr("tabindex",-1).focus();
};

var fnNextPage1 = function()
{
    //제목 체크
    if ($("#txt_title").val() == '' )
    {
        alert('제목을 입력하세요');
        $("#txt_title").focus();
        return;
    }
    //본문 내용
    //if(tinymce.activeEditor.getContent() == ''){
    if(CrossEditor.GetBodyValue() == ''){
        alert('본문 내용을 입력하세요');
        return;
    }

    var start_day  = $("#start_date").val();  //시작 일자
    var start_hour = $('#start_hour option:selected').val(); //시간
    
    if (start_hour == 'null')
    {
        alert('설문 시작 시간을 선택하세요');
        $('#start_hour').focus();
        return;
    }               
    var start_min  = $('#start_min option:selected').val();   //분
    if (start_min == 'null')
    {
        alert('설문 시작 시간(분)을 선택하세요');
        $('#start_min').focus();
        return;
    }

   var limit_day  = $("#close_date").val();  //마감 일자
   var limit_hour = $('#inp_hour option:selected').val(); //시간
   
   if (limit_hour == 'null')
   {
       alert('설문 마감 시간을 선택하세요');
       $('#limit_hour').focus();
       return;
   }               
   var limit_min  = $('#inp_min option:selected').val();   //분
   if (limit_min == 'null')
   {
       alert('설문 마감 시간(분)을 선택하세요');
       $('#inp_min').focus();
       return;
   }
   
   var nowdate = new Date();           

   var date_str = nowdate.getFullYear() + '-' + fnTwoDigit(''+(nowdate.getMonth()+1)) + '-' + fnTwoDigit(''+nowdate.getDate())+fnTwoDigit(''+nowdate.getHours())+fnTwoDigit(''+nowdate.getMinutes())+'00';

   if (date_str > start_day+start_hour+start_min+'00')
   {
       alert('설문시작시간이 현재 시간 보다 작을 수는 없습니다.');
       return;
   }
   
   if (date_str > limit_day+limit_hour+limit_min+'00')
   {
       alert('설문마감시간이 현재 시간 보다 작을 수는 없습니다.');
       return;
   }
   
   if(start_day+start_hour+start_min>limit_day+limit_hour+limit_min)
   {
       alert('설문마감시간이 설문시작시간 보다 작을 수는 없습니다.');
       return;
   }

    var apndFileFormLength = $("#apndFileform input:file[name^=upFile]").length;
    if(apndFileFormLength>1)
    {
		for(var i=0; i<apndFileFormLength; i++)
		{
			if($('#apndFileform ul li').eq(i).find('input:eq(0)').val()=='')
			{
				alert('파일을 선택하세요');
				return;
			}
		}
    }

    $('#page1').css("display","none");  
    $('#page2').css("display","");
    $('#box1 a').attr("class","");
    $('#box2 a').attr("class","on");
    if(modifyFlag=='N')
    {
    	if(notiId == '')
        {
        	fnAddViewForm();
        }
    } 
    fnFrameReload();

    $("#box2").attr("tabindex",-1).focus();
};

var fnNextPage2 = function()
{
	var fileExist = false;
    
	for(var i=0; i<arNo.length; i++)
    {
       var tableCnt = $('#tableCnt-'+arNo[i]).val();
       
       for(var j=1; j<=tableCnt; j++)
       {
           if($('#txt_area-'+arNo[i]+'-'+j).val() == '')
           {
               alert('질문 내용을  입력하세요');
               $('#txt_area-'+arNo[i]+'-'+j).focus();
               return;
           }
           
           if($('#radio_multi-'+arNo[i]+'-'+j).is(":checked"))
           {                   
               var view_type = '020';  //보기유형
               if($('#radio_txt-'+arNo[i]+'-'+j).is(":checked"))
               {
                   view_type = '010';
               }
               var flag = ''; 
               var txtViewCnt = $('#hid_txt_view1-'+arNo[i]+'-'+j).val();            
               for(var k=1; k<=txtViewCnt; k++)
               { 
                   if (view_type == '010')  //텍스트
                   {
                       if($('#txt_view-'+arNo[i]+'-'+j+'-'+k).val() == '')
                       {
                         alert('보기항목 [텍스트]을 입력하세요');
                         $('#txt_view-'+arNo[i]+'-'+j+'-'+k).focus();
                         return;
                       }
      
                   }
                   else  //이미지
                   {
                       if($('#txt_view-'+arNo[i]+'-'+j+'-'+k).val() == '' || $('#txt_view-'+arNo[i]+'-'+j+'-'+k).val() == '(이미지: 가로240px, 세로180px)')
                       {
                           alert('보기항목 [이미지]을  입력하세요');
                           $('#txt_view-'+arNo[i]+'-'+j+'-'+k).focus();
                           return;
                       }
                
                   }
                   if($('#chk_skip-'+arNo[i]+'-'+j).is(":checked"))
                   {
                       if($('#sel_view-'+arNo[i]+'-'+j+'-'+k).val() != '')
                       {
                            flag = 'Y';           
                       }
                   }                       
               }
               if($('#chk_skip-'+arNo[i]+'-'+j).is(":checked"))
               {
                   if(flag != 'Y')
                   {
                       alert('이동 할 번호를 선택하세요');
                       $('#sel_view-'+arNo[i]+'-'+j+'-1').focus();
                       return;
                   }                       
               }
           }
       }
    }
	
	$('#page2').css("display","none");  
    $('#page3').css("display","");
    $('#box2 a').attr("class","");
    $('#box3 a').attr("class","on");
	
    $('#page3_txt_title').text($('#txt_title').val());
    var survey_date = $('#start_date').val()+" "+$('#start_hour').val()+":"+$('#start_min').val()+" ~ "+$('#close_date').val()+" "+$('#inp_hour').val()+":"+$('#inp_min').val()
    $('#page3_survey_date').text(survey_date);
    
    if($('#notiOpenDiv').val()=="010")
    {
    	$('#page3_notiOpenDiv').text("전체공개");
    }
    else if($('#notiOpenDiv').val()=="020")
    {
    	$('#page3_notiOpenDiv').text("사용자지정");
    }
    else
	{
    	$('#page3_notiOpenDiv').text("부서지정");
	}
    
    if($(':radio[name="researchOpenYn"]:checked').val()=='Y')
    {
    	$('#page3_researchOpenYn').text("공개");
    }
    else
    {
    	$('#page3_researchOpenYn').text("비공개");
    }
    //$('#page3_txt_area').text(tinymce.activeEditor.getContent());
    $('#page3_txt_area').text(CrossEditor.GetBodyValue());
    
    $('#ulNotiFile li').remove();
    
    if(notiId != '')//글 수정시 기존 첨부되어있던 파일 보여주기
    {
    	for (var i=0; i < jsonAppendFileList.length; i++){
    		$('#ulNotiFile').append('<li><a href="javascript:fnDoFileDown(\''+ jsonAppendFileList[i].apndFileSeq +'\',\''+ jsonAppendFileList[i].apndFileName +'\',\''+ jsonAppendFileList[i].apndFileOrgn +'\')">'+jsonAppendFileList[i].apndFileOrgn+'</a>'
				+'('+getFileSzForKb(jsonAppendFileList[i].apndFileSz)+"kb"+')</li>');
    	}
    }
    
    var fileExist = false;
    $("#apndFileform input:file[name^=upFile]").each(function(){
        if($(this).val() != ""){
            fileExist = true;
        }
        return;
    });
    if(fileExist){
    	fnShowAddFile(); 
    }
    
    
    fnAddQuestionList();
    fnFrameReload();
    $("#box3").attr("tabindex",-1).focus();
}

var fnAddQuestionList = function()
{
	$('#ul_questionList li').remove();
	
	for(var i=0; i<arNo.length; i++)
    {
        var tableCnt = $('#tableCnt-'+arNo[i]).val();
  	              
        for(var j=1; j<=tableCnt; j++)
        {
        	var qNo = $('#span_question_no-'+arNo[i]+'-'+j).text()+$('#span_sub_no-'+arNo[i]+'-'+j).text();
        	var qTxt = $('#txt_area-'+arNo[i]+'-'+j).val();
        	
        	$('#ul_questionList').append(        			
      		    '<li>'
      		    +'	<span class="quest">질문'+qNo+'.</span>'
      		    +'	<div class="answer">'
      		    +'		<p>'+qTxt+'</p>'
      		    +'		<div id="surveyExmpl-'+qNo+'"></div>'
      		    +'	</div>'
      		    +'</li>'
      		    );
      		
        	if($('#radio_multi-'+arNo[i]+'-'+j).is(":checked"))
        	{ 
        		//객관식	
				var txtViewCnt = $('#hid_txt_view1-'+arNo[i]+'-'+j).val();
				for(var k=1; k<=txtViewCnt; k++)
				{   					
					var strMove = "";
					if($('#chk_skip-'+arNo[i]+'-'+j).is(":checked"))//스킵허용
		        	{ 
				    	var selVal = $('#sel_view-'+arNo[i]+'-'+j+'-'+k).val();
				    	if(selVal!="")
				    	{
				    		strMove = '<span class="col01">→ '+selVal+'번(으)로 이동</span>';
				    	}
		        	}	
					
					var exampleTxt = $('#txt_view-'+arNo[i]+'-'+j+'-'+k).val();					
					if($('#chk_multi-'+arNo[i]+'-'+j).is(":checked"))//복수선택 허용
		        	{
						if($('#radio_txt-'+arNo[i]+'-'+j).is(":checked"))//텍스트	
						{
							$('#surveyExmpl-'+qNo).append(
								'<div>'
		        				+'<input type="checkbox" id="exmpl_chkbox-'+arNo[i]+'-'+j+'" name="exmpl_chkbox-'+arNo[i]+'-'+j+'" /><label for="exmpl_chkbox-'+arNo[i]+'-'+j+'"> '+k+'. '+exampleTxt
		        				+strMove
		        				+'</label>'	
		        				+'</div>'
		            		    );
						}
						else
						{
							//이미지
							var imgSrc = $('#rshimg-'+arNo[i]+'-'+j+'-'+k).attr("src");
							
							$('#surveyExmpl-'+qNo).append(
								'<div class="imgBox">'
		            		    +'<label class="quest3"><input type="checkbox" name="exmpl_chkbox-'+arNo[i]+'-'+j+'" class="vTop" /> '+k+'. '
		            		    +strMove
		            		    +'</label><span class="sns_img"><a href="#" style="cursor:pointer;" onclick="javascript:fnSurveyImgPop(\''+imgSrc+'\');"><img src="'+imgSrc+'" style="width:100%;height:100%" alt="이미지"></a></span>'		            		    		        	
		        				+'</div>'
		            		    );
							
							//fnSurveyImgEffect();
							fnFrameReload();
						}
		        	}
					else
					{	
						if($('#radio_txt-'+arNo[i]+'-'+j).is(":checked"))//텍스트	
						{
							$('#surveyExmpl-'+qNo).append(
								'<div>'
		            		    +'<input type="radio" id="exmpl_radio-'+arNo[i]+'-'+j+'" name="exmpl_radio-'+arNo[i]+'-'+j+'" /><label for="exmpl_radio-'+arNo[i]+'-'+j+'"> '+k+'. '+exampleTxt
		            		    +strMove
		        				+'</label>'
		        				+'</div>'
		            		    );
						}
						else
						{
							//이미지	
							var imgSrc = $('#rshimg-'+arNo[i]+'-'+j+'-'+k).attr("src");

							$('#surveyExmpl-'+qNo).append(
								'<div class="imgBox">'
		            		    +'<label class="quest3"><input type="radio" name="exmpl_radio-'+arNo[i]+'-'+j+'" class="vTop" /> '+k+'. '
		            		    +strMove
		            		    +'</label><span class="sns_img"><a href="#" style="cursor:pointer;" onclick="javascript:fnSurveyImgPop(\''+imgSrc+'\');"><img src="'+imgSrc+'" style="width:100%;height:100%" alt="이미지"></a></span></div>'		            		    
		            		    );
							
							//fnSurveyImgEffect();
							fnFrameReload();
						}
					}		
				}
				if($('#input_plus-'+arNo[i]+'-'+j).is(":checked"))//직접입력
	        	{
					$('#surveyExmpl-'+qNo).append(
        				'<div class="directBox">'
            		    +'	<input type="radio" id="direct" name="exmpl_radio-'+arNo[i]+'-'+j+'" title="직접입력" title="직접입력 체크" /> <label for="direct" class="directInput">'+(txtViewCnt*1+1)+'. 직접 입력</label>'
            		    +'	<input type="text" class="text" style="width:475px" value="" title="직접입력합니다." title="직접입력" />'
            		    +'</div>'
            		    );
	        	}
        	}
        	else
        	{
        		//주관식
        		$('#surveyExmpl-'+qNo).append('<input type="text" class="text" style="width:575px" value="" title="" />');
        	}
        }
        
   }
}

//이미지 팝업
var fnSurveyImgPop = function(imgPath)
{
	var img1 = new Image();
	img1.src = imgPath;
	var width = 0;
	var height = 0;	
	var option = "";
	var pop;
	width = img1.width;
	height = img1.height;
	option = "width="+width+",height="+height;
	pop = window.open(imgPath,"",option);
};


var fnSurveyImgEffect = function()
{
   $obj = $('.imgBox span');
		for( var j=0; j < $obj.length+1; j++){
		$('.imgBox span img').each(function(){
			if ($(this).width() >= $(this).parents('span').width()){
			    $(this).css( {
			   		 'width': '100%',
			   		 'margin-left': "-" + $(this).width()/2 +"px",
					 'margin-top': "-" + $(this).height()/2 +"px"
				});
			} else if($(this).width() < $(this).parents('div').width()){
				$(this).css({
					'width':'auto',
					'margin-left': "-" + $(this).width()/2 +"px",
					'margin-top': "-" + $(this).height()/2 +"px"		
				});
			};
		});
	};
};

//첨부파일
var fnSetDataNotiFileInfo = function(notiFileJson){
	for (var i=0; i < notiFileJson.length; i++){
		$('#ulNotiFile').append('<li><a href="javascript:fnFileDown(\''+ notiFileJson[i].saveFileName +'\',\''+ notiFileJson[i].original +'\')">'+notiFileJson[i].original+'</a>'
				+'('+getFileSzForKb(notiFileJson[i].saveFileSize)+"kb"+')</li>');	
		
	}
};

var getFileSzForKb = function(sz) {
	if(sz > 0){
		sz = sz / 1000;
	}
	return Number(sz);
};

var fnChgAddFile = function()
{
	var chk = true;
    $("#apndFileform input:file[name^=upFile]").each(function(){
        if(!PortalCommon.execUploadFileCheck($(this).val())){
            chk = false;
            return false;
        }
    });
    if(!chk){
        alert("추가할 수 없는 파일입니다.");
        return;
    }
}

var fnShowAddFile = function()
{
	$("#apndFileform").ajaxSubmit({
        url : WEB_HOME+"/board230/bbsFileUpload.jdo",
        //contentType: "application/x-www-form-urlencoded; charset=UTF-8",

        type : 'POST',
        data :  $("#apndFileform").serialize(),
        action: $("#dummy"),
        dataType : "script",
        success : function(data){
        	//alert(data);
        	fnSetDataNotiFileInfo($.parseJSON(data));
        },error : function(){
            alert("전송 실패 했습니다.");
        },
        clearForm: false,
        resetForm: false
    });
	
}

//파일다운로드
var fnFileDown = function(filename, fileorg)
{	
	
	 var jsonObject = {
		'apndFileOrgn' : fileorg,
		'apndFileName' : filename,
		'notiId' : notiId
	 };
	 
	 var url =WEB_HOME+"/board100/bbsFileDownloadNew.jdo?data="+encodeURI(JSON.stringify(jsonObject),"UTF-8");
	 //alert(url);
	 document.dummy.location.href = url;
};

//파일다운로드
var fnDoFileDown = function(fileseq, filename, fileorg)
{	
	
	 var jsonObject = {
		'apndFileOrgn' : fileorg,
		'apndFileName' : filename,
		'apndFileSeq' :  fileseq,
		'notiId' : notiId
	 };
	 
	 var url =WEB_HOME+"/board100/bbsFileDownload.jdo?data="+encodeURI(JSON.stringify(jsonObject),"UTF-8");
	 document.dummy.location.href = url;
};

//설문 보기 항목 추가
var fnAddViewForm = function()
{   
    var cnt = 0;
    var t_no = 0;
    
   	itemCnt++;
    no++;
    c_no++;
   	cnt = c_no;
   	arNo.push(cnt);
   	t_no = no;
    
    $("#research_body").append(
    	'<div class="rbox02">'
    	+'<span id="research_top-'+cnt+'" class="top"></span>'
        +'<div id="research-'+cnt+'" class="mid">'
        +' 	<div class="inquiry_top">'
        +'		<span class="radiogroup02">'	
        +'     		<input type="radio" name="question_type'+cnt+'" id="sep_question'+cnt+'" value="seperate" checked/> <label for="sep_question'+cnt+'">개별 질문</label>'
        +'     		<input type="radio" name="question_type'+cnt+'" id="grp_question'+cnt+'" value="group"/> <label for="grp_question'+cnt+'">그룹 질문</label>'
        +'     		<input type="text" id="question_cnt'+cnt+'" class="text" style="width:28px" maxlength="2" onKeyDown="javascript:fnQuestionCntEnter('+cnt+','+t_no+');" disabled="disabled"/>'
        +'     		<label for="unit02">개</label>'
        +'		</span>'
        +'     	<span class="btn_st01 posi_st01"><button id="question_cnt_btn'+cnt+'" onclick="javascript:fnAddGrp('+cnt+','+t_no+');">저장</button></span>'
        +' 	</div>' 
        +'	<div class="inquiry_cont">' 
        +'		<span class="top"></span>'
        +'		<div id="table_body'+cnt+'" class="mid">'
        +'     		<input type="hidden" id="question_no-'+cnt+'" value="'+t_no+'" />'
        +'		</div>'
        +'		<span class="btm"></span>'
        +'	</div>'
        +'	<div class="inquiry_btn">'
        +'		<span class="btn_st02"><button onclick="javascript:fnDelViewForm('+cnt+')">삭제</button></span>'
        +'	</div>'
        +'  <input type="hidden" id="cnt-'+cnt+'" value="'+cnt+'" />'
        +'</div>'
        +'<span id="research_btm-'+cnt+'" class="btm"></span>'
        +'</div>'
    );
    
    fnAddTable(cnt,t_no,1,0);
    $('#txt_area-'+cnt+'-1').focus();
    $('#txt_view-'+cnt+'-1').val("2");

    fnAddTxtView(cnt,1,"");
    
    arSelBoxVal.push(t_no);
    
    fnChgSelBox(0,"");
    fnFrameReload();

    $(':radio[name="question_type'+cnt+'"]').bind("change", function()
    {
    	var strTno = 0;
    	if($("#sep_question"+cnt).is(":checked")==true)
        {
	    	$('#table_body'+cnt+' table').remove();
	    	
	    	strTno = $('#question_no-'+cnt).val();
	        
	        var idx = 0;
	        var eqCnt = 0;
	        for(var i=0;i<arSelBoxVal.length;i++)
	        {
	        	var spSelBoxVal = (arSelBoxVal[i]+"").split('-');
	            
	            if(spSelBoxVal[0]==strTno)
	            {
	                if(eqCnt==0)
	                 {
	                    idx = i;
	                 }
	                 eqCnt++;
	             }
	        }
	        arSelBoxVal.splice(idx,eqCnt,strTno);
	    	
	    	fnAddTable(cnt,strTno,1,0);
	    	$('#sep_question'+cnt).attr("checked",true);
            $('#question_cnt'+cnt).val("");
            $('#question_cnt'+cnt).attr("disabled",true);
            $('#txt_view-'+cnt+'-'+1).val("2");
            fnAddTxtView(cnt,1,"");
        }
    	if($("#grp_question"+cnt).is(":checked")==true)
        {
            $('#table_body'+cnt+' table').remove();
            strTno = $('#question_no-'+cnt).val();
            $('#grp_question'+cnt).attr("checked",true);
            $('#question_cnt'+cnt).attr("disabled",false);
            $('#question_cnt'+cnt).val("2");
    		fnAddGrp(cnt,strTno);
        }
    });
    
};

var fnQuestionCntEnter = function(cnt,t_no)
{
    if(event.keyCode==13)
    {
        fnAddGrp(cnt, t_no);
    }
};

var fnAddGrp = function(cnt, t_no)
{
	if($('#sep_question'+cnt).is(":checked"))
	{
		return;
	}
	
	var oldTableCnt = $('#table_body'+cnt+' table').length;
	var newTableCnt = $('#question_cnt'+cnt).val();
	
	if(newTableCnt < 2)
    {
        alert('그룹 질문 갯수는 적어도 2개 이상 이어야 합니다.');
        $('#question_cnt'+cnt).val(oldTableCnt);
        return;
    }
    
    if (newTableCnt > surveyGrpQuestionCnt)
    {
        alert('보기의 최대개수는 '+surveyGrpQuestionCnt+'개 입니다.');
        $('#question_cnt'+cnt).val(oldTableCnt);
        return;
    }
    $('#tableCnt-'+cnt).val(newTableCnt);
    
    var pQuestionNo = $("#question_no-"+cnt).val();
    
    var idx = 0;
    var eqCnt = 0;
    for(var i=0;i<arSelBoxVal.length;i++)
    {
    	var spSelBoxVal = (arSelBoxVal[i]+"").split('-');
    	
         if(spSelBoxVal[0]==pQuestionNo)
         {
            //alert(i);
            if(eqCnt==0)
             {
                idx = i;
             }
             eqCnt++;
         }
    }
    //alert(idx+"/"+eqCnt+"/"+pQuestionNo);
    arSelBoxVal.splice(idx,eqCnt);
    //alert("length:"+arSelBoxVal.length+"/newTableCnt: "+newTableCnt);
    for(var i=0; i<newTableCnt; i++)
    {
        arSelBoxVal.splice(idx+i,0,pQuestionNo+'-'+(i+1));
    }
    //alert("length:"+arSelBoxVal.length);
	if(oldTableCnt - newTableCnt > 0)
	{
		for(var i = oldTableCnt; i > newTableCnt; i--)
        {
			$('#question_table-'+cnt+'-'+i).remove();
		}
	}
	else
	{
		fnAddTable(cnt,t_no,newTableCnt,oldTableCnt);
		for(var i=1+oldTableCnt; i<=newTableCnt; i++)
	    {
			$('#txt_view-'+cnt+'-'+i).val("2");
			fnAddTxtView(cnt,i,"");            
        }    
	}	
	fnChgSelBox(0,"");  
};

var fnAddTable = function(cnt,t_no,tableCnt,oldTableCnt)
{
	var strSubNo = "";
	for(var i=1+oldTableCnt; i<=tableCnt; i++)
    {
		if(tableCnt>1){
			strSubNo = '-'+i;
		}
		
		if(i==1){
			$("#table_body"+cnt).append(
	        '<table id="question_table-'+cnt+'-'+i+'" class="table_st01" summary="질문번호, 질문유형, 질문, 보기설정, 보기에 관한 설문지 정보제공">'
	        +'	<caption>설문지 생성</caption>'
	        +'  <colgroup>'
	        +'  	<col style="width:12%" />'
	        +'      <col style="width:88%" />'
	        +'  </colgroup>'
	        +'  <tbody>'
	        +'  	<tr class="tr1">'
	        +'      	<th scope="row">질문 번호</th>'
	        +'          <input type="hidden" id="tableCnt-'+cnt+'" value="'+tableCnt+'" />'
	        +'          <td><strong><span id="span_question_no-'+cnt+'-'+i+'">'+t_no+'</span><span id="span_sub_no-'+cnt+'-'+i+'">'+strSubNo+'</span></strong></td>'
	        +'      </tr>'
	        +'      <tr class="tr2">'
	        +'      	<th scope="row">질문 유형</th>'
	        +'          <td>'
	        +'          	<div class="multigroup">'
	        +'                  <input type="radio" title="객관식 선택" id="radio_multi-'+cnt+'-'+i+'" name="question_type-'+cnt+'-'+i+'" value="010" onclick="javascript:fnRadioMultiClick('+cnt+','+i+')" checked/> <label for="radio_multi-'+cnt+'-'+i+'">객관식</label>'
	        +'                  <input type="checkbox" title="직접입력 체크" id="input_plus-'+cnt+'-'+i+'" onclick="fnInputPlusClick('+cnt+','+i+')"/> <label for="input_plus-'+cnt+'-'+i+'" style="margin-right:25px;">직접입력 추가</label>'
	        +'              	<input type="radio" title="주관식 선택" id="radio_single-'+cnt+'-'+i+'" name="question_type-'+cnt+'-'+i+'" value="020" onclick="javascript:fnRadioSingleClick('+cnt+','+i+')"/> <label for="radio_single-'+cnt+'-'+i+'">주관식</label>'
	        +'              <span class="eachG">'
	        +'                  <input type="checkbox" id="chk_skip-'+cnt+'-'+i+'" name="skipchoice" onclick="javascript:fnChkSkipClick('+cnt+','+i+')" title="SKIP 사용체크"/> <label for="chk_skip-'+cnt+'-'+i+'">SKIP 사용</label>'
	        +'              </span>'
	        +'              </div>'
	        +'          </td>'
	        +'		</tr>'
	        +'      <tr id="tr_view_option-'+cnt+'-'+i+'" class="tr4">'
	        +'      	<th scope="row">보기 설정</th>'
	        +'          <td>'
	        +'          	<span class="eachG">'
	        +'              	<em class="stit"><label for="txt_view-'+cnt+'-'+i+'">보기개수</label></em>'
	        +'                  <input type="hidden" id="hid_txt_view-'+cnt+'-'+i+'" value=""/>'
	        +'                  <input type="hidden" id="hid_txt_view1-'+cnt+'-'+i+'" value=""/>'
	        +'                  <input type="text" class="text" id="txt_view-'+cnt+'-'+i+'" onKeyDown="javascript:fnTxtViewEnter('+cnt+','+i+');" size="2" maxlength="2" value="" style="width:25px;text-align:right"/>'
	        +'                  <label for="unit2">개</label>'
	        +'                  <button type="button" class="btn_style1_2" onclick="javascript:fnAddTxtView('+cnt+','+i+',\'\')">생성</button>'
	        +'              </span>'
	        +'              <span class="eachG">'
	        +'                  <em class="stit">보기유형</em>'
	        +'                  <input type="radio" value="010" id="radio_txt-'+cnt+'-'+i+'" name="radio_name-'+cnt+'-'+i+'" onclick="javascript:fnRadioTxtClick('+cnt+','+i+')" title="보기유형중 텍스트선택"/><label for="radio_txt-'+cnt+'-'+i+'">텍스트</label>'
	        +'                  <input type="radio" value="020" id="radio_img-'+cnt+'-'+i+'" name="radio_name-'+cnt+'-'+i+'" onclick="javascript:fnRadioImgClick('+cnt+','+i+')" title="보기유형중 이미지선택"/><label for="radio_img-'+cnt+'-'+i+'">이미지</label>'
	        +'              </span>'
	        +'              <span class="eachG">'
	        +'                  <input type="checkbox" id="chk_multi-'+cnt+'-'+i+'" name="multiplechoice" value="Y" onclick="javascript:fnChkMultiClick('+cnt+','+i+')" title="복수선택 허용체크"/> <label for="chk_multi-'+cnt+'-'+i+'">복수선택 허용</label>'
	        +'              </span>'
	        +'            </td>'
	        +'       </tr>' 
	        +'       <tr class="tr3">'
	        +'       	<th scope="row"><label for="txt_area-'+cnt+'-'+i+'">질문</label></th>'
	        +'          <td>'
	        +'          	<textarea cols="" id="txt_area-'+cnt+'-'+i+'" class="textbox" title="질문 입력" style="width:535px;height:40px;"></textarea>'
	        +'          </td>'
	        +'       </tr>'
	        +'       <tr id="tr_view-'+cnt+'-'+i+'" class="tr5" style="display:none;">'     
	        +'			<th scope="row">보기</th>'			
	        +'          <td id="li_view-'+cnt+'-'+i+'"></td>'
	        +'       </tr>'
	        +'</tbody>'
	        +'</table>'
	        );
		}else{
			$("#table_body"+cnt).append(
	        '<table id="question_table-'+cnt+'-'+i+'" class="table_st01" summary="질문번호, 질문유형, 질문, 보기설정, 보기에 관한 설문지 정보제공">'
	        +'	<caption>설문지 생성</caption>'
	        +'  <colgroup>'
	        +'  	<col style="width:12%" />'
	        +'      <col style="width:88%" />'
	        +'  </colgroup>'
	        +'  <tbody>'
	        +'  	<tr class="tr1">'
	        +'      	<th scope="row">질문 번호</th>'
	        +'          <td><strong><span id="span_question_no-'+cnt+'-'+i+'">'+t_no+'</span><span id="span_sub_no-'+cnt+'-'+i+'">'+strSubNo+'</span></strong></td>'
	        +'      </tr>'
	        +'      <tr class="tr2">'
	        +'      	<th scope="row">질문 유형</th>'
	        +'          <td>'
	        +'          	<div class="multigroup">'
	        +'                  <input type="radio" title="객관식 선택" id="radio_multi-'+cnt+'-'+i+'" name="question_type-'+cnt+'-'+i+'" value="010" onclick="javascript:fnRadioMultiClick('+cnt+','+i+')" checked/> <label for="radio_multi-'+cnt+'-'+i+'">객관식</label>'
	        +'                  <input type="checkbox" title="직접입력 체크" id="input_plus-'+cnt+'-'+i+'" onclick="fnInputPlusClick('+cnt+','+i+')"/> <label for="input_plus-'+cnt+'-'+i+'" style="margin-right:25px;">직접입력 추가</label>'
	        +'              	<input type="radio" title="주관식 선택" id="radio_single-'+cnt+'-'+i+'" name="question_type-'+cnt+'-'+i+'" value="020" onclick="javascript:fnRadioSingleClick('+cnt+','+i+')"/> <label for="radio_single-'+cnt+'-'+i+'">주관식</label>'
	        +'              <span class="eachG">'
	        +'                  <input type="checkbox" id="chk_skip-'+cnt+'-'+i+'" name="skipchoice" onclick="javascript:fnChkSkipClick('+cnt+','+i+')" title="SKIP 사용체크"/> <label for="chk_skip-'+cnt+'-'+i+'">SKIP 사용</label>'
	        +'              </span>'
	        +'              </div>'
	        +'          </td>'
	        +'		</tr>'
	        +'      <tr id="tr_view_option-'+cnt+'-'+i+'" class="tr4">'
	        +'      	<th scope="row">보기 설정</th>'
	        +'          <td>'
	        +'          	<span class="eachG">'
	        +'              	<em class="stit"><label for="txt_view-'+cnt+'-'+i+'">보기개수</label></em>'
	        +'                  <input type="hidden" id="hid_txt_view-'+cnt+'-'+i+'" value=""/>'
	        +'                  <input type="hidden" id="hid_txt_view1-'+cnt+'-'+i+'" value=""/>'
	        +'                  <input type="text" class="text" id="txt_view-'+cnt+'-'+i+'" onKeyDown="javascript:fnTxtViewEnter('+cnt+','+i+');" size="2" maxlength="2" value="" style="width:25px;text-align:right"/>'
	        +'                  <label for="unit2">개</label>'
	        +'                  <a href="#" class="btn_style1_2" onclick="javascript:fnAddTxtView('+cnt+','+i+',\'\')">생성</a>'
	        +'              </span>'
	        +'              <span class="eachG">'
	        +'                  <em class="stit">보기유형</em>'
	        +'                  <input type="radio" value="010" id="radio_txt-'+cnt+'-'+i+'" name="radio_name-'+cnt+'-'+i+'" onclick="javascript:fnRadioTxtClick('+cnt+','+i+')" title="보기유형중 텍스트선택" checked/><label for="radio_txt-'+cnt+'-'+i+'">텍스트</label>'
	        +'                  <input type="radio" value="020" id="radio_img-'+cnt+'-'+i+'" name="radio_name-'+cnt+'-'+i+'" onclick="javascript:fnRadioImgClick('+cnt+','+i+')" title="보기유형중 이미지선택"/><label for="radio_img-'+cnt+'-'+i+'">이미지</label>'
	        +'              </span>'
	        +'              <span class="eachG">'
	        +'                  <input type="checkbox" id="chk_multi-'+cnt+'-'+i+'" name="multiplechoice" value="Y" onclick="javascript:fnChkMultiClick('+cnt+','+i+')" title="복수선택 허용체크"/> <label for="chk_multi-'+cnt+'-'+i+'">복수선택 허용</label>'
	        +'              </span>'
	        +'            </td>'
	        +'       </tr>' 
	        +'       <tr class="tr3">'
	        +'       	<th scope="row"><label for="txt_area-'+cnt+'-'+i+'">질문</label></th>'
	        +'          <td>'
	        +'          	<textarea cols="" id="txt_area-'+cnt+'-'+i+'" class="textbox" title="질문 입력" style="width:535px;height:40px;"></textarea>'
	        +'          </td>'
	        +'       </tr>'
	        +'       <tr id="tr_view-'+cnt+'-'+i+'" class="tr5" style="display:none;">'     
	        +'			<th scope="row">보기</th>'			
	        +'          <td id="li_view-'+cnt+'-'+i+'"></td>'
	        +'       </tr>'
	        +'</tbody>'
	        +'</table>'
	        );
		}
		$('#radio_txt-'+cnt+'-'+i).attr("checked",true);
    }
	
	fnFrameReload();
};


var fnRadioMultiClick = function(cnt, selTxtView) 
{              
    $('#input_plus-'+cnt+'-'+selTxtView).attr("disabled",false);
    $('#chk_skip-'+cnt+'-'+selTxtView).attr("disabled",false);
    $('#tr_view_option-'+cnt+'-'+selTxtView).css('display','');
    $('#txt_view-'+cnt+'-'+selTxtView).val("2");
	//yblee
    $('#radio_txt-'+cnt+'-'+selTxtView).trigger('click');
};

var fnRadioSingleClick = function(cnt, selTxtView) 
{    
    var c_cnt = $('#txt_view-'+cnt+'-'+selTxtView).val();
    
    $('#input_plus-'+cnt+'-'+selTxtView).attr("checked",false);
    $('#input_plus-'+cnt+'-'+selTxtView).attr("disabled",true);
    $('#chk_skip-'+cnt+'-'+selTxtView).attr("checked",false);
    fnChkSkip(cnt, selTxtView);
    $('#chk_skip-'+cnt+'-'+selTxtView).attr("disabled",true);
    $('#txt_view-'+cnt+'-'+selTxtView).val("");
    $(':radio[name="radio_name-'+cnt+'-'+selTxtView+'"]').attr("checked",false);
    $('#chk_multi-'+cnt+'-'+selTxtView).val("");
    $('#tr_view_option-'+cnt+'-'+selTxtView).css('display','none');
    
    for(var i=1; i<=c_cnt; i++)
    {
        $("#txt_view-"+cnt+'-'+selTxtView+'-'+i).val("");
        //$("#txt_view2-"+cnt+'-'+selTxtView+'-'+i).val("");
    }      
    
    $('#li_view-'+cnt+'-'+selTxtView+' ol').remove();    
    $('#tr_view-'+cnt+'-'+selTxtView).css('display','none');
};

var fnRadioTxtClick = function(cnt, selTxtView) 
{              
    var c_cnt = $('#txt_view-'+cnt+'-'+selTxtView).val();
    
    for(var i=1; i<=c_cnt; i++)
    {
        $("#txt_view-"+cnt+'-'+selTxtView+'-'+i).val("");
        //$("#txt_view2-"+cnt+'-'+selTxtView+'-'+i).val("");
    }
    
    $('#li_view-'+cnt+'-'+selTxtView+' ol').remove();

    fnAddTxtView(cnt, selTxtView, "radio");
};


var fnRadioImgClick = function(cnt, selTxtView) 
{    
    var c_cnt = $('#txt_view-'+cnt+'-'+selTxtView).val();

    for(var i=1; i<=c_cnt; i++)
    {
        $("#txt_view-"+cnt+'-'+selTxtView+'-'+i).val("");
        //$("#txt_view2-"+cnt+'-'+selTxtView+'-'+i).val("");
    }
    
    $('#li_view-'+cnt+'-'+selTxtView+' ol').remove();     

    fnAddTxtView(cnt, selTxtView, "radio");                   
};


var fnInputPlusClick = function(cnt, selTxtView)
{
	if($("#input_plus-"+cnt+'-'+selTxtView).is(":checked")==false)
    {
        $('#chk_skip-'+cnt+'-'+selTxtView).attr("disabled",false);
        $('#chk_multi-'+cnt+'-'+selTxtView).attr("disabled",false);
        $("#input_plus_ol-"+cnt+'-'+selTxtView).remove();
    }else{       
        var lastCnt = $('#txt_view-'+cnt+'-'+selTxtView).val()*1+1;
        $('#li_view-'+cnt+'-'+selTxtView).append(
                '<ol id="input_plus_ol-'+cnt+'-'+selTxtView+'">'   
                +'	<li class="ma_bot5"><em class="stit"><label for="input_plus_txt-'+cnt+'-'+selTxtView+'">보기'+lastCnt+'</label></em>'
                +'	<input type="text" id="input_plus_txt-'+cnt+'-'+selTxtView+'" class="text" style="width:343px;" title="직접입력항목" disabled></li>'
                +'</ol>'
        );
        $('#chk_skip-'+cnt+'-'+selTxtView).attr("checked",false);
        fnChkSkip(cnt,selTxtView);
        $('#chk_skip-'+cnt+'-'+selTxtView).attr("disabled",true);
        $('#chk_multi-'+cnt+'-'+selTxtView).attr("checked",false);
        $('#chk_multi-'+cnt+'-'+selTxtView).attr("disabled",true);
    }
    fnFrameReload();
};

var fnChkMultiClick = function(cnt, selTxtView)
{
	$('#chk_skip-'+cnt+'-'+selTxtView).attr("checked",false);
    fnChkSkip(cnt,selTxtView);
};

var fnChkSkipClick = function(cnt, selTxtView)
{
	fnChkSkip(cnt,selTxtView);
};

var fnTxtViewEnter = function(cnt, selTxtView)
{
	if(event.keyCode==13)
	{
		fnAddTxtView(cnt, selTxtView, "");
	}
};

var fnAddTxtView = function(cnt, selTxtView, flag)
{
	var b_cnt = $('#li_view-'+cnt+'-'+selTxtView+' ol[name^=ol_view-]').length;
    var c_cnt = $('#txt_view-'+cnt+'-'+selTxtView).val();
    var h_cnt = $('#hid_txt_view-'+cnt+'-'+selTxtView).val();    
	
    if (c_cnt < 2)
    {
        alert('보기 갯수는 적어도 2개 이상 이어야 합니다.');
        $('#txt_view-'+cnt+'-'+selTxtView).val(h_cnt);
        return;
    }
    
    if (c_cnt > surveyUploadView)
    {
        alert('보기의 최대개수는 '+surveyUploadView+'개 입니다.');
        $('#txt_view-'+cnt+'-'+selTxtView).val(h_cnt);
        return;
    }
    
    if(b_cnt - c_cnt > 0)  //이전에 입력한 보기가 많을경우
    {
        for(var i = b_cnt; i > c_cnt; i--)
        {
            $('#ol_view-'+cnt+'-'+selTxtView+'-'+i).remove();
        }
        var input_cnt = $('#input_plus_ol-'+cnt+'-'+selTxtView).length;
        if(input_cnt>0)
        {
        	$('#input_plus_ol-'+cnt+'-'+selTxtView).remove();
        }
        fnInputPlusClick(cnt,selTxtView);
    }
    else
    {
    	var input_cnt = $('#input_plus_ol-'+cnt+'-'+selTxtView).length;
        if(input_cnt>0)
        {
        	$('#input_plus_ol-'+cnt+'-'+selTxtView).remove();
        }
    	
        var view_kind = $(':radio[name="radio_name-'+cnt+'-'+selTxtView+'"]:checked').val();
        //yblee
        if (view_kind == '010' || typeof(view_kind) == "undefined")
        {           
            for(var i = b_cnt+1; i <= c_cnt; i++)
            {
                if($('#tr_view-'+cnt+'-'+selTxtView).css('display')=="none"){
                    $('#tr_view-'+cnt+'-'+selTxtView).css('display','');
                }
                $('#li_view-'+cnt+'-'+selTxtView).append(
                        '<ol id="ol_view-'+cnt+'-'+selTxtView+'-'+i+'" name="ol_view-'+cnt+'-'+selTxtView+'-'+i+'">'                     
                        +'<li id="li_sel_view-'+cnt+'-'+selTxtView+'-'+i+'" class="ma_bot5">'
                        +'	<em class="stit"><label for="txt_view-'+cnt+'-'+selTxtView+'-'+i+'">보기'+i+'</label></em>'
                        +' 	<input type="text" id="txt_view-'+cnt+'-'+selTxtView+'-'+i+'" class="text" style="width:343px" title="항목 보기'+i+'">'
                        +'  <span id="div_sel_view-'+cnt+'-'+selTxtView+'-'+i+'" class="selectN" style="width:74px;">'
                        +'  	<span>'
                        +'			<label for="sel_view-'+cnt+'-'+selTxtView+'-'+i+'" class="hidden">보기선택</label>'
                        +'			<select id="sel_view-'+cnt+'-'+selTxtView+'-'+i+'" title="">'
                        +'     			<option value="">선택안함</option>'    
                        +'  		</select> (으)로 이동'
                        +'  	</span>'
                        +'  </span>'
                        +'</li>'
                        +'</ol>'
                );				
            }
        }
        else
        {
            for(var i = b_cnt+1; i <= c_cnt; i++)
             {
                if($('#tr_view-'+cnt+'-'+selTxtView).css('display')=="none"){
                    $('#tr_view-'+cnt+'-'+selTxtView).css('display','');
                }
                
                $('#li_view-'+cnt+'-'+selTxtView).append(
	                '<ol id="ol_view-'+cnt+'-'+selTxtView+'-'+i+'" name="ol_view-'+cnt+'-'+selTxtView+'-'+i+'">'                     
	                +'<li id="li_sel_view-'+cnt+'-'+selTxtView+'-'+i+'" class="ma_bot5">'
	                +'  <form id="view_form-'+cnt+'-'+selTxtView+'-'+i+'" enctype="multipart/form-data" method="post">'
	                +'	<em class="stit"><label for="txt_view-'+cnt+'-'+selTxtView+'-'+i+'">보기'+i+'</label></em>'
	                +' 	<input type="text" id="txt_view-'+cnt+'-'+selTxtView+'-'+i+'" class="text" style="width:343px" value="(이미지: 가로240px, 세로180px)" title="파일을 넣으세요" readOnly/>'
	                +'  <span class="file_wrap">'
	                +'		<button class="btn_style1_2">파일</button>'
	                //+'		<input type="file" class="file_hidden" onchange="javascript:document.getElementById(\'txt_view-'+cnt+'-'+selTxtView+'-'+i+'\').value = this.value" id="viewFile-'+cnt+'-'+selTxtView+'-'+i+'" name="viewFile-'+cnt+'-'+selTxtView+'-'+i+'">'
	                +'		<input type="file" class="file_hidden" onchange="javascript:document.getElementById(\'txt_view-'+cnt+'-'+selTxtView+'-'+i+'\').value = this.value" id="viewFile-'+cnt+'-'+selTxtView+'-'+i+'" name="viewFile-'+cnt+'-'+selTxtView+'-'+i+'">'
	                +'		<button class="btn_style1_2">파일</button>'
	                +'  </span>'	               	              
	                +'  <span id="div_sel_view-'+cnt+'-'+selTxtView+'-'+i+'" class="selectN" style="width:74px">'
	                +'  	<span>'
	                +'			<label for="sel_view-'+cnt+'-'+selTxtView+'-'+i+'" class="hidden">보기선택</label>'
	                +'			<select id="sel_view-'+cnt+'-'+selTxtView+'-'+i+'" title="">'
	                +'     			<option value="">선택안함</option>'    
	                +'  		</select> (으)로 이동'
	                +'  	</span>'
	                +'  </span>'
	                +'  </form>'
	                +'</li>'
	                +'</ol>'
                ); 

					
                  $("#viewFile-"+cnt+'-'+selTxtView+'-'+i).bind("change",function() {
                      if(!PortalCommon.imgUploadFileCheck($(this).val())){
                          alert("추가할 수 없는 파일입니다.");
                          return;
                      }
                      //$(this).parent().parent().prev().val($(this).val());
                      //var formfile = $(this).parent();                      
                      //var idx = formfile.attr("id");
				
					  var thisId = $(this).attr("id");
					  var formfile = $("#view_form-"+thisId.replace("viewFile-",""));
					  var idx = formfile.attr("id");
					  //alert($(this).parent().parent().prev().attr("id"));
					  
                      idx = idx.substring(idx.indexOf('-')+1, idx.length);
                      
                      $(formfile).ajaxSubmit({
                          url : WEB_HOME+"/board230/bbsFileUpload.jdo",
                          action: $("#dummy"),
                          type : 'POST',
                          data : $(formfile).serialize(),
                          success : function(data){
                              //var json = $.parseJSON(data);
                              fnResearchAddImg($.parseJSON(data), idx);//$(formfile).attr("id"));
                          },error : function(){
                              alert("전송 실패 했습니다.");
                          },
                          clearForm: false,
                          resetForm: false
                      });
                  }); 
             }

        }
        fnInputPlusClick(cnt,selTxtView);
	
        $('#hid_txt_view1-'+cnt+'-'+selTxtView).val(c_cnt);
        var pQuestionNo = $("#question_no-"+cnt).val();
        fnChgSelBox(pQuestionNo,flag);  
        fnChkSkip(cnt,selTxtView);
        fnFrameReload();
    }
    
    $('#hid_txt_view-'+cnt+'-'+selTxtView).val(c_cnt);
    
    //parent.document.getElementById("bbsFrame").height = $(document).height();
};

var fnResearchAddImg = function(obj, cnt)
{
    var json = obj[0];
    //기존에 선택한 이미지가 있으면 삭제하고 추가한다.    
    if($('#ol_view-'+cnt+' .imglayout').length >= 1) 
    	$('#ol_view-'+cnt+' .imglayout').last().remove();

    $('#ol_view-'+cnt).append(        
        '<span class="imglayout" id="'+json.saveFileId+'"><a href="#" style="cursor:pointer;" onclick="javascript:fnSurveyImgPop(\''+json.webDir+json.saveFileName+'\');"><img id="rshimg-'+cnt+'" src="'+json.webDir+json.saveFileName+'" style="width:100%;height:100%" alt="이미지"><input type="hidden" id="hid_img-'+cnt+'" val='+json.webDir+json.saveFileName+'><a href="#" class="ico_clo" title="삭제" onclick="javascript:fnResearchListRemove(\''+json.saveFileId+'\',\''+cnt+'\')"></a></a></span>' 
    );
    
    $("#rshimg-"+cnt).bind("load",function(){
    	//fnImgEffect3();
        fnFrameReload();
    });
};



//이미지 조절 
var fnImgEffect3 = function()
{
    /*sns 이미지 등록 - sns 가로,세로 가로정렬*/
  $obj = $('.sns_img');
    
  for( var j=0; j < $obj.length+1; j++)
  {
        $('.sns_img img').each(function(){
            if ($(this).width() >= $(this).parents('li').width()){
                //alert('1:'+$(this).width()+' '+$(this).parents('li').width());
                $(this).css( {
                     'width': '100%',
                     'margin-left': '-' + $(this).width()/2 +"px",
                     'margin-top': '-' + $(this).height()/2 +"px"
                });
            } else if($(this).width() < $(this).parents('li').width()){
                    $(this).css({
                        'width':'auto',
                        'margin-left': '-' + $(this).width()/2 +"px",
                        'margin-top': '-' + $(this).height()/2 +"px"        
                    });
                };
        });
   };
};

//설문 보기 항목 삭제
var fnDelViewForm = function(val)//val: cnt 질문항목 생성시 사용하는 번호
{	
    if(itemCnt>1)
    {	
       var pQuestionNo = $("#question_no-"+val).val();//삭제 문제 번호
       
       var arUseQuestionNo = new Array();

       for(var i=0; i<arNo.length; i++)
       {
           var useFlag = "";
           var useQuestionNo = $("#question_no-"+arNo[i]).val(); 
           var tableCnt = $('#tableCnt-'+arNo[i]).val();
           if(pQuestionNo!=useQuestionNo)
           {
	           for(var j=1; j<=tableCnt; j++)
	           {   
	               if($('#chk_skip-'+arNo[i]+'-'+j).is(":checked")==true)
	               {
	                   var txtViewCnt = $('#hid_txt_view1-'+arNo[i]+'-'+j).val();
	                   for(var k=1; k<=txtViewCnt; k++)
	                   {                                  
	                       var sel_val = $('#sel_view-'+arNo[i]+'-'+j+'-'+k).val();        
	                       var spSelVal = sel_val.split('-');
	                              
	                       if(spSelVal[0]==pQuestionNo)
	                       {
	                           useFlag = "Y";
	                       }                        
	                   }
	               }
	           }
           }
           if(useFlag=="Y")
           {
               arUseQuestionNo.push(useQuestionNo);
           }
      }
                
      if(arUseQuestionNo.length>0)
      {
          var strUseQuestionNo = "";
          for(i=0;i<=arUseQuestionNo.length-1;i++)
          {
              if(i==arUseQuestionNo.length-1)
              {
                  strUseQuestionNo += arUseQuestionNo[i];
              }else{
                  strUseQuestionNo += arUseQuestionNo[i]+", "; 
              }
          }
          
          if(!confirm("해당 문제가 "+strUseQuestionNo+"번 문제에서 사용중입니다. 삭제하시겠습니까?"))
          {
              return;
          }
      }

       var idx = 0;
       var eqCnt = 0;
       for(var i=0;i<arSelBoxVal.length;i++)
       {
    	   var spSelBoxVal = (arSelBoxVal[i]+"").split('-');
           
           if(spSelBoxVal[0]==pQuestionNo)
           {
			   if(eqCnt==0)
			    {
				   idx = i;
			    }
			    eqCnt++;
			}
       }
       arSelBoxVal.splice(idx,eqCnt);
       for(var i=idx;i<arSelBoxVal.length;i++)
       {   	    
    	   var spSelBoxVal = (arSelBoxVal[i]+"").split('-');
    	   if(spSelBoxVal.length>1)
    	   {
    		   arSelBoxVal.splice(i,1,(spSelBoxVal[0]*1-1)+'-'+spSelBoxVal[1]);   
    	   }
    	   else
    	   {
    		   arSelBoxVal.splice(i,1,arSelBoxVal[i]-1);
    	   }   	   
       }             
              
       $('#research-'+val).remove();
       $('#research_top-'+val).remove();
       $('#research_btm-'+val).remove();
       
       var idx = 0;
       for(var i=0; i<arNo.length; i++)
       {
    	   if(arNo[i]==val)
    	   {	   
    		   idx = i;
    		   break;
    	   }	   
       }

       for(var i=idx+1; i<arNo.length; i++)
       {
    	   var tableCnt = $("#tableCnt-"+arNo[i]).val();
    	   
    	   var questionNo = $("#question_no-"+arNo[i]).val();
    	   
    	   if(questionNo>1)
    	   {
    		   $("#question_no-"+arNo[i]).val(questionNo-1);
    	   }
    	   
    	   for(j=1;j<=tableCnt;j++)
    	   {
	           var spanQuestionNo = $("#span_question_no-"+arNo[i]+'-'+j).text();
	           
	           if(spanQuestionNo>1)
	           {
	               $("#span_question_no-"+arNo[i]+'-'+j).text(spanQuestionNo-1);
	           }
    	   }
       }     
        
       fnFrameReload();
       itemCnt--;
       no = itemCnt;
       t_no = no;
       
       arNo.splice(idx,1);
       fnChgSelBox(pQuestionNo,"");
       
    }
    else
    {
        alert('질문이 한 개 일 경우 삭제 할 수 없습니다.');
        return;
    }
}

//질문 추가, 삭제 시 이동 셀렉트 박스 option 변경
var fnChgSelBox = function(pQuestionNo, flag)
{            
    for(var i=0; i<arNo.length; i++)
    {
       var tableCnt = $('#tableCnt-'+arNo[i]).val();
       
       for(var j=1; j<=tableCnt; j++)
       {   
           if($('#chk_skip-'+arNo[i]+'-'+j).is(":checked")==true)
           {
               var txtViewCnt = $('#hid_txt_view1-'+arNo[i]+'-'+j).val();
               var strMainNo = $('#span_question_no-'+arNo[i]+'-'+j).text();
               var strSubNo = $('#span_sub_no-'+arNo[i]+'-'+j).text();
               var intMainNo = strMainNo*1;
               var intSubNo = 0;
               if(strSubNo.length>0)
               {
            	   var spSubNo = strSubNo.split('-');
                   strSubNo = strSubNo[1];
                   intSubNo = strSubNo*1;
               }
      
               for(var k=1; k<=txtViewCnt; k++)
               {                                  
                   var sel_val = $('#sel_view-'+arNo[i]+'-'+j+'-'+k).val();
                   //alert("1: "+sel_val);
                   var spSelVal = sel_val.split('-');
                   var strSelVal1 = spSelVal[0];
                   var strSelVal2 = "";
                   var intSelVal1 = spSelVal[0]*1;
                   var intSelVal2 = 0;
                   if(spSelVal.length>1)
                   {
                	   strSelVal2 = spSelVal[1];
                	   intSelVal2 = spSelVal[1]*1;
                   }

                   if(pQuestionNo>0)
                   {
                	   //alert("2: "+pQuestionNo);
                	   if(flag != "radio")
                	   {
	                       if(intSelVal1>pQuestionNo)//선택된 값이 삭제선택된 문제 번호보다 클 경우 -1 씩 감소
	                       {
	                           strSelVal1 = (intSelVal1 - 1)+"";
	                       }
	                       else if(intSelVal1==pQuestionNo)//선택된 값이 선택된 문제 번호와 같을 경우 문제가 삭제 된 것이기때문에 초기값으로 설정
	                       {
	                    	   strSelVal1 = "";
	                       }
	
	                       if(intSelVal2 == 0)
	                       {
	                            sel_val = strSelVal1;
	                       }
	                       else
	                       {
	                           if(strSelVal1!="")
	                           {	   
	                               sel_val = strSelVal1+"-"+strSelVal2;
	                           }else{
	                               sel_val = "";
	                           }    
	                       }      
                	   }               
                   }
                  
                   $('#sel_view-'+arNo[i]+'-'+j+'-'+k+' option').remove();
                                   
                   if(typeof($('#sel_view-'+arNo[i]+'-'+j+'-'+k))!="undefined")
                   {    
                       $('#sel_view-'+arNo[i]+'-'+j+'-'+k).append('<option value="">선택</option>');    
                       for(var l=0;l<arSelBoxVal.length;l++)
                       {
                    	   var strSelBoxVal = arSelBoxVal[l]+"";
                           var spSelBoxVal = strSelBoxVal.split('-');
                          
                           if(spSelBoxVal.length>1)
                           {                              
                               var mainNo = spSelBoxVal[0]*1;                               
                               var subNo = spSelBoxVal[1]*1;       
                               
                               if(intMainNo<mainNo)
                               {
                                   $('#sel_view-'+arNo[i]+'-'+j+'-'+k).append('<option value="'+arSelBoxVal[l]+'">'+arSelBoxVal[l]+'</option>');
                               }
                               else if(intMainNo==mainNo)
                               {
                                   if(intSubNo<subNo)
                                       $('#sel_view-'+arNo[i]+'-'+j+'-'+k).append('<option value="'+arSelBoxVal[l]+'">'+arSelBoxVal[l]+'</option>');
                               }       
                           }
                           else
                           {
                               if(intMainNo<arSelBoxVal[l])
                                   $('#sel_view-'+arNo[i]+'-'+j+'-'+k).append('<option value="'+arSelBoxVal[l]+'">'+arSelBoxVal[l]+'</option>');
                           }                                                                              
                       }
                       $('#sel_view-'+arNo[i]+'-'+j+'-'+k).val(sel_val);
                   }
               }
           }
        }              
    }
};


//skip 허용 체크박스 체크시 보기 셀렉트박스 보이게
var fnChkSkip = function(cnt,selTxtView)
{
    if($("#chk_skip-"+cnt+'-'+selTxtView).is(":checked"))
    {
        $("#chk_multi-"+cnt+'-'+selTxtView).attr("checked",false);
        for(var i=1; i<=surveyUploadView; i++)
        {
            //$('#li_sel_view1-'+cnt+'-'+selTxtView+'-'+i).css("display","none");
            //$('#li_sel_view2-'+cnt+'-'+selTxtView+'-'+i).css("display","block");
        	//$('#sel_view-'+cnt+'-'+selTxtView+'-'+i).css("display","block");
        	$('#div_sel_view-'+cnt+'-'+selTxtView+'-'+i).css("display","");
        }
        fnChgSelBox(0,"");
    }   
    else
    {
        for(var i=1; i<=surveyUploadView; i++)
        {
            $('#sel_view-'+cnt+'-'+selTxtView+'-'+i).val("");
            //$('#li_sel_view1-'+cnt+'-'+selTxtView+'-'+i).css("display","block");
            //$('#li_sel_view2-'+cnt+'-'+selTxtView+'-'+i).css("display","none");
            //$('#sel_view-'+cnt+'-'+selTxtView+'-'+i).css("display","none");
            $('#div_sel_view-'+cnt+'-'+selTxtView+'-'+i).css("display","none");
        }
    }
    fnFrameReload();    
}


//등록버튼
var fnWriteInsert = function()
{	
    if (nojoYn == 'N')
    {
        alert('업무 시간 이외 에는  등록 할 수 없습니다.');
        return;
    }   
    /*
    if (notiId != "")
    {
        //권한이없으면  아니면 등록 막음
        if (isAdmin == 'N')
        {
            if (notiWriteId != userId)
            {
                alert('귀하는 수정 할 권한이 없습니다.');
                return;
            }
        }
        
        if (!confirm('수정하시겠습니까?')) {
            return;
        }
    }
    else
    {
        if (!confirm('등록하시겠습니까?')) {
            return;
        }
    }
    
    insertMode = "insert";
   
    //제목 체크
    if ($("#txt_title").val() == '' )
    {
        alert('제목을 입력하세요');
        $("#txt_title").focus();
        return;
    }
    //본문 내용
    if(tinymce.activeEditor.getContent() == ''){
        alert('본문 내용을 입력하세요');
        return;
    }
    
    var nickUseYn = "N";

    if ($("#nickUseYn").is(":checked")){
        nickUseYn = "Y";
    }
    
    var userNick = $("#txt_nickname").val();
    if(userNick){
        if (nickUseYn == 'Y')
        {
            if (userNick == '')
            {
                alert('닉네임을 입력하세요');
                $("#txt_nickname").focus();
                return;
            }
        }
    
        if (userNick.length > 10)
        {
            alert('닉네임의 길이가 너무 큽니다. 10자이내로 연락하세요.');
            $("#txt_nickname").focus();
            return;
        }
    }
    var notiEndDttm = $('#openCloseDate').val();
    
    if (notiEndDttm == '')
    {
        alert('게시 종료일자를 입력하세요');
        $('#openCloseDate').focus();
        return;
    }
    var rsrvYN = 'N';
    
    if ($("#chkReserveDate").is(":checked")){
        rsrvYN = 'Y';
    }
    
    
    if (rsrvYN == 'Y')
    {
        var openReserveHour = $('#openReserveHour option:selected').val();
        
        if (openReserveHour == 'null')
        {
            alert('예약 시간을 선택하세요');
            return;
        }
        var openReserveMin = $('#openReserveMin option:selected').val()+'00';
        if (openReserveMin == 'null')
        {
            alert('예약 분을 선택하세요');
            return;
        }
    }
    */
    if (boardKind == '030')
    {
        var cdlnEvntCode =  $('#cdlnEvntCode option:selected').val();
        
        if (cdlnEvntCode == 'null')
        {
            alert('경조사 구분을 선택하세요');
            return;
        }
        
        var cdlnObjrName =  $('#cdlnObjrName').val();   
        if (cdlnObjrName == "")
        {
            alert('대상자를 입력하세요');
            return;
        }
        
        var cdlnDeptFname =  $('#cdlnDeptFname').val();
        if (cdlnDeptFname == "")
        {
            alert('소속기관을 입력하세요');
            return;
        }
        
         var cdlnDeptName =  $('#cdlnDeptName').val();
        if (cdlnDeptName == "")
        {
            alert('소속부서를 입력하세요');
            return;
        }
        
    };
    
    if (write_apnd_kind == '020')  //이미지
    {
       if (jsonAppendImgList.length == 0)
       {
          alert('추가한 이미지가 없습니다. 이미지를 추가하세요');
          return;
       }
    }
    else if (write_apnd_kind == '030')  //동영상
    {
        if (jsonAppendMovList.length == 0)
        {
            alert('추가한 동영상이 없습니다. 동영상을 추가하세요');
            return;
        }
    }
    
    //portalexpet 추가
    //첨부 파일 upload
    var fileExist = false;
    $("#apndFileform input:file[name^=upFile]").each(function(){
        if($(this).val() != ""){
            fileExist = true;
        }
        return;
    });
    if(fileExist){
        fnMultiFileUpload();
    }else{
        fnBoardNotiCreate();
    }
};


var fnWriteCancel = function()
{
    if (loadingComplete) history.back(-1);
};

// 임시저장 버튼
var fnNotiTempInsert = function(data){
    
    var editMethod = "html";
    var mimeValue = null;
    var temp_mimeValue = null;
    
    PortalCommon.getJson({
        url: WEB_HOME+"/board230/insertBbsTmpNotiInfo.jdo?format=json",
        data: {'data' : data, 'contents' : mimeValue, 'htmlSrc' : null},
        contentType: "application/x-www-form-urlencoded; charset=utf-8",
        type : 'POST',
        success :function(data){
            if(data.jsonResult.success ===true){
                
                
                if (pageIndex == 0) pageIndex = 1;
                
                if (boardId = 'BBS999999')  //임시게시판이면
                {
                    parent.document.location.href = WEB_HOME+'/board100/boardFrame.jdo?boardId='+boardId+'&pageIndex=1&pageUnit=10&orderType=default';
                }
                else
                {
                    if (kind == 'BBS')
                    {
                        if (boardForm == '010')
                        {
                            location.href = WEB_HOME+'/board210/getBoardInfoList.jdo?boardId='+boardId+'&pageIndex='+pageIndex+'&pageUnit=10&orderType=default';
                        }
                        else if (boardForm == '020')  //SNS형
                        {
                            alert('게시판 종류가 SNS형 게시판 입니다.');
                            location.href = WEB_HOME+'/board220/getBbsSnsBoardList.jdo?boardId='+boardId+'&pageIndex=1&pageUnit=10&orderType=default';
                        }
                        else if (boardForm == '030')  //컨텐츠
                        {
                            if (boardFormSpec =='010') //이미지형
                            {
                                location.href = WEB_HOME+'/board211/getBbsImgBoardNotiList.jdo?boardId='+boardId+'&pageIndex=1&pageUnit=6&orderType=default';
                            }
                            else if (boardFormSpec =='020') //동영상
                            {
                                location.href = WEB_HOME+'/board212/getBbsVideoBoardNotiList.jdo?boardId='+boardId+'&pageIndex=1&pageUnit=6&orderType=default';
                            }
                            else if (boardFormSpec =='030') //컨텐츠리스트형
                            {
                                location.href = WEB_HOME+'/board213/getBbsContentsBoardNotiList.jdo?boardId='+boardId+'&pageIndex=1&pageUnit=6&orderType=default';
                            }
                            
                        }
                        else
                        {
                            location.href = WEB_HOME+'/board210/getBoardInfoList.jdo?boardId='+boardId+'&pageIndex='+pageIndex+'&pageUnit=10&orderType=default';
                        }
                    }
                }
            }
        }
    });
};


//게시물 저장
var fnNotiInsert = function(data){
    var editMethod = "html";
    var mimeValue = null;
    var temp_mimeValue = null;
    
    var jsonObject = {
            'mimeValue' : mimeValue
    };
    
    PortalCommon.getJson({
        url: WEB_HOME+"/board230/insertBbsNotiInfo.jdo?format=json",
        data: {'data' : data, 'contents' : jsonObject.mimeValue},
        contentType: "application/x-www-form-urlencoded; charset=utf-8",
        type : 'POST',
        success :function(data){
            if(data.jsonResult.success ===true){
                if (boardForm == '010')
                {
                    location.href = WEB_HOME+'/board210/getBoardInfoList.jdo?boardId='+boardId+'&pageIndex=1&pageUnit=10&orderType=default';
                }
                else if (boardForm == '020')  //SNS형
                {
                    alert('게시판 종류가 SNS형 게시판 입니다.');
                    location.href = WEB_HOME+'/board210/getBoardInfoList.jdo?boardId='+boardId+'&pageIndex=1&pageUnit=10&orderType=default';
                }
                else if (boardForm == '030')  //컨텐츠
                {
                    if (boardFormSpec =='010') //이미지형
                    {
                        location.href = WEB_HOME+'/board211/getBbsImgBoardNotiList.jdo?boardId='+boardId+'&pageIndex=1&pageUnit=6&orderType=default';
                    }
                    else if (boardFormSpec =='020') //동영상
                    {
                        location.href = WEB_HOME+'/board212/getBbsVideoBoardNotiList.jdo?boardId='+boardId+'&pageIndex=1&pageUnit=6&orderType=default';
                    }
                    else if (boardFormSpec =='030') //컨텐츠형
                    {
                        location.href = WEB_HOME+'/board213/getBbsContentsBoardNotiList.jdo?boardId='+boardId+'&pageIndex=1&pageUnit=6&orderType=default';
                    }
                    
                }
                else
                {
                    location.href = WEB_HOME+'/board210/getBoardInfoList.jdo?boardId='+boardId+'&pageIndex=1&pageUnit=10&orderType=default';
                }
            }
        }
    });
};


//게시물 임시저장
var fnBoardTempNotiCreate = function()
{
    var notiTitle = $("#txt_title").val().replace(/</g,"&lt;").replace(/>/g,"&gt;");
    
    
    var notiTitleOrgn = $("#txt_title").val().replace(/</g,"&lt;").replace(/>/g,"&gt;"); 
    
    var titleBoldYn = "N";
    var titleColorDiv = " ";
    
    if ($("#rt1").is(":checked")){
        titleBoldYn = "Y";
        notiTitle = "<b>"+notiTitle+"</b>";
    }
    
    if ($("#rt3").is(":checked")){      
        titleColorDiv = "RED";
        notiTitle = "<font color='red'>"+notiTitle+"</font>";
    }
    else
    {
        if ($("#rt2").is(":checked")){      
            titleColorDiv = "BLU";
            notiTitle = "<font color='blue'>"+notiTitle+"</font>";
        }
    }
    
    //var notiConts = tinymce.activeEditor.getContent();
    var notiConts = CrossEditor.GetBodyValue();
    var linkUrl = "";
    var notiTP = "010";
    
    var moblOpenDiv = $(':radio[name="moblOpenDiv"]:checked').val();
    var notiKind = write_apnd_kind;
    if(!notiKind){
        notiKind = "010";
    }
    
    var nickUseYn = "N";

    if ($("#nickUseYn").is(":checked")){
        nickUseYn = "Y";
    }
    
    var userNick = $("#txt_nickname").val();
    
    var editDiv = "010";
    var rsrvYN = 'N';
    
    if ($("#chkReserveDate").is(":checked")){
        rsrvYN = 'Y';
    }
    
    
    var notiBgnDttm = $('#openReserveDate').val();  
    var notiEndDttm = $('#openCloseDate').val();
    if(!notiEndDttm){
        notiEndDttm = "9999-12-31 23:59:59";
    }
    
    var notiOpenDiv = $(':radio[name="notiOpenDiv"]:checked').val();
    
    var notiOpenDivSpec='';
    if (userDiv == 'ALL'){
        notiOpenDivSpec = '010';
    }else if (userDiv == 'PUB'){
        notiOpenDivSpec = '020';
    }else if (userDiv == 'SGU'){
        notiOpenDivSpec = '030';
    }else if (userDiv == 'ADM'){
		notiOpenDivSpec = '040';
	}
    
    var opnPrmsYN = 'N';
    
    if ($("#opnPrmsYN").is(":checked")){
        opnPrmsYN = 'Y';
    };
    
    
    var agrmOppYn = 'N';
    if ($("#agrmOppYN").is(":checked")){
        agrmOppYn = 'Y';
    }
    
    var replyPrmsYn = 'N';  
    if ($("#replyPrmsYn").is(":checked")){
        replyPrmsYn = 'Y';
    };
    
    var opnMakrRealnameYn = $(':radio[name="opnMarkRealNameYN"]:checked').val();
    
    var notiTagLst = $("#txt_tag").val();   

    if (tmpNotiSeq == '' ) tmpNotiSeq = 0;
    
    
    var cdlnEvntCode = '';
    var cdlnObjrName = '';
    var cdlnDeptFname = '';
    var cdlnDeptName = '';
    var cdlnDeptCode = '';
    
    if (boardKind == '030')
    {
        cdlnEvntCode =  $('#cdlnEvntCode option:selected').val();
        cdlnObjrName =  $('#cdlnObjrName').val();   
        cdlnDeptFname =  $('#cdlnDeptFname').val();
        cdlnDeptName =  $('#cdlnDeptName').val();
    }
    
    var anmtYn = 'N';
    if ($("#rt4").is(":checked")){
        anmtYn = 'Y';
    };
    
    var jsonWriteObject = {
         'tmpNotiSeq' : tmpNotiSeq
        , 'upNotiId' : ''
        , 'sortSeq' : '0'
        , 'boardId' : boardId
        , 'emgcYn' : 'N'
        , 'anmtYn' : anmtYn
        , 'popupYn' : 'N'
        , 'briefYn' : 'N'
        , 'moblOpenDiv' : moblOpenDiv
        , 'notiTitle' : notiTitle
        , 'notiTitleOrgn' : notiTitleOrgn
        , 'titleBoldYn' : titleBoldYn
        , 'titleColorDiv' : titleColorDiv
        , 'notiConts' : notiConts
        //, 'notiConts' : ''
        , 'linkUrl' : linkUrl
        , 'notiTp' : notiTP
        , 'notiKind' : notiKind
        , 'nickUseYn' : nickUseYn
        , 'userId' : userId
        , 'userNick' : userNick
        , 'userName' : userName
        , 'editDiv' : editDiv
        , 'rsrvYn' : rsrvYN
        , 'notiBgnDttm' : notiBgnDttm
        , 'notiEndDttm' : notiEndDttm
        , 'notiOpenDiv' : notiOpenDiv
        , 'notiOpenDivSpec' : notiOpenDivSpec
        , 'publAsgnDiv' : ''
        , 'publAsgnDivSpec' : ''
        , 'replyPrmsYn' : replyPrmsYn
        , 'replyMakrRealnameYn' : 'N'  
        , 'opnPrmsYn' : opnPrmsYN   //작성자 실명여부
        , 'opnMakrRealnameYn' : opnMakrRealnameYn  //실명여부
        , 'notiTagLst' : notiTagLst  
        , 'notiReadCnt' : '0'
        , 'notiOpnCnt' : '0'
        , 'notiAgrmCnt' : '0'
        , 'notiOppCnt' : '0'
        , 'notiLikeCnt' : '0'
        , 'moblSendCnt' : '0'
        , 'bfBoardId' : ''
        , 'bfNotiId' : ''
        , 'statCode' : ''
        , 'deptCode' : ''
        , 'deptName' : ''
        , 'deptFname' : ''
        , 'makrIp' : ''
        , 'brghCode' : ''
        , 'cdlnDeptCode' : cdlnDeptCode
        , 'cdlnDeptName' : cdlnDeptName
        , 'cdlnDeptFname' : cdlnDeptFname
        , 'cdlnObjrName' : cdlnObjrName
        , 'cdlnEvntCode' : cdlnEvntCode
        , 'delYn' : 'N'
        , 'regrId' : notiWriteId
        , 'regrName' : ''
        , 'regDttm' : ''
        , 'updrId' : notiWriteId
        , 'updrName' : ''
        , 'updDttm' : ''
        , 'oldBrdId' : ''
        , 'oldHeaderId' : ''
        , 'oldOrignalId' : ''
        , 'oldNoticeSeq' : ''
        , 'agrmOppYn' : agrmOppYn
        , 'isAdmin' : isAdmin
        , 'AppendList' : []         
        , 'AppendFileList' : []  //첨부 리스트
        , 'NotiOpenDivDeptList' : []  // 조회자 지정 부서
        , 'NotiOpenDivEmpList' : []   // 조회자 지정 개인
        
    };
    
    //게시자 지정 부서지정
    $obj = $('#OpenDeptCategories li'); 
    for( var i=0; i < $obj.length; i++)
    {
        var jsonObject = {
                'id' : $obj.eq(i).attr("id"),
                'name' : $obj.eq(i).text(),
                'div'  : 'DPT',
                'auth' : 'RED'
        };
        jsonWriteObject.NotiOpenDivDeptList[i] = jsonObject;
    }
    
    //게시자 지정 개인지정
    $obj = $('#OpenEmpCategories li');  
    for( var i=0; i < $obj.length; i++)
    {
        var jsonObject = {
                'id' : $obj.eq(i).attr("id"),
                'name' : $obj.eq(i).text(),
                'div'  : 'EMP',
                'auth' : 'RED'
        };
        jsonWriteObject.NotiOpenDivEmpList[i] = jsonObject;
    }

    if (write_apnd_kind == '020')  //이미지
    {
       if (jsonAppendImgList.length == 0)
       {
          alert('추가한 이미지가 없습니다. 이미지를 추가하세요');
          return;
       }
       jsonWriteObject.AppendList=jsonAppendImgList;
       
    }
    else if (write_apnd_kind == '030')  //동영상
    {
        
        if (jsonAppendMovList.length == 0)
        {
            alert('추가한 동영상이 없습니다. 동영상을 추가하세요');
            return;
        }
        jsonWriteObject.AppendList=jsonAppendMovList;
    }
    else if (write_apnd_kind == '040')  //설문
    {
        var jsonSurveyObjectList = [];                  
        var start_day  = $("#start_date").val();  //시작 일자
        var start_hour = $('#start_hour option:selected').val(); //시간             
        var start_min  = $('#start_min option:selected').val();   //분
        var limit_day  = $("#close_date").val();  //마감 일자
        var limit_hour = $('#inp_hour option:selected').val(); //시간         
        var limit_min  = $('#inp_min option:selected').val();   //분

        var rshOpenYn  = $(':radio[name="researchOpenYn"]:checked').val(); //공개여부
       
        for(var i=0; i < arNo.length; i++)  //질문갯수
        {                                            
            var tableCnt = $('#tableCnt-'+arNo[i]).val();               
            for(var j=1; j<=tableCnt; j++)
            {
         	 //설문 기본정보
                var surveyJsonObject = {
                 'surveyNo' : '0'
                , 'relaNotiKind' : ''
                , 'notiId' : ''
                , 'tmpNotiSeq' : '0'
                , 'tmlnSeq' : '0'
                , 'userNotiSeq' : '0'
                , 'surveyOpenDttm' : ''
                , 'surveyClosDttm' : ''
                , 'surveyRsltOpenYn' : ''
                , 'surveyConts' : ''
                , 'surveyTp' : ''
                , 'delYn' : 'N'
                , 'regrId' : ''
                , 'regrName' : ''
                , 'regDttm' : ''
                , 'updrId' : ''
                , 'updrName' : ''
                , 'updDttm' : ''
                , 'surveyForm' : ''
                , 'grpSurveyNo' : '0'
                , 'grpSurveyCnt' : '0'
           	   , 'exmplTp' : ''
   			   , 'inputAddYn' : ''
   		       , 'skipPermitYn' : ''
   		       , 'multiSelPermitYn' : ''      		    	
                , 'apndExmpList' : []
                };            	             	 
         	 
         	   var surveyConts = $('#txt_area-'+arNo[i]+'-'+j).val();  
         	   var view_type = $(':radio[name="radio_name-'+arNo[i]+'-'+j+'"]:checked').val();
         	   var inputAddYn = '';
         	   if($('#input_plus-'+arNo[i]+'-'+j).is(":checked"))
         	   {
         		   inputAddYn = 'Y';
         	   }
         	   else
         	   {
         		   inputAddYn = 'N';
         	   }
         	   var skipPermitYn = '';
                if($('#chk_skip-'+arNo[i]+'-'+j).is(":checked"))
                {
             	   skipPermitYn = 'Y';
                }
                else
                {
             	   skipPermitYn = 'N';
                }
                var multiSelPermitYn = '';
                if($('#chk_multi-'+arNo[i]+'-'+j).is(":checked"))
                {
             	   multiSelPermitYn = 'Y';
                }
                else
                {
             	   multiSelPermitYn = 'N';
                }
         	   
         	   surveyJsonObject.surveyOpenDttm = start_day+start_hour+start_min+'00';  //설문시작일시
                surveyJsonObject.surveyClosDttm = limit_day+limit_hour+limit_min+'00';  //설문마감일시
                surveyJsonObject.surveyRsltOpenYn = rshOpenYn; //공개여부
                surveyJsonObject.surveyConts = surveyConts;  //설문내용
                surveyJsonObject.surveyTp = view_type;    //설문유형(텍스트/이미지)
                surveyJsonObject.surveyForm = $(':radio[name="question_type'+arNo[i]+'"]:checked').val(); //설문형태(개별질문/그룹질문)
                if($('#grp_question'+arNo[i]).is(":checked"))
                {
                    surveyJsonObject.grpSurveyNo = $('#question_no-'+arNo[i]).val()*1; //그룹번호
                    surveyJsonObject.grpSurveyCnt = $('#question_cnt'+arNo[i]).val()*1; //그룹문제 갯수
                }                    
                surveyJsonObject.exmplTp = $(':radio[name="question_type-'+arNo[i]+'-'+j+'"]:checked').val(); //질문유형(객관식/주관식)
                surveyJsonObject.inputAddYn = inputAddYn; //직접입력추가여부
                surveyJsonObject.skipPermitYn = skipPermitYn; //스킵허용여부
                surveyJsonObject.multiSelPermitYn = multiSelPermitYn; //복수선택허용여부
                
				var view_type = '020';  //보기유형            
                if($('#radio_txt-'+arNo[i]+'-'+j).is(":checked"))
                {
                    view_type = '010';
                }
                
                if(!$('#radio_single-'+arNo[i]+'-'+j).is(":checked"))
                {
	                var txtViewCnt = $('#hid_txt_view1-'+arNo[i]+'-'+j).val();            
	                for(var k=1; k<=txtViewCnt; k++)
	                {
	             	   var jsonObject = {
	                            'surveyNo' : '0'
	                           , 'exmplNo' : '0'
	                           , 'exmplConts' : ''
	                           , 'imgPath' : ''
	                           , 'imgName' : ''
	                           , 'prvwPath' : ''
	                           , 'prvwName' : ''
	                           , 'totCnt' : '0'
	                           , 'rsltCnt' : '0'
	                           , 'rsltRto' : '0'
	                           , 'delYn' : 'N'
	                           , 'regrId' : ''
	                           , 'regrName' : ''
	                           , 'regDttm' : ''
	                           , 'updrId' : ''
	                           , 'updrName' : ''
	                           , 'updDttm' : ''
	                           , 'moveExmplNo' : ''
	                    };
	             	   
	             	  
	             	   if(view_type == '010')  //텍스트
	                    {
	             		   jsonObject.exmplConts = $('#txt_view-'+arNo[i]+'-'+j+'-'+k).val();
	             		   /*
	             		   if(!$('#chk_skip-'+cnt+'-'+i).is(":checked"))
	                        {
	             			   jsonObject.exmplConts = $('#txt_view1-'+arNo[i]+'-'+j+'-'+k).val();
	                        }
	             		   else
	             		   {
	             			   jsonObject.exmplConts = $('#txt_view2-'+arNo[i]+'-'+j+'-'+k).val();
	             		   }
	             		   */
	                    }
	             	   else
	            	   {
	             		   var tmpStr = $('#rshimg-'+arNo[i]+'-'+j+'-'+k).attr("src");
	                        var filePath = tmpStr.substring(0, tmpStr.lastIndexOf('/'));
	                        var fileName = tmpStr.substring(tmpStr.lastIndexOf('/')+1,  tmpStr.length);
	                        jsonObject.imgPath = filePath;
	                        jsonObject.imgName = fileName;
	                        
	                        tmpStr = $('#txt_view-'+arNo[i]+'-'+j+'-'+k).val();
	                        /*
	                        if(!$('#chk_skip-'+cnt+'-'+i).is(":checked"))
	                        {
	                     	   tmpStr = $('#txt_view1-'+arNo[i]+'-'+j+'-'+k).val(); 
	                        }
	                        else
	                        {
	                     	   tmpStr = $('#txt_view2-'+arNo[i]+'-'+j+'-'+k).val(); 
	                        }
	                        */
	                        filePath = tmpStr.substring(0, tmpStr.lastIndexOf("\\"));
	                        fileName = tmpStr.substring(tmpStr.lastIndexOf("\\")+1,  tmpStr.length);
	                        
	                        jsonObject.prvwPath = filePath;
	                        jsonObject.prvwName = fileName;
	            	   }
	             	
	             	   if($('#chk_skip-'+arNo[i]+'-'+j).is(":checked"))
	                   {
	                       jsonObject.moveExmplNo = $('#sel_view-'+arNo[i]+'-'+j+'-'+k).val();
	                   }
	             	   surveyJsonObject.apndExmpList.push(jsonObject);
	                }
                }
                jsonSurveyObjectList.push(surveyJsonObject); 
            }   
                          
        }
        
        jsonWriteObject.AppendList = jsonSurveyObjectList;
    }
    /*
    else if (write_apnd_kind == '040')  //설문
    {
        var jsonSurveyObjectList = [];  
        //임시
        /*       
        var start_day  = $("#start_date").val();  //시작 일자
        var start_hour = $('#start_hour option:selected').val(); //시간
        
        if (start_hour == 'null')
        {
            alert('설문 시작 시간을 선택하세요');
            $('#start_hour').focus();
            return;
        }               
        var start_min  = $('#start_min option:selected').val();   //분
        if (start_min == 'null')
        {
            alert('설문 시작 시간(분)을 선택하세요');
            $('#start_min').focus();
            return;
        }
        
           var limit_day  = $("#close_date").val();  //마감 일자
           var limit_hour = $('#inp_hour option:selected').val(); //시간
           
           if (limit_hour == 'null')
           {
               alert('설문 마감 시간을 선택하세요');
               $('#limit_hour').focus();
               return;
           }               
           var limit_min  = $('#inp_min option:selected').val();   //분
           if (limit_min == 'null')
           {
               alert('설문 마감 시간(분)을 선택하세요');
               $('#inp_min').focus();
               return;
           }

           
           var rshOpenYn  = $(':radio[name="researchOpenYn"]:checked').val(); //공개여부
           var resObj = $('[id^="research-"]');
           
           for (var i=0; i < resObj.length; i++)  //질문갯수
           {
               
               //설문 기본정보
               var surveyJsonObject = {
                'surveyNo' : '0'
               , 'relaNotiKind' : 'TMP'
               , 'notiId' : ''
               , 'tmpNotiSeq' : '0'
               , 'tmlnSeq' : '0'
               , 'userNotiSeq' : '0'
               , 'surveyOpenDttm' : ''
               , 'surveyClosDttm' : ''
               , 'surveyRsltOpenYn' : ''
               , 'surveyConts' : ''
               , 'surveyTp' : ''
               , 'delYn' : 'N'
               , 'regrId' : ''
               , 'regrName' : ''
               , 'regDttm' : ''
               , 'updrId' : ''
               , 'updrName' : ''
               , 'updDttm' : ''
               , 'apndExmpList' : []
               };
               
               var surveyConts = resObj.eq(i).find('textarea').val();  //질문내용
               var view_cnt = resObj.eq(i).find('input:eq(0)').val();  //보기갯수
               var view_type = '020';  //보기유형
               if (resObj.eq(i).find('input:eq(12)').is(':checked')) 
               {
                   view_type = '010';
               }
               
               surveyJsonObject.surveyOpenDttm = start_day+start_hour+start_min+'00';  //설문마감일시
               surveyJsonObject.surveyClosDttm = limit_day+limit_hour+limit_min+'00';  //설문마감일시
               surveyJsonObject.surveyRsltOpenYn = rshOpenYn; //공개여부
               surveyJsonObject.surveyConts = surveyConts;  //설문내용
               surveyJsonObject.surveyTp = view_type;    //설문유형
               
               var olObj = resObj.eq(i).find('td ol');                 
               for (var j=0; j < olObj.length; j++)  //보기갯수
               {
                   var jsonObject = {
                        'surveyNo' : '0'
                       , 'exmplNo' : '0'
                       , 'exmplConts' : ''
                       , 'imgPath' : ''
                       , 'imgName' : ''
                       , 'prvwPath' : ''
                       , 'prvwName' : ''
                       , 'totCnt' : '0'
                       , 'rsltCnt' : '0'
                       , 'rsltRto' : '0'
                       , 'delYn' : 'N'
                       , 'regrId' : ''
                       , 'regrName' : ''
                       , 'regDttm' : ''
                       , 'updrId' : ''
                       , 'updrName' : ''
                       , 'updDttm' : ''
                   };
                   
                   if (view_type == '010')  //텍스트
                   {
                       if (olObj.eq(j).find('input:eq(0)').val() == '')
                       {
                         alert('보기항목 [텍스트]을 입력하세요');
                         return;
                       }
                       jsonObject.exmplConts = olObj.eq(j).find('input:eq(0)').val();
                   }
                   else  //이미지
                   {
                       if (olObj.eq(j).find('img').attr("src") == null)
                       {
                           alert('보기항목 [이미지]을  입력하세요');
                           return;
                       }
                       var tmpStr = olObj.eq(j).find('img').attr("src");
                       var filePath = tmpStr.substring(0, tmpStr.lastIndexOf('/'));
                       var fileName = tmpStr.substring(tmpStr.lastIndexOf('/')+1,  tmpStr.length);
                       jsonObject.imgPath = filePath;
                       jsonObject.imgName = fileName;
                       
                       tmpStr = olObj.eq(j).find('input:eq(0)').val(); 
                       filePath = tmpStr.substring(0, tmpStr.lastIndexOf("\\"));
                       fileName = tmpStr.substring(tmpStr.lastIndexOf("\\")+1,  tmpStr.length);
                       
                       jsonObject.prvwPath = filePath;
                       jsonObject.prvwName = fileName;
                       
                       
                   }
                   
                   surveyJsonObject.apndExmpList.push(jsonObject);
                   
               }
               jsonSurveyObjectList.push(surveyJsonObject);
           }
           
           jsonWriteObject.AppendList = jsonSurveyObjectList;
    }
    */
    
    if (jsonAppendFileList.length > 0)
    {
        jsonWriteObject.AppendFileList = jsonAppendFileList; 
    }
    
    fnNotiTempInsert(JSON.stringify(jsonWriteObject));
};


//임시저장
var fnWriteTempInsert = function()
{

    if (nojoYn == 'N')
    {
        alert('업무 시간 이외 에는  등록 할 수 없습니다.');
        return;
    }

    
    if (!confirm('임시 저장 하시겠습니까?')) {
        return;
    }   
    
    insertMode = "temp";
    
    fnBoardTempNotiCreate();
};


var fnMovieEffect = function(id)
{
    /*sns 이미지 등록 - sns 가로,세로 가로정렬*/
    //$obj = $('.sns_img');
      $obj = $('#'+id);
      for( var j=0; j < $obj.length; j++)
      {
            var li_list = $obj[j];
            $(li_list).find('img').each(function(){
                if ($(this).width() >= $(li_list).width()){
                    $(this).css( {
                         'width': '100%'
                    });
                    $(this).css( {
                         'width': '100%',
                         'margin-left': '-' + $(this).width()/2 +"px",
                         'margin-top': '-' + $(this).height()/2 +"px"
                    });
                } else if($(this).width() < $(this).parents('li').width()){
                        $(this).css({
                            'width':'auto',
                            'margin-left': '-' + $(this).width()/2 +"px",
                            'margin-top': '-' + $(this).height()/2 +"px"        
                        });
                    };
            });
       };
};




    //게시판 선택 팝업
    var fnBoardListView = function()
    {
        PortalCommon.windowPopup(WEB_HOME+'/board/organization/totCategoryChartPop.jdo?kind=2&type=1&admin=1&select=2', '카테고리',400,460);  //select옵션이 2 면 한개만 선택
    };

    //게시판명 선택
    var callbackBoardList = function(data)
    {
        var jsonArr = $.parseJSON(data);
        
        boardId = jsonArr[0].id;  //1건 이므로
        $("#txtBoardName").val(jsonArr[0].name);
        
    };

//첨부파일 추가
var fnAddFileList = function()
{
    var id = Math.floor(Math.random() * (9999998))+2;
    /*
    $("#apndFileform ul").append(
      //'<li id="apnd-'+id+'" class="fo_11px ma_bot5">'
      //+'<span class="inp_file2">'
      //+'<input type="text" title="파일을 넣으세요">' 
      //+'<a href="#" class="btn_file"><input type="file" class="file2" size="1" title="찾기" id="file-'+id+'" name="upFile-'+id+'"></a>'
      //+'<a style="cursor:pointer;" onclick="javascript:fnDelFileList(\'apnd-'+id+'\')" class="btn_grid2"><span class="btn_text">삭제</span></a>'
      //+'</span>'
      //+'</li>'
            '<li id="apnd-'+id+'" class="ma_bot5"> '
            +'<input type="text" class="text" style="width:476px" title="파일을 넣으세요" readonly> ' 
            +'<a href="#" class="btn_style1_2 mv_file_a"><input type="file" class="mv_file" size="1" title="찾기" id="file-'+id+'" name="upFile-'+id+'" onchange="javascript:fnChgAddFile();">파일</a> '
            +'<a style="cursor:pointer;" onclick="javascript:fnDelFileList(\'apnd-'+id+'\')" class="btn_style1_2">삭제</a> '
            +'</li>'
    );*/
	$("#apndFileform ul").append(
			//'<li id="apnd-'+id+'" class="ma_bot5"> '
			//+'<input type="text" class="text" style="width:476px;height:30px;" title="파일을 넣으세요" readonly> ' 
			//+'<a href="#" class="btn_set bt_style1 mv_file_a"><input type="file" class="mv_file" size="1" title="찾기" id="file-'+id+'" name="upFile-'+id+'"> '
			//+'<button type="button" class="btn_style2_2">파일</button></a> '
			//+'<a style="cursor:pointer;" onclick="javascript:fnDelFileList(\'apnd-'+id+'\')" class="btn_set bt_style1"><button type="button" class="btn_style2_2">삭제</button></a> '
			//+'</li>'
			'<li id="apnd-'+id+'" class="ma_bot5"> '
			+'<input type="text" class="text" style="width:476px" readonly>'
			+'<span class="file_wrap">'
			+'	<button class="btn_style1_2" type="button">파일</button>'
			+'	<input type="file" id="file-'+id+'" name="upFile-'+id+'" class="file_hidden" />'
			+'</span>'					    
			+'<button type="button" class="btn_style1_2" onclick="fnDelFileList(\'apnd-'+id+'\')">삭제</button>'		
			+'</li>'
	);    
    
    
    $("#file-"+id).bind("change",function(e) {
        $(this).parent().prev().val($(this).val());
    });

    parent.document.getElementById("bbsFrame").height = $(document).height()+"px";
    
    return false;
}   

var fnDelFileList = function(id)
{
    $("#"+id).remove();
}

//첨부파일 전송
var fnMultiFileUpload = function()
{  
    var chk = true;
    $("#apndFileform input:file[name^=upFile]").each(function(){
        if(!PortalCommon.execUploadFileCheck($(this).val())){
            chk = false;
            return false;
        }
    });
    if(!chk){
        alert("추가할 수 없는 파일입니다.");
        return;
    }

    $("#apndFileform").ajaxSubmit({
        url : WEB_HOME+"/board230/bbsFileUpload.jdo",
        // contentType: "application/x-www-form-urlencoded; charset=utf-8",

        type : 'POST',
        data :  $("#apndFileform").serialize(),
        action: $("#dummy"),
        dataType : "script",
        success : function(data){
        	//alert("data: "+data);
            makeApndFileList($.parseJSON(data));
            fnBoardNotiCreate();
        },error : function(){
            alert("전송 실패 했습니다.");
        },
        clearForm: true,
        resetForm: true
    });
}

//동영상첨부파일 추가
var fnAddMovieFileList = function()
{
    var id = Math.floor(Math.random() * (9999998))+2;
    /*
    $("#movieImgform ul").append(
      '<li id="movieApnd-'+id+'" class="fo_11px ma_bot5">'
      +'<span class="inp_file2">'
      +'<input type="text" title="파일을 넣으세요">' 
      +'<a href="#" class="btn_file"><input type="file" size="1" title="찾기" id="moviefile-'+id+'" name="upMovieFile-'+id+'"></a>'
      +'<a style="cursor:pointer;" onclick="javascript:fnDelFileList(\'movieApnd-'+id+'\')" class="btn_grid2"><span class="btn_text">삭제</span></a>'
      +'</span>'
      +'</li>'
    );
    */
    
    $("#movieImgformDiv ul").append(
    '<li id="movieApnd-'+id+'">'
    +'<form id="movieImgform-'+id+'" name="movieImgform-'+id+'" enctype="multipart/form-data" method="post">'
    +'<input type="text" style="width:100px">'
    +'<input type="file" size="1" title="동영상추가" id="apndMovie-'+id+'" name="bbsUpMovie-'+id+'">'
    +'<input type="button" onclick="javascript:fnDelFileList(\'movieApnd-'+id+'\')" value="삭제">'
    +'</form>'
    +'</li>'
    );
    
    $("#moviefile-"+id).bind("change",function(e) {
        $(this).parent().prev().val($(this).val());
    });
    
}

//글수정시 파일업로드 목록 구함.
var makeAlreadyUploadFileList = function()
{
    var apndList = '[]';
    if (kind == 'TMP')
    {
        apndList = tmpApndList;
    }
    else
    {
        apndList = savedApndList;
    }   

    for (var j=0; j < apndList.length; j++)  //첨부파일
    {
        var obj = apndList[j];
        if (obj.apndFileTp == '050')
        {
                var jsonObject = {              
                          'notiId' : ''
                        , 'apndFileSeq' : obj.apndFileSeq
                        , 'apndFileTp' : '050'
                        , 'apndFileId' : obj.apndFileId
                        , 'apndFileSz' : obj.apndFileSz
                        , 'apndFileOrgn' : obj.apndFileOrgn
                        , 'apndFileName' : obj.apndFileName
                        , 'apndFilePath' : SAVE_DIR+'/'+obj.apndFilePath
                        , 'apndFilePrvwPath' : obj.apndFilePrvwPath
                        , 'apndFilePrvwName' : obj.apndFilePrvwName
                        , 'sourceCodeInput' : ''
                        , 'adminRcmdYn' : ''
                        , 'adminRcmdDttm' : ''
                        , 'readCnt' : '0'
                        , 'delYn' : 'N'
                        , 'regrId' : ''
                        , 'regrName' : ''
                        , 'regDttm' : ''
                        , 'updrId' : ''
                        , 'updrName' : ''
                        , 'updDttm' : ''
                        , 'mvpKey' : ''
                    
                };
                jsonAppendFileList.push(jsonObject);
        }
    }   
}

//파일업로드 성공한 목록
var makeApndFileList = function(obj){
    for(var i=0; i < obj.length; i++)
    {
        var json = obj[i];
        var jsonObject = {
                  'notiId' : ''
                , 'apndFileSeq' : '1'
                , 'apndFileTp' : '050'
                , 'apndFileId' : json.saveFileId
                , 'apndFileSz' : json.saveFileSize
                , 'apndFileOrgn' : json.original
                , 'apndFileName' : json.saveFileName
                , 'apndFilePath' : json.saveDir
                //, 'apndFilePrvwPath' : json.orgfilepath
                , 'apndFilePrvwPath' : json.saveDir  //파일수정시 참조하기위하여 저장
                , 'apndFilePrvwName' : json.saveFileName
                , 'sourceCodeInput' : ''
                , 'adminRcmdYn' : ''
                , 'adminRcmdDttm' : ''
                , 'readCnt' : '0'
                , 'delYn' : 'N'
                , 'regrId' : ''
                , 'regrName' : ''
                , 'regDttm' : ''
                , 'updrId' : ''
                , 'updrName' : ''
                , 'updDttm' : ''
                , 'mvpKey' : ''             
            };
        jsonAppendFileList.push(jsonObject);
    }
};

//첨부파일 삭제
var fnApndFileListRemove = function(id)
{
    for(var i=0; i < jsonAppendFileList.length; i++)
    {
        var json = jsonAppendFileList[i];
        if (json.apndFileSeq == id)
        {
            
            jsonAppendFileList.splice(i,1);
            break;
        }
    }
    $("#delapnd-"+id).remove();
};



////////////////////////////////onload/////////////////////////////////////////////////////////////////////

$(document).ready(function () {
	
    //데이타 로드
    var fnDataLoad  =  function()
    {
        var userList = "";
        //boardId = '${boardId}';
        //tmpNotiSeq = '${tmpNotiSeq}';
        //notiId = '${notiId}';
        //boardForm = '${boardForm}';
        //boardFormSpec = '${boardFormSpec}';

        if (kind == 'BBS')  //게시판 쓰기
        {
            //var userList = ${userMapList};
            var userList = userMapList;
            if (notiId == "")
            {
                
                /* userDiv = userList[0].userDiv ;
                if (userDiv == 'ALL'||userDiv == 'PUB'||userDiv =='SGU') //전체 공개
                {
                    
                }
                else
                {
                    for (var i=0; i < userList.length; i++)
                    {
                        if (userList[i].userDiv == 'DPT')
                        {
                            fnOpenDept(userList[i]);
                        }
                        else if (userList[i].userDiv == 'EMP')
                        {
                            fnOpenEmp(userList[i]);
                        }
                    }
                } */
            }
            else if (notiId != "")
            {
                for (var i=0; i < userList.length; i++)
                {
                    if (userList[i].userDiv == 'DPT')
                    {
                        fnOpenDept(userList[i]);
                    }
                    else if (userList[i].userDiv == 'EMP')
                    {
                        fnOpenEmp(userList[i]);
                    }
                }
            }
            
            
            
            if (boardFormSpec == '010')  //이미지형
            {
               $("#mobile_item").hide();
              
               $('input:radio[name=apndKind]:input[value='+'020'+']').attr("checked", "true");
               $("#item_kind").attr("disabled",true);
               $('#div_image_view').show();
               write_apnd_kind = "020";
               
            }
            else if (boardFormSpec == '020')  //동영상형
            {
                  $("#mobile_item").hide();
                  $('input:radio[name=apndKind]:input[value='+'030'+']').attr("checked", "true");
                  $("#item_kind").attr("disabled",true);
                  $('#div_media_view').show();
                  write_apnd_kind = "030";
            }
            else if (boardFormSpec == '030')  //컨텐츠 리스트형
            {
                  $("#mobile_item").hide();
                  $("#item_research").attr("disabled",true);
                  $('#div_media_view').show();
                  write_apnd_kind = "010";
            }
        };          
        
        fnSetCompoValue();
        
    }
    
    //게시판에 따른 화면  설정
    var fnSetCompoValue = function()
    {
        if (boardKind == '030')
        {
            //$("#mobile_item").hide();
            //$("#cdlnEvntTH").show();
            $("#cdlnEvntTH").css("visibility","visible");       
            
            //$("#cdlnEvntTD").show();
            $("#cdlnEvntTD").css("visibility","visible");
            //$("#cdlnObjrTH").show();
            $("#cdlnObjrTH").css("visibility","visible");
            //$("#cdlnObjrTD").show();
            $("#cdlnObjrTD").css("visibility","visible");
            $("#cdlnDeptFnameTR").show();
            
            $("#cdlnDeptFnameTH").css("visibility","visible");
            $("#cdlnDeptFnameTD").css("visibility","visible");
            
            $("#cdlnDeptFname").val('크로센트');
            

        }
        
        $('input:radio[name=moblOpenDiv]:input[value='+moblOpenDiv+']').attr("checked", "true"); //모바일 공개
        //의견 사용 여부
        if (opnWrteDiv == '020')
        {
            $("#opnPrmsTR").hide();
            $("#opnPrmsYN").removeAttr("checked");
        }
        //닉네임 사용 여부
        if (nickUseYn == 'N')
        {
            $("#nickUseYnTR").hide();
        }
        if (replyPrmsDiv = '020')
        {
            $("#replyPrmsTR").hide();
            $("#replyPrmsYn").removeAttr("checked");
        }
        //관리자면 
        if (isAdmin == 'Y')
        {
            $("#chkRedFont").show();
            
            $("#chkPopupYnTH").css("visibility","visible");
            $("#chkPopupYnTD").css("visibility","visible");
            
        }
        
        if (moblOpenYN == 'N')
        {
            $("#mobile_item").hide();
        }
        //찬성 반대
        if (agrmOppUseYn == 'N')
        {
            $("#agrmOppYnTR").hide();
        }
        
        //수정모드면 임시저장 막음
        if (notiId != "")
        {
            $("#tmpButton").hide();
            $("#tmpButton2").hide();
            
            //수정모드면 찬/반, 의견 항목 막음
            $("#agrmOppYnTR").hide();
            $("#opnPrmsTR").hide();
            
        }
        
        //게시물 권한이면 전체공개 막음
        if (notiReadmanAsgnYn == 'Y')
        {
            $("#notiOpenDiv_ALL_LI").css("display","none");
        }
        
        
        if(boardExplUseYn == 'Y' && boardExpl !=""){
            $("#boardExpl").html(boardExpl);
        }
        
        var notiKind = write_apnd_kind;
        if(notiKind == '020'){
            //이미지
            $("#div_img_view").show();
        }else if(notiKind == '030'){
            //동영상
            $("#div_mv_view").show();
        }
        
    };
    
    //부서지정
    var fnOpenDept = function(json){    
        var contains = false;
        
        $obj = $('#OpenDeptCategories li');
        for( var j=0; j < $obj.length; j++)
        {
            if ($obj.eq(j).attr("id") == json.userId)
            {
                contains = true;
                break;
            }
        }
        if (!contains) $('#OpenDeptCategories').append('<li id="'+json.userId+'"><a class="ico_del" style="cursor:pointer;" onclick="javascript:fnOpenPersonListRemove(\''+json.userId+'\')" ></a>'+json.displayName+'</li>');
    };
    
    //조회자 지정
    var fnOpenEmp = function(json){ 
        var contains = false;
        $obj = $('#OpenEmpCategories li');
        for( var j=0; j < $obj.length; j++)
        {
            if ($obj.eq(j).attr("id") == json.userId)
            {
                contains = true;
                break;
            }
        }
        if (!contains) $('#OpenEmpCategories').append('<li id="'+json.userId+'"><a class="ico_del" style="cursor:pointer;" onclick="javascript:fnOpenPersonListRemove(\''+json.userId+'\')" ></a>'+json.displayName+'</li>');
    };
    
    //추가 입력항목 클릭 처리 
    $("#id_apnd_item").click(function(eventObject) {
        
    });
    //alert(boardKind);
    //게시물 종류 처리
    $('#div_image_view').css("display","none");
    $("#div_image_view #bbsImgform").hide();
    
    $('#div_media_view').css("display","none");
    $("#div_media_view #movieImgform").hide();
             
    $("#bigbox").css("display","none");
    $("#tr_surveyDate").css("display","none");
    $("#tr_surveyOpen").css("display","none");
    $('#div_research_view').css("display","none");
    //$('#div_research_view').children().css("display","none");
    if (boardKind == '010')  //일반
    {
        write_apnd_kind = '010';
    }
    else if (boardKind == '020')  //이미지
    {
        write_apnd_kind = '020';
        //$('#div_image_view').show();
        $('#div_image_view').css("display","");
        //$('#div_image_view').children().css("display","block");
        $("#div_image_view #bbsImgform").show();
    }
    else if (boardKind == '030')  //동영상
    {
         write_apnd_kind = '030';
         //$("#div_media_view").show();
         $('#div_media_view').css("display","");
         //$('#div_media_view').children().css("display","block");
         $("#div_media_view #movieImgform").show();  
    }
    else if (boardKind == '110')  //설문
    {
         write_apnd_kind = '040';
         //$("#div_research_view").show();
         $("#bigbox").css("display","");
         $("#tr_surveyDate").css("display","");
         $("#tr_surveyOpen").css("display","");
         $('#div_research_view').css("display","");
         
         //$('#div_research_view').children().css("display","block");
    }      
    fnFrameReload();
    
    //이미지 전송    (동적)    
    $("#apndImg").change(function(e) {
        //jQuery.ajaxSetup({cache:false});
        if (jsonAppendImgList.length >= imgUploadMax)
        {
            alert('최대 이미지 추가 개수는 '+imgUploadMax+'개입니다.\n 더이상 추가 할 수 없습니다.' );
            return;
        }
        
        if(!PortalCommon.imgUploadFileCheck(bbsImgform.bbsUpImg.value)){
            alert("추가할 수 없는 파일입니다.");
            return;
        }
    
        
        $("#bbsImgform").ajaxSubmit({
            url : WEB_HOME+"/board230/bbsFileUpload.jdo",
            type : 'POST',
            data : $("#bbsImgform").serialize(),
            action: $("#dummy"),
            success : function(data){           
                loadImageList($.parseJSON(data));
            },error : function(){
                alert("전송 실패 했습니다.");
            },
            clearForm: true,
            resetForm: true
        }); 
    });
    
    
    //이미지 추가 (동적)
    var loadImageList = function(obj)
    {
        var json = obj[0];
        
        var size = json.saveFileSize/1024/1024;
        
        if (size > imgUploadSize)
        {
            alert('최대 이미지 추가 사이즈는 '+imgUploadSize+'M 입니다.' );
            return;
        }
        
        
        
        $('<li class="sns_img" id="'+json.saveFileId+'" name= '+json.original+'><img id="img-'+json.saveFileId+'" src="'+json.webDir+json.saveFileName+'" alt="이미지"><a style="cursor:pointer;" class="ico_clo" title="삭제" onclick="javascript:fnImgListRemove(\''+json.saveFileId+'\')" ><!--삭제--></a></li>').insertBefore($('#div_image_view .sns_imgadd'));

        var jsonObject = {
             'notiId' : ''
            , 'apndFileSeq' : jsonAppendImgList.length+1
            , 'apndFileTp' : '020'
            , 'apndFileSz' : json.saveFileSize
            , 'apndFileOrgn' : json.original
            , 'apndFileName' : json.saveFileName
            , 'apndFilePath' : json.saveDir
            , 'apndFilePrvwPath' : json.webDir
            , 'apndFilePrvwName' : json.saveFileName
            , 'sourceCodeInput' : ''
            , 'adminRcmdYn' : ''
            , 'adminRcmdDttm' : ''
            , 'readCnt' : '0'
            , 'delYn' : 'N'
            , 'regrId' : ''
            , 'regrName' : ''
            , 'regDttm' : ''
            , 'updrId' : ''
            , 'updrName' : ''
            , 'updDttm' : ''
            , 'mvpKey' : ''
        };      

        
        jsonAppendImgList.push(jsonObject);
        
        $("#img-"+json.saveFileId).load(function(){
            fnImgEffect(json.saveFileId);
        });
        
        fnFrameReload();
    };
    
    //이미지 전송    (정적)    
    $("input[id^=apndImg]").change(function(e) {
        var form_id = $(this).parent().attr("id");
        
        if(!PortalCommon.imgUploadFileCheck($(this).val())){
            alert("추가할 수 없는 파일입니다.");
            return;
        }
    
        
        $("#"+form_id).ajaxSubmit({
            url : WEB_HOME+"/board230/bbsFileUpload.jdo",
            type : 'POST',
            data : $("#"+form_id).serialize(),
            action: $("#dummy"),
            success : function(data){           
                loadImageList2(form_id, $.parseJSON(data));
            },error : function(){
                alert("전송 실패 했습니다.");
            },
            clearForm: true,
            resetForm: true
        }); 
    });
    
    //이미지 추가 (정적)
    var loadImageList2 = function(form_id, obj)
    {
        var json = obj[0];
        
        $('<li id="'+json.saveFileId+'" name= '+json.original+'><img id="img-'+json.saveFileId+'" src="'+json.webDir+json.saveFileName+'"  width="124" height="124"  alt="이미지"><a style="cursor:pointer;" class="ico_clo" title="삭제" onclick="javascript:fnImgListRemove(\''+json.saveFileId+'\')" ><!--삭제--></a></li>').insertBefore($("#"+form_id));
//          $('<li class="sns_img" id="'+json.saveFileId+'" name= '+json.original+'><img id="img-'+json.saveFileId+'" src="/portalxpert.template/upload/test.jpg" width="124" height="124" alt="이미지"><a style="cursor:pointer;" class="ico_clo" title="삭제" onclick="javascript:fnImgListRemove(\''+json.saveFileId+'\')" ><!--삭제--></a></li>').insertBefore($("#"+form_id));

        var jsonObject = {
             'notiId' : ''
            , 'apndFileSeq' : jsonAppendImgList.length+1
            , 'apndFileTp' : '020'
            , 'apndFileSz' : json.saveFileSize
            , 'apndFileOrgn' : json.original
            , 'apndFileName' : json.saveFileName
            , 'apndFilePath' : json.saveDir
            , 'apndFilePrvwPath' : json.webDir
            , 'apndFilePrvwName' : json.saveFileName
            , 'sourceCodeInput' : ''
            , 'adminRcmdYn' : ''
            , 'adminRcmdDttm' : ''
            , 'readCnt' : '0'
            , 'delYn' : 'N'
            , 'regrId' : ''
            , 'regrName' : ''
            , 'regDttm' : ''
            , 'updrId' : ''
            , 'updrName' : ''
            , 'updDttm' : ''
            , 'mvpKey' : ''
        };      

        
        jsonAppendImgList.push(jsonObject);
        
    };  
    
    //이미지 위치조정 
    var fnImgEffect = function(id)
    {
        /*sns 이미지 등록 - sns 가로,세로 가로정렬*/
        //$obj = $('.sns_img');
          $obj = $('#'+id);
          for( var j=0; j < $obj.length; j++)
          {
                var li_list = $obj[j];
                $(li_list).find('img').each(function(){
                //$('.sns_img img').each(function(){
                    if ($(this).width() >= $(li_list).width()){
                        //alert('1:'+$(this).width()+' '+$(this).parents('li').width());
                        $(this).css( {
                             'width': '100%'
                        });
                        $(this).css( {
                             'width': '100%',
                             'margin-left': '-' + $(this).width()/2 +"px",
                             'margin-top': '-' + $(this).height()/2 +"px"
                        });
                    } else if($(this).width() < $(this).parents('li').width()){
                            $(this).css({
                                'width':'auto',
                                'margin-left': '-' + $(this).width()/2 +"px",
                                'margin-top': '-' + $(this).height()/2 +"px"        
                            });
                        };
                });
           };
    };
    
    //설문의 질문입력(이전에 입력한 정보가 지워지지 않도록 수정  20130620)       
    $("#question_cnt").css('imeMode','disabled').keyup(function(e) {
        //숫자만 허용
        $(this).val( $(this).val().replace(/[^0-9]/g, '') );
        if (e.keyCode == '13') {
            
            var v_cnt =  $('[id^="research-"]').length;  //이전에 보여진 보기수
            var q_cnt = $('#question_cnt').val();   //현재 입력한 보기수
            
            if (q_cnt > surveyUploadMax)
            {
                alert('질문 개수는 '+surveyUploadMax+'개를 초과 할 수 없습니다.');
                return;
            }
            
            var differ_cnt = v_cnt - q_cnt;
            
            if (differ_cnt > 0 )  //이전에 입력한 보기가 많을경우
            {
                for (var i= v_cnt-1; i >= q_cnt; i--)
                {
                    $("#research-"+i).remove();
                }
            }
            else
            {
                for (var i= v_cnt; i < q_cnt; i++  )
                {
                    fnAddViewForm(i);
                }
            }
        }
        
        fnFrameReload();
    });

    //설문의 질문입력 포커스 처리 
    $("#question_cnt").focusout(function(e) {
        
        var e = jQuery.Event("keyup");
        e.which = 13;
        e.keyCode = 13
        $('#question_cnt').trigger(e);
    });
    
    
    
    //닉네임 클릭 처리
    $("#nickUseYn").click(function() {
        if ($(this).is(":checked"))
        {
            $("#txt_nickname").removeAttr("disabled");
        }
        else
        {
            $("#txt_nickname").attr("disabled",true);
        }
        
    });
    
    
    $("#txt_tag").click(function() {
        if ($(this).val() == '태그는 10개 이하로 입력 가능하며 쉼표로 구분합니다.'){
                $("#txt_tag").val('');
        }
    });
    
    //전체공개 클릭 처리
    $("#notiOpenDiv_ALL").click(function() {
        $("#notiOpenKind").hide();
    });
    //부서/개인 지정 클릭 처리
    $("#notiOpenDiv_PART").click(function() {
        $("#notiOpenKind").show();
    });
    
    //의견 허용 여부 클릭처리 
    $("#opnPrmsYN").click(function() {
        if ($(this).is(":checked")){
            $("#opnMarkRealNameYN_Y").removeAttr("disabled");
            $("#opnMarkRealNameYN_N").removeAttr("disabled");
        }
        else
        {
            $("#opnMarkRealNameYN_Y").attr('disabled', 'true');
            $("#opnMarkRealNameYN_N").attr('disabled', 'true');
        }
    });
    //예약 게시여부 클릭 처리
    $("#chkReserveDate").click(function() {
        if ($(this).is(":checked")){
            $("#openReserveDate").removeAttr("disabled");
            $("#openReserveHour").removeAttr("disabled");
            $("#openReserveMin").removeAttr("disabled");
            $('img.ui-datepicker-trigger').removeAttr("disabled");
        }
        else
        {
            $("#openReserveDate").attr('disabled', 'true');
            $("#openReserveHour").attr('disabled', 'true');
            $("#openReserveMin").attr('disabled', 'true');
            $('img.ui-datepicker-trigger').attr('disabled', 'true');
        }
    
    });
    
    //동영상 클릭 처리
    $("#movie_upload_select").change(function(eventObject) {
        if ($(this).val() == '010')
        {
            $("#movie_upload_1").show();
            $("#movie_upload_2").hide();
        }
        else
        {
            $("#movie_upload_1").hide();
            $("#movie_upload_2").show();
        }
        fnFrameReload();
    });

    
$(".btn_print_survey").click(function(){
	var top_po = (screen.availHeight/2) - (530/2);
    var left_po = (screen.availWidth/2) - (820/2);
    var f = document.pageForm;
    f.pageHtml.value = $("#page3").html();
    //var popup = window.open('', 'surveyPrintWin', 'top='+top_po+',left='+left_po+',width=820,height=530,resizable=yes,scrollbars=yes,toolbar=yes,menubar=yes');
    var pop = window.open;
    pop("","surveyWritePrintWin", 'top='+top_po+',left='+left_po+',width=820,height=530,resizable=yes,scrollbars=yes,toolbar=yes,menubar=yes');
    f.target = "surveyWritePrintWin";
    f.submit();
    
}); 

//목록 클릭 처리
$("#btn_item_list, #btn_item_list2").click(function(){

    /* $("#innoApDiv").remove();    
    $("#editor").remove(); */
    
    if (boardId == 'BBS999999')  //임시게시판이면
    {
        parent.document.location.href = WEB_HOME+'/board100/boardFrame.jdo?boardId='+boardId+'&pageIndex=1&pageUnit=10&orderType=default';
    }
    else
    {
        if (kind == 'BBS')
        {
            if (boardForm == '010')
            {
                location.href = WEB_HOME+'/board210/getBoardInfoList.jdo?boardId='+boardId+'&pageIndex=1&pageUnit=10&orderType=default';
            }
            else if (boardForm == '020')  //SNS형
            {
                
            }
            else if (boardForm == '030')  //컨텐츠
            {
                if (boardFormSpec =='010') //이미지형
                {
                    location.href = WEB_HOME+'/board211/getBbsImgBoardNotiList.jdo?boardId='+boardId+'&pageIndex=1&pageUnit=6&orderType=default';
                }
                else if (boardFormSpec =='020') //동영상
                {
                    location.href = WEB_HOME+'/board212/getBbsVideoBoardNotiList.jdo?boardId='+boardId+'&pageIndex=1&pageUnit=6&orderType=default';
                }
                
            }
        }
        else
        {
            if (boardForm == '010')
            {
                location.href = WEB_HOME+'/board210/getBoardInfoList.jdo?boardId='+boardId+'&pageIndex=1&pageUnit=10&orderType=default';
            }
            else if (boardForm == '020')  //SNS형
            {
                
            }
            else if (boardForm == '030')  //컨텐츠
            {
                if (boardFormSpec =='010') //이미지형
                {
                    location.href = WEB_HOME+'/board211/getBbsImgBoardNotiList.jdo?boardId='+boardId+'&pageIndex=1&pageUnit=6&orderType=default';
                }
                else if (boardFormSpec =='020') //동영상
                {
                    location.href = WEB_HOME+'/board212/getBbsVideoBoardNotiList.jdo?boardId='+boardId+'&pageIndex=1&pageUnit=6&orderType=default';
                }
                
            }
            
        }
    }
    
    
});

//동영상 전송        
$("input[id^=apndMovie]").change(function(e) {
//$("input[id^=apndMovie]").bind("change",function() {  alert('1');return;
//$(document).on("change","input[id^=apndMovie]",function() {
    
    
    if (jsonAppendMovList.length >= 1)
    {
        alert('최대 동영상 추가 개수는 '+1+'개입니다.\n 더이상 추가 할 수 없습니다.' );
        return;
    }
    

    if(!PortalCommon.movieUploadFileCheck($(this).val())){
        alert("추가할 수 없는 파일입니다.");
        return;
    }

    
        $("#movieImgform").ajaxSubmit({
        url : WEB_HOME+"/board230/movieFileUpload.jdo",
        type : 'POST',
        data : $("#movieImgform").serialize(),
        action: $("#dummy"),
        success : function(data){           
            loadMovieList($.parseJSON(data));
        },error : function(){
            alert("전송 실패 했습니다.");
            return;
        },
        clearForm: true,
        resetForm: true
    }); 
});


//동영상 추가
var loadMovieList = function(obj)
{
    var json = obj[0];


    var jsonObject = {
         'notiId' : ''
        , 'apndFileSeq' : '1'
        , 'apndFileTp' : '030'
        , 'apndFileSz' : json.saveFileSize
        , 'apndFileOrgn' : json.original
        , 'apndFileName' : json.saveFileName
        , 'apndFilePath' : json.saveDir
        , 'apndFilePrvwPath' : json.webDir
        , 'apndFilePrvwName' : json.saveFileName
        , 'sourceCodeInput' : ''
        , 'adminRcmdYn' : ''
        , 'adminRcmdDttm' : ''
        , 'readCnt' : '0'
        , 'delYn' : 'N'
        , 'regrId' : ''
        , 'regrName' : ''
        , 'regDttm' : ''
        , 'updrId' : ''
        , 'updrName' : ''
        , 'updDttm' : ''
        , 'mvpKey' : json.nkey
    };      

    
    jsonAppendMovList.push(jsonObject);
    
    /*
    var thumbnailImg = WEB_MOVIE_DIR+"/movie_process.jpg";
    $("#div_movie_add").prepend('<li class="sns_img" id="'+json.nkey+'"><img id="img-movie-'+json.nkey+'" src="'+thumbnailImg+'" alt="이미지"><a style="cursor:pointer;" class="ico_clo" title="삭제" onclick="javascript:fnMovieListRemove(\''+json.nkey+'\')" ><!--삭제--></a></li>');
    $("#img-movie-"+json.nkey).load(function(){
        fnMovieEffect(json.nkey);
    }); 
    */
    $("#movieFileDiv dl").append('<dd id="del_movie_apnd-'+json.saveFileId+'" style="border: 0 !important;">'+json.original+' <a class="ico_del" style="cursor:pointer;" onclick="javascript:fnMovieListRemove(\''+json.saveFileId+'\')" ></a></dd>');  
    
};  

$("input[name^=upFile]").change(function(e) {
    $(this).parent().prev().val($(this).val());
});

    //이노AP 설정
    //innApInstall();
    //달력 Setting
    fnSetCalendar();        
    //데이타 로드
    fnDataLoad();
    //화면Setting
    fnSetCompoValue();
    
    //editor 설정
    //fnMakeWebEditor(RES_HOME, '#editor');
    

    
    ////////////////////////////////////////////////////////////////////////////////////////////////
    
    //설문 보기 이미지 추가
    var fnResearchAddImg2 = function(obj, cnt)
    {
        var json = obj[0];
        
        //기존에 선택한 이미지가 있으면 삭제하고 추가한다.
        
        if ($('#ol_view-'+cnt+" li").length > 1) $('#ol_view-'+cnt+" li").last().remove();
        
        $('#ol_view-'+cnt).append(
            //'<li class="sns_img" id="'+json.saveFileId+'"><img id="rshimg-'+json.saveFileId+'" src="'+json.saveDir+json.saveFileName+'" alt="이미지"><input type="hidden" name='+json.saveDir+json.saveFileName+'><a href="#" class="ico_clo" title="삭제" onclick="javascript:fnResearchListRemove(\''+json.saveFileId+'\')"></a></li>'   
                '<li class="sns_img" id="'+json.saveFileId+'"><img id="rshimg-'+json.saveFileId+'" src="'+json.webDir+json.saveFileName+'" alt="이미지"><input type="hidden" name='+json.webDir+json.saveFileName+'><a href="#" class="ico_clo" title="삭제" onclick="javascript:fnResearchListRemove(\''+json.saveFileId+'\')"></a></li>'
        );
        
        $("#rshimg-"+json.saveFileId).bind("load",function(){
            fnImgTmpEffect();
            fnFrameReload();
        });
        
        //parent.document.getElementById("bbsFrame").height = $(document).height();
    };  
    
    //설문 보기항목 추가
    var fnAddTmpViewForm = function(cnt)
    {
        $("#research_body").append(
                '<tr id="research-'+cnt+'">'
                +'<th scope="row" class="ver_top">질문 입력</th>'
                +'<td>'
                +'  <ul class="h_list k2 clearfix">'
                +'      <li><textarea cols="30" rows="3" style="width:97%;"></textarea></li>'
                +'      <li class="fo_11px">보기개수 <input id="txt_view'+cnt+'" type="text" class="inp_mnum te_right ma_lef5" title="보기개수">개'
                +'          <span class="ma_lef25">보기유형<input type="radio" value="010" id="radio_txt-'+cnt+'" name="radio_name-'+cnt+'" class="ma_lef10" checked><label for="radio_txt-'+cnt+'">텍스트</label><input type="radio" value="020" id="radio_img-'+cnt+'" name="radio_name-'+cnt+'"><label for="radio_img-'+cnt+'">이미지</label>'
                +'          </span>'
                +'      </li>'                      
                +'      <li id="li_view-'+cnt+'">'
                +'      </li>'
                +'</ul>' 
                +'</td>'
                +'</tr>'
                        
            );
        
        $('#txt_view'+cnt).css('imeMode','disabled').bind("keyup", function(e)
        {
            $(this).val( $(this).val().replace(/[^0-9]/g, '') );
            if (e.keyCode == '13')
            {
                var b_cnt = $('#li_view-'+cnt+' ol').length;
                var c_cnt = $('#txt_view'+cnt).val();
                
                if (c_cnt > surveyUploadView)
                {
                    alert('보기의 최대개수는 '+surveyUploadView+'개 입니다.');
                    return;
                }
                
                if (b_cnt - c_cnt > 0)  //이전에 입력한 보기가 많을경우
                    {
                    for(var i = b_cnt; i > c_cnt; i--)
                        {
                        $('#ol_view-'+cnt+'_'+i).remove();
                        }

                    }
                else
                    {
                    var view_kind = $(':radio[name="radio_name-'+cnt+'"]:checked').val();
                    if (view_kind == '010')
                    {
                        for(var i = b_cnt+1; i <= c_cnt; i++)
                            {
                            $('#li_view-'+cnt).append(
                                    '<ol id="ol_view-'+cnt+'_'+i+'">'   
                                    +'<li class="fo_11px">보기'+i+'<input type="text" class="inp_half ma_lef25" title="항목 보기'+i+'"></li>'
                                    +'</ol>'
                            );
                            }
                    }
                    else
                        {
                        //
                        for(var i = b_cnt+1; i <= c_cnt; i++)
                            {
                            //
                            $('#li_view-'+cnt).append(
                                       '<ol id="ol_view-'+cnt+'_'+i+'">'        
                                       +'<li class="fo_11px">보기'+i+''                                  
                                       +'   <span class="inp_file2">'                                  
                                       +'       <input type="text" title="파일을 넣으세요" readOnly >'
                                       +'       <a href="#" class="btn_file">'
                                       +'           <form id="view_form-'+cnt+'_'+i+'" enctype="multipart/form-data" method="post">'
                                       +'               <input type="file" class="file2" size="1" title="찾기" id="viewFile-'+cnt+'_'+i+'" name="viewFile-'+cnt+'_'+i+'">'
                                       +'           </form>'
                                       +'       </a>'                                  
                                       +'   </span>'                                   
                                       +'</li>'
                                       +'</ol>'
                                    );
                                    
                                    $("#viewFile-"+cnt+'_'+i+"").bind("change",function() {
                                        $(this).parent().parent().prev().val($(this).val());
                                            var formfile = $(this).parent();
                                            var idx = formfile.attr("id");
                                            idx = idx.substring(idx.indexOf('-')+1, idx.length);
                                            $(formfile).ajaxSubmit({
                                            url : WEB_HOME+"/board230/bbsFileUpload.jdo",
                                            action: $("#dummy"),
                                            type : 'POST',
                                            data : $(formfile).serialize(),
                                            success : function(data){
                                                //var json = $.parseJSON(data);
                                                fnResearchAddImg2($.parseJSON(data), idx);//$(formfile).attr("id"));
                                            },error : function(){
                                                alert("전송 실패 했습니다.");
                                            },
                                            clearForm: false,
                                            resetForm: false
                                        });
                                    }); 
                            }

                        }
                    }
                fnImgTmpEffect();
            }
                    
        });
    
            //
    
            
        $("#radio_txt-"+cnt).bind("click",function() {
            
            var c_cnt = $('#txt_view'+cnt).val();
            
            if (c_cnt > surveyUploadView)
            {
                alert('보기의 최대개수는 '+surveyUploadView+'개 입니다.');
                return;
            }
            
            $('#li_view-'+cnt+' ol').remove();                  
            var e = jQuery.Event("keyup");
            e.which = 13;
            e.keyCode = 13
            $('#txt_view'+cnt).trigger(e);
        });
        
        
        $("#radio_img-"+cnt).bind("click",function() {
            
            var c_cnt = $('#txt_view'+cnt).val();
            
            if (c_cnt > surveyUploadView)
            {
                alert('보기의 최대개수는 '+surveyUploadView+'개 입니다.');
                return;
            }
            
            $('#li_view-'+cnt+' ol').remove();                  
            var e = jQuery.Event("keyup");
            e.which = 13;
            e.keyCode = 13
            $('#txt_view'+cnt).trigger(e);                      
        });
        
        
        
        $('#txt_view'+cnt).focusout(function(e) {
            var e = jQuery.Event("keyup");
            e.which = 13;
            e.keyCode = 13
            $('#txt_view'+cnt).trigger(e);
            
        });
    };  
        var fnImgUptEffect = function(id)
        {
            /*sns 이미지 등록 - sns 가로,세로 가로정렬*/
          //$obj = $('.sns_img');
            
            $obj = $('#'+id);
          for( var j=0; j < $obj.length; j++)
          {
                var li_list = $obj[j];
                $(li_list).find('img').each(function(){
                //$('.sns_img img').each(function(){
                    if ($(this).width() >= $(li_list).width()){
                        //alert('1:'+$(this).width()+' '+$(this).parents('li').width());
                        $(this).css( {
                             'width': '100%'
                        });
                        $(this).css( {
                             'width': '100%',
                             'margin-left': '-' + $(this).width()/2 +"px",
                             'margin-top': '-' + $(this).height()/2 +"px"
                        });
                    } else if($(this).width() < $(this).parents('li').width()){
                            $(this).css({
                                'width':'auto',
                                'margin-left': '-' + $(this).width()/2 +"px",
                                'margin-top': '-' + $(this).height()/2 +"px"        
                            });
                        };
                });
           };
        };      
        
        //동적
        var loadUpdImageList = function(obj)
        {
            var json = obj;     
        
            $('<li class="sns_img" id="'+json.saveFileId+'" name= '+json.apndFileOrgn+'><img id="img-'+json.saveFileId+'" src="'+WEB_DIR+'/'+json.apndFilePath+'/'+json.apndFileName+'" alt="이미지"><a style="cursor:pointer;" class="ico_clo" title="삭제" onclick="javascript:fnImgListRemove(\''+json.saveFileId+'\')" ><!--삭제--></a></li>').insertBefore($('#div_image_view .sns_imgadd'));
        
            var jsonObject = {
                 'notiId' : ''
                , 'apndFileSeq' : jsonAppendImgList.length+1
                , 'apndFileTp' : '020'
                , 'apndFileSz' : json.apndFileSz
                , 'apndFileOrgn' : json.apndFileOrgn
                , 'apndFileName' : json.apndFileName
                //, 'apndFilePath' : WEB_DIR+'/'+json.apndFilePath
                , 'apndFilePath' : SAVE_DIR+'/'+json.apndFilePath
                , 'apndFilePrvwPath' : json.apndFilePrvwPath
                , 'apndFilePrvwName' : json.apndFilePrvwName
                , 'sourceCodeInput' : ''
                , 'adminRcmdYn' : ''
                , 'adminRcmdDttm' : ''
                , 'readCnt' : '0'
                , 'delYn' : 'N'
                , 'regrId' : ''
                , 'regrName' : ''
                , 'regDttm' : ''
                , 'updrId' : ''
                , 'updrName' : ''
                , 'updDttm' : ''
                , 'mvpKey' : ''
            };      
        
            
            jsonAppendImgList.push(jsonObject);
            
            $("#img-"+json.saveFileId).load(function(){
                fnImgUptEffect(json.saveFileId);
            });
            
            fnFrameReload();
        };  
        
        //정적
        var loadUpdImageList2 = function(obj, idx)
        {
            var json = obj;     

            $('<li id="'+json.saveFileId+'" name= '+json.apndFileOrgn+'><img id="img-'+json.saveFileId+'" src="'+WEB_DIR+json.apndFilePath+'/'+json.apndFileName+'"  width="124" height="124"  alt="이미지"><a style="cursor:pointer;" class="ico_clo" title="삭제" onclick="javascript:fnImgListRemove(\''+json.saveFileId+'\')" ><!--삭제--></a></li>').insertBefore($("#bbsImgform"+idx));
            
            var jsonObject = {
                    'notiId' : ''
                        , 'apndFileSeq' : jsonAppendImgList.length+1
                        , 'apndFileTp' : '020'
                            , 'apndFileSz' : json.apndFileSz
                            , 'apndFileOrgn' : json.apndFileOrgn
                            , 'apndFileName' : json.apndFileName
                            //, 'apndFilePath' : WEB_DIR+'/'+json.apndFilePath
                            , 'apndFilePath' : SAVE_DIR+'/'+json.apndFilePath
                            , 'apndFilePrvwPath' : json.apndFilePrvwPath
                            , 'apndFilePrvwName' : json.apndFilePrvwName
                            , 'sourceCodeInput' : ''
                            , 'adminRcmdYn' : ''
                            , 'adminRcmdDttm' : ''
                            , 'readCnt' : '0'
                            , 'delYn' : 'N'
                            , 'regrId' : ''
                            , 'regrName' : ''
                            , 'regDttm' : ''
                            , 'updrId' : ''
                            , 'updrName' : ''
                            , 'updDttm' : ''
                            , 'mvpKey' : ''
                    };      
            
            
            jsonAppendImgList.push(jsonObject);
            
            //$("#img-"+json.saveFileId).load(function(){
            //  fnImgUptEffect(json.saveFileId);
            //});
            
            fnFrameReload();
        };      
        
        
        var loadTmpImageList = function(obj)
        {
            var json = obj;
            $('<li class="sns_img" id="'+json.saveFileId+'" name= '+json.original+'><img id="img-'+json.saveFileId+'" src="'+json.apndFilePrvwPath+json.apndFilePrvwName+'" alt="이미지"><a style="cursor:pointer;" class="ico_clo" title="삭제" onclick="javascript:fnImgListRemove(\''+json.saveFileId+'\')" ><!--삭제--></a></li>').insertBefore($('#div_image_view .sns_imgadd'));
            
            var jsonObject = {
                 'notiId' : ''
                , 'apndFileSeq' : jsonAppendImgList.length+1
                , 'apndFileTp' : '020'
                , 'apndFileSz' : json.apndFileSz
                , 'apndFileOrgn' : json.apndFileOrgn
                , 'apndFileName' : json.apndFileName
                , 'apndFilePath' : json.apndFilePath
                , 'apndFilePrvwPath' : json.apndFilePrvwPath
                , 'apndFilePrvwName' : json.apndFilePrvwName
                , 'sourceCodeInput' : ''
                , 'adminRcmdYn' : ''
                , 'adminRcmdDttm' : ''
                , 'readCnt' : '0'
                , 'delYn' : 'N'
                , 'regrId' : ''
                , 'regrName' : ''
                , 'regDttm' : ''
                , 'updrId' : ''
                , 'updrName' : ''
                , 'updDttm' : ''
                , 'mvpKey' : ''
            };
            
            jsonAppendImgList.push(jsonObject);
            
            $("#img-"+json.saveFileId).bind("load",function(){
                fnImgUptEffect(json.saveFileId);
            });
            
            fnFrameReload();
        };
        
        var fnImgTmpEffect = function()
        {
            /*sns 이미지 등록 - sns 가로,세로 가로정렬*/
          $obj = $('.sns_img');
            
          for( var j=0; j < $obj.length+1; j++)
          {
                $('.sns_img img').each(function(){
                    if ($(this).width() >= $(this).parents('li').width()){
                        //alert('1:'+$(this).width()+' '+$(this).parents('li').width());
                        $(this).css( {
                             'width': '100%',
                             'margin-left': '-' + $(this).width()/2 +"px",
                             'margin-top': '-' + $(this).height()/2 +"px"
                        });
                    } else if($(this).width() < $(this).parents('li').width()){
                            $(this).css({
                                'width':'auto',
                                'margin-left': '-' + $(this).width()/2 +"px",
                                'margin-top': '-' + $(this).height()/2 +"px"        
                            });
                        };
                });
           };
        };
        
        //임시저장 설문보기 설정
        var fnResearchTmpAddImg = function(obj, cnt)
        {
            var json = obj;     
            var saveFileId = json.imgName;
            $("#txt_survey-"+cnt).val(json.prvwPath+"\\"+json.prvwName);        
            var strArr = saveFileId.split(".");
             $('#ol_view-'+cnt).append(
                    '<li class="sns_img" id="'+strArr[0]+'"><img id="rshimg-'+strArr[0]+'" src="'+json.imgPath+'/'+json.imgName+'" alt="이미지"><input type="hidden" name='+json.webDir+json.saveFileName+'><a href="#" class="ico_clo" title="삭제" onclick="javascript:fnResearchListRemove(\''+strArr[0]+'\')"></a></li>'
            );
             
             
             
             
            $("#rshimg-"+strArr[0]).bind("load",function(){
                fnImgTmpEffect();
            }); 
            
        };
        
        var fnResearchAddImgLoad = function(obj, cnt)
        {
            var json = obj;
            
            
            //기존에 선택한 이미지가 있으면 삭제하고 추가한다.       
            if ($('#ol_view-'+cnt+" li").length > 1) $('#ol_view-'+cnt+" li").last().remove();
            
            $('#ol_view-'+cnt).append(
                //'<li class="sns_img" id="'+json.saveFileId+'"><img id="rshimg-'+json.saveFileId+'" src="'+json.saveDir+json.saveFileName+'" alt="이미지"><input type="hidden" name='+json.saveDir+json.saveFileName+'><a href="#" class="ico_clo" title="삭제" onclick="javascript:fnResearchListRemove(\''+json.saveFileId+'\')"></a></li>'   
                    '<li class="sns_img" id="'+json.saveFileId+'"><img id="rshimg-'+json.saveFileId+'" src="'+json.webDir+json.saveFileName+'" alt="이미지"><input type="hidden" name='+json.webDir+json.saveFileName+'><a href="#" class="ico_clo" title="삭제" onclick="javascript:fnResearchListRemove(\''+json.saveFileId+'\')"></a></li>'
            );
 
            
            $("#rshimg-"+json.saveFileId).bind("load",function(){
                fnImgTmpEffect();
                //fnFrameReload();
            });
            
            fnImgTmpEffect();
        };  
        
        var loadUpdMovieList = function(obj)
        { 
            //var WEB_MOVIE_DIR = WEB_MOVIE_DIR;
            var json = obj; 
            
            var jsonObject = {
                     'notiId' : ''
                    , 'apndFileSeq' : jsonAppendMovList.length+1
                    , 'apndFileTp' : '030'
                    , 'apndFileSz' : json.apndFileSz
                    , 'apndFileOrgn' : json.apndFileOrgn
                    , 'apndFileName' : json.apndFileName
                    , 'apndFilePath' : json.apndFilePath
                    , 'apndFilePrvwPath' : ''
                    , 'apndFilePrvwName' : ''
                    , 'sourceCodeInput' : ''
                    , 'adminRcmdYn' : ''
                    , 'adminRcmdDttm' : ''
                    , 'readCnt' : '0'
                    , 'delYn' : 'N'
                    , 'regrId' : ''
                    , 'regrName' : ''
                    , 'regDttm' : ''
                    , 'updrId' : ''
                    , 'updrName' : ''
                    , 'updDttm' : ''
                    , 'mvpKey' : json.mvpKey == null ? '' : json.mvpKey
            };
            
            jsonAppendMovList.push(jsonObject);
            
            /*
            $("#div_movie_add").prepend('<li class="sns_img" id="'+json.mvpKey+'"><img id="img-movie-'+json.mvpKey+'" src="'+WEB_MOVIE_DIR+'/'+json.apndFilePath+'/'+json.apndFileName+'" alt="이미지"><a style="cursor:pointer;" class="ico_clo" title="삭제" onclick="javascript:fnMovieListRemove(\''+json.mvpKey+'\')" ><!--삭제--></a></li>');
            $("#img-movie-"+json.mvpKey).load(function(){
                fnMovieEffect(json.mvpKey);
            }); 
            */
            $("#movieFileDiv dl").append('<dd id="del_movie_apnd-'+json.mvpKey+'" style="border: 0 !important;">'+json.apndFileOrgn+' <a class="ico_del" style="cursor:pointer;" onclick="javascript:fnMovieListRemove(\''+json.mvpKey+'\')" ></a></dd>');  
            
            
        };      
    
    /////////////////////////////////////////////////////////////////////////////////////////////////
    
        
        if (notiId != "")  //글수정
        {
            //console.log('qqq')
            //var notiList = ${notiList};
            //var surveyList = ${surveyList};
            //var surveyExmplList = ${surveyExmplList};
            var apndList = savedApndList;
            
            var json = notiList[0];
            var notiTitle = json.notiTitle;
            var notiTitleOrgn = json.notiTitleOrgn;
            var moblOpenDiv = json.moblOpenDiv;
            var titleBoldYn = json.titleBoldYn;
            var titleColorDiv = json.titleColorDiv;
            var notiConts = json.notiConts;
            var linkUrl = json.linkUrl;
            var notiTp = json.notiTp;
            var notiKind = json.notiKind;
            var nickUseYn = json.nickUseYn;
            var userNick = json.userNick;
            var userName = json.userName;
            var editDiv = json.editDiv;
            var rsrvYn = json.rsrvYn;
            var notiBgnDttm = json.notiBgnDttm;  //게시 시작일
            var notiEndDttm = json.notiEndDttm;  //게시 종료일
            var opnPrmsYn = json.opnPrmsYn;  //의견 허용 여부
            var replyPrmsYn = json.replyPrmsYn;  //답글 허용 여부
            
            var opnMakrRealnameYn = json.opnMakrRealnameYn;  //실명표기 여부
            var notiTagLst = json.notiTagLst;  //태그 
            var notiOpenDiv = json.notiOpenDiv;
            var agrmOppYn = json.agrmOppYn;
            
            var anmtYn = json.anmtYn; //공지
            

            $("#txt_title").val(notiTitleOrgn);  //제목
            
            if (titleBoldYn == 'Y')  //볼드체
            {
                $("#rt1").attr("checked", "true");
            }
            if (titleColorDiv == 'BLU')  //파랑색
            {
                $("#rt2").attr("checked", "true");
            }
            if (titleColorDiv == 'RED')  //빨강색
            {
                $("#rt3").attr("checked", "true");
            }
            $('input:radio[name=moblOpenDiv]:input[value='+moblOpenDiv+']').attr("checked", "true"); //모바일 공개
            $('input:radio[name=apndKind]:input[value='+notiKind+']').attr("checked", "true"); //게시물 종류
            
            
            //##############################추가항목 설정##############################
            //닉네임 사용 여부     
            if (nickUseYn == 'Y')
            {
                $("#nickUseYn").attr("checked", "true");
                $("#txt_nickname").removeAttr("disabled");
                $("#txt_nickname").val(userNick);
                $("#userNameTR").hide();
            }
            else
            {
                $("#userNameTR").show();
            }
            
            //게시 종료일
            $('#openCloseDate').val(notiEndDttm);
            
            //태그
            $("#txt_tag").val(notiTagLst);
            
            if (json.opnPrmsYn == 'Y')
            {
                $("#opnPrmsYN").attr("checked", "true");
                $("#opnMarkRealNameYN_Y").removeAttr("disabled");
                $("#opnMarkRealNameYN_N").removeAttr("disabled");           

                $('input:radio[name=opnMarkRealNameYN]:input[value='+opnMakrRealnameYn+']').attr("checked", "true"); //작성자 실명 표기
            }
            else
            {
                $("#opnPrmsYN").removeAttr("checked");
                $("#opnMarkRealNameYN_Y").attr('disabled', 'true');
                $("#opnMarkRealNameYN_N").attr('disabled', 'true');
            }
            
            
            if (replyPrmsYn  == 'Y')
            {
                $("#replyPrmsYn").attr("checked", "true");
            }           
            
            //예약 게시
            if (rsrvYn == 'Y')
            {
                $("#chkReserveDate").attr("checked", "true");
                
                $("#openReserveDate").removeAttr("disabled");
                $("#openReserveHour").removeAttr("disabled");
                $("#openReserveMin").removeAttr("disabled");
                
                $("#openReserveDate").val(notiBgnDttm.split(':')[0]);
                $("#openReserveHour").val(notiBgnDttm.split(':')[1]);
                $("#openReserveMin").val(notiBgnDttm.split(':')[2]);
                
            }
            
            $('input:radio[name=notiOpenDiv]:input[value='+notiOpenDiv+']').attr("checked", "true"); //조회자 지정
            if (notiOpenDiv == '020')
            {
                $("#notiOpenKind").show();
            }
            
            if (agrmOppYn  == 'Y')
            {
                $("#agrmOppYN").attr("checked", "true");
            }           
            
            if (notiKind == '020')  //이미지
            {
                write_apnd_kind = '020';
                $('#div_image_view').show();
                for (var i=0; i < apndList.length; i++)
                {
                    var obj = apndList[i];
                    if (obj.apndFileTp == '020')
                    {
                        loadUpdImageList2(obj, i);
                    }
                }           
            }
            else if (notiKind == '030')  //동영상 
            {
                write_apnd_kind = '030';
                //$('#div_movie_add').show();
                $('#div_media_view').show();
                for (var i=0; i < apndList.length; i++)
                {
                    var obj = apndList[i];
                    if (obj.apndFileTp == '030')
                    {
                        loadUpdMovieList(obj);
                    }
                }
            }
            else if (notiKind == '040')  //설문
            {
                $('#bigbox').show();
                $("#tr_surveyDate").show();
                $("#tr_surveyOpen").show();
                $('#div_research_view').show();
                                          
				var grpSurveyNo = "";
				var mCnt = 0;
				var grpCnt = 1;
                for(var i=0; i < surveyList.length; i++)
                {                   
                    var surveyJson = surveyList[i];
                    
                    if (i == 0)  //설문 시간 설정
                    {
						var surveyOpenDttm = surveyJson.surveyOpenDttm;       
						var arrSurvey1 = surveyOpenDttm.split(" ");                     
						var surveyOpenDay = arrSurvey1[0];                      
						var tmpTime1 = arrSurvey1[1];
						var arrTime1 = tmpTime1.split(":");                   
						var surveyOpenHour = arrTime1[0]; 
						var surveyOpenMinute = arrTime1[1]; 
						
						$("#start_date").val(surveyOpenDay);
						$("#start_hour").val(surveyOpenHour);
						$("#start_min").val(surveyOpenMinute);
						
						var surveyCloseDttm = surveyJson.surveyClosDttm;                      
						var arrSurvey2 = surveyCloseDttm.split(" ");                     
						var surveyCloseDay = arrSurvey2[0];                      
						var tmpTime2 = arrSurvey2[1];
						var arrTime2 = tmpTime2.split(":");                   
						var surveyCloseHour = arrTime2[0]; 
						var surveyCloseMinute = arrTime2[1]; 
						
						$("#close_date").val(surveyCloseDay);
						$("#inp_hour").val(surveyCloseHour);
						$("#inp_min").val(surveyCloseMinute);                                    
                    }
                    
                    if(surveyJson.surveyForm == "group" && surveyJson.grpSurveyNo!=grpSurveyNo)
                    {
                    	//그룹질문-처음문제
                    	mCnt++;
                    	grpCnt = 1;
                    	fnAddViewForm();                    	                  
                    	$('#grp_question'+mCnt).attr("checked",true);                  
                    	$(':radio[name="question_type'+mCnt+'"]').trigger("change");
                    	$('#question_cnt'+mCnt).val(surveyJson.grpSurveyCnt);
                    	$('#question_cnt_btn'+mCnt).trigger("click");
                    }
                    else if(surveyJson.surveyForm == "group" && surveyJson.grpSurveyNo==grpSurveyNo)
                    {
                    	//그룹질문-두번째부터   
                    	grpCnt++;                 	
                    }
                    else
                    {                   	
                    	mCnt++;
                    	grpCnt = 1;
                    	fnAddViewForm();                    	                     	
                    }
                    
                    if(surveyJson.exmplTp=='020')//주관식
                	{
                		$('#radio_single-'+mCnt+'-'+grpCnt).attr("checked",true);
						$('#radio_single-'+mCnt+'-'+grpCnt).trigger("click");						
                	}
                    
                    if(surveyJson.exmplCnt>=2)//주관식이 아닐경우
                    {
                    	$('#txt_view-'+mCnt+'-'+grpCnt).val(surveyJson.exmplCnt);                    	
                    	fnAddTxtView(mCnt,grpCnt,'');
                    	if(surveyJson.surveyTp=='020')//보기 이미지
                		{
                    		$('#radio_img-'+mCnt+'-'+grpCnt).attr("checked",true);                    		                		
                    		$('#radio_img-'+mCnt+'-'+grpCnt).trigger("click");
                		}
                    	
						var eCnt = 1;

                    	for(var j=0; j<surveyExmplList.length; j++)
                        {
                     		var surveyExmplJson = surveyExmplList[j];                        	
                        	if(surveyJson.surveyNo==surveyExmplJson.surveyNo)
                        	{                        	
                        		if(surveyJson.surveyTp=='010')//보기 텍스트
                        		{
                        			$('#txt_view-'+mCnt+'-'+grpCnt+'-'+eCnt).val(surveyExmplJson.exmplConts);
                        		}
                        		else//보기 이미지
                        		{                        			
                        			var imgPath = surveyExmplJson.prvwPath+'\\'+surveyExmplJson.prvwName;
                        			$('#txt_view-'+mCnt+'-'+grpCnt+'-'+eCnt).val(imgPath);
                        			var formfile = $("#view_form-"+mCnt+'-'+grpCnt+'-'+eCnt);
              					  	var idx = formfile.attr("id");
                                    idx = idx.substring(idx.indexOf('-')+1, idx.length);
                                    //alert(tempWeb);
                                    //'<span class="imglayout" id="'+json.saveFileId+'"><img id="rshimg-'+cnt+'" src="'+json.webDir+json.saveFileName+'" onclick="javascript:fnSurveyImgPop(\''+json.webDir+json.saveFileName+'\')" style="width:100%;height:100%" alt="이미지"><input type="hidden" id="hid_img-'+cnt+'" val='+json.webDir+json.saveFileName+'><a href="#" class="ico_clo" title="삭제" onclick="javascript:fnResearchListRemove(\''+json.saveFileId+'\')"></a></span>'
                                    var saveFileName = surveyExmplJson.imgName;
                                    var saveFileId = saveFileName.split(".")[0];                                    
                                    var jsonObj = {
										'saveFileId' : saveFileId,
										'webDir' : tempWeb,
										'saveFileName' : saveFileName
									};
                                    //alert(JSON.stringify(jsonObj));
                                    fnResearchAddImg($.parseJSON("["+JSON.stringify(jsonObj)+"]"), idx);
                        		}
                        		eCnt++;
                        	}
                        }
                    	if(surveyJson.inputAddYn=='Y')
                    	{
                    		$('#input_plus-'+mCnt+'-'+grpCnt).attr("checked",true);
                    		fnInputPlusClick(mCnt,grpCnt);					
                    	}
                    	if(surveyJson.multiSelPermitYn=='Y')
                    	{
                    		$('#chk_multi-'+mCnt+'-'+grpCnt).attr("checked",true);
                    		fnChkMultiClick(mCnt,grpCnt);					
                    	}
                    }
                    $('#txt_area-'+mCnt+'-'+grpCnt).val(surveyJson.surveyConts);
                    
					//surveyExmplList surveyAnswList
                    
                    
                    grpSurveyNo = surveyJson.grpSurveyNo;
                    //start_idx = end_idx;
                }
                
                //skip이동은 테이블이 전부 만들어지고 나서 설정
                var grpSurveyNo1 = "";
                var mCnt1 = 0;
				var grpCnt1 = 1;
                for(var i=0; i < surveyList.length; i++)
                {                   
                    var surveyJson = surveyList[i];
                    if(surveyJson.surveyForm == "group" && surveyJson.grpSurveyNo!=grpSurveyNo1)
                    {
                    	//그룹질문-처음문제
                    	mCnt1++;
                    	grpCnt1 = 1;
                    }
                    else if(surveyJson.surveyForm == "group" && surveyJson.grpSurveyNo==grpSurveyNo1)
                    {
                    	//그룹질문-두번째부터   
                    	grpCnt1++;                 	
                    }
                    else
                    {                   	
                    	mCnt1++;
                    	grpCnt1 = 1;               	                     	
                    }
                    if(surveyJson.skipPermitYn=='Y')
                    {
                    	$('#chk_skip-'+mCnt1+'-'+grpCnt1).attr("checked",true);
                    	fnChkSkipClick(mCnt1,grpCnt1);
	                    if(surveyJson.exmplCnt>=2)//주관식이 아닐경우
	                    {
	                    	var eCnt = 1;
	                    	for(var j=0; j<surveyExmplList.length; j++)
	                        {
	                    		var surveyExmplJson = surveyExmplList[j];   
	                    		if(surveyJson.surveyNo==surveyExmplJson.surveyNo)
	                        	{ 
	                    			$('#sel_view-'+mCnt1+'-'+grpCnt1+'-'+eCnt).val(surveyExmplJson.moveExmplNo);
	                    			eCnt++;
	                        	}
	                        }                
	                    }
                    }
                    grpSurveyNo1 = surveyJson.grpSurveyNo;
                }
                write_apnd_kind = '040';
            } 
            //일하자
            
            for (var i=0; i < apndList.length; i++)  //첨부파일
            {
                var obj = apndList[i];

                if (obj.apndFileTp == '050')
                {
                    $("#innoApDiv dl").append('<dd id="delapnd-'+obj.apndFileSeq+'" style="border: 0 !important;">'+obj.apndFileOrgn+' <a class="ico_del" style="cursor:pointer;" onclick="javascript:fnApndFileListRemove(\''+obj.apndFileSeq+'\')" ></a></dd>');
                }
            }
            
			makeAlreadyUploadFileList();
            
            //첨부목록
            $("#innoApDiv").show();
                     
            if (boardKind == '030')  //경조사
            {
                $("#cdlnEvntCode").val(json.cdlnEvntCode);
                $("#cdlnDeptName").val(json.cdlnDeptName);
                $("#cdlnDeptFname").val(json.cdlnDeptFname);
                $("#cdlnObjrName").val(json.cdlnObjrName);                
            };
            
            //공지
            if (anmtYn  == 'Y')
            {
                $("#rt4").attr("checked", "true");
            }
            
			//공개구분
			$("#notiOpenDiv").val(notiOpenDiv);
			if(notiOpenDiv == '030') $("#notiOpenDivBtn").show();            

            fnFrameReload();
            //$("#editor").val(notiConts);
        };
                    //수정-설문지 생성 페이지
                    //fnAddViewForm();
                    
                    /*
                    fnAddViewForm(i);                
                    $('#research-'+i).find('textarea').val(json.surveyConts);
                    
                    $('input:radio[name=radio_name-'+i+']:input[value='+json.surveyTp+']').attr("checked", "true"); 
                    
                    var exmpCnt = 0;
                    for(var k=0; k < surveyExmplList.length; k++)
                    {
                      var tmp =  surveyExmplList[k];
                      if (json.surveyNo == tmp.surveyNo) exmpCnt++; 
                    }
                
                    $('#txt_view'+i).val(exmpCnt);
                    
                    end_idx += exmpCnt; 
                    if (json.surveyTp == '010')  //텍스트
                    {
                        var idx = 1;
                        for (var j=start_idx; j < end_idx; j++)
                        {
                            var obj = surveyExmplList[j];
                            $('#li_view-'+i).append(
                                    '<ol id="ol_view-'+i+'_'+idx+'">'   
                                    +'<li class="fo_11px">보기'+idx+'<input type="text" class="inp_half ma_lef25" title="항목 보기'+idx+'" value="'+obj.exmplConts+'"></li>'
                                    +'</ol>'
                            );
                        }
                        idx++;
                    }
                    else  //이미지
                    {
                        var idx = 1;
                        for (var j=start_idx; j < end_idx; j++)                     
                        {
                            $('#li_view-'+i).append(
                                       '<ol id="ol_view-'+i+'_'+idx+'">'        
                                   +'<li class="fo_11px">보기'+idx+''                                
                                   +'   <span class="inp_file2">'                                  
                                   +'       <input id="txt_survey-'+i+'_'+idx+'" type="text" title="파일을 넣으세요" readOnly >'
                                   +'       <a href="#" class="btn_file">'
                                   +'           <form id="view_form-'+i+'_'+idx+'" enctype="multipart/form-data" method="post">'
                                   +'               <input type="file" class="file2" size="1" title="찾기" id="viewFile-'+i+'_'+idx+'" name="viewFile-'+i+'_'+idx+'">'
                                   +'           </form>'
                                   +'       </a>'                                  
                                   +'   </span>'                                   
                                   +'</li>'
                                   +'</ol>'
                            );
                            
                            
                            $("#viewFile-"+i+'_'+idx).bind("change",function() {
                                $(this).parent().parent().prev().val($(this).val());
                                    var formfile = $(this).parent();
                                    var idx_id = formfile.attr("id");
                                    idx_id = idx_id.substring(idx_id.indexOf('-')+1, idx_id.length);
                                    $(formfile).ajaxSubmit({
                                    url : WEB_HOME+"/board230/bbsFileUpload.jdo",
                                    action: $("#dummy"),
                                    type : 'POST',
                                    data : $(formfile).serialize(),
                                    success : function(data){
                                        //var json = $.parseJSON(data);
                                        fnResearchAddImg2($.parseJSON(data), idx_id);//$(formfile).attr("id"));
                                    },error : function(){
                                        alert("전송 실패 했습니다.");
                                    },
                                    clearForm: false,
                                    resetForm: false
                                });
                            }); 
                            
                            fnResearchTmpAddImg(surveyExmplList[j], i+'_'+idx);
                            //fnResearchAddImg(tmpSurveyExmplList[j], j);
                            idx++;
                        }
                        

                    }
                    */                                
        
        if (kind == 'TMP')  //임시저장 게시판      
        {

            
            var json = tmpNotiList[0];
            var notiTitle = json.notiTitle;
            var notiTitleOrgn = json.notiTitleOrgn;
            var moblOpenDiv = json.moblOpenDiv;
            var titleBoldYn = json.titleBoldYn;
            var titleColorDiv = json.titleColorDiv;
            var notiConts = json.notiConts;
            var linkUrl = json.linkUrl;
            var notiTp = json.notiTp;
            var notiKind = json.notiKind;
            var nickUseYn = json.nickUseYn;
            var userNick = json.userNick;
            var userName = json.userName;
            var editDiv = json.editDiv;
            var rsrvYn = json.rsrvYn;
            var notiBgnDttm = json.notiBgnDttm;  //게시 시작일
            var notiEndDttm = json.notiEndDttm;  //게시 종료일
            var opnPrmsYn = json.opnPrmsYn;  //의견 허용 여부
            var replyPrmsYn = json.replyPrmsYn;  //답글 허용 여부
            var opnMakrRealnameYn = json.opnMakrRealnameYn;  //실명표기 여부
            var notiTagLst = json.notiTagLst;  //태그 
            var notiOpenDiv = json.notiOpenDiv;
            var agrmOppYn = json.agrmOppYn;
            boardName = json.boardName;
            boardId = json.boardId;
            
            $("#txtBoardName").val(boardName);
            
            $('#tmpBoardName').css("display","");
            $('#tmpBoardName').children().css("display","");
            
            
            $("#txt_title").val(notiTitleOrgn);  //제목
            
            if (titleBoldYn == 'Y')  //볼드체
            {
                $("#rt1").attr("checked", "true");
            }
            if (titleColorDiv == 'BLU')  //파랑색
            {
                $("#rt2").attr("checked", "true");
            }
            if (titleColorDiv == 'RED')  //빨강색
            {
                $("#rt3").attr("checked", "true");
            }
            
            $('input:radio[name=moblOpenDiv]:input[value='+moblOpenDiv+']').attr("checked", "true"); //모바일 공개
            $('input:radio[name=apndKind]:input[value='+notiKind+']').attr("checked", "true"); //게시물 종류
            
            
            //##############################추가항목 설정##############################
            //닉네임 사용 여부     
            if (nickUseYn == 'Y')
            {
                $("#nickUseYn").attr("checked", "true");
                $("#txt_nickname").removeAttr("disabled");
                $("#txt_nickname").val(userNick);
            }
            
            //게시 종료일
            $('#openCloseDate').val(notiEndDttm);
            
            //태그
            $("#txt_tag").val(notiTagLst);
            
            if (opnPrmsYn == 'Y')
            {
                $("#opnPrmsYN").attr("checked", "true");
                $("#opnMarkRealNameYN_Y").removeAttr("disabled");
                $("#opnMarkRealNameYN_N").removeAttr("disabled");           

                $('input:radio[name=opnMarkRealNameYN]:input[value='+opnMakrRealnameYn+']').attr("checked", "true"); //작성자 실명 표기
            }
            
            if (replyPrmsYn == 'Y')
            {
                $("#replyPrmsYn").attr("checked", "true");
            }
            
            if (agrmOppYn == 'Y')
            {
                $("#agrmOppYN").attr("checked", "true");
            }
            
            //예약 게시
            if (rsrvYn == 'Y')
            {
                $("#chkReserveDate").attr("checked", "true");
                
                $("#openReserveDate").removeAttr("disabled");
                $("#openReserveHour").removeAttr("disabled");
                $("#openReserveMin").removeAttr("disabled");
                
                $("#openReserveDate").val(notiBgnDttm);
                
            }
            
            $('input:radio[name=notiOpenDiv]:input[value='+notiOpenDiv+']').attr("checked", "true"); //조회자 지정
            if (notiOpenDiv == '020')
            {
                $("#notiOpenKind").show();
            }
            
            //조회자 지정
            for (var i=0; i < tmpUserList.length; i++)
            {
                if (tmpUserList[i].userDiv == 'DPT')
                {
                    fnOpenDept(tmpUserList[i]);
                }
                else if (tmpUserList[i].userDiv == 'EMP')
                {
                    fnOpenEmp(tmpUserList[i]);
                }
            }
            if (notiKind == '020')  //이미지
            {
                $('#div_image_view').show();
                for (var i=0; i < tmpApndList.length; i++)
                {
                    var obj = tmpApndList[i];               
                    if (obj.apndFileTp == '020')
                    {
                        loadTmpImageList2(obj, (i+1));
                    }
                }       
                write_apnd_kind = '020';
            }
            else if (notiKind == '030')  //동영상
            {
                write_apnd_kind = '030';
            }
            else if (notiKind == '040')  //설문
            {
                $("#question_cnt").val(tmpSurveyList.length);
                
                $('#bigbox').show();
                $("#tr_surveyDate").show();
                $("#tr_surveyOpen").show();
                //$('#div_research_view').show();
                
                
                var start_idx = 0;
                var end_idx = 0;
                for(var i=0; i < tmpSurveyList.length; i++)
                {
                    
                    var json = tmpSurveyList[i];
                    fnAddTmpViewForm(i);                
                    $('#research-'+i).find('textarea').val(json.surveyConts);
                    
                    $('input:radio[name=radio_name-'+i+']:input[value='+json.surveyTp+']').attr("checked", "true"); 
                    
                    var exmpCnt = 0;
                    for(var k=0; k < tmpSurveyExmplList.length; k++)
                    {
                      var tmp =  tmpSurveyExmplList[k];
                      if (json.surveyNo == tmp.surveyNo) exmpCnt++; 
                    }
                
                    $('#txt_view'+i).val(exmpCnt);
                    
                    end_idx += exmpCnt; 
                    if (json.surveyTp == '010')  //텍스트
                    {
                        var idx = 1;
                        for (var j=start_idx; j < end_idx; j++)
                        {
                            var obj = tmpSurveyExmplList[j];
                            $('#li_view-'+i).append(
                                    '<ol id="ol_view-'+i+'_'+idx+'">'   
                                    +'<li class="fo_11px">보기'+idx+'<input type="text" class="inp_half ma_lef25" title="항목 보기'+idx+'" value="'+obj.exmplConts+'"></li>'
                                    +'</ol>'
                            );
                        }
                        idx++;
                    }
                    else  //이미지
                    {
                        var idx = 1;
                        for (var j=start_idx; j < end_idx; j++)                     
                        {
                            $('#li_view-'+i).append(
                                       '<ol id="ol_view-'+i+'_'+idx+'">'        
                                   +'<li class="fo_11px">보기'+idx+''                                
                                   +'   <span class="inp_file2">'                                  
                                   +'       <input id="txt_survey-'+i+'_'+idx+'" type="text" title="파일을 넣으세요" readOnly >'
                                   +'       <a href="#" class="btn_file">'
                                   +'           <form id="view_form-'+i+'_'+idx+'" enctype="multipart/form-data" method="post">'
                                   +'               <input type="file" class="file2" size="1" title="찾기" id="viewFile-'+i+'_'+idx+'" name="viewFile-'+i+'_'+idx+'">'
                                   +'           </form>'
                                   +'       </a>'                                  
                                   +'   </span>'                                   
                                   +'</li>'
                                   +'</ol>'
                            );
                            
                            
                            $("#viewFile-"+i+'_'+idx).bind("change",function() {
                                $(this).parent().parent().prev().val($(this).val());
                                    var formfile = $(this).parent();
                                    var idx_id = formfile.attr("id");
                                    idx_id = idx_id.substring(idx_id.indexOf('-')+1, idx_id.length);
                                    $(formfile).ajaxSubmit({
                                    url : WEB_HOME+"/board230/bbsFileUpload.jdo",
                                    action: $("#dummy"),
                                    type : 'POST',
                                    data : $(formfile).serialize(),
                                    success : function(data){
                                        //var json = $.parseJSON(data);
                                        fnResearchAddImg2($.parseJSON(data), idx_id);//$(formfile).attr("id"));
                                    },error : function(){
                                        alert("전송 실패 했습니다.");
                                    },
                                    clearForm: false,
                                    resetForm: false
                                });
                            }); 
                            
                            fnResearchTmpAddImg(tmpSurveyExmplList[j], i+'_'+idx);
                            idx++;
                        }

                    }
                    
                    start_idx = end_idx;
                }
                
                write_apnd_kind = '040';
            }
            
            
            for (var i=0; i < tmpApndList.length; i++)  //첨부파일
            {
                var obj = tmpApndList[i];
                
                if (obj.apndFileTp == '050')
                {
                    $("#innoApDiv dl").append('<dd style="border: 0 !important;">'+obj.apndFileOrgn+'<span class="fo_gray">('+obj.apndFileSz+')</span></dd>');
                }
            }
            makeAlreadyUploadFileList();
            
            //첨부목록
            $("#innoApDiv").show();
            
            //공지
            if (anmtYn  == 'Y')
            {
                $("#rt4").attr("checked", "true");
            }
            
			//공개구분
			$("#notiOpenDiv").val(notiOpenDiv);
			if(notiOpenDiv == '030') $("#notiOpenDivBtn").show();            
            
            fnFrameReload();
            //$("#editor").val(notiConts);
            CrossEditor.SetBodyValue(notiConts);
            
        }
        //답글
        if (upNotiId != '' )
        {
            //var reply_list = ${reply_list};
            var json = reply_list[0];
            $("#txt_title").val("[RE] "+json.notiTitleOrgn);  //제목
            //$("#editor").val('<br><br>---- 원본메세지 ----<br>'+json.notiConts);
            CrossEditor.SetBodyValue('<br><br>---- 원본메세지 ----<br>'+json.notiConts);
        }

        loadingComplete = true;
        if (notiReadmanAsgnYn == 'N')
        {
            $("#notiReadmanAsgnYn").hide(); 
        }
    
                
        $("#txt_title").bind('keydown keyup', function(e){
            if(e.keyCode == 9)
            {
                //$('#editor').tinymce().focus();
            }
            
        });
                
        if (nickUseYn == 'Y')
        {
            $("#userNameTR").hide();
        }
        else
        {
            $("#userNameTR").show();
        }
        
        //게시판 설명 보기     
        /* $("#moreBoardExpl").click(function() {
            
            if (boardExplUseYn == 'Y')
            {
                PortalCommon.windowPopup(WEB_HOME+'/board230/bbsBoardExplPopup.jdo?boardId='+boardId, '게시판설명',750,300);
            }
            
        }); */  

		$("#notiOpenDiv").change(function(){
			var div = $(this).val();
			if(div == '030'){
				//부서지정
				$("#notiOpenDivBtn").show();
			}else{
				$("#notiOpenDivBtn").hide();
				$("#OpenEmpCategories").empty();
				$("#OpenDeptCategories").empty();
			}
		});	        
        
    
    	$("#notiOpenDivBtn").click(function(){
    		var div = $("#notiOpenDiv").val();
    		if(div == '020'){
    			//개인지정
    			PortalCommon.popupWindowCenter(WEB_HOME+'/board/organization/organizationChart.jdo?type=2&callback=callbackOpenPerson', '개인선택',900,520);
    		}else if(div == '030'){
    			//부서지정
    			PortalCommon.popupWindowCenter(WEB_HOME+'/board/organization/organizationChart.jdo?type=1&callback=callbackOpenDept', '부서선택',900,520);
    		}
    	});	     
            
    //parent.document.getElementById("bbsFrame").height = "700px";
    //parent.document.getElementById("bbsFrame").height = $(document).height()+"px"; //document.body.scrollHeight+400+"px";
       
});

window.onload = fnLoadPage;
</script>

<!-- <script type="text/javascript" src="${RES_HOME}/js/portal/board/board230Write.js"></script> -->

</head>

<body>
<form action="${WEB_HOME}/board100/surveyWritePrint.jdo" method="post" name="pageForm">
	<input type="hidden" name="pageHtml" value="">
</form>

<div class="container">
	<div class="header">
		<div class="h1">${boardName}</div>
		<div class="loc">
			<a href="#" class="home"><img src="${RES_HOME}/images/ico_home.png" alt="홈" /></a>
			<a href="#">커뮤니티</a>
			<strong class="str">${boardName}</strong>
		</div>
	</div>
	
	<ul id="bigbox" name="bigbox" class="tab_st01">
		<li id="box1" name="box1" class="t1"><a href="#" class="on">설문 설명 및 속성 &gt;</a></li>
		<li id="box2" name="box2" class="t2"><a href="#">설문지 생성 &gt;</a></li>
		<li id="box3" name="box3" class="t3"><a href="#">설문지 확인</a></li>
	</ul>
    
	<div id="page1">
		<p class="txt_notice">게시판 게시기준에 맞지 않는 부적절한 게시물은 작성자의 동의 없이 삭제됩니다.</p>
		<table class="tbl_form" summary="소속기관, 작성자, 제목, 공개대상, 설문기간, 결과 공개여부에 관한 정보제공">
		<caption>설문 설명 및 속성 입력목록</caption>
		<colgroup>
			<col style="width:15%" />
			<col style="width:35%" />
			<col style="width:15%" />
			<col style="width:35%" />
		</colgroup>
		<tbody>
		<tr>
			<th scope="row">소속 기관</th>
			<td>${deptName}</td>
			<th scope="row">작성자</th>
			<td>${userName}</td>
		</tr>
		<tr>
			<th scope="row"><label for="input01">제목</label></th>
			<td colspan="3">
				<input type="text" id="txt_title" class="text" style="width:525px" title="제목 입력" /> 
				<span>
					<input type="checkbox" id="rt4" title="공지여부 선택">
					<label for="chk01">공지</label>
				</span>		
			</td>
		</tr>
		<tr id="notiReadmanAsgnYn">
			<th scope="row"><label for="selectN_id2">공개대상</label></th>
			<td colspan="3">
				<span class="selectN" style="width:100px">
					<span>
						<select title="" name="notiOpenDiv" id="notiOpenDiv" title="공개대상여부">
							<option value="010" selected>전체공개</option>
							<%-- <option value="020">사용자지정  --%>
							<option value="040">운영자만공개
							<option value="030">부서지정
						</select>
					</span>
				</span>
						<button type="button" class="btn_style1_3" type="button" id="notiOpenDivBtn" style="display:none;">조직도</button>
						<div class="listbox">
							<ul id="OpenDeptCategories">
							</ul>
							<ul id="OpenEmpCategories">
							</ul>
						</div>
			</td>
		</tr>
<!-- 
		<tr id="tr_openDate" style="display:none;>
		    <th scope="row"><label for="input01">게시기간</label></th>
		    <td colspan="3">
		        <div class="sec_calender">
		            <input type="text" class="text" id="openReserveDate" name="openReserveDate" title="시작 날짜를 입력합니다. 예)YYYY.MM.DD"/>
		        </div> ~ 
		        <div class="sec_calender">
		            <input type="text" class="text" id="openCloseDate" name="openCloseDate" title="종료 날짜를 입력합니다. 예)YYYY.MM.DD"/>
		        </div>
		    </td>
		</tr>
 -->
		<tr id="tr_surveyDate">
			<th scope="row"><label for="date07">설문 기간</label></th>
			<td colspan="3">
				<div class="sec_calender active">
				    <input type="text" class="text" id="start_date" value=""  title="시작 날짜를 입력합니다. 예)YYYY.MM.DD" />
				</div>
		        <span class="selectN" style="width:56px">
		       		<span>
						<select id="start_hour" name="start_hour" title="시작 시간을 선택합니다.">
						    <option value="null">시간</option>
						    <option value="01">1시</option>
						    <option value="02">2시</option>
						    <option value="03">3시</option>
						    <option value="04">4시</option>
						    <option value="05">5시</option>
						    <option value="06">6시</option>
						    <option value="07">7시</option>
						    <option value="08">8시</option>
						    <option value="09">9시</option>
						    <option value="10">10시</option>
						    <option value="11">11시</option>
						    <option value="12">12시</option>
						    <option value="13">13시</option>
						    <option value="14">14시</option>
						    <option value="15">15시</option>
						    <option value="16">16시</option>
						    <option value="17">17시</option>
						    <option value="18">18시</option>
						    <option value="19">19시</option>
						    <option value="20">20시</option>
						    <option value="21">21시</option>
						    <option value="22">22시</option>
						    <option value="23">23시</option>
						    <!-- <option value="00">24시</option> -->
						</select>
					</span>
				</span>
		     	<span class="selectN" style="width:56px">
					<span>
						<select id="start_min" name="start_min" title="시작 분을 선택합니다.">
						    <option value="null">분</option>
						    <option value="00">00분</option>
						    <option value="10">10분</option>
						    <option value="20">20분</option>
						    <option value="30">30분</option>
						    <option value="40">40분</option>
						    <option value="50">50분</option>
						</select>
		         	</span>
		     	</span>
		     	~
				<div class="sec_calender active">
				    <input type="text" class="text" id="close_date" value=""  title="종료 날짜를 입력합니다. 예)YYYY.MM.DD" />
				</div>
				<span class="selectN" style="width:56px">
					<span>
					    <select id="inp_hour" name="inp_hour" title="종료 시간을 선택합니다.">
					        <option value="null">시간</option>
					        <option value="01">1시</option>
					        <option value="02">2시</option>
					        <option value="03">3시</option>
					        <option value="04">4시</option>
					        <option value="05">5시</option>
					        <option value="06">6시</option>
					        <option value="07">7시</option>
					        <option value="08">8시</option>
					        <option value="09">9시</option>
					        <option value="10">10시</option>
					        <option value="11">11시</option>
					        <option value="12">12시</option>
					        <option value="13">13시</option>
					        <option value="14">14시</option>
					        <option value="15">15시</option>
					        <option value="16">16시</option>
					        <option value="17">17시</option>
					        <option value="18">18시</option>
					        <option value="19">19시</option>
					        <option value="20">20시</option>
					        <option value="21">21시</option>
					        <option value="22">22시</option>
					        <option value="23">23시</option>
					        <!-- <option value="00">24시</option> -->
					    </select>
					</span>
		     	</span>
		     	<span class="selectN" style="width:56px">
		            <span>
			            <select id="inp_min" name="inp_min" title="종료 분을 선택합니다.">
			                <option value="null">분</option>
			                <option value="00">00분</option>
			                <option value="10">10분</option>
			                <option value="20">20분</option>
			                <option value="30">30분</option>
			                <option value="40">40분</option>
			                <option value="50">50분</option>
			            </select>
		            </span>
		        </span>		    
		    </td>
		</tr>
		<tr id="tr_surveyOpen">
			<th scope="row"><label>결과 공개여부</label></th>
			<td colspan="3">
				<div class="radiogroup">
					<input type="radio" id="research_open" name="researchOpenYn" title="공개 선택" value="Y"/>
					<label for="research_open">공개</label>
					<input type="radio" id="research_close" name="researchOpenYn" title="비공개 선택" value="N" checked/>
					<label for="research_close" class="mgrn">비공개</label>	
				</div>
			</td>
		</tr>
		
		<tr>
			<td colspan="4" class="editor">
				<!-- 에디터들어가는자리 -->
				<textarea class="editor ma_none" id="editor" style="height:360px;"></textarea>
				<script type="text/javascript">
					var CrossEditor = new NamoSE('editor');
					CrossEditor.params.Width = "100%";
					CrossEditor.params.UserLang = "auto";
					CrossEditor.params.FullScreen = false;
					CrossEditor.params.ImageSavePath = "/crosseditor/binary";
					CrossEditor.params.UploadFileExecutePath = "<%=uploadFileExecutePath%>";
					
					CrossEditor.EditorStart();
					
					function OnInitCompleted(e) {
						e.editorTarget.SetBodyValue(document.getElementById('editor').value);
						//yblee
						fnFrameReload();
					}
				</script>				
			</td>
		</tr>
		
		<tr>
			<th scope="row">첨부</th>
			<td colspan="3">
    			<div id="movieImgformDiv">
        			<form id="apndFileform" name="apndFileform" enctype="multipart/form-data" method="post">
        				<ul>
						    <li class="ma_bot5">
						    <input type="text" class="text" style="width:476px" readonly><span class="file_wrap">
									<button class="btn_style1_2" type="button">파일</button>
									<input type="file" name="upFile-" class="file_hidden" />
								</span><button type="button" class="btn_style1_2" onclick="fnAddFileList();">추가</button>
						    </li>        				
<!-- 				            <li class="ma_bot5"> -->
<!-- 				            <input type="text" class="text" style="width:476px" readonly> -->
<!-- 				            <a href="#" class="btn_style1_2 mv_file_a"> -->
<!-- 				            <input type="file" size="1" name="upFile-" class="mv_file" onchange="javascript:fnChgAddFile();">파일</a> -->
<!-- 				            <a style="cursor:pointer;" class="btn_style1_2" onclick="javascript:fnAddFileList();">추가</a> -->
<!-- 				            </li>    -->
        				</ul>
        			</form>
    			</div>
    			<div id="innoApDiv" class="listbox" style="display:none;">
        		<dl></dl>
    			</div>
			</td>
		</tr>
		
	</tbody>
	</table>
	
	<div class="btn_board_sec">
		<div class="fl">
			<button id="tmpButton" class="btn_style2_4" onclick="javascript:fnWriteTempInsert();">임시저장</button>
			<!-- <button class="btn_style2_2" onclick="javascript:fnWriteCancel();">취소</button> -->
		</div>
		<div class="fr" id="div_btn" style="display:none;">
			<button class="btn_style3_2" onclick="javascript:fnWriteInsert();">등록</button>
			<button class="btn_style4_2" id="btn_item_list">목록</button>
		</div>
		<div id="div_survey_btn" class="fr">
			<button class="btn_style3_2" onclick="javascript:fnNextPage1();">완료</button>
			<button class="btn_style4_2" id="btn_item_list">목록</button>
		</div>
	</div>
</div>

<div id="page2" style="display: none;">
    <div id="research_body"></div>
    <!-- 버튼영역 -->
    <div class="btn_board_sec">
        <div class="fl">
            <button id="tmpButton2" class="btn_style2_4" onclick="javascript:fnWriteTempInsert();">임시저장</button>
			<!-- <button class="btn_style2_2" onclick="javascript:fnWriteCancel();">취소</button> -->
			<button class="btn_style2_2" onclick="javascript:fnAddViewForm();">추가</button>
        </div>
        <div class="fr">
            <button class="btn_style3_2" onclick="javascript:fnNextPage2();">완료</button>
			<button class="btn_style4_2" id="btn_item_list">목록</button>
        </div>
    </div>
    <!-- //버튼영역 -->  
</div>

<div id="page3" style="display: none;">
	<table class="tbl_view mt10" summary="번호, 조회수, 공개여부에 관한 정보제공">
	<caption>설문입력 목록</caption>
	<colgroup>
		<col style="width:7%" />
		<col style="width:17%" />
		<col style="width:7%" />
		<col style="width:17%" />
		<col style="width:7%" />
		<col style="width:17%" />
		<col style="width:28%" />
	</colgroup>
	<tbody>
	<tr>
		<td colspan="7">
			<div class="inner">
				<span class="title">제휴복지를 위한 선호하는 운동에 관한 설문조사</span>
				<ul>
					<li>
						<span class="tit">작성자</span>
						<span class="desc"><span>${userName}</span> <span><img src="${RES_HOME}/images/ico_room.png" alt="부서" />${deptName}</span> <span><img src="${RES_HOME}/images/ico_email.png" alt="이메일" />${mail}</span></span>
					</li>
					<li>
						<span class="tit">설문기간</span>
						<span id="page3_survey_date" class="desc"></span>
					</li>
					<li class="half">
						<span class="tit">공개설정</span>
						<span id="page3_notiOpenDiv" class="desc"></span>
					</li>
					<li class="half other">
						<span class="tit">결과 공개여부</span>
						<span id="page3_researchOpenYn" class="desc"></span>
					</li>
				</ul>
			</div>
			<div id="page3_txt_area" class="intxt"></div>
		</td>
	</tr>

	<tr id="apndFileTr">
		<td colspan="7">
		<div class="rbox02 mt0">
			<span class="top"></span>
			<div class="mid">
				<div class="inquiry_top">
					<div class="ico_file">
						<strong>첨부파일</strong>
						<ul id="ulNotiFile"></ul>
					</div>
				</div>
			</div>
			<span class="btm"></span>
		</div>
		</td>
	</tr>
	</tbody>
	</table>

	<div class="rbox03">
		<span class="top"></span>
		<div class="mid">
			<ul id="ul_questionList">
			</ul>
			<div class="thanks">'
				<p>설문에 참여해주셔서 고맙습니다.</p>
				<span class="bottom"></span>'
			</div>
		</div>
		<span class="btm"></span>
	</div>
	
	<div id="lastBtns" class="btn_board_sec">
		<div class="fl">
			<button class="btn_style2_2" onclick="javascript:fnModify();">수정</button>
			<button class="btn_style2_2 btn_print_survey">출력</button>
		</div>
		<div class="fr">
			<button class="btn_style3_4" onclick="javascript:fnWriteInsert();">설문 등록</button>
			<button class="btn_style4_2" id="btn_item_list">목록</button>
		</div>
	</div>
</div>

</div>

<div style="display:none;">
    <input type="radio" name="apndKind" value="010" checked>일반
    <input type="radio" name="apndKind" value="020">이미지
    <input type="radio" name="apndKind" value="030">동영상
</div>
<div style="display:none;">
    <div id ="replyPrmsTR">
        <div>답글 허용</div>
        <div><input type="checkbox" id="replyPrmsYn" name="opnPrmsYN" class="ma_none" title="허용" checked><label for="replyPrmsYn">허용</label></div>
    </div>
    <div id ="opnPrmsTR">
        <div>의견 허용</div>
        <div><input type="checkbox" id="opnPrmsYN" name="opnPrmsYN" class="ma_none" title="허용" checked><label for="opnPrmsYN">허용</label><input type="radio" id="opnMarkRealNameYN_Y" name="opnMarkRealNameYN" value="Y" checked ></div>
    </div>
    <input type="checkbox"  id="chkReserveDate" title="예약게시사용" checked>
</div>
<iframe name="dummy" width=0 height=0 border=0 style="visibility:hidden"></iframe>
</body>
</html>     
