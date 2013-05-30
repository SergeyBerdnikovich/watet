$(document).ready(function() {
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