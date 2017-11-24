require 'securerandom'
require 'colorize'

class User
  def self.find(id)

    Logger.log('find_user', Time.now, color: true)

    {
      id: id,
      name: 'Likit'
    }
  end
end

class Logger
  def self.log(event, time, options = {})
    if options[:color]
      puts (time.to_s + '=>' + event).blue
    else
      puts time.to_s + '=>' + event
    end
  end
end

RSpec.describe User do
  context 'expectation on a class method' do
    context 'without matching the arguments because we dont know the exact value of time, dangerous!' do
      it 'logs the event' do
        expect(Logger).to receive(:log)

        User.find(1)
      end
    end

    context 'use anything matcher' do
      it 'logs the event' do
        expect(Logger).to receive(:log).with('find_user', anything, anything)

        User.find(1)
      end
    end

    context 'use a_kind_of matcher' do
      it 'logs the event' do
        expect(Logger).to receive(:log).with('find_user', a_kind_of(Time), a_kind_of(Hash))

        User.find(1)
      end
    end

    context 'use duck_type matcher' do
      it 'logs the event' do
        expect(Logger).to receive(:log).with('find_user', duck_type(:to_s), a_kind_of(Hash))

        User.find(1)
      end
    end

    context 'use hash_including matcher' do
      it 'logs the event' do
        expect(Logger).to receive(:log).with('find_user', duck_type(:to_s), hash_including(color: true))

        User.find(1)
      end
    end
  end

  context 'post expectatin by stubbing and spying on the class' do
    before do
      # setting up spy
      allow(Logger).to receive(:log)
    end

    it 'logs the event' do
      User.find(1)

      expect(Logger).to have_received(:log).with('find_user', kind_of(Time), hash_including(color: true))
    end
  end

  context 'spying only' do
    before do
      # setting up spy
      allow(Logger).to receive(:log).and_call_original
    end

    it 'logs the event' do
      User.find(1)

      expect(Logger).to have_received(:log).with('find_user', kind_of(Time), hash_including(color: true))
    end
  end
end
