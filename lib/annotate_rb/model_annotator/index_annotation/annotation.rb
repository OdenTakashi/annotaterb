# frozen_string_literal: true

module AnnotateRb
  module ModelAnnotator
    module IndexAnnotation
      class Annotation
        HEADER_TEXT = "Indexes"

        def initialize(indexes)
          @indexes = indexes
        end

        def body
          [
            Components::BlankCommentLine.new,
            Components::Header.new(HEADER_TEXT),
            Components::BlankCommentLine.new,
            *@indexes
          ]
        end

        def to_markdown
          body.map(&:to_markdown).join("\n")
        end

        def to_default
          body.map(&:to_default).join("\n")
        end
      end
    end
  end
end
