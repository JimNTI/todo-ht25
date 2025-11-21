require 'sinatra'
require 'sqlite3'
require 'slim'
require 'sinatra/reloader'




post('/todo/:id') do
    todo_id = params[todo_id]
    "You request ##{todo_id}"
end


get('/todoslist') do

  query = params[:q]
  p "Yo skrev #{query}"

  #gör koppling till db
  db = SQLite3::Database.new("db/todos.db")

  #[{},{},{}] önskar vi oss istället för [[], [],[]]
  db.results_as_hash = true

  #hämta allting från db
  @datatodo = db.execute("SELECT * FROM todoslist")    

  p @datatodo

  if query && !query.empty?
    @datatodo = db.execute("SELECT * FROM todoslist WHERE name LIKE ?","%#{query}%")
  else
    @datatodo = db.execute("SELECT * FROM todoslist")
  end

  #visa med slim
  slim(:"todoslist/index")



end





