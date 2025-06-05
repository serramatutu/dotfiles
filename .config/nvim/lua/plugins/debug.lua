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
    config = function()
      local dap = require("dap")

      dap.adapters.lldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = "codelldb",
          args = { "--port", "${port}" },
          detached = false,
        },
      }

      dap.configurations.c = {
        {
          name = "Debug an Executable",
          type = "lldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
      dap.configurations.cpp = dap.configurations.c
      dap.configurations.rust = dap.configurations.c

      local dapui = require("dapui")

      dapui.setup({
        mappings = {
          edit = "e",
          expand = { "<cr>", "l", "<Space>" },
          open = { "o" },
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
    keys = {
      {
        "<leader>bh",
        function()
          require("dapui").eval()
        end,
      },
    },
  },
}
