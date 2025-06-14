return {
  "nomnivore/ollama.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {},
  keys = {
    { "<leader>oo", "<cmd>OllamaChat<CR>", desc = "Ollama Chat" },
  },
}
