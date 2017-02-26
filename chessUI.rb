require './chessBoard'
require './chessEngine'
require 'time'
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

def playerTurn (board)
	while true
		puts("\e[1\e[25H")
		puts("                           ")
		puts("\e[1\e[25H")
		print("   Enter Move: ")
		userMove = gets.chomp
		if userMove.downcase == "menu"
			return(inGameMenu(board))
		elsif isValidSyntax(userMove)
			rawMove = inputConverter(userMove, "nil")
			if pieceType(board.data[rawMove / 1000]) == "pawn" && (rawMove - (rawMove / 10) * 10 == 8 || rawMove - (rawMove / 10) * 10 == 1)
				while true
					print("   Promote to: ")
					promotion = gets.chomp
					if promotion.downcase == "n" || promotion.downcase == "b" || promotion.downcase == "r" || promotion.downcase == "q"
						promotion = promotion.downcase
						break
					else
						startTime = Time.new
						puts("\e[1\e[25H")
						puts("                           ")
						puts("\e[1\e[25H")
						print("\r   ERROR: Invalid Syntax")
						while Time.new - startTime < 1.4
						end
					end
				end
				rawMove = inputConverter(userMove, promotion)
			end
			if board.finalList.include? rawMove
				board.move(rawMove)
				board.printBoard
				break
			else 
				startTime = Time.new
				puts("\e[1\e[25H")
				puts("                         ")
				puts("\e[1\e[25H")
				print("\r   ERROR: Invalid Move")
				while Time.new - startTime < 1.4
				end
			end
		else
			startTime = Time.new
			puts("\e[1\e[25H")
			puts("                           ")
			puts("\e[1\e[25H")
			print("\r   ERROR: Invalid Syntax")
			while Time.new - startTime < 1.4
			end
		end
	end
end

def computerTurn(computerIsWhite, board)
	moveTree = deep_thought(board, computerIsWhite)
	evaluationTree = tree_evaluator(moveTree)
	bestMoves = moveSelector(evaluationTree)
	theMoveIndex = bestMoves.sample
	theMove = board.finalList[theMoveIndex]
	board.move(theMove)
	board.printBoard
end

def inGameMenu(board)
	while true
		puts("\e[H\e[2J")
		puts("")
		puts("              -- C H E S S --                 ")
		puts("")
		puts("")
		puts("        +----------------------+")
		puts("        |                      |")		
		puts("        |         MENU         |")
		puts("        |                      |")
		puts("        +----------------------+")
		puts("")		
		puts("            Back........[1]     ")
		puts("            New Game....[2]")
		puts("            Exit Game...[3]")
		puts("")
		print("             Input: ")
		inGameMenuInput = gets.chomp
		if ["1", "2", "3"].include? inGameMenuInput
			break
		else
			startTime = Time.new
			puts("\e[1\e[15H")
			puts("                                             ")
			puts("\e[1\e[15H")
			print("\r             ERROR: Invalid Input")
			while Time.new - startTime < 1.4
			end
		end
	end
		if inGameMenuInput == "1"
			board.printBoard			
			return("back")
		elsif inGameMenuInput == "2"
			return("new")
		else
			return("exit")
		end
end

# Program loop

specialOutput = nil
while true
	if specialOutput == "exit" then break end

	# Main menu loop

	while true
		puts("\e[H\e[2J")
		puts("\e[1\e[1H")
		puts("")
		puts("   +-----------------------------------------------+")
		puts("   ¦          _____ _                              ¦")
		puts("   ¦	     / ____| |                             ¦")
		puts("   ¦	    | |    | |__   ___  ___ ___            ¦")
		puts("   ¦	    | |    | '_ \\ / _ \\/ __/ __|           ¦")
		puts("   ¦	    | |____| | | |  __/\\__ \\__ \\           ¦")
		puts("   ¦	     \\_____|_| |_|\\___||___/___/           ¦")
		puts("   ¦                                               ¦")
		puts("   ¦                                               ¦")	
		puts("   ¦            By Martin Giannakopoulos           ¦")
		puts("   ¦                                               ¦")
		puts("   +-----------------------------------------------+")
		puts("")
		puts("            Play Against Computer...[1]")
		puts("            Two Players.............[2]")
		puts("            Instructions............[3]")
		puts("            Exit....................[4]")
		puts("")
		print("            Input: ")
		menuInput = gets.chomp
		if (menuInput == "1" || menuInput == "2" || menuInput == "3" || menuInput == "4")
			puts("\e[H\e[2J")			
			break
		else
			startTime = Time.new
			puts("\e[1\e[20H")
			puts("                                             ")
			puts("\e[1\e[20H")
			print("\r            ERROR: Invalid Input")
			while Time.new - startTime < 1.4
			end
		end
	end

	case menuInput

		# Game instructions

		when "3"
			puts("\e[1\e[1H")
			puts("")
			puts("   Entering moves:")
			puts("")
			puts("   Move inputs must contain two pieces of information:")
			puts("   The square on which the piece you want to move is and")
			puts("   the square to which you want that piece to move. So,")
			puts("   if you want to advance your pawn on the e2 square to")
			puts("   the e4 square you would enter the following:")
			puts("")
			puts("   e2 e4")
			puts("")
			puts("   For the input syntax to be valid the first two")
			puts("   characters must correspond to a square on the board,")
			puts("   the third character must be a blank space, and the")
			puts("   fouth and fifth characters must correspond to another")
			puts("   square on the board. The input is NOT case sensitive,")
			puts("   so 'E2 E4' is also valid syntax.")
			puts("")
			puts("")
			puts("   Accessing in-game menu:")
			puts("")			
			puts("   When prompted to enter a move the in-game menu can be")
			puts("   accessed by entering the word 'menu'. When playing")
			puts("   against the computer this option is not available")
			puts("   while the engine is 'thinking'.")
			puts("")
			puts("")
			print("   Press Enter to return to main menu")
			gets

		# One-player chess game loop

		when "1"
			while true
				puts("")
				puts("   PLAY AGAINST COMPUTER")
				puts("")
				puts("   Play as white [w] or as black [b]")
				puts("")				
				print("   Input: ")
				humanColour = gets.chomp
				if humanColour.downcase == "b"
					computerIsWhite = true
					break
				elsif humanColour.downcase == "w"
					computerIsWhite = false
					break
				end
			end
			mainBoard = Board.new("std", true)
			mainBoard.printBoard
			while true
				if mainBoard.gameOver
				  if mainBoard.inCheck
						puts("  Checkmate")
					else
						puts("  Stalemate")
					end
						print("   Press Enter to return to main menu")
						gets
					break
				else
					if computerIsWhite == mainBoard.playerTurn
						computerTurn(computerIsWhite, mainBoard)
					else
						specialOutput = playerTurn(mainBoard)
					end
				end

				if specialOutput == "new" || specialOutput == "exit"
					break
				end
			end

		# Two-player chess game loop

		when "2"
			mainBoard = Board.new("std", true)
			mainBoard.printBoard
			while true
				if mainBoard.gameOver
				  if mainBoard.inCheck
						puts(" Checkmate")
					else
						puts(" Stalemate")
					end
					STDIN.getch 
					break
				else
					specialOutput = playerTurn(mainBoard)
				end
				if specialOutput == "new" || specialOutput == "exit"
					break
				end
			end
		when "4"
			break
	end
end