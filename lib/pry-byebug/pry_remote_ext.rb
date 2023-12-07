# frozen_string_literal: true

require "pry-remote-reloaded"

module PryRemoteReloaded
  #
  # Overrides PryRemote::Server
  #
  class Server
    #
    # Override the call to Pry.start to save off current Server, and not
    # teardown the server right after Pry.start finishes.
    #
    alias original_run run
    def run
      raise("Already running a pry-remote session!") if
        PryByebug.current_remote_server

      PryByebug.current_remote_server = self

      catch(:breakout_nav) { original_run }
    end

    #
    # Override to reset our saved global current server session.
    #
    alias original_teardown teardown
    def teardown
      original_teardown

      return if @torn

      PryByebug.current_remote_server = nil
      @torn = true
    end
  end
end

# Ensure cleanup when a program finishes without another break. For example,
# 'next' on the last line of a program won't hit Byebug::PryProcessor#run,
# which normally handles cleanup.
at_exit do
  PryByebug.current_remote_server&.teardown
end
