class ResultSet

	include Validation

	def initialize(table_class, array_columns = nil)
		@table = table_class
		@fields = array_columns || @table.fields.keys
		@result 		= @table.records

		@equal 			= Hash.new
		@min 				= Hash.new
		@max 				= Hash.new
		@like 			= Hash.new
	end

	def equal(column, value)
		@equal[column] = value
		return self
	end

	def min(column, value)
		@min[column] = value
	end

	def max(column, value)
		@max[column] = value
	end

	def like(column, value)
		@like[column] = value
	end

	def result
		result_equal if !@equal.nil?


		return @result
	end

	private

	def result_equal
		@equal.each do |col_name, col_value|
			this_result = Array.new
			@table.records.each do |id, record|
				# puts "---- #{id} ---- \n ----- #{record.send :col1}"
				# puts "- col_value - #{col_value} -+- - col_value - #{col_value}"
				r = record.send col_name.to_sym
				if r == col_value
					this_result << id
				end
			end
			puts "this_result_> #{this_result}"
			remove_if_key_not_in(this_result)
		end


		# @equal.each do |k, v|
		# 	this_result = Array.new
		# 	@table.records.each do |kk, vv|
		# 		puts "---- #{kk} ---- \n ----- #{vv.send :col1}"
		# 		puts "- k - #{k} -+- - v - #{v}"
		# 		r = vv.send k.to_sym
		# 		if r == v
		# 			this_result << kk
		# 		end
		# 	end
		# 	remove_if_key_not_in(this_result)
		# end




		# @equal.each do |name, value|
		# 	keys = Array.new
		# 	@table.records.each do |k, v|
		# 		if k.send "#{name}", value
		# 			 keys << k
		# 		end
		# 	end
		# 	@result.keys.each do |key|
		# 		@result.delete(key)	if keys.include?(key) == false
		# 	end
		# end
	end

	def remove_if_key_not_in(arr)
		@result.keys.each do |key|
			@result.delete(key) if arr.include?(key) == false
		end
	end

end

