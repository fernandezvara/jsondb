require_relative '../lib/jsondb'
require 'json'

describe "DB" do

  describe "Class" do


  	# before :each do
  	$db = Db.new(File.join(File.dirname(__FILE__), './dbtest'))
  	# end

    it "db should be an instance of class Db" do
    	expect($db).to be_an_instance_of(Db)
    end

    # TABLES

    it "db.table('table_name') must be an instance of class Table" do 
    	@table_a = $db.table('a')
    	expect(@table_a).to be_an_instance_of(Table)
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

		# FIELDS

    it "db.table('table_name').fields must be an instance of class Fields" do
    	@table_a_fields = $db.table('a').fields
    	expect(@table_a_fields).to be_an_instance_of(Fields)
    end

    # FIELD

    it "db.table('table_name').field('field_name') must be an instance of class Field" do
    	@table_a_field_a = $db.table('a').field('a')
    	expect(@table_a_field_a).to be_an_instance_of(Field)
    end

    it "db.table('table_name').field.add('field_name') and fields.count == 5" do 
    	@table_a = $db.table('a')
    	@table_a_new_field = @table_a.fields.add('b')
    	puts @table_a.fields.to_hash.keys
    	expect(@table_a.fields.names.count).to eq(5)
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
    	expect(@table_a.fields.names).to eq(['id', 'created_at', 'updated_at', 'a', 'b'])
    end

    # RECORDS

    it "must allow to add a record" do 
    	record = $db.table('a').new_record
    	record.a = 1
    	$db.table('a').insert(record)
    end

    # RESULTS
    it "must return the record on the table" do
    	puts "keys = #{$db.table('a').records.keys}"
    	expect($db.table('a').select().result.keys.count).to eq(1)
    end

		it "must return the record on the table since a = 1" do
    	puts "keys = #{$db.table('a').records.keys}"
    	expect($db.table('a').select(nil).equal('a', 1).result.keys.count).to eq(1)
    end


    it "must return zero records, since there are none with a >= 3" do
    	result = $db.table('a').select().min('a', 3).result
    	expect(result.keys.count).to eq(0)
    end

    it "must return one record, since there are one with a >= 1" do
    	puts "+++"
    	puts $db.table('a').select().min('a', 0).result.to_hash
    	expect($db.table('a').select().min('a', 0).result.keys.count).to eq(1)
    end

		it "must return zero records, since there are none with a >= 3" do
    	expect($db.table('a').select().max('a', 0).result.keys.count).to eq(0)
    end

		it "must return one records, since there are one with a <= 3" do
    	expect($db.table('a').select().max('a', 3).result.keys.count).to eq(1)
    end


  end
end