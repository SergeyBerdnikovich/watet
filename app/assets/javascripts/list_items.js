var drag_started = false;

$(document).ready(function() {

	$('.deleter').bind('ajax:success', function() {

		list_item_id = $(this).attr('list_item_id')
		$('#'+list_item_id).remove()
		$(window).resize()
	});


	$('.banner').mouseenter(function(){
		$(this).attr('class', 'banner_active')
	})
	$('.banner').mouseleave(function(){

		$(this).attr('class', 'banner')

	})
	$(window).resize()

	$('.li').mouseenter(function(){

		current_class = $(this).attr('class')
		may_change = true
		if (current_class.indexOf("list_item_active") != -1){
			may_change = false
		}

		if (current_class.indexOf("list_item_edit") != -1){
			may_change = false
		}

		if (may_change == true){
			$(this).attr('class', 'list_item_hover')
		}


	})

	$('.li').mouseleave(function(){
		current_class = $(this).attr('class')
		may_change = true
		if (current_class.indexOf("list_item_active") != -1){
			may_change = false
		}

		if (current_class.indexOf("list_item_edit") != -1){
			may_change = false
		}

		if (may_change == true){
			$(this).attr('class', 'list_item')
		}


	})



	$('.li').click(function(e) {
		if(e.target.className.indexOf('toggler') != -1){
			if (drag_started == false){
				current_class = $(this).attr('class')
				if (current_class != "list_item_active"){
					$(this).attr('class', 'list_item_active')
				} else{
					$(this).attr('class', 'list_item_hover')
				}
			} else {
				drag_started = false
			}
		}
	});


	setTimeout('$(window).resize()',500); //small fix


});
