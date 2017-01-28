# spell
A command line tool that checks spelling and grammar like a compiler
It accepts a word or a sentence as its argument.

## Examples
```bash
spell swift
# ✓ That is right.

spell --force swift
# ✓ 95.46% Confident
# 1. Swift
# 2. shift
# 3. sift
# 4. swifts

spell I love programming!
# ✓ Bingo!

spell I does not like programming.
# grammar: the word ‘does’ may not agree with the rest of the sentence.
# I does not like programming.
#   ^~~~
```

## Options
Use `--force` or `-f` to force printing suggestions regardless the word is correctly spelled or not.

## Installation
Download the latest version of spell and move it to `/usr/local/bin` folder

