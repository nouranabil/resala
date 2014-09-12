$(document).ready(function() {  
 
    //Background color, mouseover and mouseout
    var colorOver = '#31b8da';
    var colorOut = '#1f1f1f';
 
    //Padding, mouseover
    var padLeft = '20px';
    var padRight = '20px'
     
    //Default Padding
    var defpadLeft = $('#feature_tabs li a').css('paddingLeft');
    var defpadRight = $('#feature_tabs li a').css('paddingRight');
         
    //Animate the LI on mouse over, mouse out
    $('#feature_tabs li').click(function () {
        //Make LI clickable
        window.location = $(this).find('a').attr('href');
        
    }).mouseout(function () {
     
        //mouse oout LI and look for A element and discard the mouse over transition
        $(this).find('a')
        .animate( { paddingLeft: defpadLeft, paddingRight: defpadRight}, { queue:false, duration:100 } )
        //.animate( { backgroundColor: colorOut }, { queue:false, duration:200 });
    }); 
     
    //Scroll the menu on mouse move above the #sidebar layer
    $('#feature_list').mousemove(function(e) {
 
        //Sidebar Offset, Top value
        var s_top = parseInt($('#feature_list').offset().top);       
         
        //Sidebar Offset, Bottom value
         s_bottom = parseInt($('#feature_list').height() + s_top);
     
        //Roughly calculate the height of the menu by multiply height of a single LI with the total of LIs
        //TODO correct this to loop on all li's
        var itemHeight = parseInt($('#feature_tabs li').not('li.current').height());
        var mheight = (itemHeight * $('#feature_tabs li').length) - itemHeight + parseInt($('li.current').height());
     
        //I used this coordinate and offset values for debuggin
        //$('#debugging_mouse_axis').html("X Axis : " + e.pageX + " | Y Axis " + e.pageY);
        //$('#debugging_status').html(Math.round(((s_top - e.pageY)/100) * mheight / 2));
             
        //Calculate the top value
        //This equation is not the perfect, but it 's very close    
        var top_value = Math.round(( (s_top - e.pageY) /200) * mheight / 2)
         
        //Animate the #menu by chaging the top value
        var tp = $('#feature_tabs').offset().top;
        var bott = tp + mheight;
        //tpp = tp; btt = bott; tpv = top_value;
        //if( tp < top_value || bott  >  s_bottom ){
          $('#feature_tabs').animate({top: top_value}, { queue:false, duration:200});
        //}
    });
 
     
});