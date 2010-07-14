// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function checkAll(name) {
  boxes = document.getElementsByName(name)
  for (i = 0; i < boxes.length; i++) {
    boxes[i].checked = true;
  }
}

function uncheckAll(name) {
  boxes = document.getElementsByName(name)
  for (i = 0; i < boxes.length; i++) {
    boxes[i].checked = false;
  }
}

// Nested forms

function remove_fields(link) {
  jQuery(link).prev("input[type=hidden]").val("1");
  jQuery(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  // jQuery(link).parent().before(content.replace(regexp, new_id));
  jQuery(link).closest("." + association).find('.nested_records').append(content.replace(regexp, new_id));
}