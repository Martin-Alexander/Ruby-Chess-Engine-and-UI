require './chessBoard'
require 'io/console'   

# Program loop

while true

	# Main menu loop

	while true

		puts("\e[1\e[1H")
		puts("2 players [2]")
		puts("instructions [3]")
		puts("exit [4]")

		menuInput = gets.chomp

		puts("\e[H\e[2J")

		if (menuInput == "2" || menuInput == "3" || menuInput == "4")
			break
		end

	end

	case menuInput

		# Game instructions

		when "3"

			puts("\e[1\e[1H")
			puts("These are the instruction")

			STDIN.getch 

			puts("\e[H\e[2J")

		# Two-player chess game loop

		when "2"

			mainBoard = Board.new("std", true)

			while true
				
			puts("\e[H\e[2J")			
			mainBoard.printBoard 

			puts("Move")
			move1 = gets.chomp
			move1 = move1.to_i
			mainBoard.move(move1)
			mainBoard.printBoard 

			end

	end

	if menuInput == "4"
		break
	end

end

