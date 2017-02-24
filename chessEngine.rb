require './chessBoard'

def deep_thought (board, white_to_play)
  tree = []
  for i in 0...board.finalList.length
    print "\r Thinking... #{((i.to_f/board.finalList.length.to_f) * 100).round(2).to_i}\% complete"
    branch_1 = []
    firstLevel = Board.new(board.data, board.playerTurn)
    firstLevel.move(board.finalList[i])
    if firstLevel.finalList.length == 0 
      if firstLevel.inCheck
        tree.push([[999]])
      else
        tree.push([[0]])
      end
    else
      tree.push(branch_1)
      firstLevel.finalList.each do |j|
        branch_2 = []
        secondLevel = Board.new(firstLevel.data, firstLevel.playerTurn)
        secondLevel.move(j)
        if secondLevel.finalList.length == 0
          if secondLevel.inCheck
            branch_1.push([-999])
          else
            branch_1.push([0])
          end
        else
          branch_1.push(branch_2)
          secondLevel.finalList.each do |k|
            thirdLevel = Board.new(secondLevel.data, secondLevel.playerTurn)
            thirdLevel.move(k)
            if thirdLevel.finalList.length == 0
              if thirdLevel.inCheck
                branch_2.push(999)
              else
                branch_2.push(0)
              end
            end
            if white_to_play then branch_2.push(thirdLevel.evaluate_board) else branch_2.push(thirdLevel.evaluate_board * -1) end
          end
        end
      end
    end
  end
  return(tree)
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
  return(tree_evaluator_helper(list, 1))
end

def moveSelector(list)
  moveValues = [list[0]]
  moveIndex = [0]
  for i in 1...list.length
    if list[i] == moveValues.max
      moveValues.push(list[i])
      moveIndex.push(i)
    elsif list[i] > moveValues.max
      moveValues = [list[i]]
      moveIndex = [i]
    end
  end
  return(moveIndex)
end