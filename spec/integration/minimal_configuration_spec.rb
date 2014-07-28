# encoding: utf-8

require 'spec_helper'

entities = Mom::Registry.build do # build models using :anima
  register :user do
    map :id
    map :name
    group :tasks, entity: :task
  end

  register :task do
    map :id
    map :title
  end
end

entity = entities[:user]
hash   = {id: 1, name: 'snusnu', tasks: [{id: 1, title: 'doit'}]}

user_obj  = entity.load(hash)
user_hash = entity.dump(user_obj)

puts "loaded: #{user_obj.inspect}"
puts "dumped: #{user_hash.inspect}"

describe 'Minimal configuration usage' do
  it 'should support rountrips' do
    expect(entity.dump(entity.load(hash))).to eql(hash)
  end
end

__END__

loaded: #<Entity(user) id=1 name="snusnu" tasks=[#<Entity(task) id=1 title="doit">]>
dumped: {:id=>1, :name=>"snusnu", :tasks=>[{:id=>1, :title=>"doit"}]}
