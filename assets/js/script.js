window.onload = function() {  
    var grid = document.querySelector('.grid');
    
    var msnry = new Masonry( grid, {
      itemSelector: '.grid-item',
      columnWidth: '.grid-sizer',
      percentPosition: true
    });
    
    imagesLoaded( grid ).on( 'progress', function() {
      msnry.layout();
    });
};

window.onscroll = function() {
    var navbar = document.getElementById("main-navbar");
    var igr = document.getElementById("nav-igr");
    var header = document.getElementById("main-header");
    var pos = 0;
    
    if (document.body.scrollTop > header.scrollHeight || document.documentElement.scrollTop > header.scrollHeight ) {
            igr.classList.remove("fade-out");
            setTimeout(function(){ igr.style.display = "block"; }, 2);
            setTimeout(function(){ igr.classList.add("rotate-in-center"); }, 1);
    } else { igr.classList.add("fade-out"); } 
};
