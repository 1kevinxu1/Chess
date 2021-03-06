require_relative 'pieces.rb'


class Bishop < SlidingPiece
  def move_dirs
    DIAGONALS.map(&:dup)
  end
end

class Rook < SlidingPiece
  def move_dirs
    LINEARS.map(&:dup)
  end
end

class Queen < SlidingPiece
  def move_dirs
    (DIAGONALS + LINEARS).map(&:dup)
  end
end

class Pawn < SteppingPiece

  def move_dirs
    forward_diagonals = [[1, 1], [-1, 1]]
    forward_vertical  = [0, 1]

    if @color == :black
      forward_diagonals.map! { |pos| reverse_direction(pos) }
      forward_vertical = reverse_direction(forward_vertical)
    end
    forward_diagonals.select! do |step|
      if in_range?(modify_position(@position, step))
        occupied_by?(modify_position(@position, step)) == :foe
      end
    end

    if !occupied_by?(modify_position(@position, forward_vertical))
      forward_diagonals << forward_vertical
    end

    forward_diagonals
  end

  def reverse_direction(pos)
    [pos[0], -1*pos[1]]
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
