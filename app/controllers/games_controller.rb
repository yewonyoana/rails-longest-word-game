require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new #to display a new random grid and a form
    # create an array of letters
    # generate 10 random letters from the array
    # create @letters instance variable storing the random letters
    @letters = ("A".."Z").to_a.shuffle.first(10)
  end

  def score #form will be submitted (with POST) to the score action
    parsed_api = valid(params[:word])
    included = all_included(params)

    if parsed_api["found"] && included
      @result = "The word is valid according to the grid and is an English word ✅"
    elsif parsed_api["found"]
      @result = "The word can’t be built out of the original grid ❌"
    else
      @result = "The word is valid according to the grid, but is not a valid English word ❌"
    end
  end

  private
  def valid(word)
    api = "https://wagon-dictionary.herokuapp.com/#{word}"
    # parsing the API (jsonfile)
    open_api = URI.open(api).read # opening the json file and reading it -> converts to a string
    JSON.parse(open_api) # parse json file
    #letter is a valid English word
  end

  def all_included(params)
    params[:word].upcase!.chars.all? do |letter|
      params[:letters].split.include?(letter) && params[:word].count(letter) <= params[:letters].count(letter)
    end
  end
end
