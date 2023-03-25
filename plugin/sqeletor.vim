if exists("g:loaded_sqeletor")
    finish
endif
let g:loaded_sqeletor = 1

command! -nargs=0 SqeletorScript lua require('sqeletor').new_script()
command! -nargs=0 SqeletorProcedure lua require('sqeletor').new_procedure()
