require 'rack'
require_relative 'controllers/chess_controller'
require_relative 'lib/router'
require_relative 'lib/static'

router = Router.new
router.draw do
  get Regexp.new("^/chess$"), ChessController, :show
  post Regexp.new("^/chess/new$"), ChessController, :new
  get Regexp.new("^/chess/moves$"), ChessController, :moves
  post Regexp.new("^/chess/moves$"), ChessController, :move
  get Regexp.new("^/chess/move$"), ChessController, :make_move
end

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req, res)
  res.finish
end

app = Rack::Builder.new do
  use Static
  run app
end.to_app

Rack::Server.start(
  app: app,
  Port: 3000
)
