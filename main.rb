#!/usr/bin/env ruby

require 'ruby2d'
require 'open-uri'
require 'json'

set title: "Motivational Quotes For The Soul",
    background: "yellow",
    width: 640,
    height: 480

$text_x = (Window.width / 16)
$text_y = (Window.height / 3)
$fragments = []
$dels = [",", ";", "."]
$buffer = ""
$text_objects = []

def get_quote
  url = "https://zenquotes.io/api/random/"
  response = URI.open(url)
  if response.status.first == "200"
    json = JSON.parse(response.read).first
  end
  {quote: json["q"], author: json["a"]}
end

def generate_fragment(quote)
  # This will split the quote at semicolons, commas, and periods.
  # It will then generate a text object for each split result
  quote[:quote].each_char do |char|
    if $dels.include?(char)
      $buffer << char
      $fragments << $buffer
      $buffer = ""
    else
      $buffer << char
    end
  end

  $fragments << quote[:author]

end

def generate_text(text)
  $text_objects << Text.new(text, font: "/System/Library/Fonts/Supplemental/AppleGothic.ttf",
                              style: "Regular", x: $text_x, y: $text_y, color: "black", show: false)
end

on :key_down do |event|
  if event.key == "space"
    clear
    $fragments.clear # Remove all text objects
    $text_objects.clear
    $text_y = (Window.height / 2)  # Reset y position
  end
end

on :key_up do |event|
  if event.key == "space"
    quote = get_quote
    generate_fragment(quote)
    $fragments.each do |fragment|
      generate_text(fragment.strip)
      $text_y += 25
    end
    $text_objects.each {|o| o.add}
  end
end

show
