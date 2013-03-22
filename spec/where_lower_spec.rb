require 'spec_helper'

describe WhereLower do

  let(:parent_name) { 'Parent #1' }
  let(:parent_description) { 'I need a Medic!' }

  let!(:parent) do
    Parent.create!(name: parent_name, description: parent_description,
        age: 40, is_minecraft_lover: false, created_at: 1.day.ago)
  end

  describe 'finding records with condition(s) inside model' do

    describe 'finding record using string column' do
      describe 'with type string' do
        it 'works like where' do
          Parent.where_lower(name: parent_name).should_not be_empty
          Parent.where_lower(name: "#{parent_name}blah").should be_empty
        end
        it 'works like where case insensitively' do
          Parent.where_lower(name: parent_name.swapcase).should_not be_empty
          Parent.where_lower(name: "#{parent_name}blah".swapcase).should be_empty
        end
      end

      describe 'with type text' do
        it 'works like where' do
          Parent.where_lower(description: parent_description).should_not be_empty
          Parent.where_lower(description: "#{parent_description}blah").should be_empty
        end
        it 'works like where case insensitively' do
          Parent.where_lower(description: parent_description.swapcase).should_not be_empty
          Parent.where_lower(description: "#{parent_description}blah".swapcase).should be_empty
        end
      end
    end

    describe 'finding record using non string columns' do
      describe 'with type integer' do
        it 'works like where' do
          Parent.where_lower(age: 40).should_not be_empty
          Parent.where_lower(age: 41).should be_empty
        end
      end

      describe 'with type boolean' do
        it 'works like where' do
          Parent.where_lower(is_minecraft_lover: false).should_not be_empty
          Parent.where_lower(is_minecraft_lover: true).should be_empty
        end
      end
    end
  end

  describe 'find records with condition(s) on associations' do
    let!(:child) do
      Child.create!(name: name, description: description,
        age: 10, is_minecraft_lover: false, created_at: 1.day.ago,
        parent: parent)
    end

    describe 'finding record using string column' do
      describe 'with type string' do
        it 'works like where' do
          Child.where_lower(parent: {name: parent_name}).should_not be_empty
          Child.where_lower(parent: {name: "#{parent_name}blah"}).should be_empty
        end
        it 'works like where case insensitively' do
          Child.where_lower(parent: {name: parent_name.swapcase}).should_not be_empty
          Child.where_lower(parent: {name: "#{parent_name}blah".swapcase}).should be_empty
        end
      end

      describe 'with type text' do
        it 'works like where' do
          Child.where_lower(parent: {description: parent_description}).should_not be_empty
          Child.where_lower(parent: {description: "#{parent_description}blah"}).should be_empty
        end
        it 'works like where case insensitively' do
          Child.where_lower(parent: {description: parent_description.swapcase}).should_not be_empty
          Child.where_lower(parent: {description: "#{parent_description}blah".swapcase}).should be_empty
        end
      end
    end

    describe 'finding record using non string columns' do
      describe 'with type integer' do
        it 'works like where' do
          Child.where_lower(parent: {age: 40}).should_not be_empty
          Child.where_lower(parent: {age: 41}).should be_empty
        end
      end

      describe 'with type boolean' do
        it 'works like where' do
          Child.where_lower(parent: {is_minecraft_lover: false}).should_not be_empty
          Child.where_lower(parent: {is_minecraft_lover: true}).should be_empty
        end
      end
    end
  end

end
