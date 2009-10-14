class << ActiveRecord::Base
  # FIXME: check that no default scope is causing the other :order hashes to be ignored
  alias_method :original_find, :find

  def self.default_options
    @default_options ||= {
      :sort_default  => nil,
      }
  end

  def initialize name, instance, options = {}

    options = self.class.default_options.merge(options)
  end


  def default_order(key)
    @sort_default = key
  end
  
  # FIXME: permit a hash of fields to be passed
  def sortable_with(key, field)
    # Make sure our config hash are ready
    @sort_scopes ||= []
    @sort_keys ||= []

    # Remember this key and the scopes
    @sort_keys << key
    
    # Declare the scopes we're going to use
    sort_forward = "sorted_#{key}"
    named_scope sort_forward, :order => "#{field} ASC"
    @sort_scopes << sort_forward
    
    sort_reverse = "sorted_#{key}_rev"
    named_scope sort_reverse, :order => "#{field} DESC"
    @sort_scopes << sort_reverse
    
    #define_method "#{name}=" do |file|
    #  attachment_for(name).assign(file)
    #end
  end
  
  # FIXME: loops to add conditions on each argument
  # FIXME: if no filter_on method is called, the matching named_scope :filter will not be declared nor available to controllers
  def filter_on(*args)
    only_the_first_for_now = args.first.to_s
    named_scope :filtered, lambda { |filter| 
     expression = '%'+filter.to_s+'%'
     { :conditions => ['(? LIKE ?)', only_the_first_for_now, expression] }
    }
  end
  
  # FIXME: default to the first ot any chosen filter
  # FIXME: protect against inexistant sortby's
  def sorted(sortby, *args)
    options = args.is_a?(Hash) ? args.pop : {}
    logger.info "sort_keys:"+@sort_keys.to_yaml
    #logger.info "sort_scopes:"+@sort_scopes.to_yaml
    logger.info "sortby:"+sortby.to_yaml
    logger.info "options:"+options.to_yaml
    
    # Fallback is default scope if sortby is empty
    sortby = @sort_default if sortby.nil?
    
    # The wanted scope should be name that way
    scope = "sorted_#{sortby}"
    
    # Let's try and call the right scope
    send(scope, options) if respond_to?(scope)
  end
  
  def page(page)
    paginate :page => page
  end
  
  # def find_ordered(*args)
  #   key = args.first.to_s
  #   
  #   # Make sure our config is not empty
  #   @sort_options ||= {}
  #   
  #   # Get the current order and make sure it is not empty
  #   order_field = @sort_options[key] ||= {}
  #   
  #   # Do the real find now
  #   new_options = options.merge(@sort_options)
  #   #original_find(new_options)
  # end
  
end