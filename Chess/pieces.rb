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
  ]

  def initialize(color, position, board)
    @position = position
    @color    = color
    @board    = board
    @type     = [@color, self.class]
  end

  def moves
    raise "Move not implemented"
  end

  def in_range?(pos = @position)
    pos.all? { |coord| coord.between?(0,7) }
  end

  def occupied_by?(pos)
    # return nil if !in_range(pos)
    x, y = pos[0], pos[1]
    square = @board.grid[x][y]
    if !square.nil?
      square.color == @color ? (return :friend) : (return :foe)
    else
      return nil
    end
  end

  def safe_moves
    self.moves.select do |move|
      x, y = move[0], move[1]
      temp_board = @board.dup
      temp_board.grid[@position[0]][@position[1]] = nil
      temp_board.grid[x][y] = self.class.new(self.color, move, temp_board)
      !temp_board.in_check?(@color)
    end
  end

  private
    def modify_position(pos, mod)
      [pos, mod].transpose.map {|coord| coord.inject(:+)}
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
    return [pos] if occupied_by?(pos) == :foe
    new_pos = modify_position(pos, mod)
    get_all_dir(new_pos, mod) << pos
  end
end

class SteppingPiece < Piece
  def moves
    all_moves = move_dirs.map { |mod| modify_position(@position, mod) }
    all_moves.select { |spot| in_range?(spot) && occupied_by?(spot) != :friend }
  end
end
