require "active_support/all"

$match_index_arr = []
$guessed = []
$turns = 10
$index = 0

$hangman = ["-------
|     |
|    
|
|
|
|
|
|
---------", "-------
|     |
|     O 
|
|
|
|
|
|
---------", "-------
|     |
|     O 
|     |
|
|
|
|
|
---------", "-------
|     |
|     O 
|     |
|     |
|
|
|
|
---------", "-------
|     |
|     O 
|     |
|  ---|
|
|
|
|
---------", "-------
|     |
|     O 
|     |
|  ---|---
|
|
|
|
---------", "-------
|     |
|     O 
|     |
|  ---|---
|     |
|
|
|
---------", "-------
|     |
|     O 
|     |
|  ---|---
|     |
|    |
|   |
|  
---------", "-------
|     |
|     O 
|     |
|  ---|---
|     |
|    |
|  _|
|  
---------", "-------
|     |
|     O 
|     |
|  ---|---
|     |
|    | |
|   _| |
|  
---------", "-------
|     |
|     O 
|     |
|  ---|---
|     |
|    | |
|   _| |_
|  
---------" ]

def get_word()
  $word = File.read('/home/ronnie/Documents/Coding/the_odin_project/ruby/hangman/dict/words.txt').lines.select {|l| (5..12).cover?(l.strip.size)}.sample.strip
  $length = $word.length
  $display_word = "#{$word}"
  $hidden_word = "_" * $length
  $display_word_arr = $display_word.downcase.split("")
  $hidden_word_arr = $hidden_word.split("")
end

# Promts user to input a letter and saves the letter in the variable $input.
def get_letter() 
  loop do
    puts "Please enter a letter."
    $input = gets.chomp
    if $guessed.exclude?($input) && $hidden_word_arr.exclude?($input)
        break
    else
      puts ""
      puts "You already guessed that one!"
      puts ""
    end
  end  
end

# Checks if the inputted letter matches a letter in $display_word_arr.
def letter_match()
    $match_index_arr = $display_word_arr.each_index.select{|i| $display_word_arr[i] == "#{$input}"}
end

#  The hidden_word_arr matching letter indexes are changed to $input. 
def dash_to_letter() 
  $match_index_arr.map {|n| $hidden_word_arr[n] = "#{$input}"}
end

# The hidden word is displayed.
def show_word()
    puts $hidden_word_arr.join(" ")
end

# If the inputted letter doesn't match a letter in the $display_word_arr, one is subtracted from turns and one is added to index.
 def no_match() 
  if $match_index_arr == []
    $turns = $turns - 1
    $index = $index + 1
  end
end

# Displays the number of guesses the player has left.
def remaining_guesses()
  if $turns > 1
    puts "You have #{$turns} guesses left!"
  else
    puts "you have #{$turns} guess left!"
  end
end    

# If the wrong letter is guessed, it is added to the $guessed array.
def guessed_wrong_letter()
  if $hidden_word_arr.exclude?($input)
    $guessed.append($input)
  end
end    

# Displays the end message and exits the game when the word is guessed.
def game_over()
  if $hidden_word_arr.exclude?("_")
    puts "You win the game! Well done!"
    exit!
  elsif $turns == 0
    puts "It looks like you weren't able to guess the right letters. The word was #{$word}. Better luck next time!"
    exit!
  end
end

# Checks the number of incorrect guesses and displays the wrong letter array ($guessed).
def check_guess_count()
  if $guessed.count == 0
    puts ""
  elsif $guessed.count == 1
    puts "So far you have incorrectly guessed the letter #{$guessed}"
  else
    puts "So far you have incorrectly guessed the letters #{$guessed}"
  end
end

# def repeat_letter()
#   if $guessed.include?($input) || $hidden_word.include?($input)
#     puts "You already guessed that letter! Try another."
#     retry
#   end  
# end

def fail_message()
  puts "It looks like you weren't able to guess the right letters. The word was #{$word}. Better luck next time!"
end

def game()
  get_word()
  puts $hangman[$index]
  show_word()
  loop do  
    get_letter()
    letter_match()
    no_match()
    puts $hangman[$index]
    remaining_guesses()
    dash_to_letter()
    puts ""
    show_word()
    puts ""
    guessed_wrong_letter()
    game_over()
    check_guess_count()

  end
  puts "It looks like you weren't able to guess the right letters. The word was #{word}.  Better luck next time!"
end    

game()