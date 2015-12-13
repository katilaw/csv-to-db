#Y OUR CODE GOES HERE
require "pg"
require "csv"

def db_connection
  begin
    connection = PG.connect(dbname: "ingredients")
    yield(connection)
  ensure
    connection.close
  end
end

CSV.foreach("ingredients.csv") do |row|
  db_connection do |conn|
    conn.exec_params("INSERT INTO ingredients (number, ingredient) VALUES ($1,$2)", [row[0], row[1]])
  end
end

db_connection do |conn|
  results = conn.exec('SELECT * FROM ingredients;')
  results.each do |list|
    puts "#{list['number']}. #{list['ingredient']}"
  end
end
