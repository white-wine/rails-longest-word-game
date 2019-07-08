require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @guess = params[:guess].upcase
    @grid = params[:grid]
    @is_included = included?(@guess, @grid)
    if included?(@guess, @grid)
      if english_word?(@guess)
        @response = "Congrats!"
        @point = @guess.length
      else
        @response = "invalid word"
      end
    else
      @response = "you didnt use the right letters"
    end
  end

  private

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end
  def english_word?(guess)
    response = open("https://wagon-dictionary.herokuapp.com/#{guess}")
    json = JSON.parse(response.read)
    json['found']
  end
end
