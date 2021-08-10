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
    msg = f'[{level}] {name}: {msg}'
    print(msg, file=sys.stderr if level in ['WARN', 'ERROR'] else sys.stdout)
