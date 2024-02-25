local lsp_formatting = function(bufnr)
    vim.lsp.buf.format({
        timeout_ms = 5000,
        filter = function(client)
            -- apply whatever logic you want (in this example, we"ll only use null-ls)
            return client.name == "null-ls"
        end,
        bufnr = bufnr,
    })
end

-- if you want to set up formatting on save, you can use this as a callback
-- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local null_ls = require("null-ls")

null_ls.setup({
    debug = true,
    timeout_ms = 10000,
    sources = {
        -- Code actions
        null_ls.builtins.code_actions.gitsigns,
        null_ls.builtins.code_actions.gomodifytags,
        null_ls.builtins.code_actions.proselint,
        null_ls.builtins.code_actions.shellcheck,

        -- Diagnostic
        null_ls.builtins.diagnostics.clang_check.with({
            command = "clang-check-16",
        }),
        null_ls.builtins.diagnostics.cmake_lint,
        null_ls.builtins.diagnostics.dotenv_linter,
        null_ls.builtins.diagnostics.editorconfig_checker,
        null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.diagnostics.jsonlint,
        null_ls.builtins.diagnostics.luacheck,
        null_ls.builtins.diagnostics.proselint,
        null_ls.builtins.diagnostics.pylint,
        null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.diagnostics.tidy,
        null_ls.builtins.diagnostics.tsc,
        null_ls.builtins.diagnostics.yamllint,
 
        -- Linters
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.clang_format.with({
            command = "clang-format-16",
        }),
        null_ls.builtins.formatting.cmake_format,
        null_ls.builtins.formatting.eslint,
        null_ls.builtins.formatting.gofmt,
        null_ls.builtins.formatting.goimports,
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.json_tool.with({
            command = "python3",
        }),
        null_ls.builtins.formatting.lua_format,
        null_ls.builtins.formatting.remark,
        null_ls.builtins.formatting.rustfmt,
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.formatting.tidy,
        null_ls.builtins.formatting.yalfmt,


   },
})
