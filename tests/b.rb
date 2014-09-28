require 'json/pure'
require '../lib/jsondb'

db = Db.new('./dbtest')

db.table_add('aaa')
db.table_add('bbb')
puts db.table('aaa').class.to_s
puts "---"
puts db.tables
puts "---"
puts db.table_names
db.table('aaa').fields.add('col1')
db.table('aaa').field('col1').type ="String"
db.table('aaa').field('col1').default = "patatitas"

db.table('aaa').fields.add('col2')
db.table('aaa').field('col2').type ="String"
puts db.tables
puts db.table('aaa').fields.to_hash

record = db.table('aaa').new_record
#record.col1 = "1"
record.col2 = "2"
puts record.to_hash
db.table('aaa').insert(record)


(4..14).each do |x|
	record = db.table('aaa').new_record
#record.col1 = "1"
	record.col2 = x.to_s
	puts record.to_hash
	db.table('aaa').insert(record)
end


record2 = db.table('aaa').new_record
#record.col1 = "1"
record2.col2 = "3"
puts record2.to_hash
db.table('aaa').insert(record2)


record3 = db.table('aaa').new_record
record3.col1 = "col1"
record3.col2 = "4"
puts record3.to_hash
db.table('aaa').insert(record3)
puts db.table('aaa')

db.table('aaa').delete(record)
puts db.tables

puts '-'
puts record.to_hash
puts '-'
puts record2.to_hash
puts '-'
puts record3.to_hash

puts "---"
db.table('aaa').records.each do |r, val|
	puts r.class.to_s
	puts val.id
	puts val.col1
	puts val.col2
	puts "..."
end

puts "+-+-+-+-+"
query = db.table('aaa').select()
result =  db.table('aaa').select([]).equal("col1", "patatitas").like("col1", "atati").result
puts result.count
puts "*****"
puts result

db.table('bbb').fields.add("int")
db.table('bbb').field("int").type="Fixnum"

(1..14).each do |x|
	record = db.table('bbb').new_record
#record.col1 = "1"
	record.int = x
	puts record.to_hash	
	puts record.new?
	db.table('bbb').insert(record)
	puts record.to_hash
	puts record.new?
end

result2 = db.table('bbb').select([]).min('int', 3).max('int', 7).result
puts result2.count
result2.each do |id, rec|
	puts "int --> #{rec.int}"
end
