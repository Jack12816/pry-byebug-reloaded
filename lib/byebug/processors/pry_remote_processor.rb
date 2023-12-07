# frozen_string_literal: true

require "byebug/core"

module Byebug
  #
  # Extends the PryProcessor to make it work with Pry-Remote
  #
  class PryRemoteProcessor < PryProcessor
    def self.start
      super

      Byebug.current_context.step_out(5, true)
    end

    def resume_pry
      new_binding = frame._binding

      run do
        return unless server

        if defined?(@pry) && @pry
          @pry.repl(new_binding)
        else
          @pry = Pry::REPL.start_without_pry_byebug(target: new_binding,
                                                    input: input,
                                                    output: output)
        end
      end
    rescue Errno::ECONNREFUSED
      nil
    end

    private

    def input
      server.client.input_proxy
    end

    def output
      server.client.output
    end

    def server
      PryByebug.current_remote_server
    end
  end
end
