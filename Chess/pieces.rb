class Piece
  attr_accessor :type, :board, :color, :position

  DIAGONALS = [[1, 1], [1, -1], [-1, 1], [-1, -1]]
  LINEARS   = [[1, 0], [0,  1], [-1, 0], [0,  -1]]
  KNIGHTS   = [
    [-1,  2],
    [1,   2],
    [2,   1],
    [2,  -1],
    [1,  -2],
    [-1, -2],
    [-2, -1],
    [-2,  1],
    [-1,  2]
  ]

  def initialize(color, position, board)
    @position = position
    @color    = color
    @board    = board
    @type     = [self.class, @color]
  end

  def test
    return "test"
  end

  def moves
    raise "Move not implemented"
  end

  def in_range?(pos = @position)
    pos.all? { |coord| coord.between?(0,7) }
  end

  def occupied_by?(pos)
    x, y = pos[0], pos[1]
    square = @board.grid[x][y]
    if !square.nil?
      square.color == @color ? (return :friend) : (return :foe)
    else
      return nil
    end
  end

  private
    def modify_position(pos, mod)
      [pos, mod].map {|coord| coord.inject(:+)}
    end

end

class SlidingPiece < Piece

  def moves(pos = @position)
    move_dirs.inject(Array.new) do |move_array, mod|
      new_pos = [mod[0] + pos[0], mod[1] + pos[1]]
      move_array += get_all_dir(new_pos, mod)
    end

  end

  def get_all_dir(pos, mod)
    return [] if !in_range?(pos) || occupied_by?(pos) == :friend
    return [pos] if occupied_by(pos) == :foe
    new_pos = modify_position(pos, mod)
    get_all_dir(new_pos, mod) << pos
  end
end

class SteppingPiece < Piece
  def moves
    all_moves = move_dirs.map { |mod| modify_position(@position, mod) }
    all_moves.select { |spot| occupied_by?(spot) != :friend }
  end
end
