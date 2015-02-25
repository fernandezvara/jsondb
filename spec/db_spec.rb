require_relative '../lib/jsondb'
require 'spec_helper'

describe "class" do

	describe "Db" do

		system("rm -rf #{File.dirname(__FILE__)}/dbtest")

		$folder = File.expand_path(File.join(File.dirname(__FILE__), './dbtest'))

		$db = JSONdb::Db.new($folder, true, true)

		JSONdb.settings.verbose = false
		JSONdb.settings.log_enabled = true
		JSONdb.settings.log_level = :debug
		JSONdb.settings.log_file = "db1.log"

		it "db should be an instance of class Db" do
			expect($db).to be_an_instance_of(JSONdb::Db)
		end

	end

	describe "Tables" do

		it "must load up a database on a folder" do
			expect(JSONdb.tables).to be_an_instance_of(JSONdb::PaginatedHash)
		end

		it "must create a table with tables.create(name)" do
			expect($db.create_table('table_a')).to eq(true)
		end

		it "must return a table object when instancied as db.table(name)" do
			expect($db.table('table_a')).to be_an_instance_of(JSONdb::Table)
		end

		it "must return nil if the table not exists" do
			expect($db.table('table_non_existent')).to eq(nil)
		end

		it "must return true if the table exists" do
			expect($db.table_exists?('table_a')).to eq(true)
		end

		it "must return false if the table not exists" do
			expect($db.table_exists?('table_non_existent')).to eq(false)
		end

		it "must return an array ['table_a']" do
			expect($db.table_names).to eq(['table_a'])
		end

		it "must allow create more tables" do
			expect($db.create_table('table_b')).to eq(true)
		end

		it "must return true if the table exists" do
			expect($db.table_exists?('table_b')).to eq(true)
		end

		it "must fail if table already exists" do
			expect{$db.create_table('table_b')}.to raise_error
		end

		it "must have 0 records in table_a" do
			expect($db.table('table_a').count).to eq(0)
		end

		it "must allow to create more tables" do
			$db.create_table('table_c')
			$db.create_table('table_d')
			$db.create_table('table_e')
			$db.create_table('table_f')
			$db.create_table('table_g')
			expect($db.table_names).to be_an_instance_of(Array)
		end

		it "must have 7 tables" do
			expect($db.table_count).to eq(7)
		end

		it "must allow to delete a table" do
			expect($db.drop_table('table_g')).to eq(true)
		end

	end

	describe "Fields" do

		it "must have 3 fields on table_a" do
			expect($db.table('table_a').fields.count).to eq(3)
		end

		it "must have 3 fields named id, created_at and updated_at on table_a" do
			expect($db.table('table_a').fields).to eq(['id', 'created_at', 'updated_at'])
		end

		it "must allow to add a field named test1 on table_a and it must return an instance of Field" do
			expect($db.table('table_a').create_field('test1')).to be_an_instance_of(JSONdb::Field)
		end

		it "must return an Array of field names" do
			expect($db.table('table_a').fields).to be_an_instance_of(Array)
		end

		it "must have 4 fields named id, created_at, updated_at and test1 on table_a" do
			expect($db.table('table_a').fields).to eq(['id', 'created_at', 'updated_at', 'test1'])
		end

		it "must allow to make test1 on table_a of type Integer, returning true" do
			expect($db.table('table_a').field('test1').type = "Integer").to eq("Integer")
		end

		it "must allow to make test1 on table_a of type Integer" do
			expect($db.table('table_a').field('test1').type).to eq("Integer")
		end

		it "must raise errors since it's configured in that way" do
			expect{ $db.table('table_a').field('test1').type="Integer1" }.to raise_error
		end

		it "must allow to add a field named def on table_a and it must return an instance of Field" do
			expect($db.table('table_a').create_field('def')).to be_an_instance_of(JSONdb::Field)
		end

		it "must allow to make def on table_a of type Integer, returning Integer" do
			expect($db.table('table_a').field('def').type = "Integer").to eq("Integer")
		end

		it "must allow to make def on table_a not nullable, returning false" do
			expect($db.table('table_a').field('def').nullable = false).to eq(false)
		end

		it "must allow to set default value for def on table_a to 37, returning that value" do
			expect($db.table('table_a').field('def').default = 37).to eq(37)
		end

		# it "must not raise errors if configured in that way" do
		# 	expect(JSONdb.settings.raise_errors = false).to eq(false)
		# end
	end

	describe "Records" do

		it "must allow to create a record on table_a" do
			expect($db.table('table_a').new_record).to be_an_instance_of(JSONdb::Record)
		end

		it "must allow to create and insert a record on table_a" do
			$r = $db.table('table_a').new_record
			expect($db.table('table_a').insert_record($r)).to be_an_instance_of(JSONdb::Record)
		end

		it "must return fields names in an Array" do
			expect($r.fields).to be_an_instance_of(Array)
		end

		it "must return fields names" do
			expect($r.fields).to eq(['id', 'created_at', 'updated_at', 'test1', 'def'])
		end

		it "must return 4 fields" do
			expect($r.fields.count).to eq(5)
		end

		it "must allow to set fields content on the record" do
			$r.test1 = 12345
			expect($db.table('table_a').update_record($r)).to be_an_instance_of(JSONdb::Record)
		end

		it "must allow to delete the record" do
			expect($db.table('table_a').drop_record($r)).to eq(true)
		end

		it "must allow to create a record on table_a" do
			expect($db.table('table_a').count).to eq(0)
		end

		it "must insert 1.000 records using db.insert_into" do
			(1..1000).each do |x|
				r = $db.table('table_a').new_record
				r.test1 = 1000 - x
				$db.insert_into('table_a', r)
			end
			expect($db.table('table_a').count).to eq(1000)
		end

		it "must insert 1.000 records using db.insert" do
			(1..1000).each do |x|
				r = $db.table('table_a').new_record
				r.test1 = 1000 - x
				$db.insert('table_a', r)
			end
			expect($db.table('table_a').count).to eq(2000)
		end

		it "must insert 1.0000 records using db.table(table_name).insert_record(record)" do
			(1..1000).each do |x|
				r = $db.table('table_a').new_record
				r.test1 = 1000 - x
				$db.table('table_a').insert_record(r)
			end
			expect($db.table('table_a').count).to eq(3000)
		end

		it "must delete a record using db.delete(table_name, record)" do
			r = $db.table("table_a").record(2300)
			expect($db.delete("table_a", r)).to eq(true)
		end

		it "must delete a record using db.delete(table_name, record)" do
			r = $db.table("table_a").record(2301)
			expect($db.table("table_a").drop_record(r)).to eq(true)
		end

		it "must be 2.998 records on table_a after delete those 2" do
			expect($db.table('table_a').count).to eq(2998)
		end

		it "must insert 110 records using db.insert_into" do
			$db.table("table_d").create_field("test_d")
			$db.table("table_d").field("test_d").type="Integer"
			$db.table("table_d").field("test_d").nullable=true
			(1..110).each do |x|
				r = $db.table('table_d').new_record
				r.test_d = 1000 - x
				$db.insert_into('table_d', r)
			end
			expect($db.table('table_d').count).to eq(110)
		end

	end

	describe "Db" do

		it "must save the db on disk" do
			expect($db.persist).to eq(true)
		end
	end

	describe "Fields" do

		it "db.table('table_b').create_field('test_floats') must be created" do
			expect($db.table("table_b").create_field("test_floats")).to be_an_instance_of(JSONdb::Field)
		end

		it "db.table('table_b').create_field('test_floats') must be created" do
			expect($db.table("table_b").field("test_floats").type = "Float").to eq("Float")
		end

		it "must allow to add a record to table_b" do
			r = $db.table('table_b').new_record
			r.test_floats = 14.0
			expect($db.insert_into('table_b', r)).to eq(true)
		end

		it "must allow to add a record to table_b and convert a Fixnum into Float for a float type field" do
			r = $db.table('table_b').new_record
			r.test_floats = 15
			expect($db.insert_into('table_b', r)).to eq(true)
		end

		it "must have 2 records on table_b" do
			expect($db.table('table_b').record_count).to eq(2)
		end

		it "must create another field on table_c" do
			expect($db.table('table_c').create_field('tests_strings')).to be_an_instance_of(JSONdb::Field)
		end

		it "must have 5 records on table_c after its creation" do
			r1 = $db.table('table_c').new_record
			r1.tests_strings = "aaaaa"
			r2 = $db.table('table_c').new_record
			r2.tests_strings = "eeeee"
			r3 = $db.table('table_c').new_record
			r3.tests_strings = "aeaea"
			r4 = $db.table('table_c').new_record
			r4.tests_strings = "aeaea"
			r5 = $db.table('table_c').new_record
			r5.tests_strings = "aeiou"
			$db.insert_into('table_c', r1)
			$db.insert_into('table_c', r2)
			$db.insert_into('table_c', r3)
			$db.insert_into('table_c', r4)
			$db.insert_into('table_c', r5)
			expect($db.table('table_c').record_count).to eq(5)
		end

	end

	describe "ResultSet" do

		it "must allow to select one record" do
			expect($db.select_from('table_b').equal('id', 1).result.count).to eq(1)
		end

		it "must return 0 records if not meet the query" do
			expect($db.select_from('table_b').equal('id', 10000).result.count).to eq(0)
		end

		it "must allow to select one record with correct value class" do
			expect($db.select_from('table_b').equal('id', 1).result[1].test_floats).to be_an_instance_of(Float)
		end

		it "must allow to select one record with correct values" do
			expect($db.select_from('table_b').equal('id', 1).result[1].test_floats).to eq(14.0)
		end

		it "must allow to select records on intervals with correct values" do
			expect($db.select_from('table_a').interval('id', 10, 20).result.count).to eq(11)
		end

		it "must allow to select records with max returning  correct values" do
			expect($db.select_from('table_a').max('id', 10).result.count).to eq(9)
		end

		it "must allow to select records with max returning  correct values" do
			expect($db.select_from('table_a').min('id', 10).result.count).to eq(2990)
		end

		it "must allow to select records chaining min and max returning correct values" do
			expect($db.select_from('table_a').min('id', 10).max('id', 20).result.count).to eq(11)
		end

		it "must allow to select records using like" do
			expect($db.select_from('table_c').like('tests_strings', 'ea').result.keys).to eq([3,4])
		end

		it "must allow to select records using like" do
			expect($db.select_from('table_c').like('tests_strings', 'ea').equal('id', 3).result.keys).to eq([3])
		end

		it "must allow to delete a record by id" do
			result = $db.select_from('table_c').like('tests_strings', 'ea').equal('id', 3).result
			expect($db.delete_by_id('table_c', result.keys[0])).to eq(true)
		end

		it "must allow to delete a record by id" do
			expect($db.select_from('table_c').result.keys).to eq([1, 2, 4, 5])
		end

		it "must allow to delete a record by id" do
			result = $db.select_from('table_c').like('tests_strings', 'ea').result
			result.each do |id, record|
				record.tests_strings = "uuuuu"
			end
			expect($db.select_from('table_c').like('tests_strings', 'ea').result.keys).to eq([])
		end

	end

	describe "PaginatedHash" do

		it "must have a total_pages definition" do
			expect($db.tables.total_pages).to eq(1)
		end

		it "must return 6 items for tables on page 1" do
			expect($db.tables.page(1).keys.count).to eq(6)
		end

		it "must return 6 tables (table_a..table_f) for tables on page 1" do
			expect($db.tables.page(1).keys).to eq(['table_a', 'table_b', 'table_c', 'table_d', 'table_e', 'table_f'])
		end

		it "$db.tables must be a JSONdb::PaginatedHash" do
			expect($db.tables).to be_an_instance_of(JSONdb::PaginatedHash)
		end

		it "JSONdb.records[__table_name__] must be a JSONdb::PaginatedHash" do
			expect(JSONdb.records['table_c']).to be_an_instance_of(JSONdb::PaginatedHash)
		end

		it "$db.table().records must be a JSONdb::PaginatedHash" do
			expect($db.table('table_c').records).to be_an_instance_of(JSONdb::PaginatedHash)
		end

		it "page 1 of $db.table('table_a').records must have 20 items" do
			expect($db.table('table_a').records.page(1).keys.count).to eq(20)
		end

		it "$db.table('table_a').records must have 20 pages" do
			expect($db.table('table_a').records.total_pages).to eq(150)
		end

		it "$db.table('table_b').records must have 20 pages" do
			expect($db.table('table_b').records.total_pages).to eq(1)
		end


	end

end
