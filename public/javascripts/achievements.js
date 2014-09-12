$(document).ready(function(){
  $('#add_new_achievement').live('click',function(){   
    var new_index = 0;
    var last_input_element = $("#achievement_items li:last .activity_achievement_amount_input");
    if(last_input_element.length > 0){
      new_index = (Number(last_input_element.attr("id").split("_")[last_input_element.attr("id").split("_").length-1]) + 1)
    }
    
    achievement_amount_value = $("#achievement_amount").val();
    achievement_achievements_type_id = $("#achievement_achievements_type_id").val();
    achievement_achievements_type_id_value = $("#achievement_achievements_type_id option:selected").text();
    
    if(achievement_amount_value.length == 0 || achievement_achievements_type_id.length == 0 || achievement_achievements_type_id_value.length == 0 || !achievement_amount_value.match(/^[0-9\.]*$/) ){
      alert("برجاء إختيار نوع الإنجاز وكتابة العدد بصيغة صحيحة ")
      return false;
    }
    
    if($(".achievement_items .activity_achievement_type_input[value="+ achievement_achievements_type_id + "]").size() > 0 ){
      alert("تم إضافة نوع الإنجاز من قبل");
      return false;
    }
    
    var new_achievement = $($("textarea#activity_achievement_template").text());
    new_achievement.find(".achievement_amount").html(achievement_amount_value);
    new_achievement.find(".achievements_type_name").html(achievement_achievements_type_id_value);
    new_achievement.find(".activity_achievement_amount_input").val(achievement_amount_value).attr("name", "activity_achievements[" + new_index + "][amount]").attr("id", "activity_achievement_amount_" + new_index);
    new_achievement.find(".activity_achievement_type_input").val(achievement_achievements_type_id).attr("name", "activity_achievements[" +  new_index + "][achievements_type_id]").attr("id", "activity_achievement_type_" + new_index);
    $("#achievement_items ul").append(new_achievement);
    $("#achievement_amount").val("");
    $("#achievement_achievements_type_id").val(0);
    return false;
  });
  
  $('#remove_achievement').live('click',function(){
    $(this).closest("li").remove();
    return false;
  });
});
