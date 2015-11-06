# encoding: utf-8

require 'pp'
require 'rspec'

require 'mom'
require 'mom/mapper'

describe 'entity mapping' do

  include Morpher::NodeHelpers

  it 'works for arbitrarily embedded values and collections' do

    # Create a schema for defining domain data

    schema = Mom.schema(:key_transform => :symbolize)

    schema.call do

      # Optionally extend the builtin attribute constraints

      constraints do
        use Mom::Constraint.builtin

        add(:Gender) { enum('M', 'F', 'T') }
      end

      # Add entity definitions

      entity :name do
        map :name
      end

      entity :id do
        map :id, :from => 'ID'
      end

      entity :page do
        map :page, :PInteger, :default => '1'
      end

      entity :contact do
        map :email, :String, :from => :email_address
        map :phone, :String
      end

      entity :signup do
        map :password
        map :password_confirmation

        check :EqualValue, :names => [:password, :password_confirmation]
      end

      entity :car do
        embed 4, :wheels do
          map :diameter
        end
      end

      entity :task do
        map :name,          :String
        map :description,   :OString
        map :collaborators, :PIntegerArray

        embed 0..2, :labels do
          map :name,  :String
          map :color, :String
        end
      end

      entity :person do

        map :name,   :String
        map :gender, :Gender

        embed 1, :contact, :from => :profile

        embed 1, :account do
          map :login,    :String
          map :password, :String
        end

        embed 0..3, :assigned_tasks, :entity => :task, :from => :tasks

        embed 1..3, :addresses, :from => :residences do
          map :street,  :String
          map :city,    :String
          map :country, :String

          embed 0..5, :tags, :from => :categories do
            map :name, :String
          end
        end
      end
    end # schema

    expect {
      schema.constraints  do
        add(:foo) { |_| }
        add(:foo) { |_| }
      end
    }.to raise_error(Mom::DSL::AlreadyRegistered)

    expect {
      schema.entity :broken_map  do
        map :name
        map :name
      end
    }.to raise_error(Mom::DSL::AlreadyRegistered)

    expect {
      schema.entity :broken_embed  do
        embed 1, :foo
        embed 1, :foo
      end
    }.to raise_error(Mom::DSL::AlreadyRegistered)

    # Create an environment suitable for building transformers

    mom = Mom::Environment.coerce(schema)

    # Create transformers from hash to hash

    hash_transformers = mom.hash_transformers

    # Test untyped mapping with no options
    morpher = hash_transformers[:name]

    expect(morpher.call('name' => 'snusnu')[:name]).to eq('snusnu')

    ## Test untyped mapping with options
    morpher = hash_transformers[:id]

    expect(morpher.call('ID' => 1)[:id]).to be(1)

    ## Some use cases don't require the need to perform
    ## a roundtrip (thus needing a mapper). In fact, some
    ## transformations are not inversible, and thus don't
    ## support roundtrips in the first place. An example
    ## would be the s(:merge, {default: :value})) transformer.
    ##
    ## The example below illustrates a realworld usecase
    ## where a pagination (query) parameter may or may not
    ## be present, thus requiring a merge operation. It's no
    ## problem that this transformation is not inversible,
    ## since we don't need to transform the object back into
    ## a hash after working with it.

    morpher = hash_transformers[:page]

    expect(morpher.call({           })[:page]).to be(1)
    expect(morpher.call('page' => '2')[:page]).to be(2)

    # Generate entity classes for all data definitions using :anima builder

    entities = mom.entities(:anima)

    # Create transformers from hash to entity (object)

    object_mappers = mom.object_mappers(entities)

    morpher = object_mappers[:page]

    expect(morpher.call({           }).page).to be(1)
    expect(morpher.call('page' => '2').page).to be(2)

    # Create a bidirectional mapper for :task data

    mapper = mom.mapper(:task, entities)

    hash = {
      'name'          => 'test',
      'description'   => nil,
      'labels'        => [{
        'name'        => 'feature',
        'color'       => 'black'
      }],
      'collaborators' => [ '1' ]
    }

    # Expect proper anonymous embedded entity
    mapper.load(hash).labels.each do |label|
      expect(label.class).to be(entities[:'task.label'])
    end

    # Expect it to roundtrip
    expect(mapper.dump(mapper.load(hash))).to eql(hash)

    # Test behavior when number of labels is out of the supported range

    invalid_hash = {
      'name'          => 'test',
      'description'   => nil,
      'labels'        => 3.times.map { |i| {
        'name'  => "feature #{i}",
        'color' => "color #{i}"
      }},
      'collaborators' => [ '1' ]
    }

    expect {
      mapper.load(invalid_hash)
    }.to raise_error(Morpher::Executor::Hybrid::TransformError)

    # Test behavior when nr of wheels is not exactly what's expected

    mapper = mom.mapper(:car, entities)

    invalid_hash = {
      'wheels' => 3.times.map { |i| { 'diameter'  => 20 } },
    }

    expect {
      mapper.load(invalid_hash)
    }.to raise_error(Morpher::Executor::Hybrid::TransformError)

    # Test entity check constraints

    mapper = mom.mapper(:signup, entities)

    hash = {
      'password'              => '123',
      'password_confirmation' => '123'
    }

    # Expect it to roundtrip
    expect(mapper.dump(mapper.load(hash))).to eql(hash)

    invalid_hash = {
      'password'              => '123',
      'password_confirmation' => '456'
    }

    expect {
      mapper.load(invalid_hash)
    }.to raise_error(Morpher::Executor::Hybrid::TransformError)

    # Create a bidirectional mapper for :person data

    mapper = mom.mapper(:person, entities)

    hash = {
      'name'            => 'snusnu',
      'gender'          => 'M',
      'profile'         => {
        'email_address' => 'gamsnjaga@gmail.com',
        'phone'         => '+436505555555'
      },
      'account'         => {
        'login'         => 'snusnu',
        'password'      => 'secret'
      },
      'tasks'           => [{
        'name'          => 'relax',
        'description'   => nil,
        'labels'        => [{
          'name'        => 'feature',
          'color'       => 'green'
        }],
        'collaborators' => [ '1' ]
      }],
      'residences'      => [{
        'street'        => 'Aglou 23',
        'city'          => 'Aglou',
        'country'       => 'MA',
        'categories'    => [{
          'name'        => 'beach view',
        }]
      }]
    }

    # Expect proper referenced wrapped entity
    expect(mapper.load(hash).contact.class).to be(entities[:contact])

    # Expect proper referenced grouped entity
    mapper.load(hash).assigned_tasks.each do |task|
      expect(task.class).to be(entities[:task])
    end

    # Expect it to roundtrip
    expect(mapper.dump(mapper.load(hash))).to eql(hash)

    # Test transformation error handling

    expect {
      mapper.load(:invalid => :data)
    }.to raise_error(Morpher::Executor::Hybrid::TransformError)
  end
end
