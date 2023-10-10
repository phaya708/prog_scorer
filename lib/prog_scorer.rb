require "prog_scorer/version"
require "prog_scorer/score"
require "prog_scorer/common"
require 'thor'

module ProgScorer
  class Error < StandardError; end
  class CLI < Thor
    desc "init {report_number} {report_name}", "Create Report File"
    def init(report_number, report_name)
      if(report_number && report_name)
        mkdir("#{report_number}")

        if(mkdir("#{report_number}/#{report_name}"))
          mkdir("#{report_number}/#{report_name}/outputs")
          mkdir("#{report_number}/#{report_name}/diff")
          mkdir("#{report_number}/#{report_name}/src")
          mkdir("#{report_number}/#{report_name}/tmp")
          mkdir("#{report_number}/#{report_name}/testdata")
          mkdir("#{report_number}/#{report_name}/testdata/test1")
          system("touch #{report_number}/#{report_name}/testdata/test1/in.txt")
          system("touch #{report_number}/#{report_name}/testdata/test1/exp.txt")
          system("touch #{report_number}/#{report_name}/testdata/test1/exp.txt")
        else
          p "ERROR: '#{report_name}' is already exist"
        end
        
      else
        p "ERROR: Statement argument missing"
      end
    end

    desc "score {compiler} {report_number} {report_name}", "Score program files"
    def score(compiler, report_number, report_name="*", student_number="*")
      if(compiler == "gcc")
        language = {"ext" => "c", "command" => "gcc"}
      elsif(compiler == "g++")
        language = {"ext" => "cpp", "command" => "g++"}
      else
        puts "#{"error".colorize(:red)} :コマンド引数が正しくありません"
        return
      end
      root_dirs = Dir.glob("#{report_number}/#{report_name}")

      for root_dir in root_dirs do
        report_name = root_dir.split("/")[-1]
        p dir = "#{root_dir}/src/#{student_number}.#{language["ext"]}"
        score = Score.new(report_number, report_name)
        Dir.glob(dir).each do |file|
          system("cp #{file} #{root_dir}/tmp/#{report_name}.#{language["ext"]}")
          #system("gcc #{file} #{main_filename}")
          test_files = []
          student_number = Pathname(file).basename(".*")
          puts "#{student_number} scoring... "
          Dir.glob("#{root_dir}/tmp/*.#{language["ext"]}").each do |file|
            test_files.append(file)
          end
          score.compile(language["command"], test_files, student_number)
        end
        score.write_file()
      end
    end
  end
end
