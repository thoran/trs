# lib/program_loader.rb

class ProgramNotFoundError < RuntimeError; end

class ProgramLoader

  class << self

    def default_programs_directory
      File.join(File.dirname(__FILE__), '../programs')
    end

    def default_program
      random_program(default_programs_directory)
    end

    def random_program(programs_directory)
      begin
        program_filenames = Dir["#{programs_directory}/*.program"]
        if program_filenames.empty?
          raise ProgramNotFoundError
        else
          File.basename(program_filenames[rand(program_filenames.size)])
        end
      rescue ProgramNotFoundError => e
        puts "No program found."
        exit
      end
    end

  end # class << self

  def initialize(**args)
    @program_name = args[:program_name] || self.class.default_program
    @programs_directory = args[:programs_directory] || self.class.default_programs_directory
  end

  def load
    File.read(filename)
  end

  private

  def filename
    if File.exist?(File.join(@programs_directory, @program_name + '.program'))
      File.join(@programs_directory, @program_name + '.program')
    elsif File.exist?(File.join(@programs_directory, @program_name)) && File.extname(@program_name) == '.program'
      File.join(@programs_directory, @program_name)
    else
      raise ProgramNotFoundError
    end
  rescue ProgramNotFoundError => e
    puts "Program '#{@program_name}' not found."
    exit
  end

end
