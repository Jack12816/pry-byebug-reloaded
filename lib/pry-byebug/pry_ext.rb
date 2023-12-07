# frozen_string_literal: true

require "byebug/processors/pry_processor"
require "byebug/processors/pry_remote_processor"

class << Pry::REPL
  alias start_without_pry_byebug start

  def start_with_pry_byebug(options = {})
    target = options[:target]

    if target.is_a?(Binding) && PryByebug.file_context?(target) && !ENV["DISABLE_PRY"]
      if run_remote?
        Byebug::PryRemoteProcessor.start
        return start_without_pry_byebug(options)
      end

      Byebug::PryProcessor.start
    else
      # No need for the tracer unless we have a file context to step through
      start_without_pry_byebug(options)
    end
  end

  alias start start_with_pry_byebug

  def run_remote?
    PryByebug.current_remote_server
  end
end
