require 'spec_helper'

describe SlackScratcher::Model::Chats do

  # Public methods

  describe '#initialize' do
    it 'requires data, channel, users arguments' do
      target = SlackScratcher::Model::Chats
      error = ArgumentError

      expect { target.new }.to raise_error(error)
      expect { target.new([], '', '') }.to raise_error(error)
      expect { target.new('', '', {}) }.to raise_error(error)
      expect { target.new([], {}, {}) }.to_not raise_error
    end
  end

  # Private methods

  describe '#refine' do
    let(:datas) do
      [{ 'user' => 'U03O',
         'type' => 'message',
         'text' => "<@U037> <http:\/\/home.org\/index.html> \uac15\uc81c?",
         'ts' => '1421302869.000002'
       }]
    end

    let(:users) do
      { 'U03O' =>
        { 'name' => 'nacyot',
          'profile' => {
            'image_32' => 'nacyot.png'
          }
        },
        'U037' =>
        { 'name' => 'toycan' }
      }
    end

    let(:channel) { { 'name' => 'general', 'id' => 'C23874' } }
    let(:chats) { SlackScratcher::Model::Chats.new(datas, channel, users) }
    let(:log) { chats.refined_data.first }
    let(:text) { chats.refined_data.first['text'] }

    it 'should returns refined_data' do
      expect(chats.refined_data).to be_kind_of(Array)
    end

    it 'should refined_data that is not empty' do
      expect(chats.refined_data).to_not be_empty
    end

    it "should have user's information" do
      expect(log).to include('username' => 'nacyot')
      expect(log).to include('profile_image' => 'nacyot.png')
    end

    it "should have message's time" do
      expect(log['datetime']).to be_kind_of(String)
      expect(Time.parse(log['datetime'])).to(
        eq(Time.parse('2015-01-15T15:21:09+09:00')))
    end

    describe 'refine text' do
      it 'should have text' do
        expect(log).to include('text')
        expect(text).to match(/강제?/)
      end

      it 'should have a name whiche mentioned' do
        expect(text).to match(/@toycan/)
        expect(text).to match(/home.org/)
      end
    end
  end
end
