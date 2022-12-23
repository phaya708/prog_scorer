require 'pathname'
require 'colorize'

class Score
  def initialize(report_number, report_name)
    @s = ""
    @report_number = report_number
    @report_name = report_name
    @root_dir = "#{@report_number}/#{report_name}"
    @results_path = "#{@root_dir}/results.txt"
  end
  
  def write_file()
    File.open(@results_path, mode = "w"){|f|
      f.write(@s)  # ファイルに書き込む
    }

    if(!File.exist?("a.out"))
      system("rm a.out")
    end
  end

  def compile(cmd, files, student_number)
    code = "#{cmd}"
    for file in files do
      code += " #{file}"
    end
    if system(code)
      if Dir.glob("#{@root_dir}/testdata/*").count == 0 
        puts "#{student_number}: #{"success".colorize(:green)}"
        @s += "#{student_number}: !ok\n"
      else
        test(student_number)
      end
    else 
      puts "#{student_number}: #{"compile error".colorize(:red)}"
      @s += "#{student_number}: !NG/compile error\n"
    end
  end

  def test(student_number)
    Dir.glob("#{@root_dir}/testdata/*") do |input_dir|
      basename = input_dir.match(/\w+\z/)[0]
      output_path = "#{@root_dir}/outputs/#{student_number}/#{basename}.txt"

      mkdir("#{@root_dir}/outputs/#{student_number}")
      mkdir("#{@root_dir}/diff/#{student_number}")

      system("./a.out < #{input_dir}/in.txt > #{output_path}")
      diff_cmd = "diff -Bw #{@root_dir}/outputs/#{student_number}/#{basename}.txt #{input_dir}/exp.txt "
      diff(diff_cmd, "#{@root_dir}/diff/#{student_number}/#{basename}.txt", student_number)
    end
  end

  def diff(code, output_path, student_number)
    if(system("#{code} > #{output_path}"))
      puts "#{student_number}: #{"success".colorize(:green)}"
      @s += "#{student_number}: !ok\n"
    else
      puts "#{student_number}: #{"diff error".colorize(:red)}"
      @s += "#{student_number}: !NG/diff error\n"
    end
  end
end