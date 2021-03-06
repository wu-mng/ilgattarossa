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
    var menu = document.getElementById("menu-button");
    var igr = document.getElementById("nav-igr");
    var header = document.getElementById("main-header");
    
    navbar.classList.remove("fade-out-long");
    navbar.onmouseover = function(){ navbar.classList.remove("fade-out-long"); };
    menu.ontouchstart = function(){ navbar.classList.remove("fade-out-long"); };
    
    if (document.body.scrollTop > header.scrollHeight || document.documentElement.scrollTop > header.scrollHeight ) {
            navbar.classList.add("fade-out-long");
            igr.classList.remove("fade-out");
            setTimeout(function(){ igr.style.display = "block"; }, 2);
            setTimeout(function(){ igr.classList.add("rotate-in-center"); }, 1);
    } else { 
            navbar.classList.remove("fade-out-long");
            igr.classList.add("fade-out"); 
        } 
};
