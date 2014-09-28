class ResultSet

	include Validation

	def initialize(records, fields_of_table, array_fields = nil)
		@fields 		= array_fields || fields_of_table
		@result 		= records

		@equal 			= Hash.new
		@min 				= Hash.new
		@max 				= Hash.new
		@like 			= Hash.new
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

	def like(field, value)
		@like[field] = value
		return self
	end

	def result
		result_equal 		if @equal.keys.count 	!= 0
		result_min 			if @min.keys.count 		!= 0
		result_max 			if @max.keys.count 		!= 0
		result_like 		if @like.keys.count 	!= 0
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
			puts "this_result_> #{this_result}"
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
				puts "@min['#{col_name}'] = #{col_value} -> @record[#{id}] = #{record.send col_name.to_sym}"
			end
			puts "this_result_> #{this_result}"
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
			puts "this_result_> #{this_result}"
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
			puts "this_result_> #{this_result}"
			remove_if_key_not_in(this_result)
		end
	end

	def remove_if_key_not_in(arr)
		@result.keys.each do |key|
			@result.delete(key) if arr.include?(key) == false
		end
	end

end
