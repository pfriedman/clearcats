# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  #### NESTED FORMS ####

  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)", :class => "delete delete_link icon_link")
  end

  def link_to_add_fields(name, f, association, association_prefix = nil)
    if association_prefix.nil?
      association_prefix = association.to_s.singularize
    end
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |form_builder|
      render(association_prefix + "_fields", :f => form_builder)
    end
    link_to_function(name, h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"), :class => "add add_link icon_link", :id => "add_#{association.to_s.singularize}")
  end

  #### PAGE TITLE ####

  def title(page_title, show_title = true)
    @content_for_title = page_title.to_s
    @show_title = show_title
  end

  def show_title?
    @show_title
  end
  
  def session_username
    username = "anonymous"
    if current_user 
      usr = get_current_user
      username = usr.respond_to?(:full_name) ? usr.full_name : usr.username
    end
    username
  end

  #### APPLICATION VERSION ####

  def ctsa_wording
    ctsa_txt = faculty_member? ? "Interacted with NUCATS" : "CTSA Reportable #{SYSTEM_CONFIG['current_ctsa_reporting_year']}"
    ctsa_txt
  end

  def application_version
    return "#{APP_VERSION["major"]}.#{APP_VERSION["minor"]}.#{APP_VERSION["revision"]}" rescue "x.x.x"
  end

  def javascript(*files)
    content_for(:head) { javascript_include_tag(*files) }
  end

  def stylesheet(*files)
    content_for(:head) { stylesheet_link_tag(*files) }
  end
  
  #### VIEW HELPERS ####
  
  def null_safe(val, default = "n/a")
    val.blank? ? default : h(val.to_s)
  end
  
  def has_sub_uri?
    return Rails.env == "staging"
  end
  
  def cc_prefix_path
    has_sub_uri? ? "/clearcats" : ""
  end
  
  def encode_email(email)
    encoded = []
    email.each_char { |c| encoded << "&##{c[0]};" }
    encoded.join("")
  end

end