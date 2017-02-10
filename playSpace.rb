class Board

  public
  
  def initialize(layout="std", playerTurn=true)

    immortalSquares = [18, 28, 38, 58, 68, 78, 88, 17, 37, 47, 67, 77, 87, 25, 64, 84, 34, 54, 12, 26, 32, 42, 72, 82, 11, 21, 31, 41, 61, 71, 81] 
    immortalPieces =  [240, 220, 230, 260, 230, 220, 240, 210, 210, 210, 210, 210, 210, 211, 211, 250, 130, 111, 110, 110, 110, 110, 110, 110, 140, 120, 130, 150, 160, 120, 140]

    standardSquares = [11, 21, 31, 41, 51, 61, 71, 81, 12, 22, 32, 42, 52, 62, 72, 82, 17, 27, 37, 47, 57, 67, 77, 87, 18, 28, 38, 48, 58, 68, 78, 88]
    standardPieces =  [140, 120, 130, 150, 160, 130, 120, 140, 110, 110, 110, 110, 110, 110, 110, 110, 210, 210, 210, 210, 210, 210, 210, 210, 240, 220, 230, 250, 260, 230, 220, 240]

    testSquares = [28, 17, 16, 26, 36, 15, 65, 14, 24, 34, 44]
    testPieces = [250, 261, 211, 211, 211, 111, 241, 161, 111, 111, 120]

    @white_to_play = playerTurn
    @availableMoves = []
    @kingSafetyBoard = Hash.new

    if layout == "blank"
      @data = Hash.new
        for i in 1..8
          for j in 1..8
            @data[i + j * 10] = 0
          end
        end
    elsif layout == "std"
      @data = Hash.new
        for i in 1..8
          for j in 1..8
            @data[i + j * 10] = 0
          end
        end
    placementSquares = testSquares
    placementPieces = testPieces

      for i in 0..10
        @data[placementSquares[i]] = placementPieces[i]
      end
    else
      @data = layout
    end

    initial_list_constructor
    final_list_constructor
  end

  def data
    dataCopy = @data.dup
    return dataCopy
  end

  def playerTurn
    if @white_to_play
      playerTurnCopy = true
    else
      playerTurnCopy = false
    end
    return playerTurnCopy
  end

  def printBoard

    @overlay = Hash.new
    for i in 1..8
      for j in 1..8
        @overlay[i + j * 10] = 0
      end
    end

    @data.each do |k, l|
      case (l / 10)
        when 0 then @overlay[k] = " "
        when 11 then @overlay[k] = "p"
        when 12 then @overlay[k] = "n"
        when 13 then @overlay[k] = "b"
        when 14 then @overlay[k] = "r"
        when 15 then @overlay[k] = "q"
        when 16 then @overlay[k] = "k"
        when 21 then @overlay[k] = "P" 
        when 22 then @overlay[k] = "N"
        when 23 then @overlay[k] = "B"
        when 24 then @overlay[k] = "R"
        when 25 then @overlay[k] = "Q" 
        when 26 then @overlay[k] = "K" 
      end
    end

    puts("")
    puts("             -- C H E S S --                 ")
    puts("")
    puts("     Turn: ")
    puts("")
    puts("       A   B   C   D   E   F   G   H")
    puts("     ---------------------------------")
    puts("   8 | #{@overlay[18]} | #{@overlay[28]} | #{@overlay[38]} | #{@overlay[48]} | #{@overlay[58]} | #{@overlay[68]} | #{@overlay[78]} | #{@overlay[88]} | 8")
    puts("     ---------------------------------")
    puts("   7 | #{@overlay[17]} | #{@overlay[27]} | #{@overlay[37]} | #{@overlay[47]} | #{@overlay[57]} | #{@overlay[67]} | #{@overlay[77]} | #{@overlay[87]} | 7")
    puts("     ---------------------------------")
    puts("   6 | #{@overlay[16]} | #{@overlay[26]} | #{@overlay[36]} | #{@overlay[46]} | #{@overlay[56]} | #{@overlay[66]} | #{@overlay[76]} | #{@overlay[86]} | 6")
    puts("     ---------------------------------")
    puts("   5 | #{@overlay[15]} | #{@overlay[25]} | #{@overlay[35]} | #{@overlay[45]} | #{@overlay[55]} | #{@overlay[65]} | #{@overlay[75]} | #{@overlay[85]} | 5")
    puts("     ---------------------------------")
    puts("   4 | #{@overlay[14]} | #{@overlay[24]} | #{@overlay[34]} | #{@overlay[44]} | #{@overlay[54]} | #{@overlay[64]} | #{@overlay[74]} | #{@overlay[84]} | 4")
    puts("     ---------------------------------")
    puts("   3 | #{@overlay[13]} | #{@overlay[23]} | #{@overlay[33]} | #{@overlay[43]} | #{@overlay[53]} | #{@overlay[63]} | #{@overlay[73]} | #{@overlay[83]} | 3")
    puts("     ---------------------------------")
    puts("   2 | #{@overlay[12]} | #{@overlay[22]} | #{@overlay[32]} | #{@overlay[42]} | #{@overlay[52]} | #{@overlay[62]} | #{@overlay[72]} | #{@overlay[82]} | 2")
    puts("     ---------------------------------")
    puts("   1 | #{@overlay[11]} | #{@overlay[21]} | #{@overlay[31]} | #{@overlay[41]} | #{@overlay[51]} | #{@overlay[61]} | #{@overlay[71]} | #{@overlay[81]} | 1")
    puts("     ---------------------------------")
    puts("       A   B   C   D   E   F   G   H")
    puts("")
  end

  def pieceMoves(position, board, output)
    piece = board[position]                                                                                    # variable "piece" is taken to be whatever is in the postion entered into the function
    case pieceType(piece) 

      when "pawn"
        if player(piece) == "white"
          if position - (position/10 * 10) == 7
            if pieceType(board[position + 1]) == "empty" then output.push(position + 1 + 100 + (position * 1000), position + 1 + 200 + (position * 1000), position + 1 + 300 + (position * 1000), position + 1 + 400 + (position * 1000)) end   
            if player(board[position - 9]) == "black" then output.push((position - 9) + 100 + (position * 1000), (position - 9) + 200 + (position * 1000), (position - 9) + 300 + (position * 1000), (position - 9) + 400 + (position * 1000)) end
            if player(board[position + 11]) == "black" then output.push(position + 11 + 100 + (position * 1000), position + 11 + 200 + (position * 1000), position + 11 + 300 + (position * 1000), position + 11 + 400 + (position * 1000)) end              
          else    
            if pieceType(board[position + 1]) == "empty" then output.push(position + 1 + (position * 1000)) end   
            if player(board[position - 9]) == "black" then output.push(position - 9 + (position * 1000)) end
            if player(board[position + 11]) == "black" then output.push(position + 11 + (position * 1000)) end              
          end
          if pieceType(board[position + 2]) == "empty" && pieceType(board[position + 1]) == "empty" && specialStatus(piece) == "none" then output.push(position + 2 + (position * 1000)) end            
          if player(board[position - 10]) == "black" && pieceType(board[position - 10]) == "pawn" && specialStatus(board[position - 10]) == "en passent" then output.push(position - 10 + (position * 1000)) end
          if player(board[position + 10]) == "black" && pieceType(board[position + 10]) == "pawn" && specialStatus(board[position + 10]) == "en passent" then output.push(position + 10 + (position * 1000)) end
        else
          if position - (position/10 * 10) == 2
            if pieceType(board[position - 1]) == "empty" then output.push((position - 1) + 100 + (position * 1000), (position - 1) + 200 + (position * 1000), (position - 1) + 300 + (position * 1000), (position - 1) + 400 + (position * 1000)) end
            if player(board[position + 9]) == "white" then output.push(position + 9 + 100 + (position * 1000), position + 9 + 200 + (position * 1000), position + 9 + 300 + (position * 1000), position + 9 + 400 + (position * 1000)) end
            if player(board[position - 11]) == "white" then output.push((position - 11) + 100 + (position * 1000), (position - 11) + 200 + (position * 1000), (position - 11) + 300 + (position * 1000), (position - 11) + 400 + (position * 1000)) end
          else          
            if pieceType(board[position - 1]) == "empty" then output.push(position - 1 + (position * 1000)) end
            if player(board[position + 9]) == "white" then output.push(position + 9 + (position * 1000)) end
            if player(board[position - 11]) == "white" then output.push(position - 11 + (position * 1000)) end
          end
          if pieceType(board[position - 2]) == "empty" && pieceType(board[position - 1]) == "empty" && specialStatus(piece) == "none" then output.push(position - 2 + (position * 1000)) end            
          if player(board[position - 10]) == "white" && pieceType(board[position - 10]) == "pawn" && specialStatus(board[position - 10]) == "en passent" then output.push(position - 10 + (position * 1000)) end
          if player(board[position + 10]) == "white" && pieceType(board[position + 10]) == "pawn" && specialStatus(board[position + 10]) == "en passent" then output.push(position + 10 + (position * 1000)) end
        end

      when "knight"
        knightMoves = [12, 21, 19, 8, -12, -21, -19, -8]
        if player(piece) == "white"
          knightMoves.each do |i|
            if pieceType(board[position + i]) == "empty" || player(board[position + i]) == "black" then output.push(position + i + (position * 1000)) end
          end
        else 
          knightMoves.each do |i|
            if pieceType(board[position + i]) == "empty" || player(board[position + i]) == "white" then output.push(position + i  + (position * 1000)) end
          end
        end

      when "bishop"
        movingAlong([position/10 - 1, 8 - (position - ((position/10) * 10))].min, position, -9, output, board)  # NW movement
        movingAlong([8 - position/10, 8 - (position - ((position/10) * 10))].min, position, 11, output, board)  # NE movement
        movingAlong([position/10 - 1, position - ((position/10) * 10) - 1].min, position, -11, output, board)   # SW movement
        movingAlong([8 - position/10, position - ((position/10) * 10) - 1].min, position, 9, output, board)     # SE movement

      when "rook"
        movingAlong(8 - (position - (position/10) * 10), position, 1, output, board)
        movingAlong(position - (position/10) * 10 - 1, position, -1, output, board)
        movingAlong(8 - position/10, position, 10, output, board)
        movingAlong(position/10 - 1, position, -10, output, board)

      when "queen"
        movingAlong([position/10 - 1, 8 - (position - ((position/10) * 10))].min, position, -9, output, board)
        movingAlong([8 - position/10, 8 - (position - ((position/10) * 10))].min, position, 11, output, board) 
        movingAlong([position/10 - 1, position - ((position/10) * 10) - 1].min, position, -11, output, board)
        movingAlong([8 - position/10, position - ((position/10) * 10) - 1].min, position, 9, output, board)
        movingAlong(8 - (position - (position/10) * 10), position, 1, output, board)
        movingAlong(position - (position/10) * 10 - 1, position, -1, output, board)
        movingAlong(8 - position/10, position, 10, output, board)
        movingAlong(position/10 - 1, position, -10, output, board)     

      when "king"
        kingMoves = [1, 11, 10, 9, -1, -11, -10, -9]
        if player(piece) == "white"                                                                                                   
          kingMoves.each do |i|                                                                                                                    # for each of the eight king moves determine if available
            if pieceType(board[position + i]) == "empty" || player(board[position + i]) == "black"  
              output.push(position + i + (position * 1000))
            end
          end
          if specialStatus(piece) == "none"               

          end                                                                                    
        else                                                                                                 
          kingMoves.each do |i|                                                                                                                    # for each of the eight king moves determine if available
            if pieceType(board[position + i]) == "empty" || player(board[position + i]) == "white"  
              output.push(position + i + (position * 1000))
            end
          end                                                                                                   
        end
    end
  end

  def whiteMove
    return @white_to_play
  end

  def availableMoves
    return @availableMoves
  end

  def finalList
    return @final_list
  end

  def initial_list_constructor
    @availableMoves = []
    if @white_to_play
      @data.each do |i, j|
        if player(@data[i]) == "white" then pieceMoves(i, @data, @availableMoves) end
      end
    else
      @data.each do |i, j|
        if player(@data[i]) == "black" then pieceMoves(i, @data, @availableMoves) end
      end
    end
  end

  def final_list_constructor
    @final_list = []
    @availableMoves.each do |i|
      @data.each { |j, k| @kingSafetyBoard[j] = k }
      @output = []
      kingLocation = 0
      movePiece(i, @kingSafetyBoard)

      if @white_to_play
        @kingSafetyBoard.each do |l, m|
          if pieceType(@kingSafetyBoard[l]) == "king" && player(@kingSafetyBoard[l]) == "white"  
            kingLocation = l
            break
          end
        end
        @kingSafetyBoard.each do |l, m|
          if player(@kingSafetyBoard[l]) == "black" then pieceMoves(l, @kingSafetyBoard, @output) end
        end
        @output.map! { |n| n - ((n/100) * 100) }
        unless @output.include? kingLocation then @final_list.push(i) end
      else
        @kingSafetyBoard.each do |l, m|
          if pieceType(@kingSafetyBoard[l]) == "king" && player(@kingSafetyBoard[l]) == "black"  
            kingLocation = l
            break
          end
        end
        @kingSafetyBoard.each do |l, m|
          if player(@kingSafetyBoard[l]) == "white" then pieceMoves(l, @kingSafetyBoard, @output) end
        end
        @output.map! { |n| n - (n/100) * 100 }
        unless @output.include? kingLocation then @final_list.push(i) end
      end
    end
  end

  def movePiece(move, board)
    board[move - ((move/100) * 100)] = board[move/1000]
    board[move/1000] = 0
  end  

  def move(move)
    if finalList.include? move
      movePiece(move, @data)
      if move - ((move/1000) * 1000) > 99
        case ((move - ((move/1000) * 1000)) / 100) * 100
          when 100
            if @white_to_play
              @data[move - ((move/100) * 100)] = 120
            else
              @data[move - ((move/100) * 100)] = 220
            end
          when 200
            if @white_to_play
              @data[move - ((move/100) * 100)] = 130
            else
              @data[move - ((move/100) * 100)] = 230
            end
          when 300
            if @white_to_play
              @data[move - ((move/100) * 100)] = 140
            else
              @data[move - ((move/100) * 100)] = 240
            end
          when 400
            if @white_to_play
              @data[move - ((move/100) * 100)] = 150
            else
              @data[move - ((move/100) * 100)] = 250
            end             
          end
      end
      if (pieceType(@data[move - ((move/100) * 100)]) == "pawn" || pieceType(@data[move - ((move/100) * 100)]) == "king" || pieceType(@data[move - ((move/100) * 100)]) == "rook") && specialStatus(@data[move - ((move/100) * 100)]) == "none" 
        @data[move - ((move/100) * 100)] = @data[move - ((move/100) * 100)] + 1
      end
      @white_to_play = !@white_to_play
      initial_list_constructor
      final_list_constructor
    else
      return(0)
    end
  end

  def evaluate_board
    evaluation = 0
    @data.each do |i, j|
      case pieceType(j)
        when "pawn"
          if player(j) == "white"
            evaluation = evaluation + 1
          else
            evaluation = evaluation - 1
          end
        when "knight"
          if player(j) == "white"
            evaluation = evaluation + 3
          else
            evaluation = evaluation - 3
          end
        when "bishop"
          if player(j) == "white"
            evaluation = evaluation + 3
          else
            evaluation = evaluation - 3
          end 
        when "rook"
          if player(j) == "white"
            evaluation = evaluation + 5
          else
            evaluation = evaluation - 5
          end
        when "queen"
          if player(j) == "white"
            evaluation = evaluation + 8
          else
            evaluation = evaluation - 8
          end
      end
    end
    return evaluation
  end

  private
  
  def player(piece)
   if piece == nil
     return("NaS")
   elsif (((piece / 100) * 100) / 100) == 1
     return("white")
   elsif (((piece / 100) * 100) / 100) == 2
     return("black")
   else
     return("empty")
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

  def specialStatus(piece)
    case (piece - ((piece / 10) * 10))
      when 0 then return("none")
      when 1 then return("has moved")
      when 2 then return("en passent")
    end
  end

  def movingAlong(a, b, c, d, e)
    for i in 1..(a) 
      if pieceType(e[b + ( i * c)]) == "empty"
        d.push(b + ( i * c) + (b * 1000))
      elsif (player(e[b + ( i * c)]) == "white" && player(e[b]) == "black") || (player(e[b + ( i * c)]) == "black" && player(e[b]) == "white")
        d.push(b + ( i * c) + (b * 1000))
        break
      else
        break
      end
    end 
  end

end


def deep_thought (thoughtsBool)
  tree = []
  thoughts = []
  gameOne = Board.new("std", true)
  gameOne.finalList.each do |i|
    puts "#{i}"
    branch_1 = []
    tree.push(branch_1)
    firstLevel = Board.new(gameOne.data, gameOne.playerTurn)
    firstLevel.move(i)
    firstLevel.finalList.each do |j|
      branch_2 = []
      branch_1.push(branch_2)
      secondLevel = Board.new(firstLevel.data, firstLevel.playerTurn)
      secondLevel.move(j)
      secondLevel.finalList.each do |k|
        thirdLevel = Board.new(secondLevel.data, secondLevel.playerTurn)
        thirdLevel.move(k)
        branch_2.push(thirdLevel.evaluate_board)
        thoughts.push([i, j, k, thirdLevel.evaluate_board])
      end
    end
  end
  if thoughtsBool 
    return thoughts
  else
    return tree
  end
end

def tree_evaluator_helper(list, level)
  if list.all? { |i| i.kind_of?(Array) }
    if level % 2 == 0
      return(list.map { |j| (tree_evaluator_helper(j, level + 1)).max })
    else
      return(list.map { |j| (tree_evaluator_helper(j, level + 1)).min })
    end
  else
    return(list)
  end
end

def tree_evaluator(list)
  tree_evaluator_helper(list, 1)
end

gameOne = Board.new("std", true)

gameOne.printBoard

temp = deep_thought(false)
temp2 = deep_thought(true)
puts "#{temp}"
#puts "#{temp2}"
puts "#{tree_evaluator(temp)}"

gameOne.printBoard

puts "#{gameOne.finalList}"

