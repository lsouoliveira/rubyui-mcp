# frozen_string_literal: true

require "test_helper"

module RubyUI_MCP
  module DocsApi
    class TestParser < BaseTest
      def test_component_references
        html = fixture_file("files/docs.html")
        parser = RubyUI_MCP::DocsApi::Parser.new(html)
        references = parser.parse_component_references

        assert_equal references.size, 43
        assert_equal references.first.name, "Accordion"
        assert_equal references.first.url, "/docs/accordion"
      end

      def test_component
        html = fixture_file("files/carousel.html")
        parser = RubyUI_MCP::DocsApi::Parser.new(html)
        component = parser.parse_component

        expected_example = <<~EXAMPLE
          Carousel(options: {loop:false}, class: "w-full max-w-xs") do\n\tCarouselContent do\n\t\t5.times do |index|\n\t\t\tCarouselItem do\n\t\t\t\tdiv(class: "p-1") do\n\t\t\t\t\tCard do\n\t\t\t\t\t\tCardContent(class: "flex aspect-square items-center justify-center p-6") do\n\t\t\t\t\t\t\tspan(class: "text-4xl font-semibold") { index + 1 }\n\t\t\t\t\t\tend\n\t\t\t\t\tend\n\t\t\t\tend\n\t\t\tend\n\t\tend\n\tend\n\tCarouselPrevious()\n\tCarouselNext()\nend
        EXAMPLE

        expected_dependency = <<~DEPENDENCY
          # frozen_string_literal: true\n\nmodule RubyUI\n\tclass Carousel < Base\n\t\tdef initialize(orientation: :horizontal, options: {}, **user_attrs)\n\t\t\t@orientation = orientation\n\t\t\t@options = options\n\n\t\t\tsuper(**user_attrs)\n\t\tend\n\n\t\tdef view_template(&)\n\t\t\tdiv(**attrs, &)\n\t\tend\n\n\t\tprivate\n\n\t\tdef default_attrs\n\t\t\t{\n\t\t\t\tclass: ["relative group", orientation_classes],\n\t\t\t\trole: "region",\n\t\t\t\taria_roledescription: "carousel",\n\t\t\t\tdata: {\n\t\t\t\t\tcontroller: "ruby-ui--carousel",\n\t\t\t\t\truby_ui__carousel_options_value: default_options.merge(@options).to_json,\n\t\t\t\t\taction: %w[\n\t\t\t\t\t\tkeydown.right->ruby-ui--carousel#scrollNext:prevent\n\t\t\t\t\t\tkeydown.left->ruby-ui--carousel#scrollPrev:prevent\n\t\t\t\t\t]\n\t\t\t\t}\n\t\t\t}\n\t\tend\n\n\t\tdef default_options\n\t\t\t{\n\t\t\t\taxis: (@orientation == :horizontal) ? "x" : "y"\n\t\t\t}\n\t\tend\n\n\t\tdef orientation_classes\n\t\t\t(@orientation == :horizontal) ? "is-horizontal" : "is-vertical"\n\t\tend\n\tend\nend
        DEPENDENCY

        assert_equal component.name, "Carousel"
        assert_equal component.description, "A carousel with motion and swipe built using Embla."
        assert_equal component.installation_cmd, "rails g ruby_ui:component Carousel"

        assert_equal component.examples.size, 4
        assert_equal component.examples.first.name, "Example"
        assert_equal component.examples.first.description, ""
        assert_equal component.examples.first.source, expected_example
        assert_equal component.examples[1].name, "Sizes"
        assert_equal component.examples[2].name, "Spacing"
        assert_equal component.examples[3].name, "Orientation"

        assert_equal 6, component.dependencies.size
        assert_equal "RubyUI::Carousel", component.dependencies.first.name
        assert_equal expected_dependency, component.dependencies.first.source
        assert_equal "RubyUI::CarouselContent", component.dependencies[1].name
        assert_equal "RubyUI::CarouselItem", component.dependencies[2].name
        assert_equal "RubyUI::CarouselNext", component.dependencies[3].name
        assert_equal "RubyUI::CarouselPrevious", component.dependencies[4].name
        assert_equal "carousel_controller.js", component.dependencies[5].name
      end
    end
  end
end
