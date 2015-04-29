require_relative 'chess_pieces.rb'

class Board


  attr_accessor :grid

  COLORS = [:white, :black]
  UNICODE_DISPLAY = {
    [:white, Pawn]   => '♙',
    [:white, Knight] => '♘',
    [:white, Bishop] => '♗',
    [:white, Rook]   => '♖',
    [:white, Queen]  => '♕',
    [:white, King]   => '♔',

    [:black, Pawn]   => '♟',
    [:black, Knight] => '♞',
    [:black, Bishop] => '♝',
    [:black, Rook]   => '♜',
    [:black, Queen]  => '♛',
    [:black, King]   => '♚'
  }


  def initialize(fill = true)
    @grid = Array.new(8) { Array.new(8) {nil} }
    if fill
      fill_board_white
      fill_board_black
    end
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
    color_pieces = Array.new
    off_color_pieces = Array.new
    @grid.flatten.compact.each do |piece|
      if piece.color == color
        color_pieces << piece.dup
      else
        off_color_pieces << piece.dup
      end
    end
    king_piece  = color_pieces.select{ |piece| piece.is_a?(King) }.first
    off_color_pieces.each do |piece|
      return true if piece.moves.include?(king_piece.position)
    end
      return false
  end

  def checkmate?(color)
    color_pieces = Array.new
    @grid.flatten.compact.each do |piece|
      if piece.color == color
        color_pieces << piece.dup
      end
    end
    all_moves = color_pieces.inject([]) do |total_moves, piece|
      total_moves + piece.safe_moves
    end
    all_moves.empty?
  end


  def move(start_pos, end_pos)
    x, y = start_pos[0], start_pos[1]
    piece_to_move = @grid[x][y]
    move_array = piece_to_move.safe_moves
    if move_array.include?(end_pos)
      @grid[x][y] = nil
      piece_color, piece_class = piece_to_move.color, piece_to_move.class
      x, y = end_pos[0], end_pos[1]
      @grid[x][y] = piece_class.new(piece_color, end_pos, self)
    else
      raise "illegal move, try again"
    end
    self.display
  end

  def dup
    dup_board = Board.new(false)
    (0...8).each do |row|
      (0...8).each do |col|
        dup_board.grid[row][col] = (@grid[row][col] ? @grid[row][col].dup : nil)
      end
    end
    dup_board
  end

  def display
    print "\n"*5
    (0...8).each do |y|
      (0...8).each do |x|
        if @grid[x][7-y]
          piece = @grid[x][7-y]
          print " #{UNICODE_DISPLAY[piece.type]} "
          ##{@grid[x][7-y]}
        else
          print " — "
        end
      end
      print "\n"
    end
    print "\n"*5
  end
end


b = Board.new
# b.move([4,0],[4,3])
# b.move([7,7],[7,4])
# king = b.grid[4][4]
# rook = b.grid[7][4]
b.display
