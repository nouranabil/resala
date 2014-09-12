$(document).ready(function(){
  $('#city_id').live('change',function(){
    $('#branch_show_container').hide("slow");
    $('#branch_show_media_container').hide();
    
    if($(this).val().length > 0 ){
      $.ajax({
        datatType: 'script',
        url  : "/branches.js",
        data : {city_id: $(this).val()}
      })
    }
  });
  
  $('#branch_id').live('change',function(){
    showBranchData($(this).val());
  });
}); 

function showBranchData(branch_id){
  $('#branch_show_container').hide("slow");
  $('#branch_show_media_container').hide();
  
  if(branch_id.length > 0 ){
    $.ajax({
      datatType: 'script',
      url  : "/branches/" + branch_id + ".js"
    })
  }
}
