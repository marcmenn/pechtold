google.maps.event.addDomListener(window, "load", function() {
  var address = document.getElementsByTagName('address')[0];
  var canvas = document.createElement('div');
  canvas.setAttribute('id', 'gmap');
  address.parentElement.replaceChild(canvas, address);
  var position = new google.maps.LatLng(Number(address.getAttribute('lat')), Number(address.getAttribute('long')));
  var content = address.innerHTML;
  var myOptions = {
    zoom: 14,
    center: position,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };

  var map = new google.maps.Map(canvas, myOptions);
  var marker = new google.maps.Marker({map, position});
  var infowindow = new google.maps.InfoWindow({content});
  google.maps.event.addListener(marker, "click", function () {
    return infowindow.open(map, marker)
  });

  return infowindow.open(map, marker);
});
