require 'prog_scorer'
require "prog_scorer/score"

RSpec.describe ProgScorer do
  it "has a version number" do
    expect(ProgScorer::VERSION).not_to be nil
  end

  it "should make directory" do
    if(Dir.exist?("test_number"))
      system("rm -r test_number")
    end
    ProgScorer::CLI.new.init("test_number", "test_name")
    aggregate_failures do
      expect(Dir.exist?("test_number")).to eq(true)
      expect(Dir.exist?("test_number/test_name")).to eq(true)
      expect(Dir.exist?("test_number/test_name/src")).to eq(true)
      expect(Dir.exist?("test_number/test_name/outputs")).to eq(true)
      expect(Dir.exist?("test_number/test_name/testdata")).to eq(true)
      expect(Dir.exist?("test_number/test_name/testdata/test1")).to eq(true)
      expect(Dir.exist?("test_number/test_name/tmp")).to eq(true)
    end
  end

  it "should print compile result error" do
    if(Dir.exist?("test_number"))
      system("rm -r test_number")
    end
    ProgScorer::CLI.new.init("test_number", "test_name")
    
    system("cp spec/files/test_compile.c test_number/test_name/src/1234.c")
    system("cp spec/files/in.txt test_number/test_name/testdata/test1/in.txt")
    system("cp spec/files/exp.txt test_number/test_name/testdata/test1/exp.txt")

    score = Score.new("test_number", "test_name")

    aggregate_failures do
      expect{score.compile("gcc", ["test_number/test_name/src/1234.c"], "1234")}.to output("1234: #{"compile error".colorize(:red)}\n").to_stdout 
    end
  end


  it "should print compile result success" do
    if(Dir.exist?("test_number"))
      system("rm -r test_number")
    end
    ProgScorer::CLI.new.init("test_number", "test_name")
    
    system("cp spec/files/test.c test_number/test_name/src/1234.c")
    system("cp spec/files/in.txt test_number/test_name/testdata/test1/in.txt")
    system("cp spec/files/exp.txt test_number/test_name/testdata/test1/exp.txt")

    score = Score.new("test_number", "test_name")

    aggregate_failures do
      expect{score.compile("gcc", ["test_number/test_name/src/1234.c"], "1234")}.to output("1234: #{"success".colorize(:green)}\n").to_stdout 
    end
  end

  it "should print diff result success" do
    if(Dir.exist?("test_number"))
      system("rm -r test_number")
    end
    ProgScorer::CLI.new.init("test_number", "test_name")

    mkdir("test_number/test_name/outputs/1234")
    mkdir("test_number/test_name/diff/1234")
    system("cp spec/files/exp.txt test_number/test_name/outputs/1234/test1.txt")
    system("cp spec/files/exp.txt test_number/test_name/testdata/test1/exp.txt")

    score = Score.new("test_number", "test_name")
    diff_cmd = "diff -Bw test_number/test_name/outputs/1234/test1.txt test_number/test_name/testdata/test1/exp.txt"

    aggregate_failures do
      expect{score.diff(diff_cmd, "test_number/test_name/diff/1234/test1.txt", "1234")}.to output("1234: #{"success".colorize(:green)}\n").to_stdout
    end
  end

  it "should print diff result error" do
    if(Dir.exist?("test_number"))
      system("rm -r test_number")
    end
    ProgScorer::CLI.new.init("test_number", "test_name")

    mkdir("test_number/test_name/outputs/1234")
    mkdir("test_number/test_name/diff/1234")
    system("cp spec/files/exp.txt test_number/test_name/outputs/1234/test1.txt")
    system("cp spec/files/in.txt test_number/test_name/testdata/test1/exp.txt")

    score = Score.new("test_number", "test_name")
    diff_cmd = "diff -Bw test_number/test_name/outputs/1234/test1.txt test_number/test_name/testdata/test1/exp.txt"

    aggregate_failures do
      expect{score.diff(diff_cmd, "test_number/test_name/diff/1234/test1.txt", "1234")}.to output("1234: #{"diff error".colorize(:red)}\n").to_stdout
    end
  end
end
