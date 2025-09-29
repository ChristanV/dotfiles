require('plugins')
require('core')
require('autocomplete')
require('lsp')
require('navigation')
require('search')
require('uml')
require('git')
require('mappings')
require('ai/copilot')

if os.getenv("NVIM_ENABLE_ALT_AI") then
  require('ai/supermaven')
  require('ai/gen')
  require('ai/chatgpt')
end
