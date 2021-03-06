require 'spec_helper'

describe SlackScratcher::Router do
  let(:loader) do
    mock = double('loader')
    allow(mock).to receive(:is_a?).and_return(true)
    allow(mock).to receive(:each).and_yield(['test'], {})
    mock
  end

  let(:adapter) do
    mock = double('adapter')
    allow(mock).to receive(:is_a?).and_return(true)
    allow(mock).to receive(:ready_index).and_return(true)
    allow(mock).to receive(:each)
    allow(mock).to receive(:store).and_return(true)
    mock
  end

  let(:router) { SlackScratcher::Router.new(loader, adapter) }

  describe '#initialize' do
    it 'requires loader and adapter' do
      target = SlackScratcher::Router
      error = ArgumentError

      expect { target.new('', '') }.to raise_error(error)
      expect { target.new(loader, '') }.to raise_error(error)
      expect { target.new('', adapter) }.to raise_error(error)
      expect { target.new(loader, adapter) }.not_to raise_error
    end
  end

  describe '#route' do
    it 'call ready_index to adapter' do
      expect(adapter).to receive(:ready_index)
      router.route
    end

    specify 'when there is data, read from loader and store to adapter' do
      expect(loader).to receive(:each)
      expect(adapter).to receive(:store)
      expect(SlackScratcher.logger).to receive(:info).with(/routed/)

      router.route
    end

    specify 'when data is empty, nothing happen' do
      allow(loader).to receive(:each).and_yield([], {})
      expect(SlackScratcher.logger).to receive(:info).with(/empty/)

      router.route
    end
  end

  describe '#route_loop' do
    it 'return false when loop is false' do
      allow(router).to receive(:keep_loop).and_return(false)
      expect(router.route_loop).to be_falsey
    end
  end
end
