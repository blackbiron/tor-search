# encoding: utf-8
# helper for search controller
module SearchHelper
  def include_more_links(search_term)
    @include_more ||= !search_term.include?('site:')
  end
end
