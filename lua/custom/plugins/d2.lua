-- D2 diagram support (https://d2lang.com).
--
-- D2 has no mature language server, so this provides:
--   * syntax highlighting + filetype detection via terrastruct/d2-vim
--   * <leader>dd : live browser preview of the current .d2 file (d2 --watch)
--   * <leader>dc : one-shot compile of the current file to an .svg beside it
--
-- Requires the `d2` CLI on PATH (installed via winget: Terrastruct.D2).

local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'terrastruct/d2-vim' }

-- which-key group label
pcall(function() require('which-key').add { { '<leader>d', group = '[D]2 diagram' } } end)

local watch_jobs = {}

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'd2',
  callback = function(ev)
    local buf = ev.buf
    local map = function(lhs, fn, desc) vim.keymap.set('n', lhs, fn, { buffer = buf, desc = desc }) end

    -- Live preview: opens a local server in your browser that hot-reloads on save.
    map('<leader>dd', function()
      if vim.fn.executable 'd2' ~= 1 then
        vim.notify('d2 CLI not found on PATH', vim.log.levels.ERROR)
        return
      end
      local file = vim.api.nvim_buf_get_name(buf)
      if watch_jobs[file] then
        vim.notify('d2 preview already running for this file', vim.log.levels.INFO)
        return
      end
      local out = vim.fn.fnamemodify(file, ':r') .. '.svg'
      watch_jobs[file] = vim.fn.jobstart { 'd2', '--watch', file, out }
      vim.api.nvim_create_autocmd('BufUnload', {
        buffer = buf,
        once = true,
        callback = function()
          if watch_jobs[file] then
            vim.fn.jobstop(watch_jobs[file])
            watch_jobs[file] = nil
          end
        end,
      })
      vim.notify('d2 live preview started (browser)', vim.log.levels.INFO)
    end, '[D]2 live preview (browser)')

    -- One-shot compile to SVG next to the source file.
    map('<leader>dc', function()
      local file = vim.api.nvim_buf_get_name(buf)
      local out = vim.fn.fnamemodify(file, ':r') .. '.svg'
      vim.system({ 'd2', file, out }, {}, function(r)
        vim.schedule(function()
          if r.code == 0 then
            vim.notify('Compiled -> ' .. out, vim.log.levels.INFO)
          else
            vim.notify('d2 compile failed:\n' .. (r.stderr or ''), vim.log.levels.ERROR)
          end
        end)
      end)
    end, '[D]2 [c]ompile to SVG')
  end,
})
