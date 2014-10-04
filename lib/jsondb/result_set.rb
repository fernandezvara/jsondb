module JSONdb

  class ResultSet

    def initialize(table_name)
      @table_name = table_name

      @result     = Hash.new

      # TODO: It must not be here, jsut a workaround atm
      JSONdb.records[@table_name].each do |k, v|
        @result[k] = v.dup
      end

      @equal      = Hash.new
      @min        = Hash.new
      @max        = Hash.new
      @like       = Hash.new
    end

    def equal(field, value)
      @equal[field] = value
      return self
    end

    def min(field, value)
      @min[field] = value
      return self
    end

    def max(field, value)
      @max[field] = value
      return self
    end

    def interval(field, min, max)
      @min[field] = min
      @max[field] = max
      return self
    end

    def like(field, value)
      @like[field] = value
      return self
    end

    # TODO: For next version
    # TODO: Change it, it must compare all records at the same time
    # all_records.each do |r|
    #   eq.each do |k,v|
    #     ok if match
    #        ok_array << ok
    #  end
    # if ok_Array.all == true
    # then it match
    def result
      eq    = result_equal    if @equal.keys.count  != 0
      min   = result_min      if @min.keys.count    != 0
      max   = result_max      if @max.keys.count    != 0
      like  = result_like     if @like.keys.count   != 0
      return @result
    end

    private

    def result_equal
      @equal.each do |col_name, col_value|
        this_result = Array.new
        @result.each do |id, record|
          r = record.send col_name.to_sym
          if r == col_value
            this_result << id
          end
        end
        remove_if_key_not_in(this_result)
      end
    end

    def result_min
      @min.each do |col_name, col_value|
        this_result = Array.new
        @result.each do |id, record|
          r = record.send col_name.to_sym
          if r >= col_value
            this_result << id
          end
        end
        remove_if_key_not_in(this_result)
      end
    end

    def result_max
      @max.each do |col_name, col_value|
        this_result = Array.new
        @result.each do |id, record|
          r = record.send col_name.to_sym
          if r <= col_value
            this_result << id
          end
        end
        remove_if_key_not_in(this_result)
      end
    end

    def result_like
      @like.each do |col_name, col_value|
        this_result = Array.new
        @result.each do |id, record|
          r = record.send col_name.to_sym
          if r =~ Regexp.new(col_value)
            this_result << id
          end
        end
        remove_if_key_not_in(this_result)
      end
    end

    def remove_if_key_not_in(arr)
      @result.keys.each do |key|
        @result.delete(key) if arr.include?(key) == false
      end
    end

  end

end