init_map = ->
    position = new google.maps.LatLng 52.49778, 13.319680000000062
    content = "<b>Pechtold Gesellschaft von Architekten mbH</b><br/>Pariser Straße 44<br/>10707 Berlin"
    myOptions =
        zoom: 14
        center: position
        mapTypeId: google.maps.MapTypeId.ROADMAP

    canvas = document.getElementById "gmap_canvas"
    map = new google.maps.Map canvas, myOptions
    marker = new google.maps.Marker {map, position}
    infowindow = new google.maps.InfoWindow {content}
    google.maps.event.addListener marker, "click", ->
        infowindow.open map, marker

    infowindow.open map, marker

#google.maps.event.addDomListener window, "load", init_map
