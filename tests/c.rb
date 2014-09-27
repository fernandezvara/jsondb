class Q

	attr_reader :a

	def initialize
		@a = 1
	end

	def sum
		@a = @a + 1
	end

end

class W

	attr_reader :q

	def initialize
		@q = Q.new
	end
end

w = W.new
puts w.q.class.to_s
puts w.q.a
w.q.sum
puts w.q.a
puts w.q.ancestors


