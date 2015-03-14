module SlackScratcher
  # Slack log router. This import log data from loader, and route them
  # to adapter
  #
  # @since 0.0.1
  # @attr_reader [Boolean] Keep going on loop?
  class Router
    attr_accessor :loop

    # Initalize SlackScratcher::Router object
    #
    # @param [SlackScratcher::Loader::Base] loader
    # @param [SlackScratcher::Adapter::Base] adapter
    #
    # @example Initialize router object
    #   SlackScratcher::Router.new(loader, adapter)
    #
    # @return [SlackScratcher::Router] Router object
    def initialize(loader, adapter)
      fail ArgumentError unless loader.is_a?(SlackScratcher::Loader::Base)
      fail ArgumentError unless adapter.is_a?(SlackScratcher::Adapter::Base)

      @loader = loader
      @adapter = adapter
      @loop = true
    end

    # Route logs to adapter
    #
    # @return [Boolean] There isn't any problem, it returns true
    def route
      ready
      _route
      true
    end

    # Run loop to route logs in real time
    #
    # @return [Boolean] If loop interrupted, it return false
    def route_loop
      ready
      loop do
        break unless loop
        _route
      end
    rescue Interrupt => error
      SlackScratcher.logger.info error
      false
    end

    private

    # @private
    def ready
      @adapter.ready_index
    end

    # @private
    def _route
      @loader.each(@adapter) do |data, metadata|
        if data.empty?
          SlackScratcher.logger.info "* #{metadata} is empty. Nothing happen."
        else
          @adapter.send data
          SlackScratcher.logger.info "* #{metadata} is routed."
        end
      end
    end
  end
end
