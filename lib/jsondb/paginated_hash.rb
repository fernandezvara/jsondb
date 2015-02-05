module JSONdb
  
  class PaginatedHash < Hash

    attr_accessor :per_page

    def initialize
      super
      @per_page = 20
    end

    def page(page_number)
      first_item = @per_page * (page_number - 1)
      last_item = first_item + (@per_page - 1)
      keys_to_include = keys[first_item..last_item]
      new_hash = self.select { |k, v| keys_to_include.include?(k) }
      return new_hash
    end

    def total_pages
      # pages = all keys divided by per_page, giving a integer result without mod
      pages = self.keys.count / @per_page
      # pages = pages + 1 if there are some modulo after that calculation
      # so 0 / 20 = 0 + 0 ; 1 /20 = 0 + 1 ; 60 / 20 = 3 + 0 ; 65 / 20 = 3 + 1 
      pages = pages + 1 if self.keys.count % @per_page > 0
      return pages
    end
  end

end