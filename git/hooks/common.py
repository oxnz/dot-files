import enum


class CommitCategory(enum.Enum):
    # PARTIAL => work in progress
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
