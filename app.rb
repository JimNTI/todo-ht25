require 'sinatra'
require 'sqlite3'
require 'slim'
require 'sinatra/reloader'



get('/todos') do
  query = params[:q]

  db = SQLite3::Database.new("db/todos.db")
  db.results_as_hash = true

  if query && !query.empty?
    @todos = db.execute("SELECT * FROM todos WHERE name LIKE ?", "%#{query}%")
  else
    @todos = db.execute("SELECT * FROM todos")
  end

  slim(:"todos/index")
end


post('/todo') do
  new_todo = params[:name]
  new_description = params[:description]
  state = false

  db = SQLite3::Database.new("db/todos.db")
  db.execute("INSERT INTO todos (name, description, state) VALUES (?, ?, ?)", [new_todo, new_description, state])

  redirect('/todos')
end

get('/todos/:id/edit') do
  db = SQLite3::Database.new("db/todos.db")
  db.results_as_hash = true
  id = params[:id].to_i
  @unique_todos = db.execute("SELECT * FROM todos WHERE id = ?", id).first

  #show formula for updating
  slim(:"todos/edit")
end

post('/todos/:id/update') do

  id = params[:id].to_i
  name = params[:name]
  description = params[:description]
  state = params[:state]
  

  db = SQLite3::Database.new("db/todos.db")
  db.execute("UPDATE todos SET name=?, description=?, state=? WHERE id=?",[name,description,state, id])
  redirect('/todos')
end

post('/todos/:id/delete') do
  id = params[:id].to_i

  db = SQLite3::Database.new("db/todos.db")
  db.execute("DELETE FROM todos WHERE id = ?", id)

  redirect('/todos')
end

post '/todos/:id/state' do
  id = params[:id].to_i


  db = SQLite3::Database.new("db/todos.db")
  db.results_as_hash = true

  current = db.execute("SELECT state FROM todos WHERE id=?", [id]).first["state"]
  new_state = current == 0 ? 1 : 0

  db.execute("UPDATE todos SET state=? WHERE id=?", [new_state, id])

  redirect('/todos')
end

post ''


get('/todos/new') do
  slim(:"todos/new")
end







