require 'test_helper'

class Widget < ActiveRecord::Base
  has_paper_trail
  has_one :wotsit
  has_many :fluxors, :order => :name
end

class FooWidget < Widget
end

class Wotsit < ActiveRecord::Base
  belongs_to :widget
end

class Fluxor < ActiveRecord::Base
  belongs_to :widget
end

class Article < ActiveRecord::Base
  has_paper_trail :ignore => [:title],
                  :meta   => {:answer => 42,
                              :question => Proc.new { "31 + 11 = #{31 + 11}" },
                              :article_id => Proc.new { |article| article.id } }
end

class Book < ActiveRecord::Base
  has_many :authorships, :dependent => :destroy
  has_many :authors, :through => :authorships, :source => :person
  has_paper_trail
end

class Authorship < ActiveRecord::Base
  belongs_to :book
  belongs_to :person
  has_paper_trail
end

class Person < ActiveRecord::Base
  has_many :authorships, :dependent => :destroy
  has_many :books, :through => :authorships
  has_paper_trail
end


class HasPaperTrailModelTest < Test::Unit::TestCase
  load_schema

  context 'A record' do
    setup { @article = Article.create }

    context 'which updates an ignored column' do
      setup { @article.update_attributes :title => 'My first title' }
      should_not_change('the number of versions') { Version.count }
    end

    context 'which updates an ignored column and a non-ignored column' do
      setup { @article.update_attributes :title => 'My first title', :content => 'Some text here.' }
      should_change('the number of versions', :by => 1) { Version.count }
    end
  end


  context 'A new record' do
    setup { @widget = Widget.new }

    should 'not have any previous versions' do
      assert_equal [], @widget.versions
    end


    context 'which is then created' do
      setup { @widget.update_attributes :name => 'Henry' }

      should 'have one previous version' do
        assert_equal 1, @widget.versions.length
      end

      should 'be nil in its previous version' do
        assert_nil @widget.versions.first.object
        assert_nil @widget.versions.first.reify
      end

      should 'record the correct event' do
        assert_match /create/i, @widget.versions.first.event
      end


      context 'and then updated without any changes' do
        setup { @widget.save }

        should 'not have a new version' do
          assert_equal 1, @widget.versions.length
        end
      end


      context 'and then updated with changes' do
        setup { @widget.update_attributes :name => 'Harry' }

        should 'have two previous versions' do
          assert_equal 2, @widget.versions.length
        end

        should 'be available in its previous version' do
          assert_equal 'Harry', @widget.name
          assert_not_nil @widget.versions.last.object
          widget = @widget.versions.last.reify
          assert_equal 'Henry', widget.name
          assert_equal 'Harry', @widget.name
        end

        should 'have the same ID in its previous version' do
          assert_equal @widget.id, @widget.versions.last.reify.id
        end

        should 'record the correct event' do
          assert_match /update/i, @widget.versions.last.event
        end


        context 'and has one associated object' do
          setup do
            @wotsit = @widget.create_wotsit :name => 'John'
            @reified_widget = @widget.versions.last.reify
          end

          should 'copy the has_one association when reifying' do
            assert_equal @wotsit, @reified_widget.wotsit
          end
        end


        context 'and has many associated objects' do
          setup do
            @f0 = @widget.fluxors.create :name => 'f-zero'
            @f1 = @widget.fluxors.create :name => 'f-one'
            @reified_widget = @widget.versions.last.reify
          end

          should 'copy the has_many associations when reifying' do
            assert_equal @widget.fluxors.length, @reified_widget.fluxors.length
            assert_same_elements @widget.fluxors, @reified_widget.fluxors

            assert_equal @widget.versions.length, @reified_widget.versions.length
            assert_same_elements @widget.versions, @reified_widget.versions
          end
        end


        context 'and then destroyed' do
          setup do
            @fluxor = @widget.fluxors.create :name => 'flux'
            @widget.destroy
            @reified_widget = @widget.versions.last.reify
          end

          should 'record the correct event' do
            assert_match /destroy/i, @widget.versions.last.event
          end

          should 'have three previous versions' do
            assert_equal 3, @widget.versions.length
          end

          should 'be available in its previous version' do
            assert_equal @widget.id, @reified_widget.id
            assert_equal @widget.attributes, @reified_widget.attributes
          end

          should 'be re-creatable from its previous version' do
            assert @reified_widget.save
          end

          should 'restore its associations on its previous version' do
            @reified_widget.save
            assert_equal 1, @reified_widget.fluxors.length
          end
        end
      end
    end
  end


  # Test the serialisation and deserialisation.
  # TODO: binary
  context "A record's papertrail" do
    setup do
      @date_time = DateTime.now.utc
      @time = Time.now
      @date = Date.new 2009, 5, 29
      @widget = Widget.create :name        => 'Warble',
                              :a_text      => 'The quick brown fox',
                              :an_integer  => 42,
                              :a_float     => 153.01,
                              :a_decimal   => 2.71828,
                              :a_datetime  => @date_time,
                              :a_time      => @time,
                              :a_date      => @date,
                              :a_boolean   => true

      @widget.update_attributes :name      => nil,
                              :a_text      => nil,
                              :an_integer  => nil,
                              :a_float     => nil,
                              :a_decimal   => nil,
                              :a_datetime  => nil,
                              :a_time      => nil,
                              :a_date      => nil,
                              :a_boolean   => false
      @previous = @widget.versions.last.reify
    end

    should 'handle strings' do
      assert_equal 'Warble', @previous.name
    end

    should 'handle text' do
      assert_equal 'The quick brown fox', @previous.a_text
    end

    should 'handle integers' do
      assert_equal 42, @previous.an_integer
    end

    should 'handle floats' do
      assert_in_delta 153.01, @previous.a_float, 0.001
    end

    should 'handle decimals' do
      assert_in_delta 2.71828, @previous.a_decimal, 0.00001
    end

    should 'handle datetimes' do
      assert_equal @date_time.to_time.utc, @previous.a_datetime.to_time.utc
    end

    should 'handle times' do
      assert_equal @time, @previous.a_time
    end

    should 'handle dates' do
      assert_equal @date, @previous.a_date
    end

    should 'handle booleans' do
      assert @previous.a_boolean
    end


    context "after a column is removed from the record's schema" do
      setup do
        change_schema
        Widget.reset_column_information
        assert_raise(NoMethodError) { Widget.new.sacrificial_column }
        @last = @widget.versions.last
      end

      should 'reify previous version' do
        assert_kind_of Widget, @last.reify
      end

      should 'restore all forward-compatible attributes' do
        assert_equal    'Warble',               @last.reify.name
        assert_equal    'The quick brown fox',  @last.reify.a_text
        assert_equal    42,                     @last.reify.an_integer
        assert_in_delta 153.01,                 @last.reify.a_float,   0.001
        assert_in_delta 2.71828,                @last.reify.a_decimal, 0.00001
        assert_equal    @date_time.to_time.utc, @last.reify.a_datetime.to_time.utc
        assert_equal    @time,                  @last.reify.a_time
        assert_equal    @date,                  @last.reify.a_date
        assert          @last.reify.a_boolean
      end
    end
  end


  context 'A record' do
    setup { @widget = Widget.create :name => 'Zaphod' }

    context 'with PaperTrail globally disabled' do
      setup do
        PaperTrail.enabled = false
        @count = @widget.versions.length
      end

      teardown { PaperTrail.enabled = true }

      context 'when updated' do
        setup { @widget.update_attributes :name => 'Beeblebrox' }

        should 'not add to its trail' do
          assert_equal @count, @widget.versions.length
        end
      end
    end

    context 'with its paper trail turned off' do
      setup do
        Widget.paper_trail_off
        @count = @widget.versions.length
      end

      teardown { Widget.paper_trail_on }

      context 'when updated' do
        setup { @widget.update_attributes :name => 'Beeblebrox' }

        should 'not add to its trail' do
          assert_equal @count, @widget.versions.length
        end
      end

      context 'and then its paper trail turned on' do
        setup { Widget.paper_trail_on }

        context 'when updated' do
          setup { @widget.update_attributes :name => 'Ford' }

          should 'add to its trail' do
            assert_equal @count + 1, @widget.versions.length
          end
        end
      end
    end
  end


  context 'A papertrail with somebody making changes' do
    setup do
      @widget = Widget.new :name => 'Fidget'
    end

    context 'when a record is created' do
      setup do
        PaperTrail.whodunnit = 'Alice'
        @widget.save
        @version = @widget.versions.last  # only 1 version
      end

      should 'track who made the change' do
        assert_equal 'Alice', @version.whodunnit
        assert_nil   @version.originator
        assert_equal 'Alice', @version.terminator
        assert_equal 'Alice', @widget.originator
      end

      context 'when a record is updated' do
        setup do
          PaperTrail.whodunnit = 'Bob'
          @widget.update_attributes :name => 'Rivet'
          @version = @widget.versions.last
        end

        should 'track who made the change' do
          assert_equal 'Bob',   @version.whodunnit
          assert_equal 'Alice', @version.originator
          assert_equal 'Bob',   @version.terminator
          assert_equal 'Bob',   @widget.originator
        end

        context 'when a record is destroyed' do
          setup do
            PaperTrail.whodunnit = 'Charlie'
            @widget.destroy
            @version = @widget.versions.last
          end

          should 'track who made the change' do
            assert_equal 'Charlie', @version.whodunnit
            assert_equal 'Bob',     @version.originator
            assert_equal 'Charlie', @version.terminator
            assert_equal 'Charlie', @widget.originator
          end
        end
      end
    end
  end


  context 'A subclass' do
    setup do
      @foo = FooWidget.create
      @foo.update_attributes :name => 'Fooey'
    end

    should 'reify with the correct type' do
      thing = @foo.versions.last.reify
      assert_kind_of FooWidget, thing
    end


    context 'when destroyed' do
      setup { @foo.destroy }

      should 'reify with the correct type' do
        thing = @foo.versions.last.reify
        assert_kind_of FooWidget, thing
      end
    end
  end


  context 'An item with versions' do
    setup do
      @widget = Widget.create :name => 'Widget'
      @widget.update_attributes :name => 'Fidget'
      @widget.update_attributes :name => 'Digit'
    end

    context 'which were created over time' do
      setup do
        @created       = 2.days.ago
        @first_update  = 1.day.ago
        @second_update = 1.hour.ago
        @widget.versions[0].update_attributes :created_at => @created
        @widget.versions[1].update_attributes :created_at => @first_update
        @widget.versions[2].update_attributes :created_at => @second_update
        @widget.update_attribute :updated_at, @second_update
      end

      should 'return nil for version_at before it was created' do
        assert_nil @widget.version_at(@created - 1)
      end

      should 'return how it looked when created for version_at its creation' do
        assert_equal 'Widget', @widget.version_at(@created).name
      end

      should "return how it looked when created for version_at just before its first update" do
        assert_equal 'Widget', @widget.version_at(@first_update - 1).name
      end

      should "return how it looked when first updated for version_at its first update" do
        assert_equal 'Fidget', @widget.version_at(@first_update).name
      end

      should 'return how it looked when first updated for version_at just before its second update' do
        assert_equal 'Fidget', @widget.version_at(@second_update - 1).name
      end

      should 'return how it looked when subsequently updated for version_at its second update' do
        assert_equal 'Digit', @widget.version_at(@second_update).name
      end

      should 'return the current object for version_at after latest update' do
        assert_equal 'Digit', @widget.version_at(1.day.from_now).name
      end
    end


    context 'on the first version' do
      setup { @version = @widget.versions.first }

      should 'have a nil previous version' do
        assert_nil @version.previous
      end

      should 'return the next version' do
        assert_equal @widget.versions[1], @version.next
      end

      should 'return the correct index' do
        assert_equal 0, @version.index
      end
    end

    context 'on the last version' do
      setup { @version = @widget.versions.last }

      should 'return the previous version' do
        assert_equal @widget.versions[@widget.versions.length - 2], @version.previous
      end

      should 'have a nil next version' do
        assert_nil @version.next
      end

      should 'return the correct index' do
        assert_equal @widget.versions.length - 1, @version.index
      end
    end
  end


  context 'An item' do
    setup { @article = Article.new }

    context 'which is created' do
      setup { @article.save }

      should 'store fixed meta data' do
        assert_equal 42, @article.versions.last.answer
      end

      should 'store dynamic meta data which is independent of the item' do
        assert_equal '31 + 11 = 42', @article.versions.last.question
      end

      should 'store dynamic meta data which depends on the item' do
        assert_equal @article.id, @article.versions.last.article_id
      end


      context 'and updated' do
        setup { @article.update_attributes! :content => 'Better text.' }

        should 'store fixed meta data' do
          assert_equal 42, @article.versions.last.answer
        end

        should 'store dynamic meta data which is independent of the item' do
          assert_equal '31 + 11 = 42', @article.versions.last.question
        end

        should 'store dynamic meta data which depends on the item' do
          assert_equal @article.id, @article.versions.last.article_id
        end
      end


      context 'and destroyed' do
        setup { @article.destroy }

        should 'store fixed meta data' do
          assert_equal 42, @article.versions.last.answer
        end

        should 'store dynamic meta data which is independent of the item' do
          assert_equal '31 + 11 = 42', @article.versions.last.question
        end

        should 'store dynamic meta data which depends on the item' do
          assert_equal @article.id, @article.versions.last.article_id
        end

      end
    end
  end

  context 'A reified item' do
    setup do
      widget = Widget.create :name => 'Bob'
      %w( Tom Dick Jane ).each { |name| widget.update_attributes :name => name }
      @version = widget.versions.last
      @widget = @version.reify
    end

    should 'know which version it came from' do
      assert_equal @version, @widget.version
    end

    should 'return its previous self' do
      assert_equal @widget.versions[-2].reify, @widget.previous_version
    end

  end


  context 'A non-reified item' do
    setup { @widget = Widget.new }

    should 'not have a previous version' do
      assert_nil @widget.previous_version
    end

    should 'not have a next version' do
      assert_nil @widget.next_version
    end

    context 'with versions' do
      setup do
        @widget.save
        %w( Tom Dick Jane ).each { |name| @widget.update_attributes :name => name }
      end

      should 'have a previous version' do
        assert_equal @widget.versions.last.reify, @widget.previous_version
      end

      should 'have a next version' do
        assert_nil @widget.next_version
      end
    end
  end

  context 'A reified item' do
    setup do
      widget = Widget.create :name => 'Bob'
      %w( Tom Dick Jane ).each { |name| widget.update_attributes :name => name }
      @versions      = widget.versions
      @second_widget = @versions[1].reify  # first widget is null
      @last_widget   = @versions.last.reify
    end

    should 'have a previous version' do
      assert_nil @second_widget.previous_version
      assert_equal @versions[-2].reify, @last_widget.previous_version
    end

    should 'have a next version' do
      assert_equal @versions[2].reify, @second_widget.next_version
      assert_nil @last_widget.next_version
    end
  end

  context ":has_many :through" do
    setup do
      @book = Book.create :title => 'War and Peace'
      @dostoyevsky  = Person.create :name => 'Dostoyevsky'
      @solzhenitsyn = Person.create :name => 'Solzhenitsyn'
    end

    should 'store version on source <<' do
      count = Version.count
      @book.authors << @dostoyevsky
      assert_equal 1, Version.count - count
      assert_equal Version.last, @book.authorships.first.versions.first
    end

    should 'store version on source create' do
      count = Version.count
      @book.authors.create :name => 'Tolstoy'
      assert_equal 2, Version.count - count
      assert_same_elements [Person.last, Authorship.last], [Version.all[-2].item, Version.last.item]
    end

    should 'store version on join destroy' do
      @book.authors << @dostoyevsky
      count = Version.count
      @book.authorships(true).last.destroy
      assert_equal 1, Version.count - count
      assert_equal @book, Version.last.reify.book
      assert_equal @dostoyevsky, Version.last.reify.person
    end

    should 'store version on join clear' do
      @book.authors << @dostoyevsky
      count = Version.count
      @book.authorships(true).clear
      assert_equal 1, Version.count - count
      assert_equal @book, Version.last.reify.book
      assert_equal @dostoyevsky, Version.last.reify.person
    end
  end

end
