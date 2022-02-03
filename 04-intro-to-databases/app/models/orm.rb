class PatientORM
    attr_accessor :name, :age, :owner, :number, :id
    attr_reader :species

    # Will this create a new record in DB or not?
    def initialize args
        # ACTIVITY 1 => Use mass assignment to allow attributes to be 
        # passed into initialize() as key / value pairs
        args.each do |key,value|
            # makes sure that the key youre pulling out exists for what youre trying to create
            if self.respond_to? "#{key.to_s}="
                self.send "#{key.to_s}=", value
            end
        end

        # PatientORM.new(
        #     name: "Grace", 
        #     age: 1, 
        #     owner: "Sally",
        #     number: 2,
        #     species: "Cat"    
        # )

        # method hints => ".each", ".respond_to?", ".send"
        self
    end

    def save
        # For strings that will take up multiple lines in your text editor, 
        # use a heredoc (https://blog.saeloun.com/2020/04/08/heredoc-in-ruby-and-rails.html) 
        # to create a string that runs on to multiple lines.

        sql = <<-SQL
        INSERT INTO patients (species, name, age, owner, number) VALUES (?,?,?,?,?);
        SQL
        
        # ACTIVITY 1 => Use "execute" and "last_insert_row_id" to add new
        # PatientORM class instances to DB with appropriate IDs
        DB.execute(sql, self.species, self.name, self.age, self.owner, self.number)
        @id = DB.last_insert_row_id

        # NOTE => Remember to return "self" instance
        self
    end

    def self.create(args)
        # ACTIVITY 2 => Use "new" and "save" to simultaneously 
        # create / add new PatientORM class instances to DB
        patient = PatientORM.new(args)
        patient.save
        # NOTE => Remember to return "patient" instance
        patient
    end

    def self.all 
        # ACTIVITY 2 => Use "DB.execute()" + SQL to retrieve all 
        # patients from table.
        sql = <<-SQL
            SELECT * FROM PATIENTS;
        SQL
        resources = DB.execute(sql)

        # HINT => Use ".map" and "self.new" to create an array of "mapped_resources"
        mapped_resources = resources.each do |object|
            PatientORM.new object
        end
        # NOTE => Remember to return "mapped_resources" as an iterable list
        # of patients
        mapped_resources
    end

    def self.create_table 
        
        # For strings that will take up multiple lines in your text editor, 
        # use a heredoc (https://blog.saeloun.com/2020/04/08/heredoc-in-ruby-and-rails.html) to create a string that 
        # runs on to multiple lines.
        sql = <<-SQL
        CREATE TABLE IF NOT EXISTS patients (
            id INTEGER PRIMARY KEY,
            clinic_id INTEGER,
            species TEXT,
            name TEXT,
            age INTEGER,
            owner TEXT,
            number TEXT
        );
        SQL
        DB.execute(sql)
    end 
end 

# test_object = PatientORM.new( :name => "Grace", :age => 1, :owner => "Sally", :number => 2, :species => "Cat" )
# puts test_object

