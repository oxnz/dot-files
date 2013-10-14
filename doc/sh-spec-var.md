#Shell Specific Variables


1. Positional parameters $1,$2,$3… and their corresponding array representation, count and IFS expansion $@, $#, and $*.
2. $- current options set for the shell.
3. $$ pid of the current shell (not subshell)
4. $_ most recent parameter (or the abs path of the command to start the current shell immediately after startup)
5. $IFS the (input) field separator
6. $? most recent foreground pipeline exit status
7. $! PID of the most recent background command
8. $0 name of the shell or shell script
9. $# number of arguments passed to current script
10. $* / $@ list of arguments passed to script as string / delimited list

>And then there are all the environment variables set by the shell ('Shell Variables' section of man(1) bash)

>They are all documented in the bash man page. The only oddity is that $_ is only mentioned in the context of its use in the MAILPATH variable

>in man(1) bash under Special Parameters for the rest of the definition of $_

[gnu official document](http://www.gnu.org/software/bash/manual/bashref.html#Special-Parameters)