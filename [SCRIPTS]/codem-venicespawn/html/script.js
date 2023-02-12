

$(function() {
    window.addEventListener('message', function(event) {
               
        if (event.data.type == "open") {
            if (event.data.bw == true){
                $('.spawnlast').hide()
            } else {
                $('.spawnlast').show()
            }
            if (event.data.org){
                $('.spawnlast').css('left', '55%')
                $('.spawnlast').css('translate', 'transform(-50%)')
                $('.tporg').show()
            } else {
                $('.spawnlast').css('left', '50%')
                $('.spawnlast').css('translate', 'transform(-50%)')
                $('.tporg').hide()
            }

            if (event.data.job == 'police' || event.data.job == 'sheriff' || event.data.job == 'offpolice' || event.data.job == 'offsheriff'){
                $('.lspdpin').show()
            } else {
                $('.lspdpin').hide()
            }

            $("body").css('display', "block");
            $(".maptime").text(event.data.zaman)
            $(".gun").text(event.data.gun)
            $(".oyuncusayi").text(event.data.oyuncu)
            if(event.data.zaman > "08:00" && event.data.zaman < "19:00" ){
                $('.mapaksam').attr('src','../html/img/Map-Morning.png');
            }else{
                $('.mapaksam').attr('src','../html/img/Map.png');
            }
            
        }

        if (event.data.type == 'close') {
            $('body').fadeOut(1500);
        }
    })
});





$(document).ready(function() {
    
    $(".paleto").on("click", function(e) {
        $('.harborspawn').fadeIn(500);
    })

    $(".sandy").on("click", function(e) {
        $('.sandyspawn').fadeIn(500);
    })


    $(".pinkcage").on("click", function(e) {
        $('.pinkcagespawn').fadeIn(500);
    })

    $(".pillbox").on("click", function(e) {
        $('.pillboxspawn').fadeIn(500);
    })

 

    $(".vespuci").on("click", function(e) {
        $('.vespuccispawn').fadeIn(500);
    })
    $(".harbor").on("click", function(e) {
        $('.harborspawn2').fadeIn(500);
    })
    $(".lspdpin").on("click", function(e) {
        $('.lspdspawn').fadeIn(500);
    })
    
    $(".airport").on("click", function(e) {
        $('.airportspawn').fadeIn(500);
    })
    


    $(".harborspawn").on("click", function() {
        $.post("https://codem-venicespawn/paleto", JSON.stringify({}));
        $('body').fadeOut(1500);
    })
    $(".sandyspawn").on("click", function() {
      $.post("https://codem-venicespawn/sandyspawn", JSON.stringify({}));
        $('body').fadeOut(1500);
    })
    $(".pinkcagespawn").on("click", function() {
        $.post("https://codem-venicespawn/pinkspawn", JSON.stringify({}));
          $('body').fadeOut(1500);
    })
    $(".lspdspawn").on("click", function() {
        $.post("https://codem-venicespawn/lspdspawn", JSON.stringify({}));
          $('body').fadeOut(1500);
    })

    $(".pillboxspawn").on("click", function() {
        $.post("https://codem-venicespawn/hospital", JSON.stringify({}));
          $('body').fadeOut(1500);
    })
    $(".vespuccispawn").on("click", function() {
        $.post("https://codem-venicespawn/vespucci", JSON.stringify({}));
          $('body').fadeOut(1500);
    })
    
    $(".harborspawn2").on("click", function() {
        $.post("https://codem-venicespawn/harbor", JSON.stringify({}));
          $('body').fadeOut(1500);
    })
    $(".spawnlast").on("click", function() {
        $.post("https://codem-venicespawn/last", JSON.stringify({}));
          $('body').fadeOut(1500);
    })
    $(".airportspawn").on("click", function() {
        $.post("https://codem-venicespawn/airport", JSON.stringify({}));
          $('body').fadeOut(1500);
    })

    $(".tporg").click(function(){
        $.post("https://codem-venicespawn/tporg", JSON.stringify({}));
        // $('body').fadeOut(1500);
    })
    
    

    
      
});
$(document).ready(function(){
    $("body").click(function(event){
        if (!$(event.target).is(".harbor")) {
              
            $('.harborspawn2').fadeOut(500);
            return false;
        }
   
    });
});



$(document).ready(function(){
    $("body").click(function(event){
        if (!$(event.target).is(".paleto")) {
              
            $('.harborspawn').fadeOut(500);
            return false;
        }
   
    });
});
$(document).ready(function(){
    $("body").click(function(event){
        if (!$(event.target).is(".airport")) {
              
            $('.airportspawn').fadeOut(500);
            return false;
        }
   
    });
});

$(document).ready(function(){
    $("body").click(function(event){
      
        if (!$(event.target).is(".sandy")) {
           
            $('.sandyspawn').fadeOut(500);
            return false;
        }
    });
});



$(document).ready(function(){
    $("body").click(function(event){
      
        if (!$(event.target).is(".pinkcage")) {
       
            $('.pinkcagespawn').fadeOut(500);
            return false;
        }
    });
});

$(document).ready(function(){
    $("body").click(function(event){
      
        if (!$(event.target).is(".pillbox")) {
      
            $('.pillboxspawn').fadeOut(500);
            return false;
        }
    });
});


$(document).ready(function(){
    $("body").click(function(event){
      
        if (!$(event.target).is(".vespuci")) {
           
            $('.vespuccispawn').fadeOut(500);
            return false;
        }
    });
});



$(document).ready(function(){
    $("body").click(function(event){
      
        if (!$(event.target).is(".lspdpin")) {
           
            $('.lspdspawn').fadeOut(500);
            return false;
        }
    });
});
