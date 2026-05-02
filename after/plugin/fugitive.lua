-- Add all files
vim.keymap.set("n", "<leader>ga", function()
  vim.cmd("silent! !git add .")
  print("Added all files")
end)

-- Commit
vim.keymap.set("n", "<leader>gc", function()
  local msg = vim.fn.input("Commit message: ")
  if msg ~= "" then
    vim.cmd('silent! !git commit -m "' .. msg .. '"')
    print("Committed: " .. msg)
  end
end)

-- Pull
vim.keymap.set("n", "<leader>gpl", function()
  vim.cmd("silent! !git pull")
  print("Pulled changes")
end)

-- Push
vim.keymap.set("n", "<leader>gps", function()
  vim.cmd("silent! !git push")
  print("Pushed changes")
end)

-- Create branch
vim.keymap.set("n", "<leader>gb", function()
  local name = vim.fn.input("Branch name: ")
  if name ~= "" then
    vim.cmd("silent! !git checkout -b " .. name)
    print("Created branch: " .. name)
  end
end)

-- Add remote
vim.keymap.set("n", "<leader>gr", function()
  local name = vim.fn.input("Remote name: ")
  if name == "" then return end
  local url = vim.fn.input("Remote URL: ")
  if url == "" then return end

  vim.cmd("silent! !git remote add " .. name .. " " .. url)
  print("Added remote: " .. name)
end)


vim.keymap.set("n", "<leader>gpu", function()
  local branch = vim.fn.system("git branch --show-current"):gsub("\n", "")
  vim.cmd("Git push -u origin " .. branch)
  print("Pushed with upstream: " .. branch)
end)
