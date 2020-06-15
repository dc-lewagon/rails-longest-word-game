require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = []
    grid_size.times { @letters << ("A".."Z").to_a.sample }
  end

  def score
    word = params[:word]
    @letters = params[:letters].split(".")

    @result = {check: "", word: word}
    if word_exists?(word) && attempt_valid?(word, @letters)
      @result[:check] = "valid"
    elsif attempt_valid?(word, @letters)
      @result[:check] = "not a word"
    else
      @result[:check] = "invalid"
    end
    @result
  end

  private

  def grid_size
    10
  end

  def word_exists?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    JSON.parse(open(url).read)["found"]
  end

  def attempt_valid?(word, letters)
    word.upcase.scan(/./).each do |letter|
      index = letters.find_index(letter)
      if index.nil?
        return false
      else
        letters.delete_at(index)
      end
    end
    return true
  end

  def run_game(attempt, grid, start_time, end_time)
    if word_exists?(attempt) && attempt_valid?(attempt, grid)
      score = 10 * (attempt.size * grid.size + attempt.size**attempt.size) / (grid.size * (end_time - start_time))
      return { score: score, message: "Well done! #{attempt} was a good attempt." }
    elsif attempt_valid?(attempt, grid)
      return { score: 0, message: "not an english word" }
    else
      return { score: 0, message: "not in the grid" }
    end
  end

end


  
  
  
