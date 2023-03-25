##### Usage:

#### Lazy
```
return {
  {
    "groovyghoul/sqeletor.nvim",
  },
}
```

##### To develop:

lua vim.opt.runtimepath:append(',~/source/sqeletor.nvim')

##### To runt/test:

lua require('sqeletor').new_script()
lua require('sqeletor').new_procedure()

##### TODO:
- figure out how to reposition cursor to 2nd row
- can the input prompt be positioned? Would like to be centered, at least

