# SQeLetor
## Neovim Opinionated Templating Plugin

### Installation 

**Lazy**
```
return {
  {
    "groovyghoul/sqeletor.nvim",
  },
}
```

**Configuration**
```
return {
  {
    "groovyghoul/sqeletor.nvim",
    lazy = false,
    keys = {
      {
        "<leader>sq",
        function()
          require("sqeletor").new_script()
        end,
        desc = "Fire up SQeLetor for script",
      },
      {
        "<leader>sp",
        function()
          require("sqeletor").new_procedure()
        end,
        desc = "Fire up SQeLetor for procedure",
      },
    },
  },
}
```

### Usage

**Commands**

`SqeletorScript`

`SqeletorProcedure`

### Development

lua vim.opt.runtimepath:append(',~/source/sqeletor.nvim')

To runt/test:

```
lua require('sqeletor').new_script()
lua require('sqeletor').new_procedure()
```

