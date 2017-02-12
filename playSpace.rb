require './chessBoard'

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