begin
  require 'simplecov'
rescue LoadError
  # ignore
end

begin
  case
  when RUBY_PLATFORM < 'java'
    require 'debug'
    Debugger.start
  else
    require 'byebug'
  end
rescue LoadError
  # ignore
end

require 'csl'
