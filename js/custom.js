var viewer = OpenSeadragon({
    id: "openseadragon",
	prefixUrl: "https://cdnjs.cloudflare.com/ajax/libs/openseadragon/3.0.0/images/",
	tileSources: {
      type: "image",
      url: "http://diglib.hab.de/mss/50-weiss/max/00011.jpg"
    },
	showNavigationControl: true,
	showReferenceStrip: true,
	defaultZoomLevel : 0,
	maxZoomLevel : 10,
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
			let place = jsonGlosses.glosses[position][id]["reading"]["place"];
			$(resultDiv).append("<p><span class='set-margin-left'><i class='far fa-compass'></i></span><span class='emphasize-location'>" + place + "</span></p>");
			let hand = jsonGlosses.glosses[position][id]["reading"]["hand"];
			$(resultDiv).append("<p><span class='set-margin-left'><i class='far fa-hand-paper'></i></span><span class='emphasize-hand'>" + hand + "</span></p>");
			let analysis = jsonGlosses.glosses[position][id]["reading"]["analysis"];
			for (let i = 0; i < analysis.length; i++){
				let analysisItem = analysis[i];
				$(resultDiv).append("<p><span class='set-margin-left'><i class='fas fa-glasses'></i></span><span class='emphasize-analysis'>" + analysisItem + "</span></p>");
			}
			let note = "";
			if (jsonGlosses.glosses[position][id]["note"] !== undefined && jsonGlosses.glosses[position][id]["note"] !== null){
				note = jsonGlosses.glosses[position][id]["note"];
			}
			if (note !== ""){
				$(resultDiv).append("<p><span class='set-margin-left'><i class='far fa-comment'></i><span class='emphasize-note'>" + note + "</span></p>");
			}
			if (jsonGlosses.glosses[position][id]["pointer"] !== undefined && jsonGlosses.glosses[position][id]["pointer"] != null){
				pointer = jsonGlosses.glosses[position][id]["pointer"];
				$(resultDiv).append("<p><span class='set-margin-left'><i class='fa-solid fa-diagram-project'></i></span><span class='emphasize-pointer'>" + pointer + "</span></p>");
			}
			if($(resultDiv).hasClass("apparatus-hidden")){
				$(resultDiv).removeClass("apparatus-hidden");
				$(resultDiv).addClass("apparatus-visible");
			}
			else {
				$(resultDiv).removeClass("apparatus-visible");
				$(resultDiv).addClass("apparatus-hidden");
			}
			let rectangle = jsonGlosses.glosses[position][id]["reading"]["zone"];
			let upperLeftX = rectangle["ulx"];
			let upperLeftY = rectangle["uly"];
			let lowerRightX = rectangle["lrx"];
			let lowerRightY = rectangle["lry"];
			let overlayElement = document.createElement("div");
			let idOfOverlay = document.createAttribute("id");
			idOfOverlay.value = "overlay";
			overlayElement.setAttributeNode(idOfOverlay);
			document.getElementById
			let widthOfPicture = 1024;
			let heightOfPicture = 1217;
			let upperLeftXScaled = upperLeftX / widthOfPicture;
			//let upperLeftYScaled = upperLeftY / heightOfPicture * 1217/1024;
			let upperLeftYScaled = upperLeftY / heightOfPicture * 2369/2000;
			let lowerRightXScaled = lowerRightX / widthOfPicture;
			//let lowerRightYScaled = lowerRightY / heightOfPicture * 1217/1024;
			let lowerRightYScaled = lowerRightY / heightOfPicture * 2369/2000;
			let widthScaled = lowerRightXScaled - upperLeftXScaled;
			let heightScaled = lowerRightYScaled - upperLeftYScaled;
			viewer.addOverlay(overlayElement,new OpenSeadragon.Rect(upperLeftXScaled,upperLeftYScaled,widthScaled,heightScaled));
			});
		});
	});
});

