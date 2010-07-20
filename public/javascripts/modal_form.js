function edit_modal_form(link) {
  var link = jQuery(link);
  var parent_div_of_item = link.parent();
  var url = link.attr('href');
  new jQuery.get(url, function(data) {
      // displays modal window - note css centering
      jQuery.blockUI( { message: jQuery("#modal_window").html(data), 
        css: { width:"500px", margin:"-200px 0 0 -200px", left:"50%", padding: "4px 4px 4px 15px", textAlign: "left" } } );
  });
  return false;
}

// close modal window
jQuery("#modal_window .close").live('click', function() {
  jQuery.unblockUI();
});

var parent_div_of_form;
jQuery('#modal_edit_form').live('submit', function() {
  
  // add javascript request type
  jQuery.ajaxSetup({
    'beforeSend': function(xhr) { xhr.setRequestHeader("Accept", "text/javascript") }
  });
  
  jQuery.unblockUI();
  return false;
});
