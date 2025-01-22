begin
  require 'simplecov'
rescue LoadError
  # ignore
end

begin
  case
  when RUBY_PLATFORM == 'java'
    # require 'debug'
    # Debugger.start
  when defined?(RUBY_ENGINE) && RUBY_ENGINE == 'rbx'
    require 'rubinius/debugger'
  else
    require 'debug'
  end
rescue LoadError
  # ignore
end

require 'csl'
