module CommitAlgorithm

  IMPERATIVE = ["add", "create", "delete", "change", "modify", "update", "replace", "minimize", "make", "implement", "compare", "test", "refresh", "clean", "get", "post", "compute", "describe", "document", "comment", "improve", "check", "close", "include", "provide", "insert", "read", "switch", "swap", "fix", "import", "export", "present", "set", "do", "undo", "schedule", "filter", "run", "prevent", "note", "transpose", "give", "open", "destroy", "require", "develop", "raise", "split", "join", "load", "unload", "review", "view", "control", "model", "mix", "submit", "code", "clear", "structure", "refactor", "count", "validate", "install", "clone", "lock", "store", "convert", "write", "find", "pull", "push", "request", "authenticate", "show", "prove", "migrate", "route", "define", "print", "hit", "save", "advance", "start", "begin", "end", "finish", "format", "send", "receive", "kill", "log", "map", "inspect", "associate", "search", "collect", "select", "reject", "combine", "compact", "concat", "cycle", "drop", "truncate", "fetch", "fill", "flatten", "freeze", "initialize", "copy", "pack", "permute", "pop", "repeat", "reverse", "rotate", "sample", "sort", "order", "shift", "shuffle", "slice", "take", "execute", "randomize", "detect", "group", "reduce", "inject", "zip", "sum", "divide", "multiply", "subtract", "exponentiate", "return", "iterate", "recurse", "exit", "commit", "message", "punctuate", "hold", "uninstall", "accept", "contribute", "command", "try", "move", "base", "rebase", "enter", "leave", "finalize", "penalize"]

CURSES = ["arse", "ass", "asshole", "bastard", "bitch", "bollocks", "bloody", "child-fucker", "cunt", "damn", "fuck", "goddamn", "godsdamn", "hell", "holy shit", "motherfucker", "shit", "shite", "shitass", "son of a bitch", "son of a whore", "twat", "fucker", "cock", "dick"]

  def score_commit(commit)
    {
      "sha": commit["sha"],
      "date": commit["date"],
      "length": check_length_of_message(commit["message"]),
      "files": check_number_of_files(commit["files"]),
      "cursing": check_cursing_in_message(commit["message"]),
      "changes": check_number_of_changes(commit["stats"]["total"]),
      "punctuation": check_if_message_ends_with_period(commit["message"]),
      "tense": check_tense_of_messge(commit["message"])
    }
  end


  private
    def check_length_of_message(message)
      case message.length
      when 0..11
        1
      when 11..51
        2
      when 51..100
       length 1
      else
        0
      end
    end

    def check_tense_of_messge(message)
      if IMPERATIVE.include?(message.split[0].downcase)
        1
      else
        0
      end
    end

    def check_if_message_ends_with_period(message)
      if PUNCTUATION.include?(message[-1])
        1
      else
        0
      end
    end

    def check_cursing_in_message(message)
      message.split.each do |word|
        if CURSING.include?(word.downcase)
          1
          return
        else
          0
        end
      end
    end

    def check_number_of_files(file_array)
      case file_array.length
      when 1
        5
      when 2
        4
      when 3
        3
      when 4
        2
      when 5
        1
      else
        0
      end
    end

    def check_number_of_changes(commit)
      case commit
      when 1..11
        3
      when 12..30
        2
      when 31..60
        1
      else
        0
    end
end





