local M = {}

local function load_state(path)
  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok then
    return {}
  end
  local ok_decode, decoded = pcall(vim.json.decode, table.concat(lines, "\n"))
  if ok_decode and type(decoded) == "table" then
    return decoded
  end
  return {}
end

local function save_state(path, state)
  local ok_encode, encoded = pcall(vim.json.encode, state)
  if not ok_encode then
    return
  end
  vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
  vim.fn.writefile({ encoded }, path)
end

local function ensure_installed(server_name)
  local mappings = require("mason-lspconfig.mappings").get_mason_map()
  local registry = require("mason-registry")
  local package_name = mappings.lspconfig_to_package[server_name] or server_name

  if not registry.has_package(package_name) then
    return false
  end

  local pkg = registry.get_package(package_name)
  if pkg:is_installed() then
    return true
  end

  pkg:install()
  pkg:on("install:success", function()
    vim.schedule(function()
      pcall(vim.cmd, "LspStart")
    end)
  end)

  return false
end

function M.setup()
  local state_path = vim.fn.stdpath("state") .. "/lsp_filetype_servers.json"
  local state = load_state(state_path)
  local pending = {}

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("UserLspAutoInstall", { clear = true }),
    callback = function(args)
      local ft = vim.bo[args.buf].filetype
      if not ft or ft == "" then
        return
      end

      local filetype_map = require("mason-lspconfig.mappings").get_filetype_map()
      local servers = filetype_map[ft] or {}
      if #servers == 0 then
        return
      end

      local chosen = state[ft]
      if chosen and chosen ~= "" then
        ensure_installed(chosen)
        return
      elseif chosen == "" then
        -- User previously declined, so don't prompt again
        return
      end

      if pending[ft] then
        return
      end
      pending[ft] = true

      vim.ui.select(servers, {
        prompt = ("Select LSP server for %q:"):format(ft),
        format_item = function(server)
          local mappings = require("mason-lspconfig.mappings").get_mason_map()
          local registry = require("mason-registry")
          local package_name = mappings.lspconfig_to_package[server] or server
          if registry.has_package(package_name) and registry.is_installed(package_name) then
            return ("%s (installed)"):format(server)
          end
          return server
        end,
      }, function(choice)
        pending[ft] = nil
        if not choice then
          -- Save empty string to remember that user declined to install an LSP
          state[ft] = ""
          save_state(state_path, state)
          return
        end
        state[ft] = choice
        save_state(state_path, state)
        ensure_installed(choice)
      end)
    end,
  })
end

return M
