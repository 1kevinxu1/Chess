require_relative 'pieces.rb'


class Bishop < SlidingPiece
  def move_dirs
    DIAGONALS.map(&:dup)
  end
end

class Rook < SlidingPiece
  def move_dirs
    DIAGONALS.map(&:dup)
  end
end

class Queen < SlidingPiece
  def move_dirs
    (DIAGONALS + LINEARS).map(&:dup)
  end
end

class Pawn < SteppingPiece
  def move_dirs
    forward_directionals = [[1, 1],[-1, 1]]
    forward_directionals.select! do |step|
      occupied_by?(modify_position(@position, step)) == :foe
    end
    forward_directionals += [0, 1]
  end
end

class King < SteppingPiece
  def move_dirs
    (DIAGONALS + LINEARS).map(&:dup)
  end
end

class Knight < SteppingPiece
  def move_dirs
    KNIGHTS.map(&:dup)
  end
end
