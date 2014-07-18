init_map = ->
    address = document.getElementsByTagName('address')[0]
    canvas = document.createElement 'div'
    canvas.setAttribute 'id', 'gmap'
    address.parentElement.replaceChild canvas, address
    position = new google.maps.LatLng Number(address.getAttribute('lat')), Number(address.getAttribute('long'))
    content = address.innerHTML
    myOptions =
        zoom: 14
        center: position
        mapTypeId: google.maps.MapTypeId.ROADMAP

    map = new google.maps.Map canvas, myOptions
    marker = new google.maps.Marker {map, position}
    infowindow = new google.maps.InfoWindow {content}
    google.maps.event.addListener marker, "click", ->
        infowindow.open map, marker

    infowindow.open map, marker

google.maps.event.addDomListener window, "load", init_map
