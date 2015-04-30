require_relative 'chess_pieces.rb'
require 'colorize.rb'

class Board


  attr_accessor :grid, :highlight, :to_move

  COLORS = [:white, :black]
  UNICODE_DISPLAY = {
    Pawn   => '♟',
    Knight => '♞',
    Bishop => '♝',
    Rook   => '♜',
    Queen  => '♛',
    King   => '♚'
  }
  BACKGROUND_COLOR = {
    1 => :light_blue,
    0 => :light_red,
    :highlight => :yellow
  }


  def initialize
    @grid = Array.new(8) { Array.new(8) {nil} }
    fill_board_white
    fill_board_black
    @highlight = [0,0]
    @to_move = :white
  end

  def fill_board_white
    (0...8).each {|col| @grid[col][1] = Pawn.new(:white, [col, 1], self)}
    [0,7].each   {|col| @grid[col][0] = Rook.new(:white, [col, 0], self)}
    [1,6].each   {|col| @grid[col][0] = Knight.new(:white, [col, 0], self)}
    [2,5].each   {|col| @grid[col][0] = Bishop.new(:white, [col, 0], self)}
    @grid[3][0] = Queen.new(:white, [3, 0], self)
    @grid[4][0] = King.new(:white, [4, 0], self)
  end

  def fill_board_black
    (0...8).each {|col| @grid[col][6] = Pawn.new(:black, [col, 6], self)}
    [0,7].each   {|col| @grid[col][7] = Rook.new(:black, [col, 7], self)}
    [1,6].each   {|col| @grid[col][7] = Knight.new(:black, [col, 7], self)}
    [2,5].each   {|col| @grid[col][7] = Bishop.new(:black, [col, 7], self)}
    @grid[3][7] = Queen.new(:black, [3, 7], self)
    @grid[4][7] = King.new(:black, [4, 7], self)
  end


  def in_check?(color)
    color_pieces = get_all_pieces(color)
    king_piece  = color_pieces.select{ |piece| piece.is_a?(King) }.first
    get_all_pieces(other_color(color)).each do |piece|
      return true if piece.moves.include?(king_piece.position)
    end
      return false
  end

  def checkmate?(color)
    color_pieces = get_all_pieces(color)
    #puts color_pieces.map {|piece|piece.type}
    all_moves = color_pieces.inject([]) do |total_moves, piece|
      total_moves + piece.safe_moves
    end
    all_moves.empty?
  end

  def move(start_pos, end_pos)
    piece_to_move = get_piece_at(start_pos)
    move_array = piece_to_move.safe_moves
    if move_array.include?(end_pos)
      set_piece_at(start_pos) {nil}
      piece_color, piece_class = piece_to_move.color, piece_to_move.class
      set_piece_at(end_pos) {piece_class.new(piece_color, end_pos, self)}
      @to_move = other_color(@to_move)
    else
      print "illegal move, try again"
    end
  end

  def dup
    dup_board = Board.new
    (0...8).each do |row|
      (0...8).each do |col|
        dup_board.grid[row][col] = (@grid[row][col] ? @grid[row][col].dup : nil)
      end
    end
    dup_board
  end

  def get_piece_at(pos)
    @grid[pos[0]][pos[1]]
  end

  def set_piece_at(pos, &prc)
    @grid[pos[0]][pos[1]] = prc.call
  end

  def get_all_pieces(color)
    pieces = Array.new
    @grid.flatten.compact.each do |piece|
      if piece.color == color
        pieces << piece.dup
      end
    end
    pieces
  end

  def other_color(color)
    color == :white ? (return :black) : (return :white)
  end

  def display
    print "\n"*8
    (0...8).each do |y|
      print "#{8-y}  "
      (0...8).each do |x|
        render_square([x,y])
      end
      print "\n"
    end
    print "\n"
    print "   "
    ('A'..'H').each { |letter| print " #{letter} "}
    print "\n"*3
  end

  def render_square(pos)
    x, y = pos[0], pos[1]
    piece = @grid[x][7-y]
    if piece
      square = " #{UNICODE_DISPLAY[piece.class]} ".colorize(
        :color => piece.color
      )
    else
      square = "   "
    end

    if @highlight[0] == x && @highlight[1] == 7-y
      print square.colorize(:background => BACKGROUND_COLOR[:highlight])
    else
      print square.colorize(:background => BACKGROUND_COLOR[(y + x) % 2])
    end
  end


end
