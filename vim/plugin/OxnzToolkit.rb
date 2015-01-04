#!/usr/bin/env ruby
# File: ruby.rb.template
# Author: Oxnz
# Created
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
