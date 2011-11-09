unit=MiniTest::Unit.runner
pid=Kernel.fork do
  Dir.chdir(File.dirname(__FILE__))
  $:.push(".")
  Dir.glob("models/*_test.rb").each do |f|
    load f
  end
end
Process.wait(pid)

