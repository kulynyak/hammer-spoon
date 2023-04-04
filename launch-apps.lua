-- modes:
-- All
-- Work
-- Home
-- osascript -e 'id of app "Outlook"'
-- defaults write com.apple.LaunchServices LSHandlers -array-add '{LSHandlerContentType=public.plain-text;LSHandlerRoleAll=com.microsoft.VSCode;}'
return {
  -- { app-path, bundleID, hide, mode},
  -- comment
  -- { 'Notes', 'com.apple.Notes', true, 'All' },
  { 'KeePassXC', 'org.keepassxc.keepassxc', true, 'All' },
  -- { 'Viber', 'com.viber.osx', true, 'All' },
  -- { 'WhatsApp', 'WhatsApp', true, 'All' },
  -- { 'Telegram', 'ru.keepcoder.Telegram', true, 'All' },
  { 'Calendar', 'com.apple.iCal', true, 'All' },
  { 'Mail', 'com.apple.mail', true, 'All' },
  -- { 'Outlook', 'com.microsoft.Outlook', true, 'All' },
  -- { 'Microsoft Teams', 'com.microsoft.teams', true, 'Work' },
  { 'Slack', 'com.tinyspeck.slackmacgap', true, 'Work' },
  { 'Signal', 'org.whispersystems.signal-desktop', true, 'All' },
  { 'Notion', 'notion.id', true, 'All' },
}