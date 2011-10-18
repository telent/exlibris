// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function populate_for_isbn(data,success,response) {
    if(! data) {
	data=$.parseJSON(response.responseText);
    }
    ["title","author","publisher"].
	map(function(k) { $('#book_'+k)[0].value=data[k] });
    enable_fields();
    $('#book_title').focus();
}
function enable_fields() {
    ["title","author","publisher"].
	map(function(k) { $('#book_'+k)[0].disabled=false });
}

jQuery(document).ready(function() {
	$('#bookd_isbn').focus();	
    });

