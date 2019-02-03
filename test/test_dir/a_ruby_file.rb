# warn_indent: true
require 'some_module'
				  # tabs and spaces before comment
				
=begin Begin!
a multi-line

comment with #{1 +2}
=end

		  
x = 1 # single-line comment #{4 + 5}
str = "here comes an interpolation #{x + 6}"
str2 = 'no interpolation here #{"nope"}'
str3 = " \#{1}  #\{1}" 
str4 = "#{?#}" 

str5 = "nesting #{ 'here' # comment again!
  + 'still'
  + %Q(
    more nesting?
    #{
      1+ 2 # another comment?
    }
    and finished
    \)
  )
  }
  "

module TestModule
  N = 9
  # another comment
  def test
    i = []<<8<<N<<<<EOL<<7
      hi #{ 'interpolated'}
EOL

  end
end