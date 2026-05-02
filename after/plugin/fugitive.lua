-- Git status (still useful as your main hub)
vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Git status" })

-- Add ALL files (git add .)
vim.keymap.set("n", "<leader>gaa", function()
  vim.cmd("Git add .")
end, { desc = "Git add all files" })

-- Commit
vim.keymap.set("n", "<leader>gc", function()
  vim.cmd("Git commit")
end, { desc = "Git commit" })

-- Create new branch
vim.keymap.set("n", "<leader>gbc", function()
  vim.cmd("Git checkout -b ")
end, { desc = "Git create branch" })

-- Pull
vim.keymap.set("n", "<leader>gp", function()
  vim.cmd("Git pull")
end, { desc = "Git pull" })
