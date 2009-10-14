require File.join(File.dirname(__FILE__), "lib", "tableize")
require File.join(File.dirname(__FILE__), "lib", "tableize_helpers")

ActionView::Base.send :include, TableizeHelpers
