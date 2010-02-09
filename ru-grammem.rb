#!/usr/bin/env ruby1.9
# encoding: utf-8

class Grammemer
  module Config
    LEMMATIZER = './turglem-client'
  end
  
  module Grammems
    MR   = 0x200
    JR   = 0x400
    SR   = 0x800
  end
  
  def lemmatize word
    if word =~ /^[а-яА-Я]+$/
      `#{Config::LEMMATIZER} #{word}`
    else
      raise %Q{not a Russian word "#{word}"}
    end
  end
  
  def forms word
    raw = lemmatize word
    res = []
    raw.scan(/(\S+)\s+(\S+)\s+(\S+)(?:\s+(\*))?\n/) do |form, pos, gramm, original|
      res << {:form => form.downcase, :gramms => unpack_gramm(gramm.to_i(16))}
    end
    res
  end
  
  def unpack_gramm gramm
    arr = []
    arr << gramm.to_s(16)
    arr << "м.р." if gramm & Grammems::MR != 0
    arr << "ж.р." if gramm & Grammems::JR != 0
    arr << "с.р." if gramm & Grammems::SR != 0
    arr
  end
  
  def demo word
    vars = forms word
    vars.each do |var|
      puts "#{var[:form]} #{var[:gramms].join(", ")}"
    end
  end
  
end


class String
  RU_TRANSFORM =
  {
    'а' => 'А', 'А' => 'а',
    'б' => 'Б', 'Б' => 'б',
    'в' => 'В', 'В' => 'в',
    'г' => 'Г', 'Г' => 'г',
    'д' => 'Д', 'Д' => 'д',
    'е' => 'Е', 'Е' => 'е',
    'ё' => 'Ё', 'Ё' => 'ё',
    'ж' => 'Ж', 'Ж' => 'ж',
    'з' => 'З', 'З' => 'з',
    'и' => 'И', 'И' => 'и',
    'й' => 'Й', 'Й' => 'й',
    'к' => 'К', 'К' => 'к',
    'л' => 'Л', 'Л' => 'л',
    'м' => 'М', 'М' => 'м',
    'н' => 'Н', 'Н' => 'н',
    'о' => 'О', 'О' => 'о',
    'п' => 'П', 'П' => 'п',
    'р' => 'Р', 'Р' => 'р',
    'с' => 'С', 'С' => 'с',
    'т' => 'Т', 'Т' => 'т',
    'у' => 'У', 'У' => 'у',
    'ф' => 'Ф', 'Ф' => 'ф',
    'х' => 'Х', 'Х' => 'х',
    'ц' => 'Ц', 'Ц' => 'ц',
    'ч' => 'Ч', 'Ч' => 'ч',
    'ш' => 'Ш', 'Ш' => 'ш',
    'щ' => 'Щ', 'Щ' => 'щ',
    'ь' => 'Ь', 'Ь' => 'ь',
    'ы' => 'Ы', 'Ы' => 'ы',
    'ъ' => 'Ъ', 'Ъ' => 'ъ',
    'э' => 'Э', 'Э' => 'э',
    'ю' => 'Ю', 'Ю' => 'ю',
    'я' => 'Я', 'Я' => 'я'
  }
  
  alias :downcase_real :downcase
  def downcase
    cased = downcase_real
    cased.gsub(/([АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЫЪЭЮЯ])/) do |w|
      RU_TRANSFORM[w]
    end
  end
  
  alias :upcase_real :upcase
  def upcase
    cased = upcase_real
    cased.gsub(/([абвгдеёжзийклмнопрстуфхцчшщьыъэюя])/) do |w|
      RU_TRANSFORM[w]
    end
  end
end




g = Grammemer.new
g.demo(ARGV[0])