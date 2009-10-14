module TableizeHelpers
 
  
  def sortable_header(title, key = '')
    
    # If no key specified, we will not sort at all
    return content_tag(:th, title) if key.blank?
    
    # If no sort has been specified, let's assume it was for us
    # params[:sort] = key if params[:sort].blank?
    
    # If the sort is our key, then give a reverse order link
    if (params[:sort] == "#{key}")
      caption = content_tag :b, "#{title} v"
      sort =  "#{key}_rev"
      classtag = 'sorted_reverse'
 
    # If we were already sorting with our key, then give a forward order link
    elsif (params[:sort] == "#{key}_rev")
      caption = content_tag :b, "#{title} ^"
      sort = "#{key}"
      classtag = 'sorted_forward'
      
    # Give a forward order link in any other case
    else
      caption = title
      sort = "#{key}"
      classtag = 'not_sortable'
      
    end

    #link_to caption, "?sortby=#{key}&reverse=#{reverse}"
    content_tag :th, link_to (caption, "?sort=#{sort}", :class => classtag)
    
  end
  
  def livesearch_form (filter)
    form_tag '', :class => "livesearch", :method => :get, :autocomplete => "off" do
      text_field_tag 'filter', filter
      submit_tag 'Rechercher', :class => "livesubmit"
    end
  end
  
  private
  
  def sortable_header_link(caption, link, style)
    #link_to key, :overwrite_params => {facet => key} 
    "link"
  end

  
end