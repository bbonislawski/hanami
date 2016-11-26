require 'hanami/environment'
require 'hanami/commands/command'
require 'hanami/generators/generatable'
require 'hanami/generators/test_framework'
require 'hanami/generators/template_engine'
require 'hanami/version'
require 'hanami/utils/string'

module Hanami
  module Commands
    class Generate
      class Abstract < Commands::Command

        include Hanami::Generators::Generatable

        attr_reader :options, :target_path

        def initialize(options)
          super

          @options = Hanami::Utils::Hash.new(options).symbolize!
          assert_options!

          @target_path = Hanami.root
        end

        def template_source_path
          generator = self.class.name.split('::').last.downcase
          Pathname.new(::File.dirname(__FILE__) + "/../../generators/#{generator}/").realpath
        end

        private

        def api?
          p hanamirc_options
          puts 'ASDASD'
          hanamirc_options.fetch(:api, false) || options.fetch(:api, false)
        end

        def test_framework
          @test_framework ||= Hanami::Generators::TestFramework.new(hanamirc, options[:test])
        end

        def hanamirc_options
          hanamirc.options
        end

        def hanamirc
          @hanamirc ||= Hanamirc.new(target_path)
        end

        def template_engine
          @template_engine ||= Hanami::Generators::TemplateEngine.new(hanamirc, options[:template])
        end

        def assert_options!
          if options.nil?
            raise ArgumentError.new('options must not be nil')
          end
        end

      end
    end
  end
end
