return {
  "mfussenegger/nvim-dap",
  { 
    "rcarriga/nvim-dap-ui", dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      dapui.setup({
        mappings = {
          edit = "e",
          expand = { "<cr>", "<l>", "<Space>" },
          open = { "<cr>", "<l>", "<Space>" },
          remove = { "d", "D" },
          repl = "r",
          toggle = "t"
        }      
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
    end
  }
}