module DataMapper
  module Associations
    # Base class for relationships. Each type of relationship
    # (1 to 1, 1 to n, n to m) implements a subclass of this class
    # with methods like get and set overridden.
    class Relationship
      include Extlib::Assertions

      OPTIONS = [ :child_repository_name, :parent_repository_name, :child_key, :parent_key, :min, :max, :inverse ].to_set

      # Relationship name
      #
      # @example for :parent association in
      #
      #   class VersionControl::Commit
      #     # ...
      #
      #     belongs_to :parent
      #   end
      #
      # name is :parent
      #
      # @api semipublic
      attr_reader :name

      # Options used to set up association of this relationship
      #
      # @example for :author association in
      #
      #   class VersionControl::Commit
      #     # ...
      #
      #     belongs_to :author, :model => 'Person'
      #   end
      #
      # options is a hash with a single key, :model
      #
      # @api semipublic
      attr_reader :options

      # ivar used to store collection of child options in source
      #
      # @example for :commits association in
      #
      #   class VersionControl::Branch
      #     # ...
      #
      #     has n, :commits
      #   end
      #
      # instance variable name for source will be @commits
      #
      # @api semipublic
      attr_reader :instance_variable_name

      # Repository from where child objects are loaded
      #
      # @api semipublic
      attr_reader :child_repository_name

      # Repository from where parent objects are loaded
      #
      # @api semipublic
      attr_reader :parent_repository_name

      # Minimum number of child objects for relationship
      #
      # @example for :cores association in
      #
      #   class CPU::Multicore
      #     # ...
      #
      #     has 2..n, :cores
      #   end
      #
      # minimum is 2
      #
      # @api semipublic
      attr_reader :min

      # Maximum number of child objects for
      # relationship
      #
      # @example for :fouls association in
      #
      #   class Basketball::Player
      #     # ...
      #
      #     has 0..5, :fouls
      #   end
      #
      # maximum is 5
      #
      # @api semipublic
      attr_reader :max

      # Returns query options for relationship.
      #
      # For this base class, always returns query options
      # has been initialized with.
      # Overriden in subclasses.
      #
      # @api private
      attr_reader :query

      # Returns a hash of conditions that scopes query that fetches
      # target object
      #
      # @return [Hash]
      #   Hash of conditions that scopes query
      #
      # @api private
      def source_scope(source)
        { inverse => source }
      end

      # Creates and returns Query instance that fetches
      # target resource(s) (ex.: articles) for given target resource (ex.: author)
      #
      # @api semipublic
      def query_for(source, other_query = nil)
        repository_name = relative_target_repository_name_for(source)

        DataMapper.repository(repository_name).scope do
          query = target_model.query.dup
          query.update(self.query)
          query.update(source_scope(source))
          query.update(other_query) if other_query
          query.update(:fields => query.fields | target_key)
        end
      end

      # Returns model class used by child side of the relationship
      #
      # @return [Resource]
      #   Model for association child
      #
      # @api private
      def child_model
        @child_model ||= (@parent_model || Object).find_const(child_model_name)
      rescue NameError
        raise NameError, "Cannot find the child_model #{child_model_name} for #{parent_model_name} in #{name}"
      end

      # TODO: document
      # @api private
      def child_model?
        child_model
        true
      rescue NameError
        false
      end

      # TODO: document
      # @api private
      def child_model_name
        @child_model ? child_model.name : @child_model_name
      end

      # Returns a set of keys that identify the target model
      #
      # @return [PropertySet]
      #   a set of properties that identify the target model
      #
      # @api semipublic
      def child_key
        return @child_key if defined?(@child_key)

        repository_name = child_repository_name || parent_repository_name
        properties      = child_model.properties(repository_name)

        @child_key = if @child_properties
          child_key = properties.values_at(*@child_properties)
          properties.class.new(child_key).freeze
        else
          properties.key
        end
      end

      # Access Relationship#child_key directly
      #
      # @api private
      alias relationship_child_key child_key
      private :relationship_child_key

      # Returns model class used by parent side of the relationship
      #
      # @return [Resource]
      #   Class of association parent
      #
      # @api private
      def parent_model
        @parent_model ||= (@child_model || Object).find_const(parent_model_name)
      rescue NameError
        raise NameError, "Cannot find the parent_model #{parent_model_name} for #{child_model_name} in #{name}"
      end

      # TODO: document
      # @api private
      def parent_model?
        parent_model
        true
      rescue NameError
        false
      end

      # TODO: document
      # @api private
      def parent_model_name
        @parent_model ? parent_model.name : @parent_model_name
      end

      # Returns a set of keys that identify parent model
      #
      # @return [PropertySet]
      #   a set of properties that identify parent model
      #
      # @api private
      def parent_key
        return @parent_key if defined?(@parent_key)

        repository_name = parent_repository_name || child_repository_name
        properties      = parent_model.properties(repository_name)

        @parent_key = if @parent_properties
          parent_key = properties.values_at(*@parent_properties)
          properties.class.new(parent_key).freeze
        else
          properties.key
        end
      end

      # Loads and returns "other end" of the association.
      # Must be implemented in subclasses.
      #
      # @api semipublic
      def get(resource, other_query = nil)
        raise NotImplementedError, "#{self.class}#get not implemented"
      end

      # Gets "other end" of the association directly
      # as @ivar on given resource. Subclasses usually
      # use implementation of this class.
      #
      # @api semipublic
      def get!(resource)
        resource.instance_variable_get(instance_variable_name)
      end

      # Sets value of the "other end" of association
      # on given resource. Must be implemented in subclasses.
      #
      # @api semipublic
      def set(resource, association)
        raise NotImplementedError, "#{self.class}#set not implemented"
      end

      # Sets "other end" of the association directly
      # as @ivar on given resource. Subclasses usually
      # use implementation of this class.
      #
      # @api semipublic
      def set!(resource, association)
        resource.instance_variable_set(instance_variable_name, association)
      end

      # Eager load the collection using the source as a base
      #
      # @param [Resource, Collection] source
      #   the source to query with
      # @param [Query, Hash] query
      #   optional query to restrict the collection
      #
      # @return [Collection]
      #   the loaded collection for the source
      #
      # @api private
      def eager_load(source, query = nil)
        target_maps = Hash.new { |h,k| h[k] = [] }

        collection_query = query_for(source, query)

        # TODO: create an object that wraps this logic, and when the first
        # kicker is fired, then it'll load up the collection, and then
        # populate all the other methods

        collection = source.model.all(collection_query).each do |target|
          target_maps[target_key.get(target)] << target
        end

        Array(source).each do |source|
          key = target_key.typecast(source_key.get(source))
          eager_load_targets(source, target_maps[key], query)
        end

        collection
      end

      # Checks if "other end" of association is loaded on given
      # resource.
      #
      # @api semipublic
      def loaded?(resource)
        assert_kind_of 'resource', resource, source_model

        resource.instance_variable_defined?(instance_variable_name)
      end

      # Test the source to see if it is a valid target
      #
      # @param [Object] source
      #   the resource or collection to be tested
      #
      # @return [Boolean]
      #   true if the resource is valid
      #
      # @api semipulic
      def valid?(source)
        case source
          when Array, Collection then valid_collection?(source)
          when Resource          then valid_resource?(source)
          else
            raise ArgumentError, "+source+ should be an Array or Resource, but was a #{source.class.name}"
        end
      end

      # Compares another Relationship for equality
      #
      # @param [Relationship] other
      #   the other Relationship to compare with
      #
      # @return [Boolean]
      #   true if they are equal, false if not
      #
      # @api public
      def eql?(other)
        return true if equal?(other)
        instance_of?(other.class) && cmp?(other, :eql?)
      end

      # Compares another Relationship for equivalency
      #
      # @param [Relationship] other
      #   the other Relationship to compare with
      #
      # @return [Boolean]
      #   true if they are equal, false if not
      #
      # @api public
      def ==(other)
        return true  if equal?(other)
        return false if kind_of_inverse?(other)

        other.respond_to?(:cmp_repository?, true) &&
        other.respond_to?(:cmp_model?, true)      &&
        other.respond_to?(:cmp_key?, true)        &&
        other.respond_to?(:query)                 &&
        cmp?(other, :==)
      end

      # Get the inverse relationship from the target model
      #
      # @api semipublic
      def inverse
        return @inverse if defined?(@inverse)

        if kind_of_inverse?(options[:inverse])
          return @inverse = options[:inverse]
        end

        relationships = target_model.relationships(relative_target_repository_name).values

        @inverse = relationships.detect { |relationship| inverse?(relationship) } ||
          invert

        @inverse.child_key

        @inverse
      end

      # TODO: document
      # @api private
      def relative_target_repository_name
        target_repository_name || source_repository_name
      end

      # TODO: document
      # @api private
      def relative_target_repository_name_for(source)
        target_repository_name || if source.respond_to?(:repository)
          source.repository.name
        else
          source_repository_name
        end
      end

      private

      # TODO: document
      # @api private
      attr_reader :child_properties

      # TODO: document
      # @api private
      attr_reader :parent_properties

      # Initializes new Relationship: sets attributes of relationship
      # from options as well as conventions: for instance, @ivar name
      # for association is constructed by prefixing @ to association name.
      #
      # Once attributes are set, reader and writer are created for
      # the resource association belongs to
      #
      # @api semipublic
      def initialize(name, child_model, parent_model, options = {})
        initialize_object_ivar('child_model',  child_model)
        initialize_object_ivar('parent_model', parent_model)

        @name                   = name
        @instance_variable_name = "@#{@name}".freeze
        @options                = options.dup.freeze
        @child_repository_name  = @options[:child_repository_name]
        @parent_repository_name = @options[:parent_repository_name]
        @child_properties       = @options[:child_key].try_dup.freeze
        @parent_properties      = @options[:parent_key].try_dup.freeze
        @min                    = @options[:min]
        @max                    = @options[:max]

        # TODO: normalize the @query to become :conditions => AndOperation
        #  - Property/Relationship/Path should be left alone
        #  - Symbol/String keys should become a Property, scoped to the target_repository and target_model
        #  - Extract subject (target) from Operator
        #    - subject should be processed same as above
        #  - each subject should be transformed into AbstractComparison
        #    object with the subject, operator and value
        #  - transform into an AndOperation object, and return the
        #    query as :condition => and_object from self.query
        #  - this should provide the best performance

        @query = @options.except(*self.class::OPTIONS).freeze

        create_reader
        create_writer
      end

      # Set the correct ivars for the named object
      #
      # This method should set the object in an ivar with the same name
      # provided, plus it should set a String form of the object in
      # a second ivar.
      #
      # @param [String]
      #   the name of the ivar to set
      # @param [#name, #to_str, #to_sym] object
      #   the object to set in the ivar
      #
      # @return [String]
      #   the String value
      #
      # @raise [ArgumentError]
      #   raise when object does not respond to expected methods
      #
      # @api private
      def initialize_object_ivar(name, object)
        if object.respond_to?(:name)
          instance_variable_set("@#{name}", object)
          initialize_object_ivar(name, object.name)
        elsif object.respond_to?(:to_str)
          instance_variable_set("@#{name}_name", object.to_str.dup.freeze)
        elsif object.respond_to?(:to_sym)
          instance_variable_set("@#{name}_name", object.to_sym)
        else
          raise ArgumentError, "#{name} does not respond to #to_str or #name"
        end

        object
      end

      # Creates reader method for association.
      #
      # Must be implemented by subclasses.
      #
      # @api semipublic
      def create_reader
        raise NotImplementedError, "#{self.class}#create_reader not implemented"
      end

      # Creates both writer method for association.
      #
      # Must be implemented by subclasses.
      #
      # @api semipublic
      def create_writer
        raise NotImplementedError, "#{self.class}#create_writer not implemented"
      end

      # Sets the association targets in the resource
      #
      # @param [Resource] source
      #   the source to set
      # @param [Array<Resource>] targets
      #   the targets for the association
      # @param [Query, Hash] query
      #   the query to scope the association with
      #
      # @return [undefined]
      #
      # @api private
      def eager_load_targets(source, targets, query)
        raise NotImplementedError, "#{self.class}#eager_load_targets not implemented"
      end

      # TODO: document
      # @api private
      def valid_collection?(collection)
        if collection.instance_of?(Array) || collection.loaded?
          collection.all? { |resource| valid_resource?(resource) }
        else
          collection.model <= target_model && (collection.query.fields & target_key) == target_key
        end
      end

      # TODO: document
      # @api private
      def valid_resource?(resource)
        resource.kind_of?(target_model) &&
        target_key.zip(target_key.get!(resource)).all? { |property, value| property.valid?(value) }
      end

      # TODO: document
      # @api private
      def inverse?(other)
        return true if @inverse.equal?(other)

        other != self                        &&
        kind_of_inverse?(other)              &&
        cmp_repository?(other, :==, :child)  &&
        cmp_repository?(other, :==, :parent) &&
        cmp_model?(other,      :==, :child)  &&
        cmp_model?(other,      :==, :parent) &&
        cmp_key?(other,        :==, :child)  &&
        cmp_key?(other,        :==, :parent)

        # TODO: match only when the Query is empty, or is the same as the
        # default scope for the target model
      end

      # TODO: document
      # @api private
      def inverse_name
        if options[:inverse].kind_of?(Relationship)
          options[:inverse].name
        else
          options[:inverse]
        end
      end

      # TODO: document
      # @api private
      def invert
        inverse_class.new(inverse_name, child_model, parent_model, inverted_options)
      end

      # TODO: document
      # @api private
      def inverted_options
        options.only(*OPTIONS - [ :min, :max ]).update(:inverse => self)
      end

      # TODO: document
      # @api private
      def options_with_inverse
        if child_model? && parent_model?
          options.merge(:inverse => inverse)
        else
          options.merge(:inverse => inverse_name)
        end
      end

      # TODO: document
      # @api private
      def kind_of_inverse?(other)
        other.kind_of?(inverse_class)
      end

      # TODO: document
      # @api private
      def cmp?(other, operator)
        name.send(operator, other.name)           &&
        cmp_repository?(other, operator, :child)  &&
        cmp_repository?(other, operator, :parent) &&
        cmp_model?(other,      operator, :child)  &&
        cmp_model?(other,      operator, :parent) &&
        cmp_key?(other,        operator, :child)  &&
        cmp_key?(other,        operator, :parent) &&
        query.send(operator, other.query)
      end

      # TODO: document
      # @api private
      def cmp_repository?(other, operator, type)
        # if either repository is nil, then the relationship is relative,
        # and the repositories are considered equivalent
        return true unless repository_name = send("#{type}_repository_name")
        return true unless other_repository_name = other.send("#{type}_repository_name")

        repository_name.send(operator, other_repository_name)
      end

      # TODO: document
      # @api private
      def cmp_model?(other, operator, type)
        send("#{type}_model?")       &&
        other.send("#{type}_model?") &&
        send("#{type}_model").base_model.send(operator, other.send("#{type}_model").base_model)
      end

      # TODO: document
      # @api private
      def cmp_key?(other, operator, type)
        property_method = "#{type}_properties"

        self_key  = send(property_method)
        other_key = other.send(property_method)

        self_key.send(operator, other_key)
      end
    end # class Relationship
  end # module Associations
end # module DataMapper
