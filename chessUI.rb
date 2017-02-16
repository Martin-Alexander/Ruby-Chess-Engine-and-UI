require './chessBoard'
require './chessEngine'
require 'io/console'   

def isValidSyntax(move)
	move = move.downcase
	if move.length == 5 && 
		move[0].ord >= 97 && move[0].ord <= 104 &&
		move[1].ord >= 49 && move[1].ord <= 56 &&
		move[2].ord == 32 &&
		move[3].ord >= 97 && move[3].ord <= 104 &&
		move[4].ord >= 49 && move[4].ord <= 56
		return(true)
	else
		return(false)
	end
end

def pieceType(piece)
  if piece == nil
    return("NaS")
  else
    case ((piece - ((piece / 100) * 100)) / 10)
      when 0 then return("empty") 
      when 1 then return("pawn")
      when 2 then return("knight")
      when 3 then return("bishop")
      when 4 then return("rook")
      when 5 then return("queen")
      when 6 then return("king") 
    end  
  end
end

def inputConverter(move, promotion)
	move = move.downcase
	promotion = promotion.downcase
	case promotion
		when "n"
			promotion = 1
		when "b"
			promotion = 2
		when "r"
			promotion = 3
		when "q"
			promotion = 4
		else
			promotion = 0
	end
 	return((move[0].ord - 96) * 10000 + (move[1].to_i) * 1000 + promotion * 100 + (move[3].ord - 96) * 10 + (move[4].to_i))
end

# Program loop

while true

	# Main menu loop

	while true
		puts("\e[H\e[2J")
		puts("\e[1\e[1H")
		puts("1 players [1]")
		puts("2 players [2]")
		puts("instructions [3]")
		puts("exit [4]")

		menuInput = gets.chomp

		puts("\e[H\e[2J")

		if (menuInput == "1" || menuInput == "2" || menuInput == "3" || menuInput == "4")
			break
		end
	end

	case menuInput

		# Game instructions

		when "3"

			puts("\e[1\e[1H")
			puts("These are the instruction")

			STDIN.getch 

		# Two-player chess game loop

		when "1"

			mainBoard = Board.new("std", true)
			mainBoard.printBoard

			while true

				if mainBoard.gameOver
				  if mainBoard.inCheck
						puts("Checkmate")
					else
						puts("Stalemate")
					end
					STDIN.getch 
					break
				else

					if mainBoard.playerTurn

						moveTree = deep_thought(mainBoard)

						evaluationTree = tree_evaluator(moveTree)

						bestMoves = moveSelector(evaluationTree)

						theMoveIndex = bestMoves.sample

						theMove = mainBoard.finalList[theMoveIndex]

						mainBoard.move(theMove)

						mainBoard.printBoard

					else
						while true

							print("Enter Move: ")
							userMove = gets.chomp

							if userMove.downcase == "exit"
								"a" + 2
							end

							if isValidSyntax(userMove)
								rawMove = inputConverter(userMove, "nil")
								if pieceType(mainBoard.data[rawMove / 1000]) == "pawn" && (rawMove - (rawMove / 10) * 10 == 8 || rawMove - (rawMove / 10) * 10 == 1)
									while true
										print("Promote to: ")
										promotion = gets.chomp
										if promotion.downcase == "n" || promotion.downcase == "b" || promotion.downcase == "r" || promotion.downcase == "q"
											promotion = promotion.downcase
											break
										else
											puts("Invalid Syntax")
										end
									end
									rawMove = inputConverter(userMove, promotion)
								end
								puts("#{rawMove}")
								mainBoard.move(rawMove)
								mainBoard.printBoard
								break
							else
								puts("Invalid Syntax")
							end
						end
					end
				end
			end

		when "2"

			mainBoard = Board.new("std", true)
			mainBoard.printBoard

			while true

				if mainBoard.gameOver
				  if mainBoard.inCheck
						puts("Checkmate")
					else
						puts("Stalemate")
					end
					STDIN.getch 
					break
				else

					while true

						print("Enter Move: ")
						userMove = gets.chomp

						if userMove.downcase == "exit"
							"a" + 2
						end

						if isValidSyntax(userMove)
							rawMove = inputConverter(userMove, "nil")
							if pieceType(mainBoard.data[rawMove / 1000]) == "pawn" && (rawMove - (rawMove / 10) * 10 == 8 || rawMove - (rawMove / 10) * 10 == 1)
								while true
									print("Promote to: ")
									promotion = gets.chomp
									if promotion.downcase == "n" || promotion.downcase == "b" || promotion.downcase == "r" || promotion.downcase == "q"
										promotion = promotion.downcase
										break
									else
										puts("Invalid Syntax")
									end
								end
								rawMove = inputConverter(userMove, promotion)
							end
							puts("#{rawMove}")
							mainBoard.move(rawMove)
							mainBoard.printBoard
							break
						else
							puts("Invalid Syntax")
						end
					end
				end
			end
	end

	if menuInput == "4"
		break
	end

end