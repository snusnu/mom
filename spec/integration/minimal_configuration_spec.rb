# encoding: utf-8

require 'spec_helper'

require 'mom/mapper'

mom = Mom.environment do
  register :user do
    map :id
    map :name
    embed n, :tasks
  end

  register :task do
    map :id
    map :title
  end
end

entities = mom.entities(:anima)
mappers  = mom.mappers(entities)

mapper = mappers[:user]
hash   = {id: 1, name: 'snusnu', tasks: [{id: 1, title: 'doit'}]}

user_obj  = mapper.load(hash)
user_hash = mapper.dump(user_obj)

puts "loaded: #{user_obj.inspect}"
puts "dumped: #{user_hash.inspect}"

describe 'Minimal configuration usage' do
  it 'should support rountrips' do
    expect(mapper.dump(mapper.load(hash))).to eql(hash)
  end
end

__END__

loaded: #<Entity(user) id=1 name="snusnu" tasks=[#<Entity(task) id=1 title="doit">]>
dumped: {:id=>1, :name=>"snusnu", :tasks=>[{:id=>1, :title=>"doit"}]}
