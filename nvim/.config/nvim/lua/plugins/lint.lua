return
{
    'jose-elias-alvarez/null-ls.nvim',
    config = function()
        local null_ls = require("null-ls")

        null_ls.setup({
            vsources = {
                -- Terraform
                null_ls.builtins.diagnostics.tflint,

                -- Kubernetes
                null_ls.builtins.diagnostics.kube_linter,

                -- Helm
                null_ls.builtins.diagnostics.helm_ls,

                -- YAML
                null_ls.builtins.diagnostics.yamllint,

                -- JSON
                null_ls.builtins.diagnostics.jsonlint,

                -- Bash
                null_ls.builtins.diagnostics.shellcheck,

                -- Go
                null_ls.builtins.diagnostics.golangci_lint,

                -- Java
                null_ls.builtins.diagnostics.checkstyle.with({
                    extra_args = { "-c", "/path/to/google_checks.xml" }, -- Customize if needed
                }),

                -- Python
                null_ls.builtins.diagnostics.flake8,

                -- Rust
                null_ls.builtins.diagnostics.clippy,

                -- Node.js (JavaScript/TypeScript)
                null_ls.builtins.diagnostics.eslint_d,
            },
        })
    end,
}
