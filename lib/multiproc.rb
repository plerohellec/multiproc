#!/usr/bin/env ruby

require 'open3'
require 'timeout'


class Multiproc

  attr_reader :statuses

  # cmds: array of string, each one being a command
  def initialize(cmds)
    raise Exception unless cmds.is_a? Array

    nonstrings = cmds.select { |cmd| !cmd.is_a? String }
    raise Exception unless nonstrings.size==0

    @cmds = cmds
    @childs = []
    @statuses = []
    cmds.size.times{ @statuses << nil }
  end

  # fork for each command
  def start
    n = 0
    @cmds.each do |cmd|
      stdin, stdout, stderr, wait_thr = Open3.popen3(cmd)
      @childs[n] = { :thr => wait_thr, :in => stdin, :out => stdout, :err => stderr }
      n += 1
    end
  end

  # wait and pickup all dead processes
  def wait
    for n in 0..@childs.size-1
      c = @childs[n]
      c[:in].close
      c[:out].close
      c[:err].close
      @statuses[n] = c[:thr].value
    end
  end

  # count the number of processes that are still running
  def check
    num_running = 0
    for n in 0..@childs.size-1
      if(@childs[n][:thr].alive?)
        num_running += 1
      end
    end
    return num_running
  end
end


# cmds = ['sleep 5', 'ls jhjh']
#
# mtp = Multiproc.new(cmds)
# mtp.start
# mtp.wait
#
# cmds.each_index do |i|
#     puts "#{cmds[i]}: #{mtp.statuses[i]}"
# end
#
# puts "done"


