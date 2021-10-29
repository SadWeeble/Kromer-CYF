local TP = {}
--TODO FIX THIS
TP.tp          = 100       -- THE ACTUAL TP VALUE
TP.visualtp    = 0       -- What the WHITE/RED bar displays
TP.laggedtp    = 0       -- What the orange bar displays
TP.maxtp       = 100     -- The maximum amount of TP allowed!
TP.highlighted = 0       -- How much TP is highlighted to show an action cost. 0 For no highlight.

TP.color_backdrop   = {0.5, 0, 0}
TP.color_fill       = {1, 160/255, 64/255}
TP.color_float      = {1, 1, 1}
TP.color_sink       = {1, 0, 0}
TP.color_max        = {1, 208/255, 32/255}

function GetTP()
     return TP.tp
end

function SetTP(tp)
     TP.tp = math.min(tp,TP.maxtp)
end

function GetMaxTP()
     return TP.maxtp
end

function SetMaxTP(max)
     TP.maxtp = max
end

function AddTP(tp)
     TP.tp = TP.tp + math.min(tp,TP.maxtp-TP.tp)
end

TP.Init = function()
     TP.Frame = CreateSprite(Kromer_FindSprite("UI/Battle/tpbar"),"UpperUI")
     TP.Frame.MoveTo(50,342)

     TP.Background = CreateSprite(Kromer_FindSprite("UI/Battle/tpback"))
     TP.Background.SetParent(TP.Frame)
     TP.Background.Mask("sprite")
     TP.Background.MoveTo(0,0)

     TP.Float = CreateSprite("px")
     TP.Float.SetParent(TP.Background)
     TP.Float.MoveTo(0,-TP.Background.height/2)
     TP.Float.ypivot = 0
     TP.Float.xscale = TP.Background.width

     TP.Sink = CreateSprite("px")
     TP.Sink.SetParent(TP.Background)
     TP.Sink.MoveTo(0,-TP.Background.height/2)
     TP.Sink.ypivot = 0
     TP.Sink.xscale = TP.Background.width

     TP.Fill = CreateSprite("px")
     TP.Fill.SetParent(TP.Background)
     TP.Fill.MoveTo(0,-TP.Background.height/2)
     TP.Fill.ypivot = 0
     TP.Fill.xscale = TP.Background.width

     TP.Highlight = CreateSprite("px")
     TP.Highlight.SetParent(TP.Background)
     TP.Highlight.MoveTo(0,-TP.Background.height/2)
     TP.Highlight.ypivot = 0
     TP.Highlight.xscale = TP.Background.width

     TP.Indicator = CreateSprite(Kromer_FindSprite("UI/Battle/tpindicator"))
     TP.Indicator.SetParent(TP.Frame)
     TP.Indicator.MoveTo(-31,45)

     TP.Text = TextSystem.CreateText("[instant]Oopsie Doodle","BattleUIText",320,240,"UpperUI")
     TP.Text["text"].SetParent(TP.Indicator)
     TP.Text["text"].MoveTo(-10,-42)
     TP.Text.Set = function()
          local space = 0
          local xscale = 1
          local text = math.floor(math.min(TP.visualtp,TP.laggedtp))
          TP.Percent.alpha = 1
          if text < 10 then
               space = 2
          end
          if text >= 10 then
               space = -5
          end
          if text >= 100 then
               space = -9
               xscale = 0.75
          end
          if text >= TP.maxtp then
               text = "[linespacing:-10][color:ffff00]M\n A\n[charspacing:5] X"
               space = -2
               xscale = 1
               TP.Percent.alpha = 0
          end
          TP.Text["text"].xscale = xscale
          TP.Text["text"].SetText("[font:uidialog][linespacing:-5][instant][charspacing:"..space.."] [charspacing:default]"..text)
     end

     TP.Percent = CreateSprite(Kromer_FindSprite("UI/Battle/tppercent"))
     TP.Percent.SetParent(TP.Frame)
     TP.Percent.MoveTo(-29,-13)

     TP.Text.Set()
end

TP.Update = function()
     TP.Float.y = -TP.Background.height/2
     TP.Sink.y = -TP.Background.height/2

     TP.Background.alpha = 1
     TP.Highlight.alpha = 0

     TP.Background.color = TP.color_backdrop
     TP.Fill.color = TP.color_fill
     TP.Float.color = TP.color_float
     TP.Sink.color = TP.color_sink

     if math.abs(TP.visualtp - TP.tp) < 10 then TP.visualtp = TP.tp end
     if TP.visualtp < TP.tp then TP.visualtp = TP.visualtp + 10 end
     if TP.visualtp > TP.tp then TP.visualtp = TP.visualtp - 10 end
     if TP.visualtp ~= TP.laggedtp then
          if TP.visualtp - TP.laggedtp > 0    then TP.laggedtp = TP.laggedtp + 1 end
          if TP.visualtp - TP.laggedtp > 10   then TP.laggedtp = TP.laggedtp + 1 end
          if TP.visualtp - TP.laggedtp > 25   then TP.laggedtp = TP.laggedtp + 1.5 end
          if TP.visualtp - TP.laggedtp > 50   then TP.laggedtp = TP.laggedtp + 2 end
          if TP.visualtp - TP.laggedtp > 100  then TP.laggedtp = TP.laggedtp + 2.5 end
          if TP.visualtp - TP.laggedtp < 0    then TP.laggedtp = TP.laggedtp - 1 end
          if TP.visualtp - TP.laggedtp < -10  then TP.laggedtp = TP.laggedtp - 1 end
          if TP.visualtp - TP.laggedtp < -25  then TP.laggedtp = TP.laggedtp - 1.5 end
          if TP.visualtp - TP.laggedtp < -50  then TP.laggedtp = TP.laggedtp - 2 end
          if TP.visualtp - TP.laggedtp < -100 then TP.laggedtp = TP.laggedtp - 2.5 end
          if math.abs(TP.visualtp - TP.laggedtp) < 1 then TP.laggedtp = TP.visualtp end
          TP.Text.Set()
     end
     if TP.visualtp < TP.laggedtp then
          TP.Sink.yscale = (TP.laggedtp / TP.maxtp) * TP.Background.height
          TP.Float.yscale = TP.Sink.yscale + 2
          TP.Fill.yscale = (TP.visualtp / TP.maxtp) * TP.Background.height
     elseif TP.visualtp > TP.laggedtp then
          TP.Float.yscale = (TP.visualtp / TP.maxtp) * TP.Background.height + 2
          if TP.laggedtp == TP.maxtp then TP.Fill.color = TP.color_max end
          TP.Fill.yscale = (TP.laggedtp / TP.maxtp) * TP.Background.height
     elseif TP.visualtp == TP.laggedtp then
          TP.Sink.yscale = 0
          if TP.laggedtp == TP.maxtp then TP.Fill.color = TP.color_max end
          TP.Fill.yscale = (TP.laggedtp / TP.maxtp) * TP.Background.height
          TP.Float.yscale = TP.Fill.yscale + 2
     end
     if TP.highlighted > 0 then
          -- Extremely funky way to achieve the highlight effect with only the currently loaded sprites.
          -- Background is hidden, fill is lowered, float becomes a bar, sink becomes the background
          local height_tp = (TP.tp / TP.maxtp) * TP.Background.height

          -- Set highlight color
          local highlightcolor = {1,1,1}
          highlightcolor[4] = math.abs(math.sin(Time.time*2) * 0.5) + 0.2


          local aftercost = ((TP.tp - TP.highlighted) / TP.maxtp) * TP.Background.height

          -- This little maneuver is gonna cost us all our TP
          if aftercost <= 0 then
                highlightcolor = {0.25,0.25,0.25}
                highlightcolor[4] = 0.7
          end

          -- Gah hah hah!! THOUST FOOLS! That wasn'tst the REAL highlight colore! For some reason.
          highlightcolor = {lerp(highlightcolor[1],TP.color_fill[1],highlightcolor[4]),lerp(highlightcolor[2],TP.color_fill[2],highlightcolor[4]),lerp(highlightcolor[3],TP.color_fill[3],highlightcolor[4]),0.7}

          -- Just make float the little white bar
          TP.Float.y = -TP.Background.height/2 + height_tp
          TP.Float.yscale = 2

          -- Make the sink the fake background
          -- TODO: Replace this in case people use non-solid color sprites for their TP background?
          TP.Sink.color = TP.color_backdrop
          TP.Sink.yscale = TP.Background.height - height_tp
          TP.Sink.y = -TP.Background.height/2 + height_tp + 2

          -- Change fill height
          TP.Fill.yscale = aftercost

          -- Add the highlight where the fill left off
          TP.Highlight.color = highlightcolor
          TP.Highlight.yscale = (TP.highlighted / TP.maxtp) * TP.Background.height
          TP.Highlight.y = -TP.Background.height/2 + TP.Fill.yscale

          TP.Background.alpha = 0.01 -- Hopefully no one will notice. A workaround for that gosh-dern mask!
     end
end

return TP
