# <div align="center">Hangman</div>
## Description
Hangman is a Ruby based implementation of the classic word guessing game. Played in the terminal, a player types individual letters in attempt to guess the word. For each incorrect letter entered, a body part is added to a displayed stick figure. If the player incorrectly guesses 10 letters, the stick figure is completely drawn and the player loses. If the player guesses the word before the stick figure is drawn, they win.

&nbsp;

![game demonstration](/images/example.gif?raw=true)

&nbsp;

## How to Play
* Clone the "hangman" repo from github. 
* Using `cd`, navigate to the directory of the cloned repo. 
```
  cd /home/user/Documents/cloned_repo
```
* Type `ruby hangman.rb` into the terminal.
* You will be prompted to input a letter. Type your first guess and hit `ENTER`.
* Try to guess the word before the stick figure is completely drawn.

&nbsp;

# About the Project

&nbsp;

## Pulling a Word
* The project reads a text file with `File.read()` and pulls a word between 5 and 12 characters. The word is applied as the value of the global variable `$word`.
* The text file stores one word per line. The `lines()` method returns an array with each line as an array element.
* The `.select()` method iterates through each array element created by `lines()` and creates another array with the words that are between 5 and 12 characters.
* Using `.sample.strip` a word is chosen at random and any whitespace before or after the word is removed.

```
  $word = File.read('dict/words.txt').lines.select {|l| (5..12).cover?(l.strip.size)}.sample.strip
```

&nbsp;

## Getting a Letter
* Within the `get_letter()` method, `loop do` prompts a player to enter a letter until they pass the conditional statement roadblocks.
* The method `gets.chomp` saves the player input as `$input` and `$input = $input.downcase` replaces an uppercase letter with its lowercase counterpart. 
* With the condition, `if $input.count("a-z") == 0`, the statement checks if anything other than a letter was inputted. If that is the case, the loop restarts.
* The conditional then uses `elsif $input.size > 1` to check if more than one character was entered. If so, the loop is restarted. 
* Only when the `$guessed` array and the `$hidden_word_arr` do not include the inputted letter does the loop break.

&nbsp;

## Displaying Correctly Guessed Letters
* Initially, the hidden word is created by multiplying the string "_" by the length of the `$word` variable. The individual underscore characters are saved in the `$hidden_word_arr.`
* The individual letters of `$word` are saved in the array `$display_word.`
* When a player inputs a letter, `$display_word_arr` is iterated through to check if the inputted letter matches any letter in the array.
* If there is a match, the corresponding indexes are saved in the `$match_index_arr` 
```
  $match_index_arr = $display_word_arr.each_index.select{|i| $display_word_arr[i] == "#{$input}"}
```
* The `match_index_arr` is then iterated through using `.map` method to change the indexes of the matching letters in the `$hidden_word_arr` to the letter saved in the variable `$input.` 
```
  $match_index_arr.map {|n| $hidden_word_arr[n] = "#{$input}"}
```
&nbsp;

## Ending the Game
* Each time a player guesses a wrong letter, 1 is added to the index of the `$hangman` array, which displays the image of the stick figure, and 1 is subtracted from the `$turns` variable, which keeps count of the remaining wrong guesses. 
```
  def no_match() 
    if $match_index_arr == []
      $turns = $turns - 1
      $index = $index + 1
    end
  end
```
* When `$hidden_word_arr` no longer contains any "_" and the word has been guessed, the value of a variable called `$end_game` is changed to true.
* Within the method `game()` a `loop do` continues looping the game while the value of `$end_game` is false. When the value of `$end_game` changes to true, the loop breaks and the game ends.
```
  if $end_game
    break
  end
```
* When the `$turns` variable equals 0, the player was unable to guess the word. An end message is displayed and the value of the `$end_game` variable is changed to true.
```
  def game_over()
    if $hidden_word_arr.exclude?("_")
      puts "You win the game! Well done!"
      $end_game = true
    elsif $turns == 0
      puts "It looks like you weren't able to guess the right letters. The word was #{$word}. Better luck next time!"
      $end_game = true
    end
  end
```
&nbsp;
![Lose game example](/images/lose.png?raw=true) 


