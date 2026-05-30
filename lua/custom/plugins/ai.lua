-- AI assistant: CodeCompanion, configured to use Claude (Anthropic).
--
-- SETUP REQUIRED: CodeCompanion reads your API key from the environment variable
--   ANTHROPIC_API_KEY
-- Add this to your shell profile (~/.zshrc) and restart your terminal:
--   export ANTHROPIC_API_KEY="sk-ant-..."
-- Get a key at https://console.anthropic.com/settings/keys
--
-- If you'd rather use GitHub Copilot, OpenAI, Ollama (local models), etc., see
--   :help codecompanion-adapters
--
-- Usage:
--   <leader>aa  - toggle the AI chat window (works in normal & visual mode)
--   <leader>ai  - inline AI edit on the current line / visual selection
--   <leader>ap  - AI actions palette
--   :CodeCompanion <prompt>   - quick inline prompt
--   :CodeCompanionChat        - open a chat buffer

local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add {
  gh 'nvim-lua/plenary.nvim',
  gh 'olimorris/codecompanion.nvim',
}

require('codecompanion').setup {
  strategies = {
    -- Use Claude for chat, inline edits, and command suggestions.
    chat = { adapter = 'anthropic' },
    inline = { adapter = 'anthropic' },
    cmd = { adapter = 'anthropic' },
  },
}

-- Keymaps
vim.keymap.set({ 'n', 'v' }, '<leader>aa', '<cmd>CodeCompanionChat Toggle<cr>', { desc = '[A]I ch[a]t toggle' })
vim.keymap.set({ 'n', 'v' }, '<leader>ai', '<cmd>CodeCompanion<cr>', { desc = '[A]I [i]nline edit' })
vim.keymap.set({ 'n', 'v' }, '<leader>ap', '<cmd>CodeCompanionActions<cr>', { desc = '[A]I actions [p]alette' })
