if true then
  return {}
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local lspconfig = require("lspconfig")
      local configs = require("lspconfig.configs")

      if not configs.java_language_server then
        configs.java_language_server = {
          default_config = {
            cmd = { "" },
            filetypes = { "java" },
            root_dir = lspconfig.util.root_pattern(
              "MODULE.bazel",
              "BUILD.bazel",
              "WORKSPACE",
              "pom.xml",
              "build.gradle",
              ".git"
            ),
            settings = {},
          },
        }
      end

      lspconfig.java_language_server.setup({
        on_new_config = function(config, new_root)
          config.autostart = true
        end,
      })

      -- Auto-attach the LSP to Java buffers opened outside the root (e.g. extracted sources)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function(args)
          local clients = vim.lsp.get_clients({ name = "java_language_server" })
          if #clients == 0 then
            return
          end
          local bufnr = args.buf
          if not vim.lsp.buf_is_attached(bufnr, clients[1].id) then
            vim.lsp.buf_attach_client(bufnr, clients[1].id)
          end
        end,
      })

      -- Handle jar: URIs so Neovim can open files inside JARs
      -- e.g. jar:file:///path/to/lib.jar!/com/example/Foo.java
      vim.api.nvim_create_autocmd("BufReadCmd", {
        pattern = { "jar:file://*", "*/jar:file://*" },
        callback = function(args)
          -- args.match may have CWD prepended; extract the jar: URI from buffer name
          local bufname = vim.api.nvim_buf_get_name(args.buf)
          local jar_start = bufname:find("jar:file:")
          if not jar_start then
            vim.notify("Cannot find jar: URI in buffer name: " .. bufname, vim.log.levels.ERROR)
            return
          end
          local uri = bufname:sub(jar_start)

          -- Parse: jar:file:///path/to.jar!/entry/path.java
          local bang = uri:find("!/")
          if not bang then
            vim.notify("Invalid jar URI (no !/ separator): " .. uri, vim.log.levels.ERROR)
            return
          end
          local jar_file = uri:sub(#"jar:file://" + 1, bang - 1)
          local entry_path = uri:sub(bang + 2)

          -- Extract the entry using unzip
          local result = vim.system({ "unzip", "-p", jar_file, entry_path }, { text = true }):wait()
          if result.code ~= 0 then
            vim.notify("Failed to extract " .. entry_path .. " from " .. jar_file, vim.log.levels.ERROR)
            return
          end

          local lines = vim.split(result.stdout, "\n", { trimempty = false })
          if #lines > 0 and lines[#lines] == "" then
            table.remove(lines)
          end

          local bufnr = args.buf
          vim.bo[bufnr].modifiable = true
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
          vim.bo[bufnr].modifiable = false
          vim.bo[bufnr].readonly = true
          vim.bo[bufnr].buftype = "nofile"
          vim.bo[bufnr].filetype = "java"
          vim.bo[bufnr].swapfile = false
        end,
      })
    end,
  },
}
