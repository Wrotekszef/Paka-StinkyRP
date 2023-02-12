function searchFunction() {
	var input, filter, ul, li, a, i, txtValue;
	input = document.getElementById("searchCar");
	filter = input.value.toUpperCase();
	ul = document.getElementById("cars");
	li = ul.getElementsByTagName("a");
	for (i = 0; i < li.length; i++) {
		txtValue = li[i].dataset.plate;
		if (txtValue.toUpperCase().indexOf(filter) > -1) {
			$(li[i]).css('display', 'flex').hide().fadeIn('fast')
		} else {
			$(li[i]).fadeOut('fast')
		}
	}
}

$(document).ready(function(){
  window.addEventListener('message', function(event){
    var item = event.data;
    if(item.openList == true) {
      $(".headers").css("display", "none");
      $(".list-container").css("display", "block").data('list-type', item.listType).hide().fadeIn('fast');
	    $("#" + item.listType).css("display", "block");
      $('#impoundall').hide()
      if(item.listType == "impound") {
        $('#odholuj').css('visibility', 'visible');
        $('#impoundall').show()
      }
    } else if(item.openList == false) {
      $(".list-container").fadeOut('fast').removeData('list-type');
      $('#odholuj').css('visibility', 'hidden');
    } else if(item.clear == true) {
	  $(".button").remove();
    } else if(item.add == true) {
      $("#cars").append(`<a class="button" data-plate="${item.plate}">
        <div class="button-icon">
        <i class="fa-solid fa-car"></i>
        </div>
        <div class="button-titles">
          <div>
            <font color="white"> 
              <b>Model:</b> 
            </font> 
            ${item.name}
          </div>
          <div>
            <font color="white">
              <b>Tablice:</b>
            </font> 
            ${item.plate}
          </div>
        </div>
        <div class="texts">
          <p title="Silnik"><div class="texts-icon"><i class="fa-solid fa-car"></i></div>${item.engine}%</p>
          <p title="Karoseria"><div class="texts-icon"><i class="fa-solid fa-heart"></i></div>${item.body}%</p>
        </div>
        </a>`);
    }
  });

  // On 'Esc' call close method
  document.onkeyup = function (data) {
    if (data.which == 27) {
      $.post('http://exile_garages/close', JSON.stringify({}));
    }
  };
  // Handle Button Presses
  $("#cars").on('click', '.button', function(e) {
    e.preventDefault();
    $.post('http://exile_garages/pull',  JSON.stringify({ action: $(".list-container").data('list-type'), plate: $(this).data('plate') }));
  });
  
  $('#zamknij').click(function() {
    $.post('http://exile_garages/close', JSON.stringify({}));
  })

  $('#zamknij').click(function() {
    $.post('http://exile_garages/close', JSON.stringify({}));
  })


  $('#impoundall').click(function() {
    $.post('http://exile_garages/impoundall', JSON.stringify({}));
  })
});