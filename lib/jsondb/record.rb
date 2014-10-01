module JSONdb
	class Record

		include Validation

		def initialize(fields, data = nil)
			@fields = fields
			if data.nil?
				@record = Hash.new
				@new = true
				self.id = 0
			else
				@record = data
				@new = false
			end
			@persisted = false
			set_defaults # we need to apply again the defaults
		end

		def method_missing(name, *args)
			attribute = name.to_s

			if @fields.to_hash.keys.include?(attribute.sub('=', ''))
				if attribute =~ /=$/
					if @record[attribute] != args[0]
						@record[attribute.sub('=', '')] = args[0]
						@persisted = true
					end
				else
					@record[attribute]
				end
			else
				raise "Column '#{attribute.sub('=', '')}' do not exists"
			end
		end

		def save_with_id(id)
			self.created_at = Time.now.to_i
			self.updated_at = Time.now.to_i
			self.id = id
			@new = false
			@persisted = false
		end

		def update
			self.updated_at = Time.now.to_i
			@new = false
			@persisted = false
		end 

		def to_hash
			@record
		end

		def new?
			@new
		end

		def persisted?
			@persisted
		end

		def created_at
			Time.at(@record['created_at'])
		end

		def persisted_at
			Time.at(@record['updated_at'])
		end

		private

		def set_defaults
			@fields.each do |name, values|
				if values.default and @record[name].nil?
					@record[name] = values.default
				end
			end
		end

		# # TODO : Add Validation

		# def save!
		# 	raiseif(save, false, "Error saving the record.")
		# end

		# def save
		# 	return @table_class.save
		# end

	end
end