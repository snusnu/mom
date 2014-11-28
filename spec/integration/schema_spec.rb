# encoding: utf-8

require 'pp'
require 'rspec'

require 'mom'
require 'mom/mapper'

describe 'entity mapping' do

  include Morpher::NodeHelpers

  it 'works for arbitrarily embedded values and collections' do

    # Optionally extend the builtin attribute processors

    processors = Mom::PROCESSORS.merge(

      Gender: ->(_) {
        s(:guard,
          s(:or,
            s(:eql, s(:input), s(:static, 'M')),
            s(:eql, s(:input), s(:static, 'F'))))
      }

    )

    # Create a schema for defining domain data

    schema = Mom.schema(key_transform: :symbolize, processors: processors)

    schema.register(:name) do
      map :name
    end

    schema.register(:id) do
      map :id, from: 'ID'
    end

    schema.register(:page) do
      map :page, :ParsedInt10, default: '1'
    end

    schema.register(:contact) do
      map :email, :String, from: :email_address
      map :phone, :String
    end

    schema.register(:task) do
      map :name,          :String
      map :description,   :OString
      map :collaborators, :ParsedInt10Array

      group :labels do
        map :name,  :String
        map :color, :String
      end
    end

    schema.register(:person) do

      map :name,   :String
      map :gender, :Gender

      wrap :contact, entity: :contact, from: :profile

      wrap :account do
        map :login,    :String
        map :password, :String
      end

      group :tasks, entity: :task

      group :addresses, from: :residences do
        map :street,  :String
        map :city,    :String
        map :country, :String

        group :tags, from: :categories do
          map :name, :String
        end
      end
    end

    # Create an environment suitable for building transformers

    mom = Mom::Environment.coerce(schema, processors)

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

    # Expect it to roundtrip
    expect(mapper.dump(mapper.load(hash))).to eql(hash)

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

    # Expect it to roundtrip
    expect(mapper.dump(mapper.load(hash))).to eql(hash)
  end
end
