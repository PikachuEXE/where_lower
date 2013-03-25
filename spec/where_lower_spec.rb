require 'spec_helper'

describe WhereLower do

  let(:parent_name) { 'Parent #1' }
  let(:parent_name2) { 'Parent #10' }
  let(:parent_description) { 'I need a Medic!' }

  let!(:parent) do
    Parent.create!(name: parent_name, description: parent_description,
        age: 40, is_minecraft_lover: false, created_at: 1.day.ago)
  end

  describe 'finding records with condition(s) for columns inside the model table' do
    describe 'finding record using string column' do
      describe 'with type string' do
        before do
          Parent.where(name: parent_name).should_not be_empty
          Parent.where(name: "#{parent_name}blah").should be_empty
        end

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
        before do
          Parent.where(description: parent_description).should_not be_empty
          Parent.where(description: "#{parent_description}blah").should be_empty
        end

        it 'works like where' do
          Parent.where_lower(description: parent_description).should_not be_empty
          Parent.where_lower(description: "#{parent_description}blah").should be_empty
        end
        it 'works like where case insensitively' do
          Parent.where_lower(description: parent_description.swapcase).should_not be_empty
          Parent.where_lower(description: "#{parent_description}blah".swapcase).should be_empty
        end
      end

      describe 'with different types of values in conditions' do
        describe 'with Range' do
          before do
            Parent.where(name: ('Parens'..'Parenu')).should_not be_empty
            Parent.where(name: ('Parenu'..'Parenv')).should be_empty
          end

          it 'works like where' do
            Parent.where_lower(name: ('Parens'..'Parenu')).should_not be_empty
            Parent.where_lower(name: ('Parenu'..'Parenv')).should be_empty
          end
          it 'works like where case insensitively' do
            Parent.where_lower(name: (('Parens'.downcase)..('Parenu'.downcase))).should_not be_empty
            Parent.where_lower(name: (('Parenu'.downcase)..('Parenv'.downcase))).should be_empty
          end
        end
        describe 'with Array' do
          before do
            Parent.where(name: [parent_name, "#{parent_name}blah"]).should_not be_empty
            Parent.where(name: ["#{parent_name}blah1", "#{parent_name}blah2"]).should be_empty
          end

          it 'works like where' do
            Parent.where_lower(name: [parent_name, "#{parent_name}blah"]).should_not be_empty
            Parent.where_lower(name: ["#{parent_name}blah1", "#{parent_name}blah2"]).should be_empty
          end
          it 'works like where case insensitively' do
            Parent.where_lower(name: [parent_name.swapcase, "#{parent_name}blah".swapcase]).should_not be_empty
            Parent.where_lower(name: ["#{parent_name}blah1".swapcase, "#{parent_name}blah2".swapcase]).should be_empty
          end
        end
        describe 'with nil' do
          context 'when record with nil value does not exist' do
            before do
              Parent.where(name: nil).should be_empty
            end

            it 'works like where' do
              Parent.where_lower(name: nil).should be_empty
            end
          end
          context 'when record with nil value does exist' do
            before do
              Parent.create!(name: nil)
            end

            before do
              Parent.where(name: nil).should_not be_empty
            end

            it 'works like where' do
              Parent.where_lower(name: nil).should_not be_empty
            end
          end
        end
      end
    end

    describe 'finding record using non string columns' do
      describe 'with type integer' do
        before do
          Parent.where(age: 40).should_not be_empty
          Parent.where(age: 41).should be_empty
        end

        it 'works like where' do
          Parent.where_lower(age: 40).should_not be_empty
          Parent.where_lower(age: 41).should be_empty
        end
      end

      describe 'with type boolean' do
        before do
          Parent.where(is_minecraft_lover: false).should_not be_empty
          Parent.where(is_minecraft_lover: true).should be_empty
        end

        it 'works like where' do
          Parent.where_lower(is_minecraft_lover: false).should_not be_empty
          Parent.where_lower(is_minecraft_lover: true).should be_empty
        end
      end
    end
  end
end
