var viewer = OpenSeadragon({
    id: "openseadragon",
	prefixUrl: "https://cdnjs.cloudflare.com/ajax/libs/openseadragon/3.0.0/images/",
	tileSources: {
      type: "image",
      url: "http://diglib.hab.de/mss/50-weiss/00011.jpg"
    },
	showNavigationControl: true,
	showReferenceStrip: true,
	defaultZoomLevel : 0,
	fitHorizontally : true,
});