require 'simplecov'

require_relative 'simplecov-workspace-lcov/version'
require_relative 'simplecov-workspace-lcov/configuration'

module SimpleCov
  module Formatter
    class WorkspaceLcovFormatter
      def format(result)
        create_output_directory!

        if report_with_single_file?
          write_lcov_to_single_file!(result.files)
        else
          result.files.each { |file| write_lcov!(file) }
        end

        puts "Lcov style coverage report generated for #{result.command_name} to #{lcov_results_path}"
      end

      class << self
        def config
          @config ||= Configuration.new

          yield @config if block_given?

          @config
        end
      end

      private

      def output_directory
        self.class.config.output_directory
      end

      def lcov_results_path
        report_with_single_file? ? single_report_path : output_directory
      end

      def report_with_single_file?
        self.class.config.report_with_single_file?
      end

      def single_report_path
        self.class.config.single_report_path
      end

      def root_path
        self.class.config.workspace_path
      end

      def create_output_directory!
        return if Dir.exist?(output_directory)
        FileUtils.mkdir_p(output_directory)
      end

      def write_lcov!(file)
        File.open(File.join(output_directory, output_filename(file.filename)), 'w') do |f|
          f.write format_file(file)
        end
      end

      def write_lcov_to_single_file!(files)
        File.open(single_report_path, 'w') do |f|
          files.each { |file| f.write format_file(file) }
        end
      end

      def output_filename(filename)
        filename.gsub("#{SimpleCov.root}/", '').gsub('/', '-')
          .tap { |name| name << '.lcov' }
      end

      def format_file(file)
        filename = file.filename.gsub("#{root_path}/", './')
        "SF:#{filename}\n#{format_lines(file)}\nend_of_record\n"
      end

      def format_lines(file)
        filtered_lines(file)
          .map { |line| format_line(line) }
          .join("\n")
      end

      def filtered_lines(file)
        file.lines.reject(&:never?).reject(&:skipped?)
      end

      def format_line(line)
        "DA:#{line.number},#{line.coverage}"
      end
    end
  end
end
