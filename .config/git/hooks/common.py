import sys
import enum
import subprocess


class CommitCategory(enum.Enum):
    '''
    commit category used in commit msg subject line

    keep value short
    '''
    # WIP => work in progress
    WIP = 'wip'
    EXP = 'exp'
    PARTIAL = 'part'
    DOC = 'doc'
    FEATURE = 'feature'
    # Changes to the build process or auxiliary tools and libraries such as documentation generation
    CHORE = 'chore'
    ISSUE = 'issue'
    HOTFIX = 'hotfix'
    BUGFIX = 'bugfix'
    REFACTOR = 'refactor'
    MERGE = 'merge'
    UNSPECIFIED = 'category'


def current_branch():
    output = subprocess.check_output(['git', 'symbolic-ref', '--short', 'HEAD']).rstrip()
    return output.decode('utf-8')


def msgdump(level, msg):
    level = level.upper()
    name = sys.argv[0]
    output = sys.stdout
    if level == 'ERROR':  # red
        level = f'\033[1;33m{level}\033[1;0m'
        output = sys.stderr
    elif level == 'WARN':  # yellow
        level = f'\033[1;31m{level}\033[1;0m'
        output = sys.stderr
    elif level == 'INFO':  # green
        level = f'\033[1;32m{level}\033[1;0m'
    else:  # cyan
        level = f'\036[1;34m{level}\033[1;0m'
    msg = f'[{level}] {name}: {msg}'
    print(msg, file=output)
