def mommy [
  ...command: any # command
]: nothing -> nothing {
 
  def pick_random [words: list<string>]: nothing -> string {
    $words | shuffle | get 0
  }
  
  
  const $path_self = path self
  let $config_path = $"($path_self)/../mommy_config.json"
  touch $config_path
  mut $config = open $config_path | default {}
  
  let $color              = $config | get -i color              | default (ansi lightpink1)
  let $roles              = $config | get -i roles              | default "mommy"           | split row "/"
  let $pronouns           = $config | get -i pronouns           | default "her"             | split row "/"
  let $affectionate_terms = $config | get -i affectionate_terms | default "kitten"          | split row "/"
  let $emoji              = $config | get -i emoji              | default $"(ansi red)❤️"
  let $only_negative      = $config | get -i only_negative      | default false
  
  let $negative_responses = $config | get -i negative_responses | default [
          "do you need {role}'s help~? {emoji}"
          "Don't give up, my love~ {emoji}"
          "Don't worry, {role} is here to help you~ {emoji}"
          "I believe in you, my sweet {affectionate_term}~ {emoji}"
          "It's okay to make mistakes, my dear~ {emoji}"
          "just a little further, sweetie~ {emoji}"
          "Let's try again together, okay~? {emoji}"
          "{role} believes in you, and knows you can overcome this~ {emoji}"
          "{role} believes in you~ {emoji}"
          "{role} is always here for you, no matter what~ {emoji}"
          "{role} is here to help you through it~ {emoji}"
          "{role} is proud of you for trying, no matter what the outcome~ {emoji}"
          "{role} knows it's tough, but you can do it~ {emoji}"
          "{role} knows {pronoun} little {affectionate_term} can do better~ {emoji}"
          "{role} knows you can do it, even if it's tough~ {emoji}"
          "{role} knows you're feeling down, but you'll get through it~ {emoji}"
          "{role} knows you're trying your best~ {emoji}"
          "{role} loves you, and is here to support you~ {emoji}"
          "{role} still loves you no matter what~ {emoji}"
          "You're doing your best, and that's all that matters to {role}~ {emoji}"
          "{role} is always here to encourage you~ {emoji}"
  ]
  let $positive_responses = $config | get -i positive_responses | default [
          "*pets your head*"
          "awe, what a good {affectionate_term}~\n{role} knew you could do it~ {emoji}"
          "good {affectionate_term}~\n{role}'s so proud of you~ {emoji}"
          "Keep up the good work, my love~ {emoji}"
          "{role} is so grateful to have you as {pronoun} little {affectionate_term}~ {emoji}"
          "I'm so proud of you, my love~ {emoji}"
          "{role} is so proud of you~ {emoji}"
          "{role} loves seeing {pronoun} little {affectionate_term} succeed~ {emoji}"
          "{role} thinks {pronoun} little {affectionate_term} earned a big hug~ {emoji}"
          "that's a good {affectionate_term}~ {emoji}"
          "you did an amazing job, my dear~ {emoji}"
          "you're such a smart cookie~ {emoji}"
  ]
  
  let role              = pick_random $roles
  let pronoun           = pick_random $pronouns
  let affectionate_term = pick_random $affectionate_terms
  
  try {
      nu -l -c $"($command | str join ' ')"
  } catch {}
  
  let success = $env.LAST_EXIT_CODE == 0
  
  """
  if ( success and   allow positive  ) or (  failure   )
  """
  if ($success and not $only_negative) or (not $success) {
    let response = $"($color)(pick_random (if $success { $positive_responses } else { $negative_responses }))"
                 | str replace "{role}"              $role
                 | str replace "{pronoun}"           $pronoun
                 | str replace "{affectionate_term}" $affectionate_term
                 | str replace "{emoji}"             $emoji
  
    print $response
  }
  
  $config
  | upsert color              ($color)
  | upsert roles              ($roles              | str join "/")
  | upsert pronouns           ($pronouns           | str join "/")
  | upsert affectionate_terms ($affectionate_terms | str join "/")
  | upsert emoji              ($emoji)
  | upsert only_negative      ($only_negative)
  | upsert negative_responses ($negative_responses)
  | upsert positive_responses ($positive_responses)
  | save $config_path -f
}