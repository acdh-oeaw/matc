$(window).on('load', function(){
	
	$.ajax({
		url: "./json/quotes.json"
	})
	.done(function(data) {
		let jsonQuotes = data;
        const documentOfQuotes = new window.FlexSearch.Document({
            document: {
                id: "id",
                index: ["quote_normalized","quote_critical"],
                store: ["quote_normalized","quote_critical","link"]
            }
        });
        jsonQuotes.quotes.forEach(quote => {
            documentOfQuotes.add(quote);
        });

        let idOfSubmitButton = "search-glosses-submit";
        document.getElementById(idOfSubmitButton).addEventListener('click',function(event) {
			event.preventDefault();
            let quotesEnabled = document.getElementById("full-text-select-quotes").checked;
            let quotesOrInterventions = "interventions";
            if (quotesEnabled){ quotesOrInterventions = "quotes"; }
            let searchString = document.getElementById("full-text-search-input").value;
            if (quotesOrInterventions === "quotes"){
                let results = documentOfQuotes.search(searchString, { field: ["quote_normalized","quote_critical"], enrich: true });
                let resultContent = document.getElementById("search-result-content");
                    resultContent.replaceChildren();
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
            }});
    });
$.ajax({
		url: "./json/interventions.json"
	})
	.done(function(data) {
		let jsonInterventions = data;
        const documentOfInterventions = new window.FlexSearch.Document({
            document: {
                id: "id",
                index: ["type_of_intervention","id_of_intervention","lemma:text_of_lemma","reading:reading_normalized"],
                store: ["id_of_intervention","lemma:text_of_lemma","reading:reading_normalized","link"]
            }
        });
        jsonInterventions.interventions.forEach(intervention => {
            documentOfInterventions.add(intervention);
        });

        let idOfSubmitButton = "search-glosses-submit";
        document.getElementById(idOfSubmitButton).addEventListener('click',function(event) {
			event.preventDefault();
            let interventionEnabled = document.getElementById("full-text-select-interventions").checked;
            let quotesOrInterventions = "interventions";
            if (interventionEnabled){ quotesOrInterventions = "interventions"; }
            let searchString = document.getElementById("full-text-search-input").value;
            if (quotesOrInterventions === "interventions"){
                let results = documentOfInterventions.search(searchString, { field: ["id_of_intervention","lemma:text_of_lemma","reading:reading_normalized"], enrich: true });
                console.log(results);
                let resultContent = document.getElementById("search-result-content");
                    resultContent.replaceChildren();
                    results[0].result.forEach(match => {
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
            }});

    });
});