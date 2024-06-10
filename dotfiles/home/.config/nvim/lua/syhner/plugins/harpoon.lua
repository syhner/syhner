return {
  "theprimeagen/harpoon",
  config = function()
    require("harpoon").setup({})

    vim.keymap.set("n", "<leader>pa", "<cmd>lua require('harpoon.mark').add_file()<CR>",
      { desc = "har[P]oon [A]dd file" })
    vim.keymap.set("n", "<leader>pq", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>",
      { desc = "har[P]oon [Q]uick menu" })
    vim.keymap.set("n", "<leader>ps", "<cmd>lua require('harpoon.ui').nav_file(1)<CR>",
      { desc = "har[P]oon navigate to 1" })
    vim.keymap.set("n", "<leader>pd", "<cmd>lua require('harpoon.ui').nav_file(2)<CR>",
      { desc = "har[P]oon navigate to 2" })
    vim.keymap.set("n", "<leader>pf", "<cmd>lua require('harpoon.ui').nav_file(3)<CR>",
      { desc = "har[P]oon navigate to 3" })
    vim.keymap.set("n", "<leader>pg", "<cmd>lua require('harpoon.ui').nav_file(4)<CR>",
      { desc = "har[P]oon navigate to 4" })
    vim.keymap.set("n", "<leader>ph", "<cmd>lua require('harpoon.ui').nav_file(5)<CR>",
      { desc = "har[P]oon navigate to 5" })
  end,
}
