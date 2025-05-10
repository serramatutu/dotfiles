return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<leader>bc",
        function()
          require("dap").continue()
        end,
      },
      {
        "<leader>bj",
        function()
          require("dap").step_over()
        end,
      },
      {
        "<leader>bk",
        function()
          require("dap").step_into()
        end,
      },
      {
        "<leader>bl",
        function()
          require("dap").step_out()
        end,
      },
      {
        "<leader>bb",
        function()
          require("dap").toggle_breakpoint()
        end,
      },
      {
        "<leader>bf",
        function()
          require("dap-python").test_method()
        end,
      },
    },
  },
  {
    "mfussenegger/nvim-dap-python",
    dependencies = { "mfussenegger/nvim-dap" },
    ft = "python",
    config = function()
      require("dap-python").setup("python3")
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      dapui.setup({
        mappings = {
          edit = "e",
          expand = { "<cr>", "<l>", "<Space>" },
          open = { "<cr>", "<l>", "<Space>" },
          remove = { "d", "D" },
          repl = "r",
          toggle = "t",
        },
      })

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
  },
}
