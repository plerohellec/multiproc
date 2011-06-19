#!/usr/bin/env ruby

require 'open3'
require 'timeout'


puts "beginning"
stdin, stdout, stderr, wait_thr = Open3.popen3('sh')
pid = wait_thr[:pid]  # pid of the started process.
puts "spawned process, pid=#{pid}, wait_thr class=#{wait_thr.class}"

stdin.puts 'pwd'
r =  stdout.gets
puts "pwd=#{r}"

stdin.puts 'ls'
begin
    status = Timeout::timeout(0.1) do
        while(r =  stdout.gets(1024))
            puts "ls=#{r}"
        end
    end
    puts "status=#{status}"
rescue Timeout::Error => e
    puts "#{e.class} #{e}"
end

stdin.close  # stdin, stdout and stderr should be closed explicitly in this form.
stdout.close
stderr.close
puts "closed everything, starting wait..."
exit_status = wait_thr.value  # Process::Status object returned.

puts "done"


