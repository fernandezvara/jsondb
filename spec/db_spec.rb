require_relative '../lib/jsondb'

describe "class" do

	describe "Db" do

		system("rm -f #{File.dirname(__FILE__)}/dbtest/*.json")

		$folder = File.join(File.dirname(__FILE__), './dbtest')
		$db = JSONdb::Db.new($folder, true)

		it "db should be an instance of class Db" do
			expect($db).to be_an_instance_of(JSONdb::Db)
		end

		it "must fail if db folder does not exists" do 
			expect{ JSONdb::Db.new(File.join(File.dirname(__FILE__), './dbtest.error')) }.to raise_error
		end

	end

		# TABLES
	describe "Table" do

		it "db.table('table_name') must be an instance of class Table" do 
			@table_a = $db.table('a')
			expect(@table_a).to be_an_instance_of(JSONdb::Table)
		end

		it "must allow to create tables" do
			$db.table('a')
			$db.table('b')
			$db.table('c')
			expect($db.table_names).to be_an_instance_of(Array)
		end

		it "must have 3 tables" do
			$db.table('a')
			$db.table('b')
			$db.table('c')
			expect($db.table_names.count).to eq(3)
		end

		it "must have 3 tables named a, b and c" do
			$db.table('a')
			$db.table('b')
			$db.table('c')
			expect($db.table_names).to eq(['a', 'b', 'c'])
		end

		it "must create 3 tables on disk" do
			expect($db.persist).to eq(true)
		end

		it "must have 1 table, after remove 2 of them" do
			$db.table('a')
			$db.table('b')
			$db.table('c')
			$db.table_drop('b')
			$db.table_drop('c')
			expect($db.table_names.count).to eq(1)
		end

		it "must have 1 table, after remove 2 of them, named a" do
			$db.table('a')
			$db.table('b')
			$db.table('c')
			$db.table_drop('b')
			$db.table_drop('c')
			expect($db.table_names).to eq(['a'])
		end

		it "must fail trying to add a table that already exists" do 
			expect{ $db.table_add('a') }.to raise_error(RuntimeError)
		end

		it "must fail trying to add a table with disallowed characters" do 
			expect{ $db.table_add('$$$ ') }.to raise_error(RuntimeError)
		end

	end

		# FIELDS
	describe "Field" do

		it "db.table('table_name').fields must be an instance of Hash" do
			@table_a_fields = $db.table('a').fields
			expect(@table_a_fields).to be_an_instance_of(Hash)
		end

		# FIELD

		it "db.table('table_name').field('field_name') must be an instance of class Field" do
			@table_a_field_a = $db.table('a').field('a')
			expect(@table_a_field_a).to be_an_instance_of(JSONdb::Field)
		end

		it "db.table('table_name').field.add('field_name') and fields.count == 5" do 
			@table_a = $db.table('a')
			@table_a_new_field = @table_a.field('b')
			expect(@table_a.fields.keys
				.count).to eq(5)
		end

		it "db.table('table_name').field('field_name') can be nullable by default" do
			@table_a_field_a = $db.table('a').field('a')
			expect(@table_a_field_a.nullable).to eq(true)
		end

		it "db.table('table_name').field('field_name') cannot have a default value" do
			@table_a_field_a = $db.table('a').field('a')
			expect(@table_a_field_a.default).to eq(nil)
		end

		it "db.table('table_name').field('field_name') should be of type String by default" do
			@table_a_field_a = $db.table('a').field('a')
			expect(@table_a_field_a.type).to eq("String")
		end

		it "db.table('table_name').field('field_name') must allow nullable" do
			@table_a_field_a = $db.table('a').field('a')
			@table_a_field_a.nullable = true
			expect(@table_a_field_a.nullable).to eq(true)
		end

		it "db.table('table_name').field('field_name') must allow a type" do
			@table_a_field_a = $db.table('a').field('a')
			@table_a_field_a.type = "Fixnum"
			expect(@table_a_field_a.type).to eq("Fixnum")
		end

		it "db.table('table_name').field('field_name') must allow defaults" do
			@table_a_field_a = $db.table('a').field('a')
			@table_a_field_a.default = 0
			expect(@table_a_field_a.default).to eq(0)
		end

		it "db.table('table_name').field('field_name').default must NOT allow a default with wrong type" do
			@table_a_field_a = $db.table('a').field('a')
			expect { @table_a_field_a.default = "string" }.to raise_error
		end

		it "db.table('table_name').field.add('field_name')" do 
			@table_a = $db.table('a')
			expect(@table_a.fields.keys).to eq(['id', 'created_at', 'updated_at', 'a', 'b'])
		end

	end

		# RECORDS
	describe "Record" do

		it "must allow to add a record" do 
			$record1 = $db.table('a').new_record
			$record1.a = 1
			$record1.b = "text string"
			$db.table('a').insert($record1)
		end

		it "must fail if trying to insert again a record already on the table" do 
			expect{  $db.table('a').insert($record1) }.to raise_error
		end

		# RESULTS
		it "must return the record on the table" do
			expect($db.table('a').select().result.keys.count).to eq(1)
		end

		it "must return the record on the table since a = 1" do
			expect($db.table('a').select(nil).equal('a', 1).result.keys.count).to eq(1)
		end

		it "must return one record, since there are one with a >= 0" do
			result = $db.table('a').select().min('a', 0).result
			expect(result.keys.count).to eq(1)
		end

		it "must return one record, since there are one with a >= 1" do
			result = $db.table('a').select().min('a', 1).result
			expect(result.keys.count).to eq(1)
		end

		it "must return zero records, since there are none with a >= 3" do
			result = $db.table('a').select().min('a', 3).result
			expect(result.keys.count).to eq(0)
		end

		it "must return one records, since there are one with a <= 3" do
			result = $db.table('a').select().max('a', 3).result
			expect(result.keys.count).to eq(1)
		end

		it "must return zero records, since there are none with a >= 0" do
			result = $db.table('a').select().max('a', 0).result
			expect(result.keys.count).to eq(0)
		end

		it "must return zero records since we are searching for 'tests' with like" do
			result = $db.table('a').select().like('b', "tests").result
			expect(result.keys.count).to eq(0)
		end

		it "must return one record since we are searching for 'string' with like" do
			result = $db.table('a').select().like('b', "string").result
			expect(result.keys.count).to eq(1)
		end

		it "must return one record since we are searching for 'string$' with like" do
			result = $db.table('a').select().like('b', "string$").result
			expect(result.keys.count).to eq(1)
		end

	end
		# DATABASE SAVE
	describe "Db.save" do

		it "must have only one table" do 
			expect($db.table_names.count).to eq(1)
		end

		it "must have only one table referenced on db.tables" do 
			expect($db.tables.keys.count).to eq(1)
		end

		it "must save the database on disk" do 
			expect($db.persist).to eq(true)
		end
	end

	describe "Record.new" do

		it "must create 10 new records on table a" do
			(1..10000).each do |x|
				record = $db.table('a').new_record
				record.a = "string-#{x}"
				record.b = x
				$db.table('a').insert(record)
			end
			expect($db.table('a').records.keys.count).to eq(10001)
		end

		it "must save the database on disk" do 
			expect($db.persist).to eq(true)
		end

		# MUST INCORPORATE SOME KIND OF LOCK
		# it "must allow to close the database" do 
		# 	expect($db.close).to eq(true)
		# end


		$db2 = JSONdb::Db.new($folder, true)

		it "must have 11 records in table a after load" do 
			expect($db2.table('a').records.keys.count).to eq(10001)
		end

		it "add another field with default value" do 
			field_c = $db2.table('a').field('c')
			field_c.type = "String"
			field_c.default = "Default"
			expect($db2.table('a').fields.keys).to eq(['id', 'created_at', 'updated_at', 'a', 'b', 'c'])
		end

		it "must save again" do 
			expect($db2.persist).to eq(true)
		end

	end
end