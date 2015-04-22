require "spec_helper"

describe WhereLower do
  let(:parent_name) { "Parent" }
  let(:parent_name2) { "Parent #10" }
  let(:parent_name3) { "Parent #20" }
  let(:parent_description) { "I need a Medic!" }
  let(:parent_description2) { "I need a Job!" }

  let(:child_name) { "Child" }
  let(:child_name2) { "Child #10" }
  let(:child_name3) { "Child #20" }
  let(:child_description) { "I need a Power Ranger!" }
  let(:child_description2) { "I need a Pokemon!" }

  let(:grand_child_name) { "Grand Child" }
  let(:grand_child_name2) { "Grand Child #10" }

  let!(:parent) do
    Parent.create!(
      name:               parent_name,
      description:        parent_description,
      age:                40,
      is_minecraft_lover: false,
      created_at:         40.years.ago,
    )
  end
  let!(:child) do
    Child.create!(
      name:               child_name,
      description:        child_description,
      age:                18,
      is_minecraft_lover: true,
      created_at:         18.years.ago,
      parent:             parent,
    )
  end
  let!(:grand_child) do
    GrandChild.create!(
      name:               grand_child_name,
      description:        child_description,
      age:                1,
      is_minecraft_lover: false,
      created_at:         1.year.ago,
      child:              child,
    )
  end

  describe "finding records with condition(s) for columns inside the model table" do
    describe "finding record using string column" do
      describe "with type string" do
        before do
          expect(Parent.
            where(name: parent_name)).
            to_not be_empty
          expect(Parent.
            where(name: parent_name2)).
            to be_empty
        end

        it "works like where" do
          expect(Parent.
            where_lower(name: parent_name)).
            to_not be_empty
          expect(Parent.
            where_lower(name: parent_name2)).
            to be_empty
        end
        it "works like where case insensitively" do
          expect(Parent.
            where_lower(name: parent_name.swapcase)).
            to_not be_empty
          expect(Parent.
            where_lower(name: parent_name2.swapcase)).
            to be_empty
        end
      end

      describe "with type text" do
        before do
          expect(Parent.
            where(description: parent_description)).
            to_not be_empty
          expect(Parent.
            where(description: parent_description2)).
            to be_empty
        end

        it "works like where" do
          expect(Parent.
            where_lower(description: parent_description)).
            to_not be_empty
          expect(Parent.
            where_lower(description: parent_description2)).
            to be_empty
        end
        it "works like where case insensitively" do
          expect(Parent.
            where_lower(description: parent_description.swapcase)).
            to_not be_empty
          expect(Parent.
            where_lower(description: parent_description2.swapcase)).
            to be_empty
        end
      end

      describe "with different types of values in conditions" do
        describe "with Range" do
          before do
            expect(Parent.
              where(name: ("Parens".."Parenu"))).
              to_not be_empty
            expect(Parent.
              where(name: ("Parenu".."Parenv"))).
              to be_empty
          end

          it "works like where" do
            expect(Parent.
              where_lower(name: ("Parens".."Parenu"))).
              to_not be_empty
            expect(Parent.
              where_lower(name: ("Parenu".."Parenv"))).
              to be_empty
          end
          it "works like where case insensitively" do
            expect(Parent.
              where_lower(name: (("Parens".swapcase)..("Parenu".swapcase)))).
              to_not be_empty
            expect(Parent.
              where_lower(name: (("Parenu".swapcase)..("Parenv".swapcase)))).
              to be_empty
          end
        end

        describe "with Array" do
          before do
            expect(Parent.
              where(name: [parent_name, parent_name2])).
              to_not be_empty
            expect(Parent.
              where(name: [parent_name2, parent_name3])).
              to be_empty
          end

          it "works like where" do
            expect(Parent.
              where_lower(name: [parent_name, parent_name2])).
              to_not be_empty
            expect(Parent.
              where_lower(name: [parent_name2, parent_name3])).
              to be_empty
            expect(Parent.
              where_lower(name: [])).
              to be_empty
          end
          it "works like where case insensitively" do
            expect(Parent.
              where_lower(name: [parent_name.swapcase, parent_name2.swapcase])).
              to_not be_empty
            expect(Parent.
              where_lower(name: [parent_name2.swapcase, parent_name3.swapcase])).
              to be_empty
            expect(Parent.
              where_lower(name: [])).
              to be_empty
          end
        end

        describe "with nil" do
          context "when record with nil value does not exist" do
            before do
              expect(Parent.where(name: nil)).to be_empty
            end

            it "works like where" do
              expect(Parent.where_lower(name: nil)).to be_empty
            end
          end
          context "when record with nil value does exist" do
            before do
              Parent.create!(name: nil)
            end

            before do
              expect(Parent.where(name: nil)).to_not be_empty
            end

            it "works like where" do
              expect(Parent.where_lower(name: nil)).to_not be_empty
            end
          end
        end

        describe "with query injection" do
          it "prevents injection" do
            expect do
              Parent.where_lower(name: %Q|"); truncate table parents|)
            end.to_not change(Parent, :count)
          end
        end

        describe "with chaining" do
          it "can be chained with where" do
            expect(Parent.where_lower(name: parent_name).
              where(description: parent_description)).
              to_not be_empty
          end

          it "can be chained with where_lower" do
            expect(Parent.where_lower(name: parent_name).
              where_lower(description: parent_description)).
              to_not be_empty
          end

          it "can be chained with order" do
            expect(Parent.where_lower(name: parent_name).order(:description)).
              to_not be_empty
          end

          it "can be chained with name scope" do
            expect(Parent.where_lower(name: parent_name).latest_first).
              to_not be_empty
          end
          it "can be chained with class method scope" do
            expect(Parent.where_lower(name: parent_name).earliest_first).
              to_not be_empty
          end
        end
      end
    end

    describe "finding record using non string columns" do
      describe "with type integer" do
        before do
          expect(Parent.where(age: parent.age)).
            to_not be_empty
          expect(Parent.where(age: parent.age + 1)).
            to be_empty
        end

        it "works like where" do
          expect(Parent.where_lower(age: parent.age)).
            to_not be_empty
          expect(Parent.where_lower(age: parent.age + 1)).
            to be_empty
        end
      end

      describe "with type boolean" do
        before do
          expect(Parent.where(is_minecraft_lover: parent.is_minecraft_lover)).
            to_not be_empty
          expect(Parent.where(is_minecraft_lover: !parent.is_minecraft_lover)).
            to be_empty
        end

        it "works like where" do
          expect(Parent.where_lower(is_minecraft_lover: parent.is_minecraft_lover)).
            to_not be_empty
          expect(Parent.where_lower(is_minecraft_lover: !parent.is_minecraft_lover)).
            to be_empty
        end
      end
    end
  end

  describe "finding records with condition(s) for columns outside the model table" do
    describe "using string as hash key" do
      describe "finding record using string column" do
        describe "with type string" do
          before do
            expect(Parent.joins(:children).
              where("children.name" => child_name)).
              to_not be_empty
            expect(Parent.joins(:children).
              where("children.name" => child_name2)).
              to be_empty
          end

          it "works like where" do
            expect(Parent.joins(:children).
              where_lower("children.name" => child_name)).
              to_not be_empty
            expect(Parent.joins(:children).
              where_lower("children.name" => child_name2)).
              to be_empty
          end
          it "works like where case insensitively" do
            expect(Parent.joins(:children).
              where_lower("children.name" => child_name.swapcase)).
              to_not be_empty
            expect(Parent.joins(:children).
              where_lower("children.name" => child_name2.swapcase)).
              to be_empty
          end
        end

        describe "with type text" do
          before do
            expect(Parent.joins(:children).
              where("children.description" => child_description)).
              to_not be_empty
            expect(Parent.joins(:children).
              where("children.description" => child_description2)).
              to be_empty
          end

          it "works like where" do
            expect(Parent.joins(:children).
              where_lower("children.description" => child_description)).
              to_not be_empty
            expect(Parent.joins(:children).
              where_lower("children.description" => child_description2)).
              to be_empty
          end
          it "works like where case insensitively" do
            expect(Parent.joins(:children).
              where_lower("children.description" => child_description.swapcase)).
              to_not be_empty
            expect(Parent.joins(:children).
              where_lower("children.description" => child_description2.swapcase)).
              to be_empty
          end
        end

        describe "with different types of values in conditions" do
          describe "with Range" do
            before do
              expect(Parent.joins(:children).
                where("children.name" => ("Chilc".."Chile"))).
                to_not be_empty
              expect(Parent.joins(:children).
                where("children.name" => ("Chile".."Chilf"))).
                to be_empty
            end

            it "works like where" do
              expect(Parent.joins(:children).
                where_lower("children.name" => ("Chilc".."Chile"))).
                to_not be_empty
              expect(Parent.joins(:children).
                where_lower("children.name" => ("Chile".."Chilf"))).
                to be_empty
            end
            it "works like where case insensitively" do
              expect(Parent.joins(:children).
                where_lower("children.name" => (("Chilc".swapcase)..("Chile".swapcase)))).
                to_not be_empty
              expect(Parent.joins(:children).
                where_lower("children.name" => (("Chile".swapcase)..("Chilf".swapcase)))).
                to be_empty
            end
          end

          describe "with Array" do
            before do
              expect(Parent.joins(:children).
                where("children.name" => [child_name, child_name2])).
                to_not be_empty
              expect(Parent.joins(:children).
                where("children.name" => [child_name2, child_name3])).
                to be_empty
            end

            it "works like where" do
              expect(Parent.joins(:children).
                where_lower("children.name" => [child_name, child_name2])).
                to_not be_empty
              expect(Parent.joins(:children).
                where_lower("children.name" => [child_name2, child_name3])).
                to be_empty
              expect(Parent.joins(:children).
                where_lower("children.name" => [])).
                to be_empty
            end
            it "works like where case insensitively" do
              expect(Parent.joins(:children).
                where_lower("children.name" => [child_name.swapcase, child_name2.swapcase])).
                to_not be_empty
              expect(Parent.joins(:children).
                where_lower("children.name" => [child_name2.swapcase, child_name3.swapcase])).
                to be_empty
              expect(Parent.joins(:children).
                where_lower("children.name" => [])).
                to be_empty
            end
          end

          describe "with nil" do
            context "when record with nil value does not exist" do
              before do
                expect(Parent.joins(:children).
                  where("children.name" => nil)).to be_empty
              end

              it "works like where" do
                expect(Parent.joins(:children).
                  where_lower("children.name" => nil)).to be_empty
              end
            end
            context "when record with nil value does exist" do
              before do
                Child.create!(name: nil, parent: parent)
              end

              before do
                expect(Parent.joins(:children).
                  where("children.name" => nil)).to_not be_empty
              end

              it "works like where" do
                expect(Parent.joins(:children).
                  where_lower("children.name" => nil)).to_not be_empty
              end
            end
          end

          describe "with query injection" do
            it "prevents injection" do
              expect do
                Parent.joins(:children).
                  where_lower("children.name" => %Q|"); truncate table parents|)
              end.to_not change(Child, :count)
            end
          end

          describe "with chaining" do
            it "can be chained with where" do
              expect(Parent.joins(:children).
                where_lower("children.name" => child_name).
                where("children.description" => child_description)).
                to_not be_empty
            end

            it "can be chained with where_lower" do
              expect(Parent.joins(:children).
                where_lower("children.name" => child_name).
                where_lower("children.description" => child_description)).
                to_not be_empty
            end

            it "can be chained with order" do
              expect(Parent.joins(:children).
                where_lower("children.name" => child_name).order("children.description")).
                to_not be_empty
            end

            it "can be chained with name scope" do
              expect(Parent.joins(:children).
                where_lower("children.name" => child_name).latest_first).
                to_not be_empty
            end
            it "can be chained with class method scope" do
              expect(Parent.joins(:children).
                where_lower("children.name" => child_name).earliest_first).
                to_not be_empty
            end
          end
        end
      end

      describe "finding record using non string columns" do
        describe "with type integer" do
          before do
            expect(Parent.joins(:children).
              where("children.age" => child.age)).
              to_not be_empty
            expect(Parent.joins(:children).
              where("children.age" => child.age + 1)).
              to be_empty
          end

          it "works like where" do
            expect(Parent.joins(:children).
              where_lower("children.age" => child.age)).
              to_not be_empty
            expect(Parent.joins(:children).
              where_lower("children.age" => child.age + 1)).
              to be_empty
          end
        end

        describe "with type boolean" do
          before do
            expect(Parent.joins(:children).
              where("children.is_minecraft_lover" => child.is_minecraft_lover)).
              to_not be_empty
            expect(Parent.joins(:children).
              where("children.is_minecraft_lover" => !child.is_minecraft_lover)).
              to be_empty
          end

          it "works like where" do
            expect(Parent.joins(:children).
              where_lower("children.is_minecraft_lover" => child.is_minecraft_lover)).
              to_not be_empty
            expect(Parent.joins(:children).
              where_lower("children.is_minecraft_lover" => !child.is_minecraft_lover)).
              to be_empty
          end
        end
      end
    end

    describe "using nested hash" do
      describe "finding record using string column" do
        describe "with type string" do
          before do
            expect(Parent.joins(:children).
              where(children: {name: child_name})).
              to_not be_empty
            expect(Parent.joins(:children).
              where(children: {name: child_name2})).
              to be_empty
          end

          it "works like where" do
            expect(Parent.joins(:children).
              where_lower(children: {name: child_name})).
              to_not be_empty
            expect(Parent.joins(:children).
              where_lower(children: {name: child_name2})).
              to be_empty
          end
          it "works like where case insensitively" do
            expect(Parent.joins(:children).
              where_lower(children: {name: child_name.swapcase})).
              to_not be_empty
            expect(Parent.joins(:children).
              where_lower(children: {name: child_name2.swapcase})).
              to be_empty
          end
        end

        describe "with type text" do
          before do
            expect(Parent.joins(:children).
              where(children: {description: child_description})).
              to_not be_empty
            expect(Parent.joins(:children).
              where(children: {description: child_description2})).
              to be_empty
          end

          it "works like where" do
            expect(Parent.joins(:children).
              where_lower(children: {description: child_description})).
              to_not be_empty
            expect(Parent.joins(:children).
              where_lower(children: {description: child_description2})).
              to be_empty
          end
          it "works like where case insensitively" do
            expect(Parent.joins(:children).
              where_lower(children: {description: child_description.swapcase})).
              to_not be_empty
            expect(Parent.joins(:children).
              where_lower(children: {description: child_description2.swapcase})).
              to be_empty
          end
        end

        describe "with different types of values in conditions" do
          describe "with Range" do
            before do
              expect(Parent.joins(:children).
                where(children: {name: ("Chilc".."Chile")})).
                to_not be_empty
              expect(Parent.joins(:children).
                where(children: {name: ("Chile".."Chilf")})).
                to be_empty
            end

            it "works like where" do
              expect(Parent.joins(:children).
                where_lower(children: {name: ("Chilc".."Chile")})).
                to_not be_empty
              expect(Parent.joins(:children).
                where_lower(children: {name: ("Chile".."Chilf")})).
                to be_empty
            end
            it "works like where case insensitively" do
              expect(Parent.joins(:children).
                where_lower(children: {name: (("Chilc".swapcase)..("Chile".swapcase))})).
                to_not be_empty
              expect(Parent.joins(:children).
                where_lower(children: {name: (("Chile".swapcase)..("Chilf".swapcase))})).
                to be_empty
            end
          end

          describe "with Array" do
            before do
              expect(Parent.joins(:children).
                where(children: {name: [child_name, child_name2]})).
                to_not be_empty
              expect(Parent.joins(:children).
                where(children: {name: [child_name2, child_name3]})).
                to be_empty
            end

            it "works like where" do
              expect(Parent.joins(:children).
                where_lower(children: {name: [child_name, child_name2]})).
                to_not be_empty
              expect(Parent.joins(:children).
                where_lower(children: {name: [child_name2, child_name3]})).
                to be_empty
              expect(Parent.joins(:children).
                where_lower(children: {name: []})).
                to be_empty
            end
            it "works like where case insensitively" do
              expect(Parent.joins(:children).
                where_lower(children: {name: [child_name.swapcase, child_name2.swapcase]})).
                to_not be_empty
              expect(Parent.joins(:children).
                where_lower(children: {name: [child_name2.swapcase, child_name3.swapcase]})).
                to be_empty
              expect(Parent.joins(:children).
                where_lower(children: {name: []})).
                to be_empty
            end
          end

          describe "with nil" do
            context "when record with nil value does not exist" do
              before do
                expect(Parent.joins(:children).
                  where(children: {name: nil})).to be_empty
              end

              it "works like where" do
                expect(Parent.joins(:children).
                  where_lower(children: {name: nil})).to be_empty
              end
            end
            context "when record with nil value does exist" do
              before do
                Child.create!(name: nil, parent: parent)
              end

              before do
                expect(Parent.joins(:children).
                  where(children: {name: nil})).to_not be_empty
              end

              it "works like where" do
                expect(Parent.joins(:children).
                  where_lower(children: {name: nil})).to_not be_empty
              end
            end
          end

          describe "with query injection" do
            it "prevents injection" do
              expect do
                Parent.joins(:children).
                  where_lower(children: {name: %Q|"); truncate table parents|})
              end.to_not change(Child, :count)
            end
          end

          describe "with chaining" do
            it "can be chained with where" do
              expect(Parent.joins(:children).
                where_lower(children: {name: child_name}).
                where(children: {description: child_description})).
                to_not be_empty
            end

            it "can be chained with where_lower" do
              expect(Parent.joins(:children).
                where_lower(children: {name: child_name}).
                where_lower(children: {description: child_description})).
                to_not be_empty
            end

            it "can be chained with order" do
              expect(Parent.joins(:children).
                where_lower(children: {name: child_name}).
                order("children.description")).
                to_not be_empty
            end

            it "can be chained with name scope" do
              expect(Parent.joins(:children).
                where_lower(children: {name: child_name}).latest_first).
                to_not be_empty
            end
            it "can be chained with class method scope" do
              expect(Parent.joins(:children).
                where_lower(children: {name: child_name}).earliest_first).
                to_not be_empty
            end
          end
        end
      end

      describe "finding record using non string columns" do
        describe "with type integer" do
          before do
            expect(Parent.joins(:children).
              where(children: {age: child.age})).
              to_not be_empty
            expect(Parent.joins(:children).
              where(children: {age: child.age + 1})).
              to be_empty
          end

          it "works like where" do
            expect(Parent.joins(:children).
              where_lower(children: {age: child.age})).
              to_not be_empty
            expect(Parent.joins(:children).
              where_lower(children: {age: child.age + 1})).
              to be_empty
          end
        end

        describe "with type boolean" do
          before do
            expect(Parent.joins(:children).
              where(children: {is_minecraft_lover: child.is_minecraft_lover})).
              to_not be_empty
            expect(Parent.joins(:children).
              where(children: {is_minecraft_lover: !child.is_minecraft_lover})).
              to be_empty
          end

          it "works like where" do
            expect(Parent.joins(:children).
              where_lower(children: {is_minecraft_lover: child.is_minecraft_lover})).
              to_not be_empty
            expect(Parent.joins(:children).
              where_lower(children: {is_minecraft_lover: !child.is_minecraft_lover})).
              to be_empty
          end
        end
      end

      describe "with more than one level deep" do
        it "raises error" do
          expect do
            Parent.joins(children: :grand_children).
              where_lower(children: {grand_children: {name: grand_child_name}})
          end.to raise_error(WhereLower::TooDeepNestedConditions)
        end
      end
    end
  end
end
