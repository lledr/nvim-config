return {
  "JavaHello/spring-boot.nvim",
  ft = {"java", "yaml", "jproperties"},
  dependencies = {
    "mfussenegger/nvim-jdtls",
  },

  ---@type bootls.Config
  opts = {}
}
