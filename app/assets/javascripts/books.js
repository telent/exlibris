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
	$('#book_isbn').keypress(function(e) {
		if(e.which == 13) {
		    e.target.blur();
		    e.stopPropagation();
		    e.preventDefault();
		    ["title","author","publisher"].
			map(function(k) {
				$('#book_'+k)[0].disabled='disabled';
			    });
		    $.ajax
			({
			    url: "/editions/isbn/"+e.target.value,
				dataType: 'json',
				success: populate_for_isbn,
				error: enable_fields
				});
		}
	    }).focus();	
    });

