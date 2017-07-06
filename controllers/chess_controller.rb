require 'byebug'
require_relative '../lib/controller_base'
require_relative '../models/game'

class ChessController < ControllerBase
  protect_from_forgery

  def self.game
    @game ||= Game.new
  end

  def self.board
    self.game.board
  end

  def new
    game.reset
    render json: get_board_state
  end

  def get_board_state
    pieces = board.get_pieces(:white).concat(board.get_pieces(:black))
    pieces.map do |piece|
      { id: board.coordinate_from_pos(piece.current_pos), value: piece.to_html }
    end
  end

  def game
    ChessController.game
  end

  def board
    ChessController.board
  end

  def moveable
    render json: game.moveable
  end

  def moves
    coord = params[:coord]
    piece = board[board.pos_from_coordinate(coord)]
    render json: piece.valid_moves.map { |pos| board.coordinate_from_pos(pos) }
  end

  def move
    from = board.pos_from_coordinate(params[:from])
    to = board.pos_from_coordinate(params[:to])
    game.move(from, to)
    render json: game.moveable
  end

  def index
    @board = game.board
  end
end
