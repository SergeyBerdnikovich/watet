$(document).ready(function() {



	$('.li').mouseenter(function(){

		current_class = $(this).attr('class')
		may_change = true
			if (current_class == "list_item_active"){
			may_change = false
		}

		if (current_class == "list_item_edit"){
			may_change = false
		}

		if (may_change == true){
			$(this).attr('class', 'list_item_hover')
		}


	})

	$('.li').mouseleave(function(){
		current_class = $(this).attr('class')
		may_change = true
		if (current_class == "list_item_active"){
			may_change = false
		}

		if (current_class == "list_item_edit"){
			may_change = false
		}

		if (may_change == true){
			$(this).attr('class', 'list_item')
		}


	})



	$('.li').click(function(e) {	
		if(e.target.className.indexOf('toggler') != -1){
			current_class = $(this).attr('class')
		if (current_class != "list_item_active"){
			$(this).attr('class', 'list_item_active')
		} else{
			$(this).attr('class', 'list_item_hover')
		}
		}
	});


	$( "#sortable" ).sortable({
		stop: function( event, ui ) {
			var sortedIDs = $( "#sortable" ).sortable( "toArray" );

			var request = $.ajax({
				type: "GET",
				url: "http://watet.dvporg.com/list_items/sort",
				data: { order: sortedIDs },
				dataType: "HTML"
			})

			request.done(function(msg) {
				//		alert( "Request complete: " + msg );
			});

			request.fail(function(jqXHR, textStatus,errorThrown ) {
				//		alert( "Request failed: " + textStatus + " " + jqXHR + " " + errorThrown  );
			});

		}

	});

});