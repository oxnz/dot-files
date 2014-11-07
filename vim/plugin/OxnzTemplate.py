# This file is part of the OxnzTemplate Vim Plugin
# Copyright Oxnz 2014, All rights reserved.
# author: Oxnz
# coding: utf-8
# ref: http://learnvimscriptthehardway.stevelosh.com/chapters/24.html
# ref: http://www.ibm.com/developerworks/linux/library/l-vim-script-5/index.html

import os
import re
import vim
import sys
import time
import subprocess

def dbgout(obj):
    with open(os.path.join(vim.eval('fnamemodify(resolve(expand("<sfile>:p")), ":h")'), 'debug.out'), 'a') as f:
        print >>f, obj

class OxnzTemplateError(RuntimeError):
    '''general error class'''
    def __init__(self, message):
        message = '{}: {}'.format('OxnzTemplateError', message)
        super(OxnzTemplateError, self).__init__(message)

class OxnzTemplateNotFoundError(OxnzTemplateError):
    '''template file not found'''
    def __init__(self, message, filename):
        super(OxnzTemplateNotFoundError, self).__init__(message)
        self._filename = filename

    @property
    def filename(self):
        return self._filename

    def __str__(self):
        return '{}: [{}]'.format(self.message, self._filename)

class OxnzTemplateEngineError(RuntimeError):
    '''engine error'''
    def __init__(self, message, filetype):
        super(OxnzTemplateEngineError, self).__init__(message)
        self._filetype = filetype

    @property
    def filetype(self):
        return self._filetype

    def __str__(self):
        return 'OxnzTemplateEngineError(type:{}, message:{})'.format(self.filetype, self.message)

class OxnzTemplateCompileError(OxnzTemplateError):
    def __init__(self, message, template):
        super(OxnzTemplateCompileError, self).__init__(message)
        self._template = template

    @property
    def template(self):
        return self._template

    def __str__(self):
        return 'OxnzTemplateCompileError(template:{}, message:{})'.format(self.template, self.message)

class OxnzExecutor(object):
    pass

class OxnzWriter(object):
    def __init__(self):
        self._output = ''

    @property
    def content(self):
        return self._output

    def write(self, obj):
        self._output += str(obj)

class OxnzTemplateRedirect(object):
    def __init__(self, output, errput):
        self._stdout = sys.stdout
        self._stderr = sys.stderr
        self._output = output
        self._errput = errput

    def __enter__(self):
        sys.stdout = self._output
        sys.stderr = self._errput

    def __exit__(self, type_, value, traceback):
        if value:
            sys.stderr.write(value)
        sys.stdout = self._stdout
        sys.stderr = self._stderr
        return True

    def __del__(self):
        pass

class OxnzTemplate(object):
    '''template entity
    two classes supported:
    1. need to compile, i.e., executed to generate template content for renderer
    2. need not compile, just do render
    '''
    def __init__(self, tempdir, filetype):
        '''parameters:
            tempdir: template directory
            filetype: new file's type, NOT template file type
        '''
        self._filetype = filetype
        self._filename = '{}.template'.format(self._filetype)
        self._filepath = os.path.join(tempdir, self._filename)
        self._executable = os.access(self._filepath, os.X_OK)
        if self._executable:
            self._compcmd = [self._filepath]
        else:
            prog, args = self.__shebang()
            if prog:
                if args:
                    self._compcmd = [prog, args, self_filepath]
                else:
                    self._compcmd = [prog, self._filepath]
                self._compcmd += [self._filetype]
            else: # need not compile
                self.compcmd = None

    def __shebang(self):
        '''parse shebang in the first line

        It's actually the kernel that interprets that line, not bash.  The
        historical behavior is that space separates the interpreter from an
        optional argument, and there is no escape mechanism, so there's no way
        to specify an interpreter with a space in the path.  It's unlikely
        that this would ever change, since that would break existing scripts
        that rely on thecurrent behavior.
        ref: https://lists.gnu.org/archive/html/bug-bash/2008-05/msg00052.html
        '''
        with open(self._filepath) as f:
            line = f.readline().rstrip()
            m = re.match(r'#!(?P<prog>((?:/\w+)+))\s*(?P<args>(.*))$', line)
        if m:
            m = m.groupdict()
            prog = m['prog']
            args = m['args'] or None
            return prog, args
        else:
            return None, None
            #raise OxnzTemplateError("template shebang not found, first line is '{}'".format(line))

    @property
    def compcmd(self):
        '''return compile command if file is executable or shebang found in the first line'''
        return self._compcmd

    @property
    def needcomp(self):
        '''need compile or not'''
        return None != self._compcmd

    @property
    def needrender(self):
        ''' TODO: add implementation, could use filename trick:
                add noc suffix means nocompile
                add nor suffix means norender
                add nox suffix means noc & nor
        '''
        return True

    @property
    def content(self):
        '''return file content'''
        with open(self.filepath) as f:
            return f.read()

    @property
    def filepath(self):
        return self._filepath

    @property
    def filetype(self):
        return self._filetype

    def __str__(self):
        return self._filepath

class OxnzTemplateRenderer(object):
    '''template renderer'''
    def __init__(self, tempdir):
        '''
        esch: escape char
        optc: option code
        expr: any expression or variable name
        optchars = '|'.join([re.escape(c) for c in '~!@#$%^&*-+=\\<>.?/'])
        '''
        self._tempdir = tempdir
        self._regex = ''.join([
            r'(?P<esch>(^|\n|.))',  # start|newlilne|anychar
            r'(?P<pats>(',          # all the pattern, wrapper brackets `[]' included
            r'\[',                  # start `['
            r'(?P<optc>([\~|\!|\@|\#|\$|\%|\^|\&|\*|\-|\+|\=|\\|\||\<|\>|\.|\?|\/])(?!\\))',    # option code char
            r'(?P<expr>((?:\\\]|[^]])*?))',     # any thing else before the close `]'
            r'\]',                  # close `]'
            r'))'
        ])
        self._esch = '\\'

        self._optdct = {
            '$': lambda pats, optc, expr: self.__load_cfg_var(expr),
            '&': lambda pats, optc, expr: self.__load_vim_var(expr),
            '=': lambda pats, optc, expr: self.__eval_python_exp(expr),
            '+': lambda pats, optc, expr: self.__exec_python_stmt(expr),
            '!': lambda pats, optc, expr: self.__exec_shell_stmt(expr),
            '~': lambda pats, optc, expr: self.__eval_vim_exp(expr),
            '@': lambda pats, optc, expr: self.__load_file_content(expr),
        }

        self._vardict = {
            'FPATH':    vim.eval('expand("%:p")'),
            'FNAME':    vim.eval('expand("%:t")'),
            'FBASE':    vim.eval('expand("%:r")'),
            'FEXT':     vim.eval('expand("%:e")'),
            'FDIR':     vim.eval('expand("%:p:h")'),
            'AUTHOR':   vim.eval('g:OxnzTemplateAuthor'),
            'EMAIL':    vim.eval('g:OxnzTemplateEmail'),
            'USER':     os.getlogin(),
            'HOSTNAME': self.__exec_shell_stmt('hostname'),
            'COPYRIGHT':'Copyright {} {}, ALl Rights Reserved'.format(os.getlogin(), time.strftime('%Y'))
        }
        pass

    def __exec_python_stmt(self, stmt):
        '''http://stackoverflow.com/questions/2220699/whats-the-difference-between-eval-exec-and-compile-in-python'''
        out, err = OxnzWriter(), OxnzWriter()
        with OxnzTemplateRedirect(out, err):
            exec(stmt)
        out = out.content
        err = err.content

        if len(err) > 0:
            raise OxnzTemplateError("error occurred while executing python statement '{}', error message is '{}'".format(stmt, err))
        return out

    def __load_cfg_var(self, name):
        return self._vardict.get(name, 'cfg:'+name.lower())

    def __load_vim_var(self, name):
        '''expand:
			:p		expand to full path
			:h		head (last path component removed)
			:t		tail (last path component only)
			:r		root (one extension removed)
			:e		extension only
        '''
        return vim.eval(name)

    def __eval_python_exp(self, expr):
        '''python eval'''
        try:
            return eval(expr)
        except NameError as e:
            raise OxnzTemplateError("invalid expression '{}'".format(expr))

    def __exec_shell_stmt(self, stmt):
        try:
            task = subprocess.Popen([stmt], bufsize=-1, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            stdoutdata, stderrdata = task.communicate()
            returncode = task.returncode
            if returncode < 0:
                raise OxnzTemplateError("shell command was terminated by signal '{}'".format(returncode))
            elif returncode == 0:
                if len(stderrdata) != 0:
                    raise OxnzTemplateError("shell command exited with non-empty stderr output: '{}'".format(stderrdata))
                return stdoutdata.rstrip()
            else:
                raise  OxnzTemplateError("shell command exit with non-zero status '{}'".format(returncode))
        except OSError as e:
            raise OxnzTemplateError("shell command execute failed: '{}'".format(e))

    def __eval_vim_exp(self, expr):
        return 'vxm done'

    def __load_file_content(self, expr):
        return 'file:' + expr

    def __erronf(self, pats, optc, expr):
        '''error on option not found, i.e. not in self._optdct'''
        raise OxnzTemplateError("handler for option code '{}' not exists, full pattern is '{}'".format(optc, pats))

    def __sub(self, match):
        '''do substitute'''
        groupdict = match.groupdict()
        esch, pats, optc, expr = [ groupdict[key] for key in ['esch', 'pats', 'optc', 'expr'] ]
        if esch == self._esch:
            return pats
        subfunc = self._optdct.get(optc, self.__erronf)
        print 'matched' + pats
        return esch + subfunc(pats, optc, expr)

    def render(self, content):
        return re.sub(self._regex, self.__sub, content)

class OxnzTemplateEngine(object):
    '''template engine
    [compile] -> render -> insert
    '''
    def __init__(self):
        self._plugdir = vim.eval('fnamemodify(resolve(expand("<sfile>:p:h")), ":h")')
        self._tempdir = os.path.join(self._plugdir, 'templates')
        self._renderer = OxnzTemplateRenderer(self._tempdir)

    def render(self, content):
        '''content is string'''
        content = self._renderer.render(content)
        return content.split('\n')

    def compile(self, template):
        '''compile template
        pass filetype as first argument
        '''
        task = subprocess.Popen(template.compcmd, bufsize=-1, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        print template.compcmd + [template.filetype]
        stdoutdata, stderrdata = task.communicate()
        returncode = task.returncode
        if returncode or stderrdata:
            raise OxnzTemplateCompileError('OxnzTemplateCompileError(code:{}, message:{})'.format(retcode, error))
        return stdoutdata

    def insert(self, filetype):
        if len(filetype) != 1:
            raise OxnzTemplateError("invalid filetype '{}'".format(filetype))
        filetype = filetype[0]
        try:
            template = OxnzTemplate(self._tempdir, filetype)
        except IOError as e:
            if os.errno.errorcode[e.errno] == 'ENOENT': 
                # Error NO ENtry
                raise OxnzTemplateNotFoundError('template not found', e.filename)
            else:
                raise OxnzTemplateError('template init failed: {}'.format(e))
        if template.needcomp:
            content = self.compile(template)
        else:
            content = template.content
        vim.current.buffer[:] = self.render(content)

    def execmd(self, name, args):
        commands = {
            'insert': self.insert
        }
        cmd = commands.get(name, self.__errcnf(name))
        cmd(args)

    def __errcnf(self, command):
        def errfunc(args):
            raise OxnzTemplateError("command '{}' not found".format(command))
        return errfunc

if __name__ == '__main__':
    try:
        cmdname = vim.eval('a:cmd')
        cmdargs = vim.eval('a:000')
        engine = OxnzTemplateEngine()
        engine.execmd(cmdname, cmdargs)
    except OxnzTemplateNotFoundError as e:
        print e
        pass
    except OxnzTemplateCompileError as e:
        print e
    except OxnzTemplateError as e:
        print e
        #print >>sys.stderr, e
    except vim.error as e:
        print e
    except:
        #raise vim.error('Unexpected error:', sys.exc_info()[0])
        raise
