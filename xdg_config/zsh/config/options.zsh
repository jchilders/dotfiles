export ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
mkdir -p "$(dirname $ZSH_COMPDUMP)"
autoload -Uz compinit
compinit -C

export ZCACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "${ZCACHE_HOME}/zcompcache"
zstyle ':completion::complete:*' cache-path "${ZCACHE_HOME}/zcompcache"

typeset -g zle_highlight=(region:bg=black) # Highlight the background of the text when selecting.
typeset -g WORDCHARS='*?_-.[]~=&;!#$%^(){}<>' # List of characters considered part of a word.
typeset -U path # prevent duplicate PATH entries

setopt NO_BEEP # Don't beep on errors.
setopt VI # Use vi emulation mode.

# Changing Directories
typeset -g DIRSTACKSIZE=10 # The maximum size of the directory stack for `pushd` and `popd`.
setopt AUTO_CD # If can't execute the directory, perform the cd command to that.
setopt AUTO_PUSHD # Make cd push the old directory onto the directory stack.
setopt NO_CDABLE_VARS # Don't expand arguments given to a cd command.
setopt NO_CHASE_DOTS # Don't resolve symbolic links upon path segments.
setopt NO_CHASE_LINKS # Don't resolve symbolic links upon changing directories.
setopt NO_POSIX_CD # Make cd command POSIX incompatible.
setopt EXTENDED_GLOB # Treat the `#', `~' and `^' characters as part of patterns (regex-like)
setopt PUSHD_IGNORE_DUPS # Don't push multiple copies of the same directory onto the stack.
setopt PUSHD_MINUS # Exchanges  the  meanings of `+` and `-` for pushd.
setopt PUSHD_SILENT # Do not print the directory stack after pushd or popd.
setopt PUSHD_TO_HOME # Have pushd with no arguments act like `pushd $HOME`.

# Completion
# zstyle ':completion:*' menu select # Use completion menu for completion when available.
# zstyle ':completion:*' rehash true # When new programs is installed, auto update without reloading.
# zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# zstyle ':completion:*' list-colors ${(s#:#)LS_COLORS} # Match dircolors with completion schema.
# setopt COMPLETE_ALIASES # Prevent aliases from being substituted before completion is attempted.
# setopt COMPLETE_IN_WORD # Attempt to start completion from both ends of a word.
# setopt GLOB_COMPLETE # Don't insert anything resulting from a glob pattern, show completion menu.
# setopt NO_LIST_BEEP # Don't beep on an ambiguous completion.
# setopt LIST_PACKED # Try to make the completion list smaller by drawing smaller columns.
# setopt MENU_COMPLETE # Instead of listing possibilities, select the first match immediately.

# History
typeset -g HISTSIZE=1000000 # The maximum number of events stored in the internal history list.
typeset -g SAVEHIST=$HISTSIZE # The maximum number of history events to save in the history file.
setopt BANG_HIST # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY # Save each command's epoch timestamps and the duration in seconds.
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicate entries first when trimming history.
setopt HIST_FIND_NO_DUPS # Don't display a line previously found.
setopt HIST_IGNORE_ALL_DUPS # Delete old recorded entry if new entry is a duplicate.
setopt HIST_IGNORE_DUPS # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_SPACE # Don't record an entry starting with a space.
setopt HIST_REDUCE_BLANKS # Remove superfluous blanks before recording an entry.
setopt HIST_SAVE_NO_DUPS # Don't write duplicate entries in the history file.
setopt HIST_SUBST_PATTERN # Allow pattern matching in glob qualifiers
setopt HIST_VERIFY # Don't execute the line directly instead perform history expansion.
setopt INC_APPEND_HISTORY # Write to the history file immediately, not when the shell exits.

# Input/Output
setopt NO_CLOBBER # Don't allow `>` redirection to override existing files. Use `>!` instead.
setopt NO_FLOW_CONTROL # Disable flow control characters `^S` and `^Q`.
setopt NO_IGNORE_EOF # Enable ^D to logout, exit on end-of-file.
setopt INTERACTIVE_COMMENTS # Allow comments even in interactive shells.
