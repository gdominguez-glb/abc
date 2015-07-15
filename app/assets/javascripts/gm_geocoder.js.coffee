class @GmGeocoder

  @findPosition: (callback)->
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition((position)->
        point = { lat: position.coords.latitude, lng: position.coords.longitude }
        if callback
          callback(point)
      )
    else
      alert("Geocoding not support in your browser!")

  @findAddress: (opts={})->
    googlePos = new google.maps.LatLng(opts.point.lat, opts.point.lng)
    geocoder = new google.maps.Geocoder()
    
    geocoder.geocode({ 'latLng' : googlePos }, (results, status)->
      if opts.callback
        opts.callback(results[0].formatted_address)
    )

