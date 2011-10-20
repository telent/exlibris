function select_tab(target) {
    $('ul.tabs li').removeClass('active');
    $(target.parentNode).addClass('active');
    $('div.tab').removeClass('tab_selected');
    $('#'+target.name).addClass('tab_selected');
}

jQuery(document).ready(function() {
	select_tab($('ul.tabs li a')[0]);
	$('ul.tabs li a').click(function(e) { select_tab(e.target);});
    });
