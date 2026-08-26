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
                store: ["id_of_quote","quote_normalized","quote_critical","link"]
            }
        });
        jsonQuotes.quotes.forEach(quote => {
            documentOfQuotes.add(quote);
        });
    });

    let jsonInterventions = {};
    $.ajax({
		url: "./json/interventions.json"
	})
	.done(function(data) {
		jsonInterventions = data;
        documentOfInterventions = new FlexSearch.Document({
            document: {
                id: "id",
                index: ["id_of_intervention","type_of_intervention","lemma:text_of_lemma","reading:reading_normalized","reading:reading_critical"]
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
                    let matchedText = match.doc.id_of_quote + ": " + match.doc.quote_normalized + " - " + match.doc.quote_critical;
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
            let results = documentOfInterventions.search(searchString, { field: ["id_of_intervention","type_of_intervention","lemma:text_of_lemma","reading:reading_normalized","reading:reading_critical"]});
            let resultsFiltered = [];
            switch (typeOfIntervention){
                // gloss | emendation | rubrication | text variation | reference sign | annotation sign
                case "all": {
                    for (let i = 0; i < results.length; i++){
                        results[i].result.forEach(match => {
                            jsonInterventions.interventions.forEach(entry => {
                                if (entry.id === match){
                                    resultsFiltered.push(entry);
                                }
                            });
                    });};
                    break;
                }
                case "gloss": {
                    for (let i = 0; i < results.length; i++){
                        results[i].result.forEach(match => {
                            jsonInterventions.interventions.forEach(entry => {
                                if ((entry.id === match) && (entry.type_of_intervention === 'gloss')){
                                    resultsFiltered.push(entry);
                                }
                            });
                    });};
                    break; 
                }
                case "emendation": { 
                    for (let i = 0; i < results.length; i++){
                        results[i].result.forEach(match => {
                            jsonInterventions.interventions.forEach(entry => {
                                if ((entry.id === match) && (entry.type_of_intervention === 'emendation')){
                                    resultsFiltered.push(entry);
                                }
                            });
                    });};
                    break; 
                }
                case "rubrication": { 
                    for (let i = 0; i < results.length; i++){
                        results[i].result.forEach(match => {
                            jsonInterventions.interventions.forEach(entry => {
                                if ((entry.id === match) && (entry.type_of_intervention === 'rubrication')){
                                    resultsFiltered.push(entry);
                                }
                            });
                    });};
                    break; 
                }
                case "text-variation": { 
                    for (let i = 0; i < results.length; i++){
                        results[i].result.forEach(match => {
                            jsonInterventions.interventions.forEach(entry => {
                                if ((entry.id === match) && (entry.type_of_intervention === 'text variation')){
                                    resultsFiltered.push(entry);
                                }
                            });
                    });};
                    break; 
                }
                case "reference-sign": { 
                    for (let i = 0; i < results.length; i++){
                        results[i].result.forEach(match => {
                            jsonInterventions.interventions.forEach(entry => {
                                if ((entry.id === match) && (entry.type_of_intervention === 'reference sign')){
                                    resultsFiltered.push(entry);
                                }
                            });
                    });};
                    break; 
                }
                case "annotation-sign": { 
                    for (let i = 0; i < results.length; i++){
                        results[i].result.forEach(match => {
                            jsonInterventions.interventions.forEach(entry => {
                                if ((entry.id === match) && (entry.type_of_intervention === 'annotation sign')){
                                    resultsFiltered.push(entry);
                                }
                            });
                    });};
                    break; 
                }
            }
            resultsFiltered = filterHand(resultsFiltered);
            let resultContent = document.getElementById("search-result-content");
            resultContent.replaceChildren();
            if (resultsFiltered.length != 0){
                resultsFiltered.forEach(match => {
                    let handText = "hand: ";
                    if (match.reading.hand === ""){
                        handText += "-";
                    }
                    else {
                        handText += match.reading.hand;
                    }
                    let matchedText = match.id_of_intervention + ": " + match.lemma.text_of_lemma + " - " + match.reading.reading_normalized + " - " + match.reading.reading_critical + " - " + handText;
                    let matchedTextHighlighted = matchedText.replaceAll(searchString,`<span style="background-color:#c4ae95;">${searchString}</span>`);
                    let linkToEdition = match.link;
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

    document.getElementById("full-text-select-interventions").addEventListener('click',function(event){
        document.getElementById("form-subgroup-type-of-intervention").style = "display: flex !important;";
    });
    document.getElementById("full-text-select-quotes").addEventListener('click',function(event){
        document.getElementById("form-subgroup-type-of-intervention").style = "display: none;";
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

    function getScribeOfIntervention(){
        // main scribe | secondary scribe | first glossator | second glossator | Otfrid
        let selectScribeAll = document.getElementById("scribe-of-intervention-all").checked;
        let selectScribeMainScribe = document.getElementById("scribe-of-intervention-main-scribe").checked;
        let selectScribeSecondaryScribe = document.getElementById("scribe-of-intervention-secondary-scribe").checked;
        let selectScribeFirstGlossator = document.getElementById("scribe-of-intervention-first-glossator").checked;
        let selectScribeSecondGlossator = document.getElementById("scribe-of-intervention-second-glossator").checked;
        let selectScribeOtfrid = document.getElementById("scribe-of-intervention-otfrid").checked;
        if (selectScribeAll === true){ return "all"; }
        if (selectScribeMainScribe === true){ return "main-scribe"; }
        if (selectScribeSecondaryScribe === true){ return "secondary-scribe"; }
        if (selectScribeFirstGlossator === true){ return "first-glossator"; }
        if (selectScribeSecondGlossator === true){ return "second-glossator"; }
        if (selectScribeOtfrid === true){ return "otfrid"; }
    }

    function filterHand(resultsFiltered){
        let selectedHand = getScribeOfIntervention();
        let resultsFilteredByHand = [];
        switch (selectedHand){
            case "all": {
                resultsFilteredByHand = resultsFiltered;
                break;
            }
            case "main-scribe": {
                for (let i = 0; i < resultsFiltered.length; i++){
                    if (resultsFiltered[i].reading.hand === 'main writer'){
                        resultsFilteredByHand.push(resultsFiltered[i]);
                    }
                }
                break;
            }
            case "secondary-scribe": {
                for (let i = 0; i < resultsFiltered.length; i++){
                    if (resultsFiltered[i].reading.hand === 'secondary scribe'){
                        resultsFilteredByHand.push(resultsFiltered[i]);
                    }
                }
                break;
            }
            case "first-glossator": {
                for (let i = 0; i < resultsFiltered.length; i++){
                    if (resultsFiltered[i].reading.hand === 'first glossator'){
                        resultsFilteredByHand.push(resultsFiltered[i]);
                    }
                }
                break;
            }
            case "second-glossator": {
                for (let i = 0; i < resultsFiltered.length; i++){
                    if (resultsFiltered[i].reading.hand === 'second glossator'){
                        resultsFilteredByHand.push(resultsFiltered[i]);
                    }
                }
                break;
            }
            case "otfrid": {
                for (let i = 0; i < resultsFiltered.length; i++){
                    if (resultsFiltered[i].reading.hand === 'Otfrid'){
                        resultsFilteredByHand.push(resultsFiltered[i]);
                    }
                }
                break;
            }
        }
        return resultsFilteredByHand;
    }
});