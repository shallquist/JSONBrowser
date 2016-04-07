# JSONBrowser
JSON Browser is an iOS application that will display the contents of a JSON Object in a tree view. It is written in Swift 2.2 with iOS 9.3 libraries.

NOTE: This is work in progress, that I return to from time to time to improve and add featrues.

JSONBrowser is a simple app that will display the JSON Data in a tableView as a typical tree view.    Enter a URL JSON data request on the first view then select the getJSON button to retrieve data and display in a tree view.

Added a search feature to the app.  The search term must follow a specific format.
[#] retrieves an array element
term retrieves an object name term
.  separates objects

For example to retrieve the legs object from the following JSON message
  {"route":{"hasTollRoad":false,"computedWaypoints":[],"legs":[{"distance":25.973,"time":2078}]}}
Enter the search term
   route.legs[0]
   
Ex2:  To retrieve the second LatLng in the locations array from the message:
{"route":{"fuelUsed":1.28,"realTime":2202,"locations":[{"latLng":{"lng":-76.307078,"lat":40.039401},{"latLng":{"lng":-76.734668,"lat":39.960339}}]}}

route.locations[1].latLng


