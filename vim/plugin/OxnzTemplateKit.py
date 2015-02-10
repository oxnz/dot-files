# This file is part of the OxnzTemplateKit Vim Plugin
# Copyright Oxnz 2014, All rights reserved.
# author: Oxnz
# coding: utf-8
#
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


class OxnzVimUtils(object):
    def __init__(self):
        pass

    def input(self, prompt):
        vimvar = 'answer'
        vim.command('call inputsave()')
        vim.command('let {} = input("{}: ")'.format(vimvar, prompt.replace('"', "'")))
        vim.command('call inputrestore()')
        answer = vim.eval(vimvar)
        vim.command('unlet {}'.format(vimvar))
        return answer

class OxnzTemplateKitError(RuntimeError):
    '''general error class'''
    def __init__(self, message):
        super(OxnzTemplateKitError, self).__init__(message)

class OxnzTemplateError(OxnzTemplateKitError):
    '''template error'''
    def __init__(self, message, filetype, filepath, *args):
        super(OxnzTemplateError, self).__init__(message)
        self._filetype = filetype
        if filepath:
            self._filepath = filepath
            self._filename = os.path.basename(self._filepath)
        else:
            self._filepath = None
            self._filename = None
        self._args = args

    @property
    def filepath(self):
        return self._filepath

    @property
    def filename(self):
        return self._filename

    def __str__(self):
        return 'OxnzTemplateError(message:{}, template:{})'.format(self.message, self.filepath)

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

class OxnzTemplateCompileError(OxnzTemplateKitError):
    def __init__(self, template, code, message):
        super(OxnzTemplateCompileError, self).__init__(message)
        self._template = template
        self._code = code
        self._strfmt = 'OxnzTemplateCompileError(template:{}, command:{}, exitcode:{}, stderr:{})'

    @property
    def template(self):
        return self._template

    @property
    def code(self):
        return self._code

    def __str__(self):
        return self._strfmt.format(self._template, self._template.compcmd, self._code, self.message)

class OxnzExecutor(object):
    @classmethod
    def execute(command):
        pass
    pass

class OxnzWriter(object):
    def __init__(self):
        self._output = ''

    @property
    def content(self):
        return self._output

    def write(self, obj):
        self._output += str(obj)

class OxnzTemplateKitRedirect(object):
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
            template filename pattern:
            like:
                c.h.template
                cpp.c++.template
                python.py.template
                ruby.rb.template
        '''
        self._tempdir = tempdir
        self._filetype = filetype
        self._target = vim.eval('expand("%:p")')
        self._prefix = self._filetype + os.path.splitext(self._target)[1]
        self._infix = None
        self._suffix = 'template'
        # no[x] property dict
        self._infixdict = {
        #   no[x]  compilable, renderable
            'noa': {'_compilable': False, '_renderable': False},
            'noc': {'_compilable': False, '_renderable': True},
            'nor': {'_compilable': True , '_renderable': False},
        }
        self.__findtemp()
        self.__checktemp()

    def __checktemp(self):
        '''
        set up self._compcmd
        self._executable
        self._renderable
        return compile command if file is executable or shebang found in the first line
        NOTE: add filetype as first positional argument, filepath as second argument
        '''
        if self._infix:
            self._compilable = self._infixdict[self._infix]['_compilable']
            self._renderable = self._infixdict[self._infix]['_renderable']
        else:
            self._compilable = True
            self._renderable = True
        self._compcmd = None
        if self._compilable:
            if os.access(self._filepath, os.X_OK):
                self._compcmd = [self._filepath]
            else:
                prog, args = self.__shebang()
                if prog:
                    if args:
                        self._compcmd = [prog, args, self._filepath]
                    else:
                        self._compcmd = [prog, self._filepath]
                else:
                    raise OxnzTemplateError("template compile command not found", self._filetype, self._filepath)
            self._compcmd += [self._filetype, self._target]

    def __findtemp(self):
        '''find template file accroding to template name pattern:
                default: {filetype}.{suffix}.template
                special: {filetype}.{suffix}.no[a-z].template
        '''
        defpath = os.path.join(self._tempdir, '{}.{}'.format(self._prefix, self._suffix))
        if os.path.isfile(defpath):
            self._filepath = defpath
        else:
            filepaths = []
            infixes = []
            for infix in self._infixdict:
                filepath = os.path.join(self._tempdir, '{}.{}.{}'.format(self._prefix, infix, self._suffix))
                if os.path.isfile(filepath):
                    filepaths.append(filepath)
                    infixes.append(infix)
            foundcnt = len(filepaths)
            if foundcnt == 0:
                raise OxnzTemplateError("template file not found", self._filetype, defpath)
            elif foundcnt > 1:
                raise OxnzTemplateError("multiple template files found", self._filetype, defpath, [os.path.basename(fpath) for fpath in filepaths])
            self._filepath = filepaths[0]
            self._infix = infixes[0]
        self._filename = os.path.basename(self._filepath)

    def __shebang(self):
        '''parse shebang in the first line, return prog and args

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
            #raise OxnzTemplateKitError("template shebang not found, first line is '{}'".format(line))

    @property
    def compcmd(self):
        return self._compcmd

    @property
    def compilable(self):
        '''need compile or not'''
        return self._compilable

    @property
    def renderable(self):
        return self._renderable

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
    def __init__(self, content, strict=True):
        '''
        content: need to be rendered
        strict: in mode when error, throw immediatly

        esch: escape char
        optc: option code
        expr: any expression or variable name
        optchars = '|'.join([re.escape(c) for c in '~!@#$%^&*-+=\\<>.?/'])
        '''
        self._content = content
        self._strict = True
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
            'AUTHOR':   self.__load_vim_var('g:OxnzTemplateAuthor', 'AUTHOR'),
            'EMAIL':    self.__load_vim_var('g:OxnzTemplateEmail', 'EMAIL'),
            'VERSION':  '0.0.1',
            'USER':     os.getlogin(),
            'HOSTNAME': self.__exec_shell_stmt('hostname'),
            'COPYRIGHT':'Copyright {} {}, ALl Rights Reserved'.format(os.getlogin(), time.strftime('%Y')),
            'CURSOR':   self.__place_cursor(),
        }
        pass

    def __place_cursor(self):
        # TODO: add implemente
        pass

    def __call__(self):
        '''render content'''
        return re.sub(self._regex, self.__sub, self._content)

    def __exec_python_stmt(self, stmt):
        '''http://stackoverflow.com/questions/2220699/whats-the-difference-between-eval-exec-and-compile-in-python'''
        out, err = OxnzWriter(), OxnzWriter()
        with OxnzTemplateKitRedirect(out, err):
            exec(stmt)
        out = out.content
        err = err.content

        if len(err) > 0:
            raise OxnzTemplateKitError("error occurred while executing python statement '{}', error message is '{}'".format(stmt, err))
        return out

    def __load_cfg_var(self, name):
        '''return variables predefined in self._vardict'''
        return self._vardict.get(name, self.__errvnf(name, lambda: name))

    def __load_vim_var(self, name, *default):
        '''return value for name if exists, otherwise throw NameError if default is not given
        expand:
			:p		expand to full path
			:h		head (last path component removed)
			:t		tail (last path component only)
			:r		root (one extension removed)
			:e		extension only
        '''
        defcnt = len(default)
        try:
            if vim.eval('exists({})'.format(name.replace("'", '"'))):
                return vim.eval(name)
        except vim.error as e:
            #print "Warning: {}: '{}'".format(e, name)
            pass
        if defcnt > 1:
            #raise TypeError("'__load_vim_var' takes 2 or 3 arguments ({} given)".format(defcnt))
            return self.__errvnf(name, lambda: name)
        elif defcnt == 0:
            raise NameError("name '{}' is not defined".format(name))
        return default[0]

    def __eval_python_exp(self, expr):
        '''python eval'''
        try:
            return eval(expr)
        except NameError as e:
            raise OxnzTemplateKitError("invalid expression '{}'".format(expr))

    def __exec_shell_stmt(self, stmt):
        try:
            stmt = stmt.replace('\\[', '[').replace('\\]', ']')
            task = subprocess.Popen([stmt], shell=True, bufsize=-1, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            stdoutdata, stderrdata = task.communicate()
            returncode = task.returncode
            if returncode < 0:
                raise OxnzTemplateKitError("shell command was terminated by signal '{}'".format(returncode))
            elif returncode == 0:
                if len(stderrdata) != 0:
                    raise OxnzTemplateKitError("shell command exited with non-empty stderr output: '{}'".format(stderrdata))
                return stdoutdata.rstrip()
            else:
                raise  OxnzTemplateKitError("shell command exit with non-zero status '{}'".format(returncode))
        except OSError as e:
            raise OxnzTemplateKitError("shell command execute failed: '{}'".format(e))

    def __eval_vim_exp(self, expr):
        try:
            return vim.eval(expr)
        except vim.error as e:
            return expr

    def __load_file_content(self, expr):
        return 'file:' + expr

    def __erronf(self, pats, optc, expr):
        '''error on option not found, i.e. not in self._optdct'''
        raise OxnzTemplateKitError("handler for option code '{}' not exists, full pattern is '{}'".format(optc, pats))

    def __errvnf(self, name, func):
        '''error on variable not found'''
        return func()

    def __sub(self, match):
        '''do substitute'''
        # export current match to whole object
        self._curmatch = match
        groupdict = match.groupdict()
        esch, pats, optc, expr = [ groupdict[key] for key in ['esch', 'pats', 'optc', 'expr'] ]
        if esch == self._esch:
            return pats
        subfunc = self._optdct.get(optc, self.__erronf)
        return esch + subfunc(pats, optc, expr)

class OxnzTemplateEngine(object):
    '''template engine
    [compile] -> render -> insert
    '''
    def __init__(self):
        self._plugdir = os.path.dirname(vim.eval('s:OxnzTemplateKitPluginPath'))
        self._tempdir = os.path.join(self._plugdir, 'templates')

    def __render(self, content):
        '''content is string'''
        return OxnzTemplateRenderer(content)()

    def __compile(self, template):
        '''compile template
        pass fullname as first argument
        '''
        task = subprocess.Popen(template.compcmd, bufsize=-1, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        print template.compcmd + [template.filetype]
        stdoutdata, stderrdata = task.communicate()
        returncode = task.returncode
        if returncode or stderrdata:
            raise OxnzTemplateCompileError(template, returncode, stderrdata)
        return stdoutdata

    def __insert(self, filetype):
        '''insert template by filetype and suffix'''
        if len(filetype) != 1:
            raise OxnzTemplateKitError("invalid filetype '{}'".format(filetype))
        filetype = filetype[0]
        template = OxnzTemplate(self._tempdir, filetype)
        if template.compilable:
            content = self.__compile(template)
        else:
            content = template.content
        if template.renderable:
            content = self.__render(content)
        vim.current.buffer[:] = content.split('\n')

    def __commentprefix(self):
        '''return comment prefix(es) based on filetype'''
        if self._filetype in ('sh', 'zsh', 'python', 'perl', 'ruby'):
            return ('#')
        elif self._filetype in ('c', 'cpp', 'php', 'css'):
            return ('//', '#')
        elif self._filetype in ('vim'):
            return '"'
        else:
            raise OxnzTemplateKitError("unknown comment prefix for filetype: {}".format(self._filetype))

    def do(self, name, args):
        '''do command by name'''
        commands = {
            'insert': self.__insert,
        }
        cmd = commands.get(name, self.__errcnf(name))
        cmd(args)

    def __errcnf(self, command):
        def errfunc(args):
            raise OxnzTemplateKitError("command '{}' not found".format(command))
        return errfunc

class OxnzTemplateKitErrpro(object):
    def __init__(self, ex):
        pass
    pass

class erreport(object):
    '''report error'''
    def __init__(self, level = 'error'):
        self._levels = {
            'warning': 'WarningMsg',
            'error': 'ErrorMsg',
        }
        self._level = level

    def __call__(self, ex):
        '''display exception: ex'''
        errmsg = '{}: {}'.format(self._level.capitalize(), ex)
        vimcmd = 'echohl {} | echo "{}" | echohl None'.format(
                self._levels[self._level], errmsg)
        vim.command(vimcmd)


if __name__ == '__main__':
    try:
        cmdname = vim.eval('a:cmd')
        cmdargs = vim.eval('a:000')
        engine = OxnzTemplateEngine()
        engine.do(cmdname, cmdargs)
    except OxnzTemplateError as e:
        #erreport()(e)
        print >>sys.stderr, e
        pass
    except OxnzTemplateCompileError as e:
        pass
        print >>sys.stderr, e
    except OxnzTemplateKitError as e:
        pass
        print >>sys.stderr, e
    except vim.error as e:
        pass
        print >>sys.stderr, e
    except:
        #raise vim.error('Unexpected error:', sys.exc_info()[0])
        raise
