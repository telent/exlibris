
jQuery(document).ready(function() {
	$('select#mark').change(function(e) {
		v=e.target.value;
		if(v=='all') {
		    $('input[name=check]').prop("checked",true);
		} else if(v=='none') {
		    $('input[name=check]').prop("checked",false);
		} else if(v=='invert') {
		    $('input[name=check]').map(function(i,el) {
			    el.checked = !(el.checked);
			});
		}
		e.preventDefault();
		e.target.value='title';
	    });
	$("table th").click(function(e) {
		var sort_key=e.target.firstChild.textContent.toLowerCase();
		var params=document.location.search.substr(1).split('&').reduce(function(h,p) { var kv=p.split('=',2); h[kv[0]]=kv[1] ; return h }, {});
		if (params.sort==sort_key) {
		    params.direction = (params.direction == 'a') ? 'd' : 'a';
		} else {
		    params.sort=sort_key;
		    params.direction = 'a';
		};
		params.page='1';
		var  p_new=$.map(params,function(v,k) { return k+"="+v }).join("&");
		document.location=document.location.pathname+"?"+p_new;
	    });
    });

