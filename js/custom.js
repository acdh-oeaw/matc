var viewer = OpenSeadragon({
    id: "openseadragon",
	prefixUrl: "https://cdnjs.cloudflare.com/ajax/libs/openseadragon/3.0.0/images/",
	tileSources: [
	{
		type: "image",
		url: "http://diglib.hab.de/mss/50-weiss/max/00001.jpg"
    },
	{ 
		type: "image",
		url: "http://diglib.hab.de/mss/50-weiss/max/00002.jpg"
	},
	{
		type: "image",
		url: "http://diglib.hab.de/mss/50-weiss/max/00003.jpg"
    },
	{
		type: "image",
		url: "http://diglib.hab.de/mss/50-weiss/max/00004.jpg"
    },
	{
		type: "image",
		url: "http://diglib.hab.de/mss/50-weiss/max/00005.jpg"
    },
	{
		type: "image",
		url: "http://diglib.hab.de/mss/50-weiss/max/00006.jpg"
    },
	{
		type: "image",
		url: "http://diglib.hab.de/mss/50-weiss/max/00007.jpg"
    },
	{
		type: "image",
		url: "http://diglib.hab.de/mss/50-weiss/max/00008.jpg"
    },
	{
		type: "image",
		url: "http://diglib.hab.de/mss/50-weiss/max/00009.jpg"
    },
	{
		type: "image",
		url: "http://diglib.hab.de/mss/50-weiss/max/00010.jpg"
    },
	{
		type: "image",
		url: "http://diglib.hab.de/mss/50-weiss/max/00011.jpg"
    },
	{
		type: "image",
		url: "http://diglib.hab.de/mss/50-weiss/max/00012.jpg"
    },
	{
		type: "image",
		url: "http://diglib.hab.de/mss/50-weiss/max/00013.jpg"
    },
	{
		type: "image",
		url: "http://diglib.hab.de/mss/50-weiss/max/00014.jpg"
    },
	{
		type: "image",
		url: "http://diglib.hab.de/mss/50-weiss/max/00015.jpg"
    }
	],
	showNavigationControl: true,
	showReferenceStrip: true,
	defaultZoomLevel : 0,
	maxZoomLevel : 10,
	fitHorizontally : true
});

$(window).on('load', function(){
	viewer.goToPage(10);
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
			let indexOfImage = jsonGlosses.glosses[position][id]["reading"]["index"];
			viewer.goToPage(indexOfImage - 1);
			let rectangle = jsonGlosses.glosses[position][id]["reading"]["zone"];
			let upperLeftX = rectangle["ulx"];
			let upperLeftY = rectangle["uly"];
			let lowerRightX = rectangle["lrx"];
			let lowerRightY = rectangle["lry"];
			let overlayElement = document.createElement("div");
			let idOfOverlay = document.createAttribute("id");
			idOfOverlay.value = "overlay";
			overlayElement.setAttributeNode(idOfOverlay);
			let widthOfPicture = 2000;
			let heightOfPicture = 2369;
			let upperLeftXScaled = upperLeftX / widthOfPicture;
			let upperLeftYScaled = upperLeftY / heightOfPicture * 2369/2000;
			let lowerRightXScaled = lowerRightX / widthOfPicture;
			let lowerRightYScaled = lowerRightY / heightOfPicture * 2369/2000;
			let widthScaled = lowerRightXScaled - upperLeftXScaled;
			let heightScaled = lowerRightYScaled - upperLeftYScaled;
			viewer.addHandler('tile-loaded',function(){
				viewer.removeOverlay(idOfOverlay.value);
				viewer.addOverlay(overlayElement,new OpenSeadragon.Rect(upperLeftXScaled,upperLeftYScaled,widthScaled,heightScaled));
			});
			viewer.addHandler('add-overlay',function(){
				let point = new OpenSeadragon.Point(upperLeftXScaled, upperLeftYScaled);
				viewer.viewport.zoomTo(2, point, false);
			});
			});
		});
	});
	
	$.ajax({
		url: "./json/text-variations.json"
	})
	.done(function(data) {
		let jsonTextVariation = data;
		
		$(".link-for-text-variation").each(function(){
		let id = this.id;
		this.addEventListener('click', function(event) {
			event.preventDefault();
			let position = 0;
			for (let i = 0; i < jsonTextVariation["text-variations"].length; i++)
			{
				if (jsonTextVariation["text-variations"][i]["id"] === id){
					position = i;
					break;
				}
			}
		let indexOfImage = jsonTextVariation["text-variations"][position][id]["index"];
			viewer.goToPage(indexOfImage - 1);
			let rectangle = jsonTextVariation["text-variations"][position][id]["zone"];
			let upperLeftX = rectangle["ulx"];
			let upperLeftY = rectangle["uly"];
			let lowerRightX = rectangle["lrx"];
			let lowerRightY = rectangle["lry"];
			let overlayElement = document.createElement("div");
			let idOfOverlay = document.createAttribute("id");
			idOfOverlay.value = "overlay";
			overlayElement.setAttributeNode(idOfOverlay);
			let widthOfPicture = 2000;
			let heightOfPicture = 2369;
			let upperLeftXScaled = upperLeftX / widthOfPicture;
			let upperLeftYScaled = upperLeftY / heightOfPicture * 2369/2000;
			let lowerRightXScaled = lowerRightX / widthOfPicture;
			let lowerRightYScaled = lowerRightY / heightOfPicture * 2369/2000;
			let widthScaled = lowerRightXScaled - upperLeftXScaled;
			let heightScaled = lowerRightYScaled - upperLeftYScaled;
			viewer.addHandler('tile-loaded',function(){
				viewer.removeOverlay(idOfOverlay.value);
				viewer.addOverlay(overlayElement,new OpenSeadragon.Rect(upperLeftXScaled,upperLeftYScaled,widthScaled,heightScaled));
			});
			viewer.addHandler('add-overlay',function(){
				let point = new OpenSeadragon.Point(upperLeftXScaled, upperLeftYScaled);
				viewer.viewport.zoomTo(2, point, false);
			});
			});
		});
	});
	
	$.ajax({
		url: "./json/reference-signs.json"
	})
	.done(function(data) {
		let jsonReferenceSigns = data;
		
		$(".link-for-reference-sign").each(function(){
		let id = this.id;
		this.addEventListener('click', function(event) {
			event.preventDefault();
			let position = 0;
			for (let i = 0; i < jsonReferenceSigns["reference-signs"].length; i++)
			{
				if (jsonReferenceSigns["reference-signs"][i]["id"] === id){
					position = i;
					break;
				}
			}
		    let indexOfImage = jsonReferenceSigns["reference-signs"][position][id]["index"];
			viewer.goToPage(indexOfImage - 1);
			let rectangle = jsonReferenceSigns["reference-signs"][position][id]["zone"];
			let upperLeftX = rectangle["ulx"];
			let upperLeftY = rectangle["uly"];
			let lowerRightX = rectangle["lrx"];
			let lowerRightY = rectangle["lry"];
			let overlayElement = document.createElement("div");
			let idOfOverlay = document.createAttribute("id");
			idOfOverlay.value = "overlay";
			overlayElement.setAttributeNode(idOfOverlay);
			let widthOfPicture = 2000;
			let heightOfPicture = 2369;
			let upperLeftXScaled = upperLeftX / widthOfPicture;
			let upperLeftYScaled = upperLeftY / heightOfPicture * 2369/2000;
			let lowerRightXScaled = lowerRightX / widthOfPicture;
			let lowerRightYScaled = lowerRightY / heightOfPicture * 2369/2000;
			let widthScaled = lowerRightXScaled - upperLeftXScaled;
			let heightScaled = lowerRightYScaled - upperLeftYScaled;
			viewer.addHandler('tile-loaded',function(){
				viewer.removeOverlay(idOfOverlay.value);
				viewer.addOverlay(overlayElement,new OpenSeadragon.Rect(upperLeftXScaled,upperLeftYScaled,widthScaled,heightScaled));
			});
			viewer.addHandler('add-overlay',function(){
				let point = new OpenSeadragon.Point(upperLeftXScaled, upperLeftYScaled);
				viewer.viewport.zoomTo(2, point, false);
			});
			});
		});
	});
	
	$.ajax({
		url: "./json/notes.json"
	})
	.done(function(data) {
		let jsonNotes = data;
		
		$(".link-for-note").each(function(){
		let id = this.id;
		this.addEventListener('click', function(event) {
			event.preventDefault();
			let position = 0;
			for (let i = 0; i < jsonNotes["notes"].length; i++)
			{
				if (jsonNotes["notes"][i]["id"] === id){
					position = i;
					break;
				}
			}
		let indexOfImage = jsonNotes["notes"][position][id]["index"];
			viewer.goToPage(indexOfImage - 1);
			let rectangle = jsonNotes["notes"][position][id]["zone"];
			let upperLeftX = rectangle["ulx"];
			let upperLeftY = rectangle["uly"];
			let lowerRightX = rectangle["lrx"];
			let lowerRightY = rectangle["lry"];
			let overlayElement = document.createElement("div");
			let idOfOverlay = document.createAttribute("id");
			idOfOverlay.value = "overlay";
			overlayElement.setAttributeNode(idOfOverlay);
			let widthOfPicture = 2000;
			let heightOfPicture = 2369;
			let upperLeftXScaled = upperLeftX / widthOfPicture;
			let upperLeftYScaled = upperLeftY / heightOfPicture * 2369/2000;
			let lowerRightXScaled = lowerRightX / widthOfPicture;
			let lowerRightYScaled = lowerRightY / heightOfPicture * 2369/2000;
			let widthScaled = lowerRightXScaled - upperLeftXScaled;
			let heightScaled = lowerRightYScaled - upperLeftYScaled;
			viewer.addHandler('tile-loaded',function(){
				viewer.removeOverlay(idOfOverlay.value);
				viewer.addOverlay(overlayElement,new OpenSeadragon.Rect(upperLeftXScaled,upperLeftYScaled,widthScaled,heightScaled));
			});
			viewer.addHandler('add-overlay',function(){
				let point = new OpenSeadragon.Point(upperLeftXScaled, upperLeftYScaled);
				viewer.viewport.zoomTo(2, point, false);
			});
			});
		});
	});
});

