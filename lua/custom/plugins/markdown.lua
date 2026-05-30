-- Markdown + Mermaid diagram support.
--
-- Two complementary pieces:
--   1. render-markdown.nvim  -> pretty in-editor rendering (headings, code blocks,
--      tables, checkboxes) with no external dependencies.
--   2. markdown-preview.nvim -> live preview in your web browser that natively
--      renders ```mermaid fenced diagrams. The browser binary is downloaded
--      automatically by the PackChanged handler in init.lua.
--
-- Syntax highlighting inside ```mermaid blocks comes from the `mermaid` treesitter
-- parser, which is installed in the Treesitter section of init.lua.

local function gh(repo) return 'https://github.com/' .. repo end

-- 1) In-editor rendering ------------------------------------------------------
vim.pack.add {
  gh 'MeanderingProgrammer/render-markdown.nvim',
}
require('render-markdown').setup {
  -- Render in normal/command mode; show raw markdown while editing a line.
  render_modes = { 'n', 'c', 't' },
  completions = { lsp = { enabled = true } },
}

-- 2) Browser preview (with Mermaid) ------------------------------------------
-- Load lazily-ish: markdown-preview sets g:mkdp_filetypes before load.
vim.g.mkdp_filetypes = { 'markdown' }
vim.g.mkdp_auto_close = 1 -- close the browser tab when you switch away
vim.g.mkdp_theme = 'dark'

vim.pack.add {
  gh 'iamcco/markdown-preview.nvim',
}

-- Keymaps (only meaningful in markdown buffers).
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function(ev)
    local opts = { buffer = ev.buf, desc = nil }
    vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreviewToggle<cr>',
      vim.tbl_extend('force', opts, { desc = '[M]arkdown [P]review (browser, Mermaid)' }))
    vim.keymap.set('n', '<leader>mr', '<cmd>RenderMarkdown toggle<cr>',
      vim.tbl_extend('force', opts, { desc = '[M]arkdown [R]ender toggle (in-editor)' }))
  end,
})
