$(function() {
  $(".new_contact_list, .edit_contact_list").autocompleteContactEmail();  
});

$.fn.autocompleteContactEmail = function(){
  return this.each(function(){
    var input = $("#contact_email", this);
    var dataContainer = $('.data_container',this);
    
    var loadData = function(item){
      if(item){
        var contact_id = item.value;
        $.get("/contacts/load_contact", { id:contact_id }, function(data) {
          if(data) { dataContainer.append(data); input.val(""); }
        });
      }
    }
    
    input.initAutocomplete(loadData, "/contacts/email_search");
    
    // remove links
    dataContainer.delegate('.remove_contact','click',function() {
      $(this).closest('.contact_details').remove();
      return false;
    });
  });
};


$.fn.initAutocomplete = function(callback, source) {
  return this.each(function() {
    var input = $(this);
    input.autocomplete({
      source: source,
      minLength: 2,
      select: function(event, ui) {
        if(ui.item) { 
          input.val(ui.item.label); 
          callback(ui.item);
        }
        return false;
      },
      focus: function(event, ui) { // triggered by keyboard selection
        if(ui.item) { input.val(ui.item.label); }
        return false;
      },
      change: function(event, ui) { // called after the menu closes
        if(callback) { input.val(""); }
      } 
    });
  });
}