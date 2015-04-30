require 'io/console'
require_relative 'board.rb'

class Game
  attr_accessor :player

  def initialize
    @game = Board.new
    @getting_piece = true
    @current_pos = nil
    @playing = true
  end

  def play
    while @playing
      print "It is #{@game.to_move}'s turn to move!\n"
      take_turn(@game.to_move)
      if @game.checkmate?(@game.to_move)
        @playing = false
      end
    end
    print "#{@game.to_move} lost the game!\n"

  end

  def take_action(command)

    if command == "a"
      move_highlight([-1, 0])
    elsif command == "d"
      move_highlight([1,  0])
    elsif command == "w"
      move_highlight([0,  1])
    elsif command =="s"
      move_highlight([0, -1])
    elsif command == "\r"
      move_piece(@game.highlight)
    elsif command == "q"
      exit
    end
  end

  def move_piece(pos)
    if @getting_piece
      square = @game.get_piece_at(pos)
      if square
        if square.color == @game.to_move
          @piece_pos = pos
          @getting_piece = false
        else
          print "That's not your piece!"
        end
      else
        print "You can't pick that!"
      end
    else
      if pos != @piece_pos
        @game.move(@piece_pos, pos)
        @getting_piece = true
      else
        print "You can't put it there!"
      end
    end
  end

  def move_highlight(mod)
    new_pos = [@game.highlight, mod].transpose.map {|coord| coord.inject(:+)}
    if new_pos.all? { |coord| coord.between?(0,7)}
      @game.highlight = new_pos
    end
  end

  def take_turn(player)
    if player == :white
      @game.display
      print "Press Q to quit\n"
      print "WASD to move, [return] to select\n"
      if @getting_piece
        print "You are currently selecting a piece\n"
      else
        print "Where would you like to put the piece?\n"
      end
      command = STDIN.getch
      take_action(command)
    else
      generate_black_move
    end
  end

  def generate_black_move
    random_piece = @game.get_all_pieces(:black).sample
    while random_piece.moves.empty?
      random_piece = @game.get_all_pieces(:black).sample
    end
    start_pos = random_piece.position
    end_pos   = random_piece.safe_moves.sample
    @game.move(start_pos, end_pos)
  end

  def other_player(player)
    @game.to_move = (player == :white ? :black : :white)
  end

end

Game.new.play
