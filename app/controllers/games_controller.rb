require 'open-uri'

class GamesController < ApplicationController
  def new
    array = ('A'..'Z').to_a
    @letters = 10.times.map { array.sample }.to_s.gsub('"', '')
  end

  def score
    @word = params[:word]
    word_hash = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{@word}").read)
    user_array = @word.downcase.split('')
    user_hash = Hash.new(0)
    user_array.each do |char|
      user_hash[char] += 1
    end
    grid_hash = Hash.new(0)
    @letters = params[:letter].split
    @letters.each do |char|
      grid_hash[char.downcase] += 1
    end
    results = true
    user_array.each do |char|
      results = false if user_hash[char] > grid_hash[char]
    end

    if word_hash["found"] == true && results == true
      # result[:score] = (1000 / (end_time - start_time) + (@word.length * 10))
      # result[:word] = @word
      # result[:time] = (end_time - start_time)
      @result = "Congratulations! #{@word} is a valid English word!"
    elsif word_hash["found"] == true && results == false
      @result = "Sorry but #{@word} can't be built out of #{@letters}"
    else
      @result = "Sorry but #{@word} does not seem to be a valid English word..."
    end
    # @result
  end
end
