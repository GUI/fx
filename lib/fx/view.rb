module Fx
  # @api private
  class View
    include Comparable

    attr_reader :name, :definition
    delegate :<=>, to: :name

    def initialize(view_row)
      @name = view_row.fetch("name")
      @definition = view_row.fetch("definition").strip
    end

    def ==(other)
      name == other.name && definition == other.definition
    end

    def to_schema
      <<-SCHEMA.indent(2)
create_view :#{name}, sql_definition: <<-\SQL
#{definition_with_create_statement.indent(4).rstrip}
SQL
      SCHEMA
    end

    private

    def definition_with_create_statement
      "CREATE VIEW #{name} AS\n#{definition}"
    end
  end
end
