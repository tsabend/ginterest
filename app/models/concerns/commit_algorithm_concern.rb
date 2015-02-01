module CommitAlgorithmConcern

  IMPERATIVE = ["add", "reformat", "style", "create", "delete", "change", "modify", "update", "replace", "minimize", "make", "implement", "compare", "test", "refresh", "clean", "get", "post", "compute", "describe", "document", "comment", "improve", "check", "close", "include", "provide", "insert", "read", "switch", "swap", "fix", "import", "export", "present", "set", "do", "undo", "schedule", "filter", "run", "prevent", "note", "transpose", "give", "open", "destroy", "require", "develop", "raise", "split", "join", "load", "unload", "review", "view", "control", "model", "mix", "submit", "code", "clear", "structure", "refactor", "count", "validate", "install", "clone", "lock", "store", "convert", "write", "find", "pull", "push", "request", "authenticate", "show", "prove", "migrate", "route", "define", "print", "hit", "save", "advance", "start", "begin", "end", "finish", "format", "send", "receive", "kill", "generate", "correct", "rename", "log", "map", "inspect", "associate", "search", "collect", "select", "reject", "merge", "combine", "compact", "concat", "cycle", "drop", "truncate", "fetch", "fill", "flatten", "freeze", "initialize", "copy", "pack", "permute", "pop", "repeat", "reverse", "rotate", "sample", "sort", "order", "shift", "shuffle", "slice", "take", "execute", "randomize", "detect", "group", "reduce", "inject", "zip", "sum", "divide", "multiply", "use", "restore", "subtract", "exponentiate", "return", "iterate", "recurse", "exit", "commit", "message", "punctuate", "hold", "uninstall", "accept", "contribute", "command", "try", "move", "base", "rebase", "enter", "leave", "finalize", "penalize", "unify", "pass", "allow", "let", "disable", "enable", "ignore", "target", "skip", "perform", "build", "scaffold", "reassign", "bring", "preserve", "assert", "name", "redefine", "deprecate", "introduce", "go", "expand", "mutate", "rely", "duplicate", "extract", "render", "assign", "rewrite", "call", "bind", "unbind", "affect", "escape", "calculate", "bundle", "eliminate", "specify", "guide", "stop", "digest", "relax", "readd", "disallow", "regenerate", "fork", "persist", "rollback", "reset", "simplify", "prefer", "demonstrate", "better", "avoid", "consider", "throw", "loosen", "support", "cleanup", "revert", "integrate", "verify", "share", "ensure", "condense", "rephrase", "un-inline", "adjust", "inform", "fall", "fallback", "cast", "reuse", "propagate", "dump", "list", "clarify", "warn", ""]
  PAST_TENSE = ["added", "reformated", "styled", "created", "deleted", "removed", "switched", "changed", "modified", "updated", "replaced", "minimized", "maked", "implemented", "compared", "tested", "refreshed", "cleaned", "geted", "posted", "computed", "described", "documented", "commented", "improved", "checked", "closed", "included", "provided", "inserted", "readed", "switched", "swaped", "fixed", "imported", "exported", "presented", "seted", "doed", "undoed", "scheduled", "filtered", "runed", "prevented", "noted", "transposed", "gived", "opened", "destroyed", "required", "developed", "raised", "splited", "joined", "loaded", "unloaded", "reviewed", "viewed", "controled", "modeled", "mixed", "submited", "coded", "cleared", "structured", "refactored", "counted", "validated", "installed", "cloned", "locked", "stored", "converted", "writed", "finded", "pulled", "pushed", "requested", "authenticated", "show", "prove", "migrate", "route", "define", "print", "hit", "save", "advance", "start", "begin", "end", "finish", "format", "send", "receive", "kill", "generate", "correct", "rename", "log", "map", "inspect", "associate", "search", "collect", "select", "reject", "merge", "combine", "compact", "concat", "cycle", "drop", "truncate", "fetch", "fill", "flatten", "freeze", "initialize", "copy", "pack", "permute", "pop", "repeat", "reverse", "rotate", "sample", "sort", "order", "shift", "shuffle", "slice", "take", "execute", "randomize", "detect", "group", "reduce", "inject", "zip", "sum", "divide", "multiply", "use", "restore", "subtract", "exponentiate", "return", "iterate", "recurse", "exit", "commit", "message", "punctuate", "hold", "uninstall", "accept", "contribute", "command", "try", "move", "base", "rebase", "enter", "leave", "finalize", "penalize", "unify", "pass", "allow", "let", "disable", "enable", "ignore", "target", "skip", "perform", "build", "scaffold", "reassign", "bring", "preserve", "assert", "name", "redefine", "deprecate", "introduce", "go", "expand", "mutate", "rely", "duplicate", "extract", "render", "assign", "rewrite", "call", "bind", "unbind", "affect", "escape", "calculate", "bundle", "eliminate", "specify", "guide", "stop", "digest", "relax", "readd", "disallow", "regenerate", "fork", "persist", "rollback", "reset", "simplify", "prefer", "demonstrate", "better", "avoid", "consider", "throw", "loosen", "support", "cleanup", "revert", "integrate", "verify", "share", "ensure", "condense", "rephrase", "un-inline", "adjust", "inform", "fall", "fallback", "cast", "reuse", "propagate", "dump", "list", "clarify", "warn", ""]
  CURSES = ["arse", "ass", "asshole", "bastard", "bitch", "bollocks", "bloody", "cunt", "damn", "fuck", "goddamn", "godsdamn", "hell", "holy shit", "motherfucker", "shit", "shite", "shitass", "bitch", "whore", "twat", "fucker", "cock", "dick"]
  PUNCTUATION = [".", ",", "!", "?"]

    def commit_score
      length_score + tense_score + punctuation_score + cursing_score + number_of_files_score + number_of_changes_score + number_of_words_score
    end

  # private

    def length_score
      case title.length
      when 0..11
        0
      when 11..51
        30
      when 51..100
        -20
      else
        -200
      end
    end

    def number_of_words_score
      case title.split.size
      when 1
        -30
      when 2..3
        0
      when 4..8
        10
      when 9..14
        0
      else
        -30
      end
    end

    def tense_score
      num_imperatives = self.message.split.select {|word| IMPERATIVE.include?(word.downcase) }.size
      num_past_tense = self.message.split.select {|word| PAST_TENSE.include?(word.downcase) }.size
      (num_imperatives * 5) + (num_past_tense * -50)
    end

    def punctuation_score
      PUNCTUATION.include?(self.message[-1]) ? -10 : 0
    end

    def cursing_score
      num_curses = self.message.split.select {|word| CURSES.include?(word.downcase) }.size
      num_curses > 0 ? -50 : 1

    end

    def number_of_files_score
      case self.number_of_files_changed
      when 1
        20
      when 2
        18
      when 3
        15
      when 4
        10
      when 5
        2
      when 6
        0
      when 7
        -5
      else
        - 10
      end
    end

    def number_of_changes_score
      case self.diff
      when 1..5
        40
      when 6..11
        30
      when 12..30
        15
      when 31..60
        1
      else
        0
      end
    end
end
