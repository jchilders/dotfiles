local fn = vim.fn

local download_packer = function()
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    print "Downloading packer..."
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    print "... done. Restart necessary. Quit NeoVim."
    vim.cmd([[packadd packer.nvim]])
  end
end

return function()
  if not pcall(require, 'packer') then
    download_packer()
    return true
  end

  return false
end
