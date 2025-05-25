# `niclan051/nushell-mommy`

rewritten from [sudofox/shell-mommy](https://github.com/sudofox/shell-mommy)

nushell script that provides a `mommy` function which offers praise and encouragement depending on the exit code of the command passed to it

the default prefix sets the color to a light pink but you can change it to any other prefix


i am not responsible for any damage to your mental health

## installation

to use the `mommy` function you can source this script in nushell or add it to the config file

## configuration

the `mommy` function can be configured via `mommy_config.json` in the same directory which is created automatically if it does not exist

- `"color"`: sets the ansi color code of the text output by `mommy` (default: light pink)
- `"roles"`: sets the roles by which `mommy` will refer to itself (default: `"mommy"`)
- `"pronouns"`: sets the pronouns by which `mommy` will refer to itself (default: `"her"`)
- `"affectionate_terms"`: sets the affectionate_terms `mommy` will use to refer to the user (default: `"kitten"`)
- `"emoji"`: sets the emoji `mommy` will use in responses (default: ❤️)
- `"only_negative"`: if set to true, will not provide praise on a non-zero exit code
- `"negative_responses"`/`"positive_responses"`: sets the possible responses of `mommy`

you can put ansi codes in every string option in the config

to add multiple possible values, you can separate them with forward slashes:
```json
{
  "affectionate_terms": "kitten/child/girl",
  ...
}
```
```nu
~> mommy 123
123
mommy thinks her little kitten earned a big hug~ ❤️

~> mommy 123
123
that's a good girl~ ❤️

~> mommy 123
123
awe, what a good child~
mommy knew you could do it~ ❤️
```

## response syntax

when configuring responses, you can use placeholders which will be replaced by configured values:

```json
"{role} knows {pronoun} little {affectionate_term} can do better~ {emoji}"
```
will be printed as
```nu
mommy knows her little kitten can to better~ ❤️
```

## usage

to use the `mommy` function, just pass a command as an argument and `mommy` will provide a response based on the exit code of the command

```nu
mommy pwd
# output: you did an amazing job, my dear~ ❤️

mommy asdfhjkl
# output: Don't worry, mommy is here to help you~ ❤️
```

## limitations

any command part in quotes (`"like" "this"`) will be interpreted as if it was not quoted

to work around that, wrap it in quotes again (`""like"" ""this""`)

## example

```nu
# set custom affectionate_terms and pronouns
open mommy_config.json
| upsert affectionate_terms "kid/child/kitten"
| upsert pronouns "her/their"
| save mommy_config.json -f

# use the `mommy` function to run a command
mommy pwd

# output:
# mommy loves seeing their little child succeed~ ❤️
```