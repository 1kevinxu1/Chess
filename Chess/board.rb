require_relative 'chess_pieces.rb'

class Board


  attr_accessor :grid

  COLORS = [:white, :black]
  UNICODE_DISPLAY = {
    [Pawn,   :white] => '♙',
    [Knight, :white] => '♘',
    [Bishop, :white] => '♗',
    [Rook,   :white] => '♖',
    [Queen,  :white] => '♕',
    [King,   :white] => '♔'
  }


  def initialize
    @grid = Array.new(8) { Array.new(8) {nil} }
  end

  def fill_board
    (0...8).each {|col| @grid[col][1] = Pawn.new(:white, [col, 1], self)}
    [0,7].each   {|col| @grid[col][0] = Rook.new(:white, [col, 0], self)}
    [1,6].each   {|col| @grid[col][0] = Knight.new(:white, [col, 0], self)}
    [2,5].each   {|col| @grid[col][0] = Bishop.new(:white, [col, 0], self)}
    @grid[3][0] = Queen.new(:white, [3, 0], self)
    @grid[4][0] = King.new(:white, [4, 0], self)
  end

  def in_check?(color)
  end

  def move(start_pos, end_pos)
    x, y = start_pos[0], start_pos[1]
    piece_type = @grid[x][y].type
    @grid[x][y] = nil
    piece_class, piece_color = piece_type[0], piece_type[1]
    x, y = end_pos[0], end_pos[1]
    @grid[x][y] = piece_class.new(piece_color, end_pos, self)

  end

  def get_move
    pos = gets.chomp.split(",").map(&:to_i)
    x, y = pos[0], pos[1]
    @grid[7-y][x] = "X"
  end

  def display
    print "\n"*5
    (0...8).each do |y|
      (0...8).each do |x|
        if @grid[x][7-y]
          piece = @grid[x][7-y]
          print "[#{UNICODE_DISPLAY[piece.type]} ]"
          ##{@grid[x][7-y]}
        else
          print "[  ]"
        end
      end
      print "\n"
    end
    print "\n"*5
  end

end
