require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-sql
      SELECT * FROM students
    sql
    students = DB[:conn].execute(sql)
    students.map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-sql
      SELECT * FROM students WHERE name = ?
    sql
    students = DB[:conn].execute(sql, name)
    students.map do |row|
      self.new_from_db(row)
    end.first

  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.count_all_students_in_grade_9
    sql = <<-sql
      SELECT * FROM students WHERE grade = 9
    sql
    grade9 = DB[:conn].execute(sql)
    grade9.map do |row|
      self.new_from_db(row)
    end
  end

  def self.students_below_12th_grade
    sql = <<-sql
      SELECT * FROM students WHERE grade < 12
    sql
    grade9_to_11 = DB[:conn].execute(sql)
    grade9_to_11.map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_x_students_in_grade_10(num)
    sql = <<-sql
      SELECT * FROM students WHERE grade = 10 LIMIT #{num}
    sql
    selection = DB[:conn].execute(sql)
    selection.map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_student_in_grade_10
    sql = <<-sql
      SELECT * FROM students WHERE grade = 10 LIMIT 1
    sql
    selection = DB[:conn].execute(sql).flatten
    student = self.new_from_db(selection)
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-sql
      SELECT * FROM students WHERE grade = #{grade}
    sql
    students = DB[:conn].execute(sql)
    students.map do |row|
      self.new_from_db(row)
    end
  end
end

