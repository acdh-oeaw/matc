import FlexSearch from "./flexsearch.bundle.module.min.js";
$(window).on('load', function(){
	
    document.getElementById("form-subgroup-type-of-intervention").style = "display: none";

    let documentOfQuotes = {};
    let documentOfInterventions = {};

	$.ajax({
		url: "./json/quotes.json"
	})
	.done(function(data) {
		let jsonQuotes = data;
        documentOfQuotes = new FlexSearch.Document({
            document: {
                id: "id",
                index: ["quote_normalized","quote_critical"],
                store: ["quote_normalized","quote_critical","link"]
            }
        });
        jsonQuotes.quotes.forEach(quote => {
            documentOfQuotes.add(quote);
        });
    });

    $.ajax({
		url: "./json/interventions.json"
	})
	.done(function(data) {
		let jsonInterventions = data;
        documentOfInterventions = new FlexSearch.Document({
            document: {
                id: "id",
                index: ["type_of_intervention","id_of_intervention","lemma:text_of_lemma","reading:reading_normalized"],
                store: ["type_of_intervention","id_of_intervention","lemma:text_of_lemma","reading:reading_normalized","link"]
            }
        });
        jsonInterventions.interventions.forEach(intervention => {
            documentOfInterventions.add(intervention);
        });
    });

    let idOfSubmitButton = "search-glosses-submit";
    document.getElementById(idOfSubmitButton).addEventListener('click',function(event) {
        event.preventDefault();
        processSubmit();
    });

    function processSubmit(){
        let quotesEnabled = document.getElementById("full-text-select-quotes").checked;
        let quotesOrInterventions = "interventions";
        if (quotesEnabled){ quotesOrInterventions = "quotes"; }
        let searchString = document.getElementById("full-text-search-input").value;
        if (quotesOrInterventions === "quotes"){
            let results = documentOfQuotes.search(searchString, { field: ["quote_normalized","quote_critical"], enrich: true });
            let resultContent = document.getElementById("search-result-content");
            resultContent.replaceChildren();
            if (results.length !== 0){
                results[0].result.forEach(match => {
                    let matchedText = match.doc.quote_normalized;
                    let matchedTextHighlighted = matchedText.replaceAll(searchString,`<span style="background-color:#c4ae95;">${searchString}</span>`);
                    let linkToEdition = match.doc.link;
                    let paragraphWithMatchedText = document.createElement('p');
                    paragraphWithMatchedText.innerHTML = matchedTextHighlighted;
                    let linkWithLinkToEdition = document.createElement('a');
                    linkWithLinkToEdition.textContent = "Show in Edition";
                    linkWithLinkToEdition.href = linkToEdition;
                    linkWithLinkToEdition.style = "margin-left: 10pt";
                    paragraphWithMatchedText.appendChild(linkWithLinkToEdition);
                    resultContent.appendChild(paragraphWithMatchedText);
                });
            }
            else {
            let returnResultEmpty = document.createElement('p');
            returnResultEmpty.textContent = 'No matches found.'
            resultContent.appendChild(returnResultEmpty);
            }
        };
        let interventionEnabled = document.getElementById("full-text-select-interventions").checked;
        quotesOrInterventions = "quotes";
        if (interventionEnabled){ quotesOrInterventions = "interventions"; }
        if (quotesOrInterventions === "interventions"){
            let typeOfIntervention = getTypeOfIntervention();
            let results = documentOfInterventions.search(searchString, { field: ["id_of_intervention","lemma:text_of_lemma","reading:reading_normalized"], enrich: true });
            let resultsFiltered = [];
            switch (typeOfIntervention){
                // gloss | emendation | rubrication | text variation | reference sign | annotation sign
                case "all": {
                    results[0].result.forEach(match => {
                        resultsFiltered.push(match);
                    });
                    break;
                }
                case "gloss": {
                    results[0].result.forEach(match => {
                        if (match.doc.type_of_intervention === "gloss"){
                            resultsFiltered.push(match);
                        }
                    });
                    break; 
                }
                case "emendation": { 
                    results[0].result.forEach(match => {
                        if (match.doc.type_of_intervention === "emendation"){
                            resultsFiltered.push(match);
                        }
                    });
                    break; 
                }
                case "rubrication": { 
                    results[0].result.forEach(match => {
                        if (match.doc.type_of_intervention === "rubrication"){
                            resultsFiltered.push(match);
                        }
                    });
                    break; 
                }
                case "text-variation": { 
                    results[0].result.forEach(match => {
                        if (match.doc.type_of_intervention === "text variation"){
                            resultsFiltered.push(match);
                        }
                    });
                    break; 
                }
                case "reference-sign": { 
                    results[0].result.forEach(match => {
                        if (match.doc.type_of_intervention === "reference sign"){
                            resultsFiltered.push(match);
                        }
                    });
                    break; 
                }
                case "annotation-sign": { 
                    results[0].result.forEach(match => {
                        if (match.doc.type_of_intervention === "annotation sign"){
                            resultsFiltered.push(match);
                        }
                    });
                    break; 
                }
                default: {
                    results = documentOfInterventions.search(searchString, { field: ["id_of_intervention","lemma:text_of_lemma","reading:reading_normalized"], enrich: true });
                }
            }
            let resultContent = document.getElementById("search-result-content");
            resultContent.replaceChildren();
            if (resultsFiltered.length != 0){
                resultsFiltered.forEach(match => {
                    let matchedText = match.doc.id_of_intervention + ": " + match.doc.lemma.text_of_lemma + " - " + match.doc.reading.reading_normalized;
                    let matchedTextHighlighted = matchedText.replaceAll(searchString,`<span style="background-color:#c4ae95;">${searchString}</span>`);
                    let linkToEdition = match.doc.link;
                    let paragraphWithMatchedText = document.createElement('p');
                    paragraphWithMatchedText.innerHTML = matchedTextHighlighted;
                    let linkWithLinkToEdition = document.createElement('a');
                    linkWithLinkToEdition.textContent = "Show in Edition";
                    linkWithLinkToEdition.href = linkToEdition;
                    linkWithLinkToEdition.style = "margin-left: 10pt";
                    paragraphWithMatchedText.appendChild(linkWithLinkToEdition);
                    resultContent.appendChild(paragraphWithMatchedText);
                });
            }
            else {
                let returnResultEmpty = document.createElement('p');
                returnResultEmpty.textContent = 'No matches found.'
                resultContent.appendChild(returnResultEmpty);
            }
        }
    };

    let idOfSubForm = "form-subgroup-type-of-intervention";
    let subForm = document.getElementById(idOfSubForm);
    document.getElementById("full-text-select-interventions").addEventListener('click',function(event){
        subForm.style = "display: block";
    });
    document.getElementById("full-text-select-quotes").addEventListener('click',function(event){
        subForm.style = "display: none";
    });

    document.getElementById("full-text-search-input").focus();
    
    let divForSearch = document.getElementById("search-form-glosses");
    divForSearch.addEventListener("keypress",function(event){
        if (event.key === "Enter"){
            event.preventDefault();
            processSubmit();
        }
    });

    let clearButton = document.getElementById("search-glosses-clear");
    clearButton.addEventListener("click",function(event){
        event.preventDefault();
        let searchField = document.getElementById("full-text-search-input");
        searchField.value = "";
        searchField.focus();
        let resultContent = document.getElementById("search-result-content");
        resultContent.replaceChildren();
        document.getElementById("type-of-intervention-all").checked = true;
        document.getElementById("type-of-intervention-gloss").checked = false;
        document.getElementById("type-of-intervention-emendation").checked = false;
        document.getElementById("type-of-intervention-rubrication").checked = false;
        document.getElementById("type-of-intervention-text-variation").checked = false;
        document.getElementById("type-of-intervention-reference-sign").checked = false;
        document.getElementById("type-of-intervention-annotation-sign").checked = false;
        document.getElementById("full-text-select-interventions").checked = false;
        document.getElementById("form-subgroup-type-of-intervention").style = "display: none";
        document.getElementById("full-text-select-quotes").checked = true;
    })
    
    function getTypeOfIntervention(){
        // gloss | emendation | rubrication | text variation | reference sign | annotation sign
        let selectAll = document.getElementById("type-of-intervention-all").checked;
        let selectGloss = document.getElementById("type-of-intervention-gloss").checked;
        let selectEmendation = document.getElementById("type-of-intervention-emendation").checked;
        let selectRubrication = document.getElementById("type-of-intervention-rubrication").checked;
        let selectTextVariation = document.getElementById("type-of-intervention-text-variation").checked;
        let selectReferenceSign = document.getElementById("type-of-intervention-reference-sign").checked;
        let selectAnnotationSign = document.getElementById("type-of-intervention-annotation-sign").checked;
        if (selectAll === true){ return "all"; }
        if (selectGloss === true){ return "gloss"; }
        if (selectEmendation === true){ return "emendation"; }
        if (selectRubrication === true){ return "rubrication"; }
        if (selectTextVariation === true){ return "text-variation"; }
        if (selectReferenceSign === true){ return "reference-sign"; }
        if (selectAnnotationSign === true){ return "annotation-sign"; }
    }
});