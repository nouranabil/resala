$(document).ready(function()  {  
  $(function(){
    $('#loader').ajaxStart(function(){
        $.fancybox.hideActivity
        $(this).show();
    }).ajaxComplete(function(){
        $(this).hide();
    });
  });
  
//default response handling  
  renderResponse = function(response,args) {
    var hasNext = false
    if(response.length > args.perPage ){
      hasNext = true;
      response.pop()
    }
    //$(container).html(""); //loading pic //
    var node = $(args.template).jqote(response);
    $(args.container).append(node);
    if(args.paginated){
      pgTemplate = (args.pgTemplate==undefined) ? '#pagination-template' : args.pgTemplate ;
      var pag = $(pgTemplate).jqote({
        next: hasNext ? args.next : undefined,
        prev: args.prev
      })
      $(args.pagContainer).html(pag);
    }
  }
// trigger fancybox
  trigger_fancybox = function(){
    $("a.fancybox,a[rel=gallery_images],a#inline,div.fancybox_pagination a").fancybox({
      'speedIn'             : 300, 
      'speedOut'            : 300,
      'overlayShow'         : true,
      'overlayColor'        : '#000',
      'transitionIn'        : 'fade',
      'transitionOut'        : 'fade',
      'titleShow'           : false,
      'hideOnOverlayClick'  : false,
      'enableEscapeButton'  : false,
      'showCloseButton'     : true,
      'showNavArrows'       : false,
      'onComplete'          : function(){
                                $("#fancybox-wrap").css('top','0px');
                                $("#fancybox-content").css('max-height',$(window).height()*0.9);
                                $("#fancybox-content").css('overflow-y','auto');
								                $("#fancybox-content").css('overflow-x','hidden');
								                $("#fancybox-content").css('direction','rtl');
								                $("div.fancybox_pagination a").attr('rel','');
                              }
    });
  }
  trigger_fancybox();
  
  
  $("a.fancybox").live('click' , function(){
    $.fancybox.hideActivity();
  });
  
  $.ajax({
    datatType: 'script',
    url  : "/pages/user_info.js"
  })
  
  $(".tabs .selected a").click(function(){
    return false;
  });
  
  $(".join_activity_after_login").click(function(){
    $("#login_section .login_req").attr("href", "/login/facebook?action_after_login=" + $(this).attr("join_activity_link"))
  });
});

Cookies = {
    //createCookie: function(name, value){
    //  var exdate=new Date();
    //  exdate.setDate(exdate.getDate() - 1 );
    //  document.cookie = name + "=" + value + "; expires=" + exdate.toUTCString();
    //},
    createCookie: function(name,value,days,path) {
      if (days) {
        var date = new Date();
        date.setTime(date.getTime()+(days*24*60*60*1000));
        var expires = "; expires="+date.toUTCString();
      }
      else var expires = "";
      var cpath = "";
      if(path){
        cpath = path
      }
      document.cookie = name+"="+value+expires+"; path=/" + cpath ;
    },
    readCookie: function(c_name){
        if (document.cookie.length>0){
          c_start=document.cookie.indexOf(c_name + "=");
          if (c_start!=-1){
            c_start=c_start + c_name.length+1;
            c_end=document.cookie.indexOf(";",c_start);
            if (c_end==-1) c_end=document.cookie.length;
            ms_val = decodeURIComponent(document.cookie.substring(c_start,c_end)).replace(/\+/g, " ");
            Cookies.eraseCookie(c_name);
            return ms_val;
          }
        }
        return "";
    },
    eraseCookie: function(name){
        Cookies.createCookie(name, "");
    }
}

var showFlashMessages = function(){
  msg_notice = Cookies.readCookie("flash_notice");
  if(msg_notice.length>0){
    $("#flash_notice h4").html(msg_notice);
    $("#flash_notice").show("slow");
    Cookies.eraseCookie("flash_notice");
  } 
  
  msg_alert = Cookies.readCookie("flash_alert");
  if(msg_alert.length>0){
    $("#flash_alert").html(msg_alert).show("slow");
    Cookies.eraseCookie("flash_alert");
  }
  
//Facebook login :
facebook_login = {

  popup_window : undefined,
  
  login_popup : function(redirect_url,action_after_login){
    Cookies.createCookie("action_after_login", action_after_login === undefined ? "": action_after_login);
    var width = 1000;
    var height = 565;
    var left = (screen.width - width) / 2;
    var top = (screen.height - height) / 2;
    var popupParams = 'width=' + width + ', height=' + height + ', top=' + top + ', left=' + left + ',scrollbars=no,location=no,menubar=no';
    facebook_login.popup_window = window.open(redirect_url, 'my_window', popupParams);
  },
  
  success_callback : function(return_to_url){
       facebook_login.popup_window.close();
       if(return_to_url){
          document.location = return_to_url;
       }else{
          document.location.reload();
       }
  }
};


$("a.login_button").live("click",function(){
  var action_after_login = undefined;
  if ($(this).attr('action_after_login')){
    action_after_login = $(this).attr('action_after_login');
  }
  facebook_login.login_popup("/auth/facebook?origin=volunteer_login", action_after_login);
  return false;
});

$("a.register_button").live("click",function(){
  facebook_login.login_popup("/auth/facebook?origin=volunteering");
  return false;
});

}