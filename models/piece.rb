require 'singleton'
require 'htmlentities'

class Piece
  attr_accessor :color, :current_pos, :board

  def initialize(board, color = :white)
    @color = color
    @board = board
    @current_pos = nil
  end

  def moves
    result = []
    movements.each do |direction|
      result.concat(get_moves(direction, current_pos))
    end
    result
  end

  def valid_moves
    moves.select { |pos| valid_move?(pos) }
  end

  def nil?
    false
  end

  def to_html
    HTMLEntities.new.encode(self.to_s, :decimal)
  end

  def inspect
    "#{self.to_s}"
  end

  protected

  MOVES = {
    up: [-1, 0], down: [1, 0], right: [0, 1], left: [0, -1],
    nw: [-1, -1], ne: [-1, 1], sw: [1, -1], se: [1, 1]
  }

  def add(pos, delta)
    x, y = pos
    dx, dy = delta
    [x + dx, y + dy]
  end

  private

  def valid_move?(pos)
    board[pos].color != color && board.valid_move?(current_pos, pos)
  end

  def valid_pos?(pos)
    board.in_bounds?(pos) && board[pos].color != self.color
  end

end
