var map
var infoWindows=[]

function addInfoToMarker(infoString, marker){
    var infowindow = new google.maps.InfoWindow();
    infoWindows.push(infowindow);
    infowindow.setContent(infoString);
    infowindow.setPosition(marker.getPosition());
    google.maps.event.addListener(marker, 'click', function() {
        jQuery.each(infoWindows, function(i,info){ info.close();});
        infowindow.open(map,marker);
    });
    return marker;
};

function addMarker(lng, lat, infoString, icon_name){
  myLatlng = new google.maps.LatLng(lat, lng);
  placeMarker(myLatlng, infoString, icon_name);
}
function placeMarker(location, infoString, icon_name){
  marker = new google.maps.Marker({
    position: location, 
    map: map,
    draggable: false,
    icon: "/images/common/"+icon_name
    // icon: "/favicon.ico"
  });
  if(infoString.length > 0 ){
    addInfoToMarker(infoString, marker)
  }else{
    map.setCenter(location);
  }
}

function initialize(latLng, zoom){
  myOptions = {
    zoom: zoom,
    center: latLng,
    mapTypeId: google.maps.MapTypeId.HYBRID
  }
  map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
}

function initialize_map(lng, lat) {
  if(lng.length > 0 && lat.length > 0 ){
    myLatlng = new google.maps.LatLng(lat, lng);
    initialize(myLatlng, 16);
    placeMarker(myLatlng, "", "pointer.png");
  }else{
    myLatlng = new google.maps.LatLng("27.442293572134986", "30.654107449163227");
    initialize(myLatlng, 6);
    map.setCenter(myLatlng);
  }
}