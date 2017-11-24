require 'rspec'
require 'securerandom'

RSpec.describe Hash do
  context 'matching hash with keys that has undetermined value' do
    let(:json_response) do
      {
        'user' => {
          'id'         => rand(1..10),
          'name'       => 'Likit',
          'uuid'       => SecureRandom.uuid,
          'created_at' => Time.now
        }
      }
    end

    context 'just matching the keys of the hash' do
      it 'returns attributes of user' do
        expect(json_response['user'].keys).to match_array(['id', 'name', 'uuid', 'created_at'])
      end
    end

    context 'use hash_including to match known value' do
      it 'return attributes of user' do
        expect(json_response['user']).to include(
          'id',
          'uuid',
          'created_at',
          'name' => 'Likit',
        )
      end
    end

    context 'use hash_including to match known value and data type' do
      it 'return attributes of user' do
        expect(json_response['user']).to include(
          'id'         => a_kind_of(Integer),
          'uuid'       => a_kind_of(String),
          'created_at' => a_kind_of(Time),
          'name'       => 'Likit',
        )
      end
    end

    context 'if nothing were put as value, its essentially equal to' do
      it 'return attributes of user' do
        expect(json_response['user']).to include(
          'id'         => anything,
          'uuid'       => anything,
          'created_at' => anything,
          'name'       => 'Likit',
        )
      end
    end
  end

  context 'matching with array of hashes' do
    let(:json_response) do
      {
        'users' => [
          {
            'id'         => rand(1..10),
            'name'       => 'Likit',
            'uuid'       => SecureRandom.uuid,
            'created_at' => Time.now
          },
          {
            'id'         => rand(1..10),
            'name'       => 'Hong Ming',
            'uuid'       => SecureRandom.uuid,
            'created_at' => Time.now
          },
          {
            'id'         => rand(1..10),
            'name'       => 'Cloud',
            'uuid'       => SecureRandom.uuid,
            'created_at' => Time.now
          },
        ]
      }
    end

    context 'combining matches to match hashes' do
      it 'return attributes of user' do
        expect(json_response['users']).to all(include(
          'id'         => a_kind_of(Integer),
          'uuid'       => a_kind_of(String),
          'created_at' => a_kind_of(Time),
          'name'       => a_kind_of(String),
        ))
      end
    end
  end
end
