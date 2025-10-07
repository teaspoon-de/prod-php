var menuActive = false;
$(".menuIcon").click(function() {
    menuActive = !menuActive;
    console.log(menuActive);
    
    $(".menuIcon").each(function() {
        if ($(this).hasClass("null"))
            $(this).removeClass("null");
        else $(this).addClass("null");
    });
    if (menuActive) $("#menu").css("display", "flex");
    else $("#menu").css("display", "none");
});