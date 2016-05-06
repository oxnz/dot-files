#!/usr/bin/env ruby
#
# Copyright (c) 2013-2016 Will Z
# All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# File: ruby.rb.template
# Author: Will Z
# Description: template file for filetype: [ruby] with suffix: [rb]
# ref: http://items.sjbach.com/97/writing-a-vim-plugin
#

def VIM::has ident
	# All return values from `evaluate` are strings, and
	#   # "0" evaluates to true in ruby.
	return VIM::evaluate("has('#{ident}')") != '0'
end

class OxnzToolkit
	def initialize
	end

	def msg lvl = 'normal', msg
		msg = '"' + msg + '"'
		case lvl
		when 'normal'
			VIM::command "echo #{msg}"
		when 'warning'
			VIM::command "echohl WarningMsg | echo #{msg} | echohl None"
		when 'error'
			VIM::command "echohl ErrorMsg | echo #{msg} | echohl None"
		else
			msg 'error', "invalid message level: #{lvl}, message: #{msg}"
		end
	end

	def :
	def rubyinfo
		msg %{Ruby Info:
Version: #{RUBY_VERSION}
Platform: #{RUBY_PLATFORM}
Release Date: #{RUBY_RELEASE_DATE}}
	end

	def errcnf command
		fail ArgumentError, "command not found: #{command}"
	end

	def cmd name
		commands = {
			rubyinfo: ->{rubyinfo},
		}
		commands[name.to_sym] or errcnf cmd
	end

	def eva expr
		VIM::evaluate expr
	end

	def do
		name = eva 'a:cmd'
		args = eva 'a:000'
		cmd = cmd name
		if args.length == 0
			cmd.call
		else
			cmd.call args
		end
	end
end

if __FILE__ == $0 or 'vim-ruby' == $0
	begin
		OxnzToolkit.new.do
	rescue Interrupt => e
		$stderr.puts "Interrupted"
	rescue => e
		$stderr.puts "#{$0}: #{e}"
	rescue
		raise
	end
end
