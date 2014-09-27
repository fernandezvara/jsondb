class Record

	#include Validation

	def initialize(fields, data = nil)
		@fields = fields
		if data.nil?
			@record = Hash.new
			self.id = 0
		else
			@record = data
		end
		set_defaults
	end

	# def fields
	# 	@columns.keys
	# end

	def method_missing(name, *args)
		attribute = name.to_s

		if @fields.keys.include?(attribute.sub('=', ''))
			if attribute =~ /=$/			
				@record[attribute.sub('=', '')] = args[0]
			else
				@record[attribute]
			end
		else
			raise "Column '#{attribute.sub('=', '')}' do not exists"
		end
	end

	def to_hash
		@record
	end

	private

	def set_defaults
		@fields.each do |name, values|
			if values['default'] and @record[name].nil?
				@record[name] = values['default'] 
			end
		end
	end

	# TODO : Add Validation

	def save!
		raiseif(save, false, "Error saving the record.")
	end

	def save
		return @table_class.save
	end

end