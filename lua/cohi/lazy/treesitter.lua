return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- main does not support lazy loading
    build = ":TSUpdate",
    config = function()
        local parsers = {
            "vimdoc", "javascript", "typescript", "c", "lua", "rust",
            "jsdoc", "bash", "python",
        }

        require("nvim-treesitter").install(parsers):wait(300000)

        -- Replaces auto_install, highlight.enable, and indent.enable.
        vim.api.nvim_create_autocmd("FileType", {
            callback = function(event)
                local lang = vim.treesitter.language.get_lang(event.match)
                if not lang then
                    return
                end
                if not vim.tbl_contains(require("nvim-treesitter.config").get_available(), lang) then
                    return
                end
                require("nvim-treesitter").install(lang):await(function()
                    vim.treesitter.start(event.buf)
                    vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
                    vim.wo[0][0].foldmethod = "expr"
                end)
            end,
        })
    end,
}
