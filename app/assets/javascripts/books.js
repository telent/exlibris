// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function populate_for_isbn(data,success,response) {
    if(! data) {
	data=$.parseJSON(response.responseText);
    }
    ["title","author","publisher"].
	map(function(k) { $('#book_'+k)[0].value=data[k] });
    $('#book_title').focus();
}

jQuery(document).ready(function() {
	$('#book_isbn').keypress(function(e) {
		if(e.which == 13) {
		    e.target.blur();
		    e.stopPropagation();
		    e.preventDefault();
		    $.getJSON("/editions/isbn/"+e.target.value,
			      null,
			      populate_for_isbn);
		}
	    });
    });

