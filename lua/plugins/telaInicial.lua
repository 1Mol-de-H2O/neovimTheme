return {
  dir = vim.fn.stdpath('config'),
  name = 'telainicial',
  lazy = false,
  config = function()
    vim.api.nvim_set_hl(0, 'TelaInicialKey', { fg = '#E8D5A0', bold = true })
    vim.api.nvim_set_hl(0, 'TelaInicialText', { fg = '#B8C99A' })
    vim.api.nvim_set_hl(0, 'TelaInicialArt', { fg = '#D68C45' })
    vim.api.nvim_set_hl(0, 'TelaInicialDate', { fg = '#8A8F85', italic = true })

    local function abrir_tela_inicial()
      local art_str = [[
                                         ..,d?*]
                                      ,u$%p%$?'      ,y\%1
                                    ,u$$S1Ii;.'  _.,ru$p,._;
                                   .u$$1Ii:.._,u$$$$SI?SI?'
                                 ,u$$$?::.,d$$$$$$SS1Ii:-`
                             _, d$SSI:. j$$$S%7iSi:-`
                           ,p: d$$?i: d$$SIii:`
                         ,dS: j$$i:. ,$$S?ii:..       _.,_..,1yo,..
                       .d$7: js$i:- j$$I?i:j:..    ,d$$$$SS1II$$i1jo'
                       $$I:. j$$?:. j$$I?i:i:.. ,d$$$SI?SSI:ili;²
                      i$S: -j$$?:-,d$$I?i::.. ,$$$$SSIii:..
                      S$1:j$$?:,d$7I$?::..,d$$SS1Ii:- 
                     $Sij$$Sid?jSI$$:-,d$$$$SIii:-
                    j$$$? js$7:dSi$Spd$$$S?ii:.
                    $$$7js$$:iiSS$$$?iIS$ili::-
                    d$$?js$$1i:JS$$Si1:ii?:ii:-
                   j$$7is$$:dSI$$$$;ii::S:ii:.                 .:I$'jb
                  .$$iIS$?:dS$$$$7:iSII:?::i:.                :i$L %"
                 d$Iis$$?iss$$$?:iIS$Iii?::::.              .:S$SIi-`
                 isSIss$$$7::iiSS$$SiISiii::..             ::iI$ISk?
               _j$IS$$$iiIS$$b:is$$SiIS$::is-.            .:ISk?bi?
              .j$IS$$$iiIS$SI$:%I$SiiiSI::j?:..        .:ii$L?b.?:
             .j$IS$$$ss$$SSiIS$$i:?$$SIi$i:i?:..    ..::iS$$Sk?s°
             ,SI$$$$$$$IS$$$$S:iISSSISII?::..,ii::i::iiIS$$17:'
            $IS$$$$$$$iiIS$$1I$i:iSS$SIII::,ii'::iiIS$$?°:.
           d$$$$$$$? :lis$$SIiS?:iSS$1III::'..::iiIS$$?::.
          d$$$$$$$?:iIIS$$Ii:$I:IS$$Iii::::::iiIS$$?::.
         d$$$$$$$?:ii1ISSIIii:S$:IIS$$Ii:::iiIS$$$?`
       ,s$$$$$$S:ii1ISS1iii::iSb:IIS$ii:iISI$$$?^
     ,d$$$$$$$$i1iIS$$S1ii::iiS$iISS$IidSII?^
   .d$$$$$$$SIS$$iiIS$$S1ii::iiiS$$$?:?ISII:`
  $SS$$SIIiS$$1iss$$S1ii::iiSS$?*..::ii1?`
 1SSS1IiSS$1ISS$$S1ii:iii$$?`--::i?'
 1IS$$SIS$$iIS$$SLi:iiIS$S7--::-'
]]

      local art = vim.split(art_str, '\n')
      while art[1] == '' do table.remove(art, 1) end
      while art[#art] == '' do table.remove(art, #art) end

      local function show_git_status()
        local branch = vim.fn.systemlist('git rev-parse --abbrev-ref HEAD')[1]
        if vim.v.shell_error ~= 0 then
          vim.notify('Esta pasta não é um repositório git', vim.log.levels.WARN, { title = 'Git status' })
          return
        end
        local status = vim.fn.systemlist('git status --short')
        local lines = { 'Branch atual: ' .. branch, '' }
        if #status == 0 then
          table.insert(lines, 'Nada pra commitar — tudo limpo.')
        else
          vim.list_extend(lines, status)
        end
        vim.notify(table.concat(lines, '\n'), vim.log.levels.INFO, { title = 'Git status' })
      end

      local menu_items = {
        { text = 'Novo arquivo',        key = 'e', cmd = ':enew<CR>' },
        { text = 'Buscar arquivo',      key = 'f', cmd = ':Telescope find_files<CR>' },
    --  { text = 'Buscar texto',        key = 'g', cmd = ':Telescope live_grep<CR>' },
        { text = 'Arquivos recentes',   key = 'r', cmd = ':Telescope oldfiles<CR>' },
        { text = 'Projetos recentes',   key = 'p', cmd = ':Telescope project<CR>' },
        { text = 'Configurações',       key = 'c', cmd = ':e $MYVIMRC<CR>' },
        { text = 'Git status',          key = 's', fn = show_git_status },
        { text = 'Sair',                key = 'q', cmd = ':qa<CR>' },
      }

      local art_width = 0
      for _, l in ipairs(art) do
        art_width = math.max(art_width, vim.fn.strdisplaywidth(l))
      end

      local gap = 6
      local start_line = 8
      local date_line_idx
      local date_col_start

      local lines = {}
      local highlights = {}

      for i, l in ipairs(art) do
        local pad = (art_width - vim.fn.strdisplaywidth(l)) + gap
        local right_text = ''
        local rel = i - start_line
        local line_idx = i - 1

        if rel == 1 then
          right_text = os.date('%d/%m/%Y  •  %H:%M:%S')
          date_line_idx = line_idx
          date_col_start = #l + pad
        elseif rel >= 3 and menu_items[rel - 2] then
          local item = menu_items[rel - 2]
          right_text = string.format('[%s]  %s', item.key, item.text)
        end

        local line = l .. string.rep(' ', pad) .. right_text
        table.insert(lines, line)

        table.insert(highlights, { line_idx, 0, #l, 'TelaInicialArt' })

        if rel == 1 then
          table.insert(highlights, { line_idx, #l + pad, #line, 'TelaInicialDate' })
        elseif rel >= 3 and menu_items[rel - 2] then
          local key_start = #l + pad
          local key_end = key_start + 3
          table.insert(highlights, { line_idx, key_start, key_end, 'TelaInicialKey' })
          table.insert(highlights, { line_idx, key_end, #line, 'TelaInicialText' })
        end
      end

      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      vim.api.nvim_set_current_buf(buf)

      vim.bo[buf].buftype = 'nofile'
      vim.bo[buf].bufhidden = 'wipe'
      vim.bo[buf].swapfile = false
      vim.bo[buf].modifiable = false

      local prev_number = vim.wo.number
      local prev_relativenumber = vim.wo.relativenumber
      local prev_cursorline = vim.wo.cursorline

      vim.wo.number = false
      vim.wo.relativenumber = false
      vim.wo.cursorline = false

      local ns = vim.api.nvim_create_namespace('telainicial')
      for _, h in ipairs(highlights) do
        vim.api.nvim_buf_add_highlight(buf, ns, h[4], h[1], h[2], h[3])
      end

      for _, item in ipairs(menu_items) do
        if item.fn then
          vim.keymap.set('n', item.key, item.fn, { buffer = buf, silent = true })
        else
          vim.keymap.set('n', item.key, item.cmd, { buffer = buf, silent = true })
        end
      end

      local timer = vim.loop.new_timer()
      timer:start(1000, 1000, vim.schedule_wrap(function()
        if not vim.api.nvim_buf_is_valid(buf) then
          timer:stop()
          timer:close()
          return
        end

        local new_time = os.date('%d/%m/%Y  •  %H:%M:%S')
        local current_line = vim.api.nvim_buf_get_lines(buf, date_line_idx, date_line_idx + 1, false)[1]
        local art_part = current_line:sub(1, date_col_start)
        local new_line = art_part .. new_time

        vim.bo[buf].modifiable = true
        vim.api.nvim_buf_set_lines(buf, date_line_idx, date_line_idx + 1, false, { new_line })
        vim.bo[buf].modifiable = false

        vim.api.nvim_buf_clear_namespace(buf, ns, date_line_idx, date_line_idx + 1)
        vim.api.nvim_buf_add_highlight(buf, ns, 'TelaInicialArt', date_line_idx, 0, #art_part)
        vim.api.nvim_buf_add_highlight(buf, ns, 'TelaInicialDate', date_line_idx, date_col_start, #new_line)
      end))

      vim.api.nvim_create_autocmd('BufWipeout', {
        buffer = buf,
        callback = function()
          timer:stop()
          timer:close()
	  vim.wo.number = prev_number
          vim.wo.relativenumber = prev_relativenumber
          vim.wo.cursorline = prev_cursorline
        end,
      })
    end

    vim.api.nvim_create_autocmd('VimEnter', {
      callback = function()
        if vim.fn.argc() > 0 then return end
        abrir_tela_inicial()
      end,
    })

    vim.api.nvim_create_user_command('TelaInicial', abrir_tela_inicial, {})

    vim.keymap.set('n', '<leader>h', abrir_tela_inicial, { desc = 'Voltar para a tela inicial' })
  end,
}
