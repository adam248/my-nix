vim.lsp.set_log_level("debug")
local nvim_lsp = require('lspconfig')
local servers = { 'tsserver' }

local on_attach = function(client, bufnr)
    local function nmap(shortcut, command) 
      vim.api.nvim_set_keymap('n', shortcut, command, { noremap = true, silent = true })
    end

    nmap('gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
    nmap('gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
    nmap('K', '<cmd>lua vim.lsp.buf.hover()<CR>')
    nmap('<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
    nmap('gr', '<cmd>lua vim.lsp.buf.references()<CR>')
    nmap('<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
    nmap('[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
    nmap(']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
    nmap('<space>f','<cmd>lua vim.lsp.buf.formatting()<CR>')
end

for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup {
		on_attach = on_attach,
     cmd = { 
          -- This path could be a problem in the future
	  -- as well as the one at the end
          "/run/current-system/sw/bin/typescript-language-server",
          "--stdio",
          "--tsserver-path",
          "/nix/store/j45k597n1i6qlr84m9l79wwk0nx8r9gc-typescript-4.7.4/lib/node_modules/typescript/lib/"
        }
	}
end


