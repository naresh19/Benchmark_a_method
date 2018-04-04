module BenchmarkMod
  require 'benchmark'
  def benchmark *args
    puts "initiating benchmarking"
    self.class_eval do
      args.each do |method_name|
        define_method (method_name.to_s+"_with_benchmark").to_s do
          method_result = nil
          benchmark_output = Benchmark.measure{|x| method_result = send((method_name.to_s+"_without_benchmark").to_sym)}
          puts "#{method_name.to_s} took #{benchmark_output.real.round(2)} secs"
          method_result
        end        
      end
    end
    args.each do |method_name|
      alias_method (method_name.to_s+"_without_benchmark").to_sym, method_name
      alias_method method_name, (method_name.to_s+"_with_benchmark").to_sym
    end
  end
end
class Foo
  extend BenchmarkMod
  def bar
    #do something
    puts "start bar: #{Time.now}"
    sleep(2)
  end
  def foo
    #do something
    puts "start foo : #{Time.now}"
    sleep(0.3)
  end
  benchmark :bar, :foo
end

a = Foo.new
puts a.bar #start bar: 2018-04-04 18:31:30 +0530
           #bar took 2.0 secs
puts a.foo start #foo : 2018-04-04 18:38:38 +0530
                 #foo took 0.3 secs
