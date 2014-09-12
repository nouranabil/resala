$(document).ready(function(){
  $('#remove_media').live('click',function(){
    $(this).closest("span").remove();
    return false;
  });
  
  $('#more_media').live('click',function(){
  
	var new_index = 0;
    var last_input_element = $("#uploads").children().last();
    if(last_input_element.length > 0){
      new_index = (Number(last_input_element.children().first().attr("id").split("_")[3]) + 1)
    }
	var node = $($('#multiple-uploads-template').jqote());
	node.children().first().attr("id", "activity_media_desc_" + new_index)
	node.children().first().attr("name", "activity_media[" + new_index + "][desc]")
	
	node.children().last().attr("id", "activity_media_media_" + new_index)
	node.children().last().attr("name", "activity_media[" + new_index + "][media]")
    $('.uploader_item').append(node);
    return false;
  });
});
