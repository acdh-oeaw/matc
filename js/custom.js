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

$(window).on('load', function(){
	$.ajax({
		url: "./json/glosses.json"
	})
	.done(function(data) {
		let jsonGlosses = data;
		
		$(".link-for-gloss").each(function(){
		let id = this.id;
		this.addEventListener('click', function(event) {
			event.preventDefault();
			let idOfDiv = "div-for-" + id;
			let resultDiv = document.getElementById(idOfDiv);
			$(resultDiv).empty();
			let position = 0;
			for (let i = 0; i < jsonGlosses.glosses.length; i++)
			{
				if (jsonGlosses.glosses[i]["id"] === id){
					position = i;
					break;
				}
			}
			let witness = jsonGlosses.glosses[position][id]["reading"]["witness"];
			let textOfGloss = jsonGlosses.glosses[position][id]["reading"]["text"];
			$(resultDiv).append("<p>" + witness + ": " + textOfGloss + "</p>");
			if($(resultDiv).hasClass("apparatus-hidden")){
				$(resultDiv).removeClass("apparatus-hidden");
				$(resultDiv).addClass("apparatus-visible");
			}
			else {
				$(resultDiv).removeClass("apparatus-visible");
				$(resultDiv).addClass("apparatus-hidden");
			}
			});
		});
	});
});

