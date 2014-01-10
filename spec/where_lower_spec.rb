require 'spec_helper'

describe WhereLower do

  let(:parent_name) { 'Parent' }
  let(:parent_name2) { 'Parent #10' }
  let(:parent_name3) { 'Parent #20' }
  let(:parent_description) { 'I need a Medic!' }
  let(:parent_description2) { 'I need a Pokemon!' }

  let!(:parent) do
    Parent.create!(name: parent_name, description: parent_description,
        age: 40, is_minecraft_lover: false, created_at: 1.day.ago)
  end

  describe 'finding records with condition(s) for columns inside the model table' do
    describe 'finding record using string column' do
      describe 'with type string' do
        before do
          Parent.where(name: parent_name).should_not be_empty
          Parent.where(name: parent_name2).should be_empty
        end

        it 'works like where' do
          Parent.where_lower(name: parent_name).should_not be_empty
          Parent.where_lower(name: parent_name2).should be_empty
        end
        it 'works like where case insensitively' do
          Parent.where_lower(name: parent_name.swapcase).should_not be_empty
          Parent.where_lower(name: parent_name2.swapcase).should be_empty
        end
      end

      describe 'with type text' do
        before do
          Parent.where(description: parent_description).should_not be_empty
          Parent.where(description: parent_description2).should be_empty
        end

        it 'works like where' do
          Parent.where_lower(description: parent_description).should_not be_empty
          Parent.where_lower(description: parent_description2).should be_empty
        end
        it 'works like where case insensitively' do
          Parent.where_lower(description: parent_description.swapcase).should_not be_empty
          Parent.where_lower(description: parent_description2.swapcase).should be_empty
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
            Parent.where(name: [parent_name, parent_name2]).should_not be_empty
            Parent.where(name: [parent_name2, parent_name3]).should be_empty
          end

          it 'works like where' do
            Parent.where_lower(name: [parent_name, parent_name2]).should_not be_empty
            Parent.where_lower(name: [parent_name2, parent_name3]).should be_empty
            Parent.where_lower(name: []).should be_empty
          end
          it 'works like where case insensitively' do
            Parent.where_lower(name: [parent_name.swapcase, parent_name2.swapcase]).should_not be_empty
            Parent.where_lower(name: [parent_name2.swapcase, parent_name3.swapcase]).should be_empty
            Parent.where_lower(name: []).should be_empty
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

        describe 'with query injection' do
          it 'prevents injection' do
            expect do
              Parent.where_lower(name: "'); truncate table parents")
            end.to_not change(Parent, :count)
          end
        end


        describe 'with chaining' do
          it 'can be chained with where' do
            Parent.where_lower(name: parent_name).where(description: parent_description).should_not be_empty
          end

          it 'can be chained with where_lower' do
            Parent.where_lower(name: parent_name).where_lower(description: parent_description).should_not be_empty
          end

          it 'can be chained with order' do
            Parent.where_lower(name: parent_name).order(:description).should_not be_empty
          end


          it 'can be chained with name scope' do
            Parent.where_lower(name: parent_name).latest_first.should_not be_empty
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
