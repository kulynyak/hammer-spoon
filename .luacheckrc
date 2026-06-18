std = "lua54"
globals = {
  "hs",
  "spoon",
}
allow_defined_top = true
max_line_length = 80
exclude_files = {
  ".history/",
  "Spoons/",
}
ignore = {
  "212",   -- unused argument (common in Hammerspoon callbacks)
  "213",   -- unused loop variable (idiomatic for i,v in pairs)
  "431",   -- shadowing upvalue (intentional in some cases)
  "432",   -- shadowing upvalue argument
}

