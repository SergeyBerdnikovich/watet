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



$(window).resize(function(){

if ($('.new_item_container').position() != undefined){
submit = $('.new_li_submit').width();
container = $('.new_item_container').width();
container_left = $('.new_item_container').position().left;

width = container - submit - 10


$('.new_item').width(width)
// $('.new_li_submit').css('left',width + container_left + 9)

}

})




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
			current_class = $(this).attr('class')
		if (current_class != "list_item_active"){
			$(this).attr('class', 'list_item_active')
		} else{
			$(this).attr('class', 'list_item_hover')
		}
		}
	});


setTimeout('$(window).resize()',500); //small fix 


});