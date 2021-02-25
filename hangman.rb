require "active_support/all"

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

module GameModule

  # Pulls a word from the dictionary that has between 5 and 12 characters.
  def get_word()
    $word = File.read('dict/words.txt').lines.select {|l| (5..12).cover?(l.strip.size)}.sample.strip
    $length = $word.length
    $display_word = "#{$word}"
    $hidden_word = "_" * $length
    $display_word_arr = $display_word.downcase.split("")
    $hidden_word_arr = $hidden_word.split("")
  end

=begin
  Promts user to input a letter and saves the letter in the variable $input.
  Checks if the user inputs a letter or more than one character.
=end
  def get_letter() 
    loop do
      puts "Please enter a letter."
      $input = gets.chomp
      $input = $input.downcase
      if $input.count("a-z") == 0
        puts ""
        puts "Sorry, that isn't a letter!"
      elsif $input.size > 1
        puts ""
        puts "You entered too many letters!"
      elsif $guessed.exclude?($input) && $hidden_word_arr.exclude?($input)
          break
      else
        puts ""
        puts "You already guessed that one!"
      end
    end  
  end

  # Checks if the inputted letter matches a letter in $display_word_arr.
  def letter_match()
      $match_index_arr = $display_word_arr.each_index.select{|i| $display_word_arr[i] == "#{$input}"}
  end

  #  The hidden_word_arr letters that match $input are changed to that letter. 
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
      puts "You have #{$turns} incorrect guesses left!"
    elsif $turns == 1
      puts "You have 1 incorrect guess left!"
    else
      puts "GAME OVER"
    end
  end    

  # If a wrong letter is guessed, the letter is added to the $guessed array.
  def guessed_wrong_letter()
    if $hidden_word_arr.exclude?($input)
      $guessed.append($input)
    end
  end    

  # Displays the end message and changes the $end_game variable to true.
  def game_over()
    if $hidden_word_arr.exclude?("_")
      puts "You win the game! Well done!"
      $end_game = true
    elsif $turns == 0
      puts "It looks like you weren't able to guess the right letters. The word was #{$word}. Better luck next time!"
      $end_game = true
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

  #Sets the game up.
  def game()
    $match_index_arr = []
    $guessed = []
    $turns = 10
    $index = 0
    $end_game = false

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
      if $end_game
        break
      end
      check_guess_count()
    end
    return
  end    

  # Starts game and prompts player to play another round.
  def play_game() 
    game()
      loop do
        puts "Would you like to play another round?"
        answer = gets.chomp
        answer = answer.downcase
        if answer == "y" || answer == "yes" 
          game()
        elsif answer == "n" || answer == "no"
          puts ""
          puts "Goodbye!"
          exit!
        else
          puts ""
          puts "Sorry, I didn't get that. Try typing 'yes' or 'no.'"
        end
      end  
  end  
end

include GameModule

GameModule.play_game()
