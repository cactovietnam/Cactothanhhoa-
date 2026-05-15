-- NGUYEN CUTO v8.0 (Fixed)
local ok_init,err_init=pcall(function()
local TS=game:GetService("TeleportService")
local PL=game:GetService("Players")
local HS=game:GetService("HttpService")
local RS=game:GetService("ReplicatedStorage")
local UIS=game:GetService("UserInputService")
local TW=game:GetService("TweenService")
local LT=game:GetService("Lighting")
local player=PL.LocalPlayer
local placeId=game.PlaceId
local SF="NCv8.json"
local DEF={x=80,y=80,autoHop=false,autoEgg=true,targetEgg="Frostwyrm's Egg",checkInt=5,eggInt=15,fixLag=false,selectedRifts={},riftPriority="near",autoRift=false,riftDelay=3,targetMon=""}
local function loadS()
    if not(type(readfile)=="function")then return DEF end
    local ok,c=pcall(readfile,SF)
    if ok and c and c~=""then
        local ok2,d=pcall(function()return HS:JSONDecode(c)end)
        if ok2 and d then for k,v in pairs(DEF)do if d[k]==nil then d[k]=v end end;return d end
    end;return DEF
end
local function saveS(s)if type(writefile)=="function"then pcall(writefile,SF,HS:JSONEncode(s))end end
local C=loadS()
local AH=C.autoHop;local AE=C.autoEgg;local TE=C.targetEgg;local TM=C.targetMon or ""
local CI=C.checkInt;local EI=C.eggInt;local FL=C.fixLag
local AR=C.autoRift;local SEL=C.selectedRifts or{};local PRIOR=C.riftPriority;local RDEL=C.riftDelay
local recent={};local riftRunning=false
local GRAY=Color3.fromRGB(200,200,200);local lagConn=nil
local function isDyn(v)return v:FindFirstChildOfClass("Humanoid")or v:IsA("Tool")or v.Name:lower():find("pet")or v.Name:lower():find("drop")or v.Name:lower():find("coin")or v.Name:lower():find("orb")end
local function optObj(v)pcall(function()
    if v:IsA("ParticleEmitter")or v:IsA("Trail")or v:IsA("Beam")then v.Enabled=false
    elseif v:IsA("Decal")or v:IsA("Texture")then v.Transparency=1
    elseif isDyn(v)then for _,p in pairs(v:GetDescendants())do if p:IsA("BasePart")then p.Transparency=1;p.CanCollide=false end end
    elseif v:IsA("BasePart")then v.Material=Enum.Material.SmoothPlastic;v.Color=GRAY;v.CastShadow=false end
end)end
local function applyLag()
    LT.GlobalShadows=false;LT.Brightness=2;LT.FogEnd=9e9
    for _,v in pairs(LT:GetDescendants())do pcall(function()if v:IsA("PostEffect")then v.Enabled=false end end)end
    local items=workspace:GetDescendants();local i=0
    task.spawn(function()
        for _,v in ipairs(items)do i=i+1;optObj(v);if i%200==0 then task.wait()end end
        if lagConn then lagConn:Disconnect()end
        lagConn=workspace.DescendantAdded:Connect(function(v)task.wait();optObj(v)end)
    end)
end
local function offLag()if lagConn then lagConn:Disconnect();lagConn=nil end;LT.GlobalShadows=true end
local old=player.PlayerGui:FindFirstChild("NCGui");if old then old:Destroy()end
if not player.Character then player.CharacterAdded:Wait()end;task.wait(0.5)
local sg=Instance.new("ScreenGui");sg.Name="NCGui";sg.ResetOnSpawn=false;sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling;sg.Parent=player.PlayerGui
local tF=Instance.new("Frame",sg);tF.Size=UDim2.new(0,52,0,52);tF.Position=UDim2.new(0,8,0.5,-26);tF.BackgroundColor3=Color3.fromRGB(10,10,15);tF.BorderSizePixel=0;tF.ZIndex=20
Instance.new("UICorner",tF).CornerRadius=UDim.new(0.5,0);Instance.new("UIStroke",tF).Color=Color3.fromRGB(80,80,100)
local tB=Instance.new("ImageButton",tF);tB.Size=UDim2.new(0.86,0,0.86,0);tB.Position=UDim2.new(0.07,0,0.07,0);tB.BackgroundTransparency=1;tB.Image="rbxassetid://132832532598279";tB.ScaleType=Enum.ScaleType.Fit;tB.ZIndex=21
Instance.new("UICorner",tB).CornerRadius=UDim.new(0.5,0)
local WW,WH=600,440
local win=Instance.new("Frame",sg);win.Size=UDim2.new(0,WW,0,WH);win.Position=UDim2.new(0,C.x,0,C.y);win.BackgroundColor3=Color3.fromRGB(10,10,14);win.BorderSizePixel=0;win.ZIndex=5
Instance.new("UICorner",win).CornerRadius=UDim.new(0,12);Instance.new("UIStroke",win).Color=Color3.fromRGB(45,45,65)
local tb=Instance.new("Frame",win);tb.Size=UDim2.new(1,0,0,44);tb.BackgroundColor3=Color3.fromRGB(15,15,22);tb.BorderSizePixel=0;tb.ZIndex=6
Instance.new("UICorner",tb).CornerRadius=UDim.new(0,12)
local acc=Instance.new("Frame",tb);acc.Size=UDim2.new(0,3,0.6,0);acc.Position=UDim2.new(0,10,0.2,0);acc.BackgroundColor3=Color3.fromRGB(130,80,255);acc.BorderSizePixel=0;acc.ZIndex=7;Instance.new("UICorner",acc).CornerRadius=UDim.new(0,2)
local tLbl=Instance.new("TextLabel",tb);tLbl.Size=UDim2.new(0,180,1,0);tLbl.Position=UDim2.new(0,18,0,0);tLbl.BackgroundTransparency=1;tLbl.Text="NGUYEN CUTO";tLbl.TextColor3=Color3.fromRGB(255,255,255);tLbl.TextScaled=true;tLbl.Font=Enum.Font.GothamBold;tLbl.TextXAlignment=Enum.TextXAlignment.Left;tLbl.ZIndex=7
local RB={Color3.fromRGB(255,80,80),Color3.fromRGB(255,160,0),Color3.fromRGB(255,255,60),Color3.fromRGB(60,255,100),Color3.fromRGB(60,180,255),Color3.fromRGB(150,60,255),Color3.fromRGB(255,60,200)}
local rci=1;task.spawn(function()while task.wait(0.22)do if tLbl and tLbl.Parent then tLbl.TextColor3=RB[rci];rci=rci%#RB+1 end end end)
local sub=Instance.new("TextLabel",tb);sub.Size=UDim2.new(0,200,0,14);sub.Position=UDim2.new(0,18,0,28);sub.BackgroundTransparency=1;sub.Text="Catch a Monster • v8.0";sub.TextColor3=Color3.fromRGB(60,60,90);sub.TextScaled=true;sub.Font=Enum.Font.Gotham;sub.TextXAlignment=Enum.TextXAlignment.Left;sub.ZIndex=7
local cB=Instance.new("TextButton",tb);cB.Size=UDim2.new(0,26,0,26);cB.Position=UDim2.new(1,-34,0.5,-13);cB.BackgroundColor3=Color3.fromRGB(180,50,50);cB.TextColor3=Color3.fromRGB(255,255,255);cB.Text="✕";cB.TextScaled=true;cB.Font=Enum.Font.GothamBold;cB.BorderSizePixel=0;cB.ZIndex=7
Instance.new("UICorner",cB).CornerRadius=UDim.new(0,6);cB.MouseButton1Click:Connect(function()win.Visible=false end)
local tabBar=Instance.new("Frame",win);tabBar.Size=UDim2.new(1,0,0,36);tabBar.Position=UDim2.new(0,0,0,45);tabBar.BackgroundColor3=Color3.fromRGB(13,13,20);tabBar.BorderSizePixel=0;tabBar.ZIndex=6
local tabL=Instance.new("UIListLayout",tabBar);tabL.FillDirection=Enum.FillDirection.Horizontal;tabL.HorizontalAlignment=Enum.HorizontalAlignment.Left;tabL.VerticalAlignment=Enum.VerticalAlignment.Center;tabL.Padding=UDim.new(0,3)
local tabP=Instance.new("UIPadding",tabBar);tabP.PaddingLeft=UDim.new(0,6);tabP.PaddingTop=UDim.new(0,3);tabP.PaddingBottom=UDim.new(0,3)
local cont=Instance.new("Frame",win);cont.Size=UDim2.new(1,0,1,-82);cont.Position=UDim2.new(0,0,0,82);cont.BackgroundTransparency=1;cont.ClipsDescendants=true;cont.ZIndex=6
local pages={};local curTab=nil
local function showPage(n)for k,p in pairs(pages)do p.Visible=(k==n)end end
local function mkPage(n)
    local s=Instance.new("ScrollingFrame",cont);s.Size=UDim2.new(1,0,1,0);s.BackgroundTransparency=1;s.BorderSizePixel=0;s.ScrollBarThickness=3;s.ScrollBarImageColor3=Color3.fromRGB(70,70,100);s.Visible=false;s.ZIndex=7
    local l=Instance.new("UIListLayout",s);l.Padding=UDim.new(0,5);l.SortOrder=Enum.SortOrder.LayoutOrder
    local p=Instance.new("UIPadding",s);p.PaddingLeft=UDim.new(0,10);p.PaddingRight=UDim.new(0,10);p.PaddingTop=UDim.new(0,8);p.PaddingBottom=UDim.new(0,8)
    l:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()s.CanvasSize=UDim2.new(0,0,0,l.AbsoluteContentSize.Y+16)end)
    pages[n]=s;return s
end
local ord={};local function no(n)ord[n]=(ord[n] or 0)+1;return ord[n]end
local function mkTab(lbl,icon,pg)
    local b=Instance.new("TextButton",tabBar);b.Size=UDim2.new(0,105,1,0);b.BackgroundColor3=Color3.fromRGB(20,20,30);b.TextColor3=Color3.fromRGB(150,150,175);b.Text=icon.."  "..lbl;b.TextScaled=true;b.Font=Enum.Font.GothamBold;b.BorderSizePixel=0;b.ZIndex=7
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,7)
    b.MouseButton1Click:Connect(function()showPage(pg);if curTab then curTab.BackgroundColor3=Color3.fromRGB(20,20,30);curTab.TextColor3=Color3.fromRGB(150,150,175)end;curTab=b;b.BackgroundColor3=Color3.fromRGB(130,80,255);b.TextColor3=Color3.fromRGB(255,255,255)end);return b
end
local function mkSec(pg,txt,col)local l=Instance.new("TextLabel",pages[pg]);l.Size=UDim2.new(1,0,0,20);l.BackgroundTransparency=1;l.Text=txt;l.TextColor3=col or Color3.fromRGB(130,80,255);l.TextScaled=true;l.Font=Enum.Font.GothamBold;l.TextXAlignment=Enum.TextXAlignment.Left;l.ZIndex=8;l.LayoutOrder=no(pg)end
local function mkStat(pg,txt)local l=Instance.new("TextLabel",pages[pg]);l.Size=UDim2.new(1,0,0,15);l.BackgroundTransparency=1;l.Text=txt;l.TextColor3=Color3.fromRGB(140,140,165);l.TextScaled=true;l.Font=Enum.Font.Gotham;l.TextXAlignment=Enum.TextXAlignment.Left;l.ZIndex=8;l.LayoutOrder=no(pg);return l end
local function mkDiv(pg)local d=Instance.new("Frame",pages[pg]);d.Size=UDim2.new(1,0,0,1);d.BackgroundColor3=Color3.fromRGB(35,35,55);d.BorderSizePixel=0;d.ZIndex=8;d.LayoutOrder=no(pg)end
local function mkRow(pg,h)local r=Instance.new("Frame",pages[pg]);r.Size=UDim2.new(1,0,0,h or 52);r.BackgroundColor3=Color3.fromRGB(17,17,25);r.BorderSizePixel=0;r.ZIndex=8;r.LayoutOrder=no(pg);Instance.new("UICorner",r).CornerRadius=UDim.new(0,8);Instance.new("UIStroke",r).Color=Color3.fromRGB(38,38,58);return r end
local function rLbl(r,lbl,desc)local l=Instance.new("TextLabel",r);l.Size=UDim2.new(0.55,0,0,20);l.Position=UDim2.new(0,10,0,7);l.BackgroundTransparency=1;l.Text=lbl;l.TextColor3=Color3.fromRGB(230,230,255);l.TextScaled=true;l.Font=Enum.Font.GothamBold;l.TextXAlignment=Enum.TextXAlignment.Left;l.ZIndex=9;if desc then local d=Instance.new("TextLabel",r);d.Size=UDim2.new(0.55,0,0,14);d.Position=UDim2.new(0,10,0,29);d.BackgroundTransparency=1;d.Text=desc;d.TextColor3=Color3.fromRGB(90,90,120);d.TextScaled=true;d.Font=Enum.Font.Gotham;d.TextXAlignment=Enum.TextXAlignment.Left;d.ZIndex=9 end end
local function mkToggle(pg,lbl,desc,init,col,cb)
    local r=mkRow(pg);rLbl(r,lbl,desc)
    local bg=Instance.new("Frame",r);bg.Size=UDim2.new(0,42,0,22);bg.Position=UDim2.new(1,-52,0.5,-11);bg.BackgroundColor3=init and col or Color3.fromRGB(45,45,60);bg.BorderSizePixel=0;bg.ZIndex=9;Instance.new("UICorner",bg).CornerRadius=UDim.new(0.5,0)
    local k=Instance.new("Frame",bg);k.Size=UDim2.new(0,16,0,16);k.Position=init and UDim2.new(1,-19,0.5,-8)or UDim2.new(0,3,0.5,-8);k.BackgroundColor3=Color3.fromRGB(255,255,255);k.BorderSizePixel=0;k.ZIndex=10;Instance.new("UICorner",k).CornerRadius=UDim.new(0.5,0)
    local st=init
    local function tog()st=not st;TW:Create(bg,TweenInfo.new(0.15),{BackgroundColor3=st and col or Color3.fromRGB(45,45,60)}):Play();TW:Create(k,TweenInfo.new(0.15),{Position=st and UDim2.new(1,-19,0.5,-8)or UDim2.new(0,3,0.5,-8)}):Play();if cb then cb(st)end end
    r.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then tog()end end)
    return r,function()return st end
end
local function mkBtn(pg,lbl,desc,col,cb)
    local r=mkRow(pg);rLbl(r,lbl,desc)
    local b=Instance.new("TextButton",r);b.Size=UDim2.new(0,64,0,28);b.Position=UDim2.new(1,-74,0.5,-14);b.BackgroundColor3=col or Color3.fromRGB(130,80,255);b.TextColor3=Color3.fromRGB(255,255,255);b.Text="▶";b.TextScaled=true;b.Font=Enum.Font.GothamBold;b.BorderSizePixel=0;b.ZIndex=9;Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
    b.MouseButton1Click:Connect(function()TW:Create(b,TweenInfo.new(0.08),{BackgroundColor3=Color3.fromRGB(255,255,255)}):Play();task.wait(0.08);TW:Create(b,TweenInfo.new(0.08),{BackgroundColor3=col or Color3.fromRGB(130,80,255)}):Play();if cb then cb()end end);return b
end
local function mkInput(pg,lbl,desc,init,mn,mx,cb)
    local r=mkRow(pg);rLbl(r,lbl,desc)
    local b=Instance.new("TextBox",r);b.Size=UDim2.new(0,64,0,28);b.Position=UDim2.new(1,-74,0.5,-14);b.BackgroundColor3=Color3.fromRGB(22,22,34);b.TextColor3=Color3.fromRGB(255,215,80);b.Text=tostring(init);b.TextScaled=true;b.Font=Enum.Font.GothamBold;b.ClearTextOnFocus=false;b.BorderSizePixel=0;b.ZIndex=9;Instance.new("UICorner",b).CornerRadius=UDim.new(0,6);Instance.new("UIStroke",b).Color=Color3.fromRGB(80,80,120)
    b.FocusLost:Connect(function()local v=tonumber(b.Text);if v and v>=mn and v<=mx then if cb then cb(v)end;init=v else b.Text=tostring(init)end end);return b
end
local RIFTS={{id=71,name="Spirit Grove Rift",diff=1},{id=72,name="Spirit Grove Rift",diff=2},{id=73,name="Spirit Grove Rift",diff=3},{id=91,name="Blossom Haven Rift",diff=1},{id=92,name="Blossom Haven Rift",diff=2},{id=93,name="Blossom Haven Rift",diff=3},{id=41,name="Neverland Rift",diff=1},{id=42,name="Neverland Rift",diff=2},{id=61,name="Tideland Rift",diff=1},{id=62,name="Tideland Rift",diff=2},{id=63,name="Tideland Rift",diff=3},{id=21,name="Volcano Rift",diff=1},{id=22,name="Volcano Rift",diff=2},{id=51,name="Duneveil Isle Rift",diff=1},{id=52,name="Duneveil Isle Rift",diff=2},{id=53,name="Duneveil Isle Rift",diff=3},{id=83,name="Dragon's Breath Rift",diff=3},{id=10000,name="Strange Rift",diff=2},{id=10005,name="Chaos Rift",diff=2},{id=10006,name="Valentine's Rift",diff=3}}
local diffStar={"★","★★","★★★"}
local diffCol={Color3.fromRGB(60,200,80),Color3.fromRGB(220,160,0),Color3.fromRGB(220,60,60)}
mkPage("hop");mkPage("egg");mkPage("rift");mkPage("lag")
local t1=mkTab("Hop","⚡","hop");mkTab("Egg","🥚","egg");mkTab("Rift","🌀","rift");mkTab("Lag","⚙️","lag")
mkSec("hop","⚡  Hop Server",Color3.fromRGB(60,180,255))
local hStat=mkStat("hop","⏸  Sẵn sàng...")
local mStat=mkStat("hop","🔍  Kiểm tra monster...")
mkDiv("hop")
mkToggle("hop","Auto Hop","Hop khi không có monster",AH,Color3.fromRGB(0,155,215),function(v)AH=v;C.autoHop=v;saveS(C)end)
mkInput("hop","Check interval","Giây (1-60)",CI,1,60,function(v)CI=v;C.checkInt=v;saveS(C)end)
-- Monster filter UI
mkSec("hop","🐉  Chọn Monster",Color3.fromRGB(60,200,120))
local mSubStat=mkStat("hop","Để trống = mọi monster | Tab 'Biết' = chọn kể cả chưa xuất hiện")
local mRow=mkRow("hop",52);rLbl(mRow,"Tên / ID Monster","Tên thật (Monster_12) hoặc từ khóa (Frostwyrm)")
local mBox=Instance.new("TextBox",mRow);mBox.Size=UDim2.new(0.44,0,0,28);mBox.Position=UDim2.new(0.54,0,0.5,-14);mBox.BackgroundColor3=Color3.fromRGB(22,22,34);mBox.TextColor3=Color3.fromRGB(80,255,120);mBox.Text=TM;mBox.TextScaled=true;mBox.Font=Enum.Font.GothamBold;mBox.ClearTextOnFocus=false;mBox.BorderSizePixel=0;mBox.ZIndex=9
Instance.new("UICorner",mBox).CornerRadius=UDim.new(0,6);Instance.new("UIStroke",mBox).Color=Color3.fromRGB(60,180,80)
mBox.FocusLost:Connect(function()TM=mBox.Text;C.targetMon=TM;saveS(C);mStat.Text=(TM~=""and"🎯  Target: "..TM or"🔍  Mọi monster")end)

-- Tab bar: Scan | Biết
local mTabRow=mkRow("hop",34)
local mTabScan=Instance.new("TextButton",mTabRow);mTabScan.Size=UDim2.new(0,130,0,26);mTabScan.Position=UDim2.new(0,8,0.5,-13);mTabScan.BackgroundColor3=Color3.fromRGB(30,130,200);mTabScan.TextColor3=Color3.fromRGB(255,255,255);mTabScan.Text="📡 Trong server";mTabScan.TextScaled=true;mTabScan.Font=Enum.Font.GothamBold;mTabScan.BorderSizePixel=0;mTabScan.ZIndex=9
Instance.new("UICorner",mTabScan).CornerRadius=UDim.new(0,6)
local mTabKnown=Instance.new("TextButton",mTabRow);mTabKnown.Size=UDim2.new(0,130,0,26);mTabKnown.Position=UDim2.new(0,144,0.5,-13);mTabKnown.BackgroundColor3=Color3.fromRGB(30,30,45);mTabKnown.TextColor3=Color3.fromRGB(150,150,175);mTabKnown.Text="📋 Tất cả đã biết";mTabKnown.TextScaled=true;mTabKnown.Font=Enum.Font.GothamBold;mTabKnown.BorderSizePixel=0;mTabKnown.ZIndex=9
Instance.new("UICorner",mTabKnown).CornerRadius=UDim.new(0,6)
local scanBtn=Instance.new("TextButton",mTabRow);scanBtn.Size=UDim2.new(0,62,0,26);scanBtn.Position=UDim2.new(1,-72,0.5,-13);scanBtn.BackgroundColor3=Color3.fromRGB(80,60,160);scanBtn.TextColor3=Color3.fromRGB(255,255,255);scanBtn.Text="🔄 Scan";scanBtn.TextScaled=true;scanBtn.Font=Enum.Font.GothamBold;scanBtn.BorderSizePixel=0;scanBtn.ZIndex=9
Instance.new("UICorner",scanBtn).CornerRadius=UDim.new(0,6)

-- 2 list frames cùng vị trí, toggle visible
local mScanFrame=Instance.new("Frame",pages["hop"]);mScanFrame.Size=UDim2.new(1,0,0,110);mScanFrame.BackgroundColor3=Color3.fromRGB(13,13,20);mScanFrame.BorderSizePixel=0;mScanFrame.ZIndex=8;mScanFrame.LayoutOrder=no("hop")
Instance.new("UICorner",mScanFrame).CornerRadius=UDim.new(0,8);Instance.new("UIStroke",mScanFrame).Color=Color3.fromRGB(38,38,58)
local mScanSF=Instance.new("ScrollingFrame",mScanFrame);mScanSF.Size=UDim2.new(1,0,1,0);mScanSF.BackgroundTransparency=1;mScanSF.BorderSizePixel=0;mScanSF.ScrollBarThickness=3;mScanSF.CanvasSize=UDim2.new(0,0,0,0);mScanSF.ZIndex=9
local mScanLayout=Instance.new("UIListLayout",mScanSF);mScanLayout.Padding=UDim.new(0,2);mScanLayout.SortOrder=Enum.SortOrder.LayoutOrder
local mScanPad=Instance.new("UIPadding",mScanSF);mScanPad.PaddingLeft=UDim.new(0,4);mScanPad.PaddingRight=UDim.new(0,4);mScanPad.PaddingTop=UDim.new(0,3)
mScanLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()mScanSF.CanvasSize=UDim2.new(0,0,0,mScanLayout.AbsoluteContentSize.Y+6)end)

local mKnownFrame=Instance.new("Frame",pages["hop"]);mKnownFrame.Size=UDim2.new(1,0,0,110);mKnownFrame.BackgroundColor3=Color3.fromRGB(13,13,20);mKnownFrame.BorderSizePixel=0;mKnownFrame.ZIndex=8;mKnownFrame.LayoutOrder=no("hop");mKnownFrame.Visible=false
Instance.new("UICorner",mKnownFrame).CornerRadius=UDim.new(0,8);Instance.new("UIStroke",mKnownFrame).Color=Color3.fromRGB(38,38,58)
local mKnownSF=Instance.new("ScrollingFrame",mKnownFrame);mKnownSF.Size=UDim2.new(1,0,1,0);mKnownSF.BackgroundTransparency=1;mKnownSF.BorderSizePixel=0;mKnownSF.ScrollBarThickness=3;mKnownSF.CanvasSize=UDim2.new(0,0,0,0);mKnownSF.ZIndex=9
local mKnownLayout=Instance.new("UIListLayout",mKnownSF);mKnownLayout.Padding=UDim.new(0,2);mKnownLayout.SortOrder=Enum.SortOrder.LayoutOrder
local mKnownPad=Instance.new("UIPadding",mKnownSF);mKnownPad.PaddingLeft=UDim.new(0,4);mKnownPad.PaddingRight=UDim.new(0,4);mKnownPad.PaddingTop=UDim.new(0,3)
mKnownLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()mKnownSF.CanvasSize=UDim2.new(0,0,0,mKnownLayout.AbsoluteContentSize.Y+6)end)
-- Placeholder khi đang load config
local mKnownLoading=Instance.new("TextLabel",mKnownSF);mKnownLoading.Size=UDim2.new(1,0,0,22);mKnownLoading.BackgroundTransparency=1;mKnownLoading.Text="⏳  Đang load CfgMonster từ game...";mKnownLoading.TextColor3=Color3.fromRGB(150,150,175);mKnownLoading.TextScaled=true;mKnownLoading.Font=Enum.Font.Gotham;mKnownLoading.ZIndex=10

local mSelB=nil -- button đang chọn (dùng chung 2 tab)

-- Switch tab
local function switchMonTab(toScan)
    mScanFrame.Visible=toScan;mKnownFrame.Visible=not toScan
    mTabScan.BackgroundColor3=toScan and Color3.fromRGB(30,130,200)or Color3.fromRGB(30,30,45)
    mTabScan.TextColor3=toScan and Color3.fromRGB(255,255,255)or Color3.fromRGB(150,150,175)
    mTabKnown.BackgroundColor3=not toScan and Color3.fromRGB(100,60,200)or Color3.fromRGB(30,30,45)
    mTabKnown.TextColor3=not toScan and Color3.fromRGB(255,255,255)or Color3.fromRGB(150,150,175)
end
mTabScan.MouseButton1Click:Connect(function()switchMonTab(true)end)
mTabKnown.MouseButton1Click:Connect(function()switchMonTab(false)end)

-- Helper: tạo item cho cả 2 tab
local function mkMonItem(parent,rawName,displayName,accentColor)
    local isSel=rawName:lower()==TM:lower()
    local col=accentColor or Color3.fromRGB(40,140,60)
    local b=Instance.new("TextButton",parent)
    b.Size=UDim2.new(1,0,0,24);b.BackgroundColor3=isSel and col or Color3.fromRGB(20,20,30)
    b.TextColor3=isSel and Color3.fromRGB(255,255,255)or Color3.fromRGB(185,185,205)
    b.Text=(isSel and"✓  "or"    ")..displayName
    b.TextScaled=true;b.Font=Enum.Font.Gotham;b.BorderSizePixel=0;b.TextXAlignment=Enum.TextXAlignment.Left;b.ZIndex=10
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,4)
    if isSel then mSelB=b end
    b.MouseButton1Click:Connect(function()
        if mSelB then
            local prev=mSelB.Text:gsub("^✓  ",""):gsub("^%s+","")
            mSelB.BackgroundColor3=Color3.fromRGB(20,20,30);mSelB.TextColor3=Color3.fromRGB(185,185,205);mSelB.Text="    "..prev
        end
        mSelB=b;b.BackgroundColor3=col;b.TextColor3=Color3.fromRGB(255,255,255);b.Text="✓  "..displayName
        TM=rawName;mBox.Text=TM;C.targetMon=TM;saveS(C)
        mStat.Text=(TM~=""and"🎯  Target: "..TM or"🔍  Mọi monster")
    end)
    return b
end

-- ── Tab SCAN: quét workspace ─────────────────────────────────────────
local function doScan()
    for _,c in ipairs(mScanSF:GetChildren())do if c:IsA("TextButton")then c:Destroy()end end
    mSelB=nil
    mkMonItem(mScanSF,"","🔓  Any  (mọi monster)")
    local seen={};local count=0
    for _,folder in ipairs({workspace:FindFirstChild("Monsters"),workspace:FindFirstChild("ClientMonsters")})do
        if folder then for _,o in ipairs(folder:GetDescendants())do
            if o:IsA("Model") and not seen[o.Name] then
                local nm=o.Name:find("Monster_")~=nil
                local hm=o:FindFirstChildOfClass("Humanoid")~=nil
                if nm or hm then
                    seen[o.Name]=true;count=count+1
                    local display=o.Name
                    local sv=o:FindFirstChild("Name")or o:FindFirstChild("MonsterName")or o:FindFirstChild("DisplayName")
                    if sv and sv:IsA("StringValue")and sv.Value~=""then display=sv.Value.."  ["..o.Name.."]" end
                    mkMonItem(mScanSF,o.Name,display,Color3.fromRGB(40,140,60))
                end
            end
        end end
    end
    if count==0 then
        local lbl=Instance.new("TextLabel",mScanSF);lbl.Size=UDim2.new(1,0,0,22);lbl.BackgroundTransparency=1
        lbl.Text="⚠️  Server này chưa có monster — thử tab 'Tất cả đã biết'";lbl.TextColor3=Color3.fromRGB(180,100,100);lbl.TextScaled=true;lbl.Font=Enum.Font.Gotham;lbl.ZIndex=10
    end
    mSubStat.Text="📡  Scan: "..count.." loại trong server này"
end

-- ── Tab KNOWN: load từ CfgMonster trong RS ──────────────────────────
-- Thử tất cả tên config có thể có
local CM=nil
task.spawn(function()
    local cfgNames={"CfgMonster","CfgEnemy","CfgBoss","CfgCreature","CfgMob","MonsterConfig","EnemyConfig"}
    for _,n in ipairs(cfgNames)do
        local ok,r=pcall(function()return require(RS:FindFirstChild(n,true))end)
        if ok and r and r.Tmpls then CM=r;print("[NC] CfgMonster loaded:",n);break end
    end
    if not CM then
        -- Fallback: duyệt toàn RS tìm ModuleScript có .Tmpls chứa .Name
        for _,v in ipairs(RS:GetDescendants())do
            if v:IsA("ModuleScript") and v.Name:lower():find("monster") or (v.IsA and v:IsA("ModuleScript") and v.Name:lower():find("cfg"))then
                local ok2,r2=pcall(require,v)
                if ok2 and type(r2)=="table" and r2.Tmpls then
                    -- Kiểm tra xem Tmpls có chứa Name field không
                    for _,t in pairs(r2.Tmpls)do
                        if type(t)=="table" and t.Name then CM=r2;print("[NC] CfgMonster fallback:",v.Name);break end
                    end
                end
                if CM then break end
            end
        end
    end

    -- Populate tab Known sau khi load xong
    -- Xóa "Đang tải..."
    for _,c in ipairs(mKnownSF:GetChildren())do if c:IsA("TextButton")or c:IsA("TextLabel")then c:Destroy()end end

    -- Any luôn đầu tiên
    mkMonItem(mKnownSF,"","🔓  Any  (mọi monster)",Color3.fromRGB(60,60,90))

    if CM and CM.Tmpls then
        local list={}
        for id,t in pairs(CM.Tmpls)do
            if type(t)=="table" and t.Name then
                -- Model trong workspace sẽ là "Monster_<id>"
                table.insert(list,{raw="Monster_"..tostring(id), name=t.Name, id=id})
            end
        end
        table.sort(list,function(a,b)return a.name<b.name end)
        for _,m in ipairs(list)do
            -- Tìm emoji theo tên
            local em="🐉"
            local nl=m.name:lower()
            if nl:find("frost")or nl:find("ice")or nl:find("snow")then em="❄️"
            elseif nl:find("thunder")or nl:find("lightning")then em="⚡"
            elseif nl:find("tide")or nl:find("coral")or nl:find("water")then em="🌊"
            elseif nl:find("fire")or nl:find("volcano")or nl:find("lava")then em="🔥"
            elseif nl:find("blossom")or nl:find("rose")or nl:find("flower")then em="🌸"
            elseif nl:find("shadow")or nl:find("dark")or nl:find("chaos")then em="🌑"
            elseif nl:find("strange")then em="🌀"
            elseif nl:find("sand")or nl:find("dune")then em="🏜️"
            elseif nl:find("dragon")then em="🐲"
            elseif nl:find("spirit")then em="👻"
            elseif nl:find("valentine")then em="💝"
            end
            mkMonItem(mKnownSF, m.raw, em.."  "..m.name.."  ["..m.raw.."]", Color3.fromRGB(100,60,200))
        end
        mSubStat.Text="📋  "..#list.." monster từ config"
        print("[NC] Known tab: "..#list.." monsters loaded from CfgMonster")
    else
        -- Config không load được → hiện thông báo + fallback keyword list
        local warn=Instance.new("TextLabel",mKnownSF);warn.Size=UDim2.new(1,0,0,30);warn.BackgroundTransparency=1
        warn.Text="⚠️  Không đọc được CfgMonster\nDùng keyword — chỉ match khi monster đã spawn";warn.TextColor3=Color3.fromRGB(220,120,50);warn.TextScaled=true;warn.Font=Enum.Font.Gotham;warn.ZIndex=10;warn.TextWrapped=true
        local fallback={"Frostwyrm","Thunderclaw","Tidevex","Gildron","Blossom","Rosette","Coral","Volcanon","Sandwurm","Shadowfang","Strange","Chaos","Valentine","Dragon","Spirit"}
        for _,n in ipairs(fallback)do
            mkMonItem(mKnownSF,n,"🔑  "..n.."  (keyword)",Color3.fromRGB(80,80,160))
        end
        mSubStat.Text="⚠️  Config không load được, dùng keyword"
    end
end)

scanBtn.MouseButton1Click:Connect(function()
    scanBtn.Text="⏳...";task.wait(0.05);doScan();switchMonTab(true);scanBtn.Text="🔄 Scan"
end)
task.delay(3,doScan)
mkDiv("hop")
local hBtn=mkBtn("hop","Hop Ngay","Tìm server ít người",Color3.fromRGB(0,175,80),nil)
mkSec("egg","🥚  Auto Egg",Color3.fromRGB(255,175,0))
local eStat=mkStat("egg","🥚  Chờ...")
mkDiv("egg")
mkToggle("egg","Auto Egg","Tự ấp và lấy trứng",AE,Color3.fromRGB(200,100,0),function(v)AE=v;C.autoEgg=v;saveS(C)end)
mkInput("egg","Egg interval","Giây (1-30)",EI,1,30,function(v)EI=v;C.eggInt=v;saveS(C)end)
local eRow=mkRow("egg",52);rLbl(eRow,"Tên trứng","Gõ hoặc chọn nhanh")
local eBox=Instance.new("TextBox",eRow);eBox.Size=UDim2.new(0.44,0,0,28);eBox.Position=UDim2.new(0.54,0,0.5,-14);eBox.BackgroundColor3=Color3.fromRGB(22,22,34);eBox.TextColor3=Color3.fromRGB(255,215,80);eBox.Text=TE;eBox.TextScaled=true;eBox.Font=Enum.Font.GothamBold;eBox.ClearTextOnFocus=false;eBox.BorderSizePixel=0;eBox.ZIndex=9
Instance.new("UICorner",eBox).CornerRadius=UDim.new(0,6);Instance.new("UIStroke",eBox).Color=Color3.fromRGB(200,140,0)
eBox.FocusLost:Connect(function()TE=eBox.Text;C.targetEgg=TE;saveS(C);eStat.Text="🥚  Target: "..TE end)
local eggNames={"Blossom Egg","Rosette Egg","Gildron's Egg","Coral Egg","TideVex's Egg","Giant Tree Egg","Frostwyrm's Egg","Thunderclaw's Egg","GrassEgg","SwampEgg"}
local eHdr=Instance.new("TextLabel",pages["egg"]);eHdr.Size=UDim2.new(1,0,0,14);eHdr.BackgroundTransparency=1;eHdr.Text="Chọn nhanh:";eHdr.TextColor3=Color3.fromRGB(80,80,110);eHdr.TextScaled=true;eHdr.Font=Enum.Font.Gotham;eHdr.TextXAlignment=Enum.TextXAlignment.Left;eHdr.ZIndex=8;eHdr.LayoutOrder=no("egg")
local eSF=Instance.new("ScrollingFrame",pages["egg"]);eSF.Size=UDim2.new(1,0,0,80);eSF.BackgroundColor3=Color3.fromRGB(13,13,20);eSF.BorderSizePixel=0;eSF.ScrollBarThickness=3;eSF.CanvasSize=UDim2.new(0,0,0,#eggNames*25);eSF.ZIndex=8;eSF.LayoutOrder=no("egg")
Instance.new("UICorner",eSF).CornerRadius=UDim.new(0,8);Instance.new("UIStroke",eSF).Color=Color3.fromRGB(38,38,58);Instance.new("UIListLayout",eSF).Padding=UDim.new(0,2)
local eSP=Instance.new("UIPadding",eSF);eSP.PaddingLeft=UDim.new(0,4);eSP.PaddingRight=UDim.new(0,4);eSP.PaddingTop=UDim.new(0,3)
local eSelB=nil
for _,name in ipairs(eggNames)do
    local isSel=name:lower()==TE:lower()
    local b=Instance.new("TextButton",eSF);b.Size=UDim2.new(1,0,0,22);b.BackgroundColor3=isSel and Color3.fromRGB(200,100,0)or Color3.fromRGB(20,20,30);b.TextColor3=isSel and Color3.fromRGB(255,255,255)or Color3.fromRGB(185,185,205);b.Text=(isSel and "✓  "or"    ")..name;b.TextScaled=true;b.Font=Enum.Font.Gotham;b.BorderSizePixel=0;b.TextXAlignment=Enum.TextXAlignment.Left;b.ZIndex=9
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,5);if isSel then eSelB=b end
    b.MouseButton1Click:Connect(function()
        if eSelB then eSelB.BackgroundColor3=Color3.fromRGB(20,20,30);eSelB.TextColor3=Color3.fromRGB(185,185,205);eSelB.Text="    "..eSelB.Text:gsub("^✓  ","")end
        eSelB=b;b.BackgroundColor3=Color3.fromRGB(200,100,0);b.TextColor3=Color3.fromRGB(255,255,255);b.Text="✓  "..name
        TE=name;eBox.Text=name;C.targetEgg=name;saveS(C);eStat.Text="🥚  Target: "..name
    end)
end
mkSec("rift","🌀  Auto Rift",Color3.fromRGB(150,80,255))
local rStat=mkStat("rift","🌀  Chờ khởi động...")
local rStat2=mkStat("rift","📋  Rift đã chọn: 0")
mkDiv("rift")
mkToggle("rift","Auto Rift","Tự động loop Rift",AR,Color3.fromRGB(130,60,220),function(v)AR=v;C.autoRift=v;saveS(C)end)
mkInput("rift","Delay giữa Rift","Giây (1-30)",RDEL,1,30,function(v)RDEL=v;C.riftDelay=v;saveS(C)end)
local prioRow=mkRow("rift",52);rLbl(prioRow,"Ưu tiên","near=gần | high=khó | rand=ngẫu nhiên")
local prioBtns={}
local prioFrame=Instance.new("Frame",prioRow);prioFrame.Size=UDim2.new(0,160,0,30);prioFrame.Position=UDim2.new(1,-170,0.5,-15);prioFrame.BackgroundTransparency=1;prioFrame.ZIndex=9
local prioL=Instance.new("UIListLayout",prioFrame);prioL.FillDirection=Enum.FillDirection.Horizontal;prioL.Padding=UDim.new(0,3)
for _,opt in ipairs({"near","high","rand"})do
    local labels={near="📍Near",high="⬆High",rand="🎲Rand"}
    local pb=Instance.new("TextButton",prioFrame);pb.Size=UDim2.new(0,50,1,0);pb.BackgroundColor3=(PRIOR==opt)and Color3.fromRGB(130,80,255)or Color3.fromRGB(30,30,45);pb.TextColor3=Color3.fromRGB(255,255,255);pb.Text=labels[opt];pb.TextScaled=true;pb.Font=Enum.Font.GothamBold;pb.BorderSizePixel=0;pb.ZIndex=10
    Instance.new("UICorner",pb).CornerRadius=UDim.new(0,5);prioBtns[opt]=pb
    pb.MouseButton1Click:Connect(function()for k,b in pairs(prioBtns)do b.BackgroundColor3=Color3.fromRGB(30,30,45)end;pb.BackgroundColor3=Color3.fromRGB(130,80,255);PRIOR=opt;C.riftPriority=opt;saveS(C)end)
end
local rHdr=Instance.new("TextLabel",pages["rift"]);rHdr.Size=UDim2.new(1,0,0,14);rHdr.BackgroundTransparency=1;rHdr.Text="Chọn Rift:";rHdr.TextColor3=Color3.fromRGB(80,80,110);rHdr.TextScaled=true;rHdr.Font=Enum.Font.GothamBold;rHdr.TextXAlignment=Enum.TextXAlignment.Left;rHdr.ZIndex=8;rHdr.LayoutOrder=no("rift")
local rSF=Instance.new("ScrollingFrame",pages["rift"]);rSF.Size=UDim2.new(1,0,0,140);rSF.BackgroundColor3=Color3.fromRGB(13,13,20);rSF.BorderSizePixel=0;rSF.ScrollBarThickness=3;rSF.CanvasSize=UDim2.new(0,0,0,#RIFTS*27);rSF.ZIndex=8;rSF.LayoutOrder=no("rift")
Instance.new("UICorner",rSF).CornerRadius=UDim.new(0,8);Instance.new("UIStroke",rSF).Color=Color3.fromRGB(38,38,58);Instance.new("UIListLayout",rSF).Padding=UDim.new(0,2)
local rSP=Instance.new("UIPadding",rSF);rSP.PaddingLeft=UDim.new(0,4);rSP.PaddingRight=UDim.new(0,4);rSP.PaddingTop=UDim.new(0,3)
local selRifts={}
for _,id in ipairs(SEL)do selRifts[id]=true end
local function updateSelCount()local n=0;for _ in pairs(selRifts)do n=n+1 end;rStat2.Text="📋  Rift đã chọn: "..n end
for _,rift in ipairs(RIFTS)do
    local isSel=selRifts[rift.id]==true;local col=diffCol[rift.diff]or Color3.fromRGB(130,80,255)
    local b=Instance.new("TextButton",rSF);b.Size=UDim2.new(1,0,0,24);b.BackgroundColor3=isSel and Color3.fromRGB(50,30,80)or Color3.fromRGB(20,20,30);b.TextColor3=isSel and Color3.fromRGB(255,255,255)or Color3.fromRGB(185,185,205);b.Text=(isSel and "☑ "or"☐ ")..diffStar[rift.diff].."  "..rift.name;b.TextScaled=true;b.Font=Enum.Font.Gotham;b.BorderSizePixel=0;b.TextXAlignment=Enum.TextXAlignment.Left;b.ZIndex=9
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,5)
    local dot=Instance.new("Frame",b);dot.Size=UDim2.new(0,4,0.6,0);dot.Position=UDim2.new(1,-8,0.2,0);dot.BackgroundColor3=col;dot.BorderSizePixel=0;dot.ZIndex=10;Instance.new("UICorner",dot).CornerRadius=UDim.new(0,2)
    b.MouseButton1Click:Connect(function()
        selRifts[rift.id]=not selRifts[rift.id];local s=selRifts[rift.id]
        b.BackgroundColor3=s and Color3.fromRGB(50,30,80)or Color3.fromRGB(20,20,30);b.TextColor3=s and Color3.fromRGB(255,255,255)or Color3.fromRGB(185,185,205);b.Text=(s and "☑ "or"☐ ")..diffStar[rift.diff].."  "..rift.name
        local arr={};for id in pairs(selRifts)do if selRifts[id]then table.insert(arr,id)end end;SEL=arr;C.selectedRifts=arr;saveS(C);updateSelCount()
    end)
end
updateSelCount();mkDiv("rift")
local rBtn=mkBtn("rift","Start Rift","Tìm và join Rift",Color3.fromRGB(130,60,220),nil)
mkBtn("rift","Dừng","Dừng auto rift",Color3.fromRGB(150,50,50),function()riftRunning=false;rStat.Text="⏹  Đã dừng"end)
mkSec("lag","⚙️  Fix Lag",Color3.fromRGB(200,80,80));mkStat("lag","Giữ map, ẩn rác, tắt effect");mkDiv("lag")
mkToggle("lag","Fix Lag","Bật/tắt fix lag",FL,Color3.fromRGB(200,60,60),function(v)FL=v;C.fixLag=v;saveS(C);if v then applyLag()else offLag()end end)
mkBtn("lag","Áp dụng ngay","Chạy fix lag ngay",Color3.fromRGB(180,50,50),function()applyLag()end)
tB.MouseButton1Click:Connect(function()win.Visible=not win.Visible end)
showPage("hop");curTab=t1;t1.BackgroundColor3=Color3.fromRGB(130,80,255);t1.TextColor3=Color3.fromRGB(255,255,255)
local drg,dS,dP=false,nil,nil
local function clamp(x,y)local sw=workspace.CurrentCamera.ViewportSize.X;local sh=workspace.CurrentCamera.ViewportSize.Y;return math.clamp(x,0,sw-WW),math.clamp(y,0,sh-WH)end
tb.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drg=true;dS=i.Position;dP=win.Position end end)
UIS.InputChanged:Connect(function(i)if not drg then return end;if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then local d=i.Position-dS;local nx,ny=clamp(dP.X.Offset+d.X,dP.Y.Offset+d.Y);win.Position=UDim2.new(0,nx,0,ny)end end)
UIS.InputEnded:Connect(function(i)if(i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch)and drg then drg=false;C.x=win.Position.X.Offset;C.y=win.Position.Y.Offset;saveS(C)end end)
local function isRec(id)for _,v in ipairs(recent)do if v==id then return true end end;return false end
local function addRec(id)table.insert(recent,1,id);if #recent>8 then table.remove(recent)end end
local function getSvr()local ok,r=pcall(function()return game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100")end);if ok then local ok2,d=pcall(function()return HS:JSONDecode(r)end);if ok2 then return d end end;return nil end
local function hasMon()
    local ch=player.Character;if not ch then return false end
    local rt=ch:FindFirstChild("HumanoidRootPart");if not rt then return false end
    local filter=TM~="" and TM:lower() or nil
    for _,f in ipairs({workspace:FindFirstChild("Monsters"),workspace:FindFirstChild("ClientMonsters")})do
        if f then for _,o in ipairs(f:GetDescendants())do
            if o:IsA("Model")then
                local nm=o.Name:find("Monster_")~=nil
                local hm=o:FindFirstChildOfClass("Humanoid")~=nil
                if nm or hm then
                    if filter then
                        -- Match full tên thật (Monster_12) HOẶC tên hiển thị trong StringValue
                        local rawMatch=o.Name:lower():find(filter,1,true)
                        local svMatch=false
                        local sv=o:FindFirstChild("Name")or o:FindFirstChild("MonsterName")or o:FindFirstChild("DisplayName")
                        if sv and sv:IsA("StringValue") then svMatch=sv.Value:lower():find(filter,1,true)~=nil end
                        if not rawMatch and not svMatch then continue end
                    end
                    local r2=o:FindFirstChild("HumanoidRootPart")or o.PrimaryPart
                    if r2 and(rt.Position-r2.Position).Magnitude<=40 then return true end
                end
            end
        end end
    end
    return false
end
local hop2=false
local function doHop()
    if hop2 then return end;hop2=true;hStat.Text="⏳  Đang tìm..."
    local d=getSvr();if not d or not d.data or #d.data==0 then hStat.Text="❌  Lỗi API!";hop2=false;return end
    addRec(game.JobId)
    local servers={}
    for _,s in ipairs(d.data)do if s.id~=game.JobId and not isRec(s.id)then local maxP=s.maxPlayers or 20;if s.playing<=maxP-2 then table.insert(servers,s)end end end
    if #servers==0 then hStat.Text="⚠️  Không tìm thấy server!";hop2=false;return end
    table.sort(servers,function(a,b)return a.playing<b.playing end)
    local idx=0;local conn=nil;local done=false
    local function tryNext()
        idx=idx+1
        if idx>#servers then hStat.Text="⚠️  Tất cả server lỗi!";if conn then pcall(function()conn:Disconnect()end);conn=nil end;hop2=false;done=true;return end
        local s=servers[idx];hStat.Text=string.format("🔄  Thử %d/%d (%dp)...",idx,#servers,s.playing);addRec(s.id)
        pcall(function()TS:TeleportToPlaceInstance(placeId,s.id,player)end)
    end
    local ok_ev,ev=pcall(function()return TS.TeleportInitFailed end)
    if ok_ev and ev then conn=ev:Connect(function(plr,result)if plr~=player then return end;hStat.Text="❌  Lỗi "..tostring(result).." – thử tiếp...";task.wait(0.8);tryNext()end)end
    tryNext()
    task.delay(60,function()if not done then if conn then pcall(function()conn:Disconnect()end);conn=nil end;hop2=false;hStat.Text="⏹  Timeout"end end)
end
hBtn.MouseButton1Click:Connect(doHop)
task.spawn(function()while task.wait(CI)do if not AH or hop2 then continue end;if hasMon()then mStat.Text="🐉  Có monster!";mStat.TextColor3=Color3.fromRGB(255,100,100)else mStat.Text="😴  Hop!";mStat.TextColor3=Color3.fromRGB(255,200,0);hStat.Text="🔄  Auto hop...";task.wait(2);doHop()end end end)
local function getEggSys()
    local ok1,ES=pcall(function()return require(RS.CommonLogic.Egg.EggSystem)end);local ok2,EV=pcall(function()return require(RS.ClientLogic.Egg.EggSelectView)end);local ok3,IB=pcall(function()return require(RS.ClientLogic.Item.ItemBagView)end);local ok4,CE=pcall(function()return require(RS:FindFirstChild("CfgEgg",true))end);local ok5,VU=pcall(function()return require(RS:FindFirstChild("ViewUtil",true))end)
    if ok1 and ok2 and ok3 and ok4 and ok5 then return ES,EV,IB,CE,VU end;return nil
end
local function getTgt(gp,IB,CE)local l=IB._getSortedEggTmplIdList(gp);if #l==0 then return nil end;if TE and TE~=""then for _,id in ipairs(l)do local c=CE.Tmpls[id];if c and c.Name:lower():find(TE:lower())then return id end end;return nil end;return l[1]end
local function runEgg()local ES,EV,IB,CE,VU=getEggSys();if not ES then eStat.Text="❌  Lỗi EggSystem!";return end;local gp=EV._GamePlayer;if not gp then return end;for sl=1,5 do pcall(function()if not gp.egg:IsHatchUnlocked(sl)then return end;local eid=gp.egg:GetHatchEggTmplId(sl);if eid then local tl=(gp.egg:GetHatchEggStartTick(sl)or 0)+CE.Tmpls[eid].HatchTime-os.time();if tl<=0 then eStat.Text="🐣  Slot "..sl.." nở!";VU.DoRequest(ES.ClientHatchTaken,sl);task.wait(0.5);local nid=getTgt(gp,IB,CE);if nid then eStat.Text="🥚  Slot "..sl.." → "..CE.Tmpls[nid].Name;VU.DoRequest(ES.ClientHatchStart,sl,nid)end else eStat.Text="⏳  Slot "..sl.." còn "..math.floor(tl).."s"end else local nid=getTgt(gp,IB,CE);if nid then eStat.Text="🥚  Đặt slot "..sl;VU.DoRequest(ES.ClientHatchStart,sl,nid)else eStat.Text="❌  Không có: "..TE end end end);task.wait(0.3)end end
task.spawn(function()task.wait(3);while task.wait(EI)do if AE then pcall(runEgg)end end end)
local CD2=nil;pcall(function()CD2=require(RS:FindFirstChild("CfgDungeon",true))end)
local DS2=nil;local VU2=nil
pcall(function()DS2=require(RS.CommonLogic.Arena.DungeonSystem)end);pcall(function()VU2=require(RS:FindFirstChild("ViewUtil",true))end)
local function ensureDS()if not DS2 then pcall(function()DS2=require(RS.CommonLogic.Arena.DungeonSystem)end)end;if not VU2 then pcall(function()VU2=require(RS:FindFirstChild("ViewUtil",true))end)end;return DS2~=nil and VU2~=nil end
local function findRiftPrompt(m)
    -- Ưu tiên: ActionText chứa từ liên quan đến vào dungeon
    local keywords={"enter","join","go","start","vào","bắt đầu","dungeon","rift"}
    for _,d in ipairs(m:GetDescendants())do
        if d:IsA("ProximityPrompt")then
            local txt=d.ActionText:lower()
            for _,kw in ipairs(keywords)do if txt:find(kw)then return d end end
        end
    end
    -- Fallback: trả về ProximityPrompt đầu tiên bất kỳ
    for _,d in ipairs(m:GetDescendants())do if d:IsA("ProximityPrompt")then return d end end
    return nil
end
local function checkEntered(id)if not DS2 then return false end;local ok,s=pcall(function()return DS2.DungeonDataSetEnteredSync end);return ok and s and s[id]==true end
local function getPortalForRift(arenaId)
    local area=workspace:FindFirstChild("Area");if not area then return nil,nil end
    if CD2 then local cfg=CD2.Tmpls and CD2.Tmpls[arenaId];if cfg and cfg.EnterModel then for _,isl in ipairs(area:GetChildren())do local ia=isl:FindFirstChild("Area");if not ia then continue end;local dg=ia:FindFirstChild("Dungeon");if not dg then continue end;for _,dm in ipairs(dg:GetChildren())do local portal=dm:FindFirstChild(cfg.EnterModel);if portal then local pos=nil;if portal:IsA("BasePart")then pos=portal.Position elseif portal.PrimaryPart then pos=portal.PrimaryPart.Position else for _,p in ipairs(portal:GetDescendants())do if p:IsA("BasePart")then pos=p.Position;break end end end;if pos then return portal,pos end end end end end end
    for _,isl in ipairs(area:GetChildren())do local ia=isl:FindFirstChild("Area");if not ia then continue end;local dg=ia:FindFirstChild("Dungeon");if not dg then continue end;for _,dm in ipairs(dg:GetChildren())do for _,child in ipairs(dm:GetChildren())do for _,desc in ipairs(child:GetDescendants())do if desc:IsA("ProximityPrompt")and desc.ActionText:lower():find("enter")then local pos=nil;if child:IsA("BasePart")then pos=child.Position elseif child.PrimaryPart then pos=child.PrimaryPart.Position else for _,p in ipairs(child:GetDescendants())do if p:IsA("BasePart")then pos=p.Position;break end end end;if pos then return child,pos end end end end end end
    return nil,nil
end
local function getBestRift()
    local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart");local candidates={}
    for _,rift in ipairs(RIFTS)do if selRifts[rift.id]then local _,pos=getPortalForRift(rift.id);if pos then table.insert(candidates,{rift=rift,pos=pos,dist=root and(root.Position-pos).Magnitude or 999})end end end
    if #candidates==0 then return nil,nil end
    if PRIOR=="near"then table.sort(candidates,function(a,b)return a.dist<b.dist end)elseif PRIOR=="high"then table.sort(candidates,function(a,b)return a.rift.diff>b.rift.diff end)else local i=math.random(1,#candidates);return candidates[i].rift,candidates[i].pos end
    return candidates[1].rift,candidates[1].pos
end
local function tpToPortal(arenaId)local portal,pos=getPortalForRift(arenaId);if not pos then return false,nil end;local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart");if not root then return false,nil end;root.CFrame=CFrame.new(pos+Vector3.new(0,3,0));return true,portal end
local function joinRift(arenaId)
    if not ensureDS() then rStat.Text="❌  Không load DS!"; return false end
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then rStat.Text="❌  Không có character!"; return false end

    -- ── PHASE 1: Tìm portal ──────────────────────────────────────────
    rStat.Text = "🔍  Tìm portal "..arenaId.."..."
    local portal, pos = getPortalForRift(arenaId)
    if not pos then rStat.Text = "❌  Không thấy portal!"; return false end
    print("[NC] Portal tìm thấy tại", pos)

    -- ── Scan TẤT CẢ ProximityPrompts quanh điểm (bán kính động) ────
    local function scanPrompts(center, radius)
        local found = {}
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                local part = v.Parent
                if part and part:IsA("BasePart") then
                    local d = (part.Position - center).Magnitude
                    if d <= radius then
                        table.insert(found, {prompt=v, dist=d, text=v.ActionText})
                    end
                end
            end
        end
        table.sort(found, function(a,b) return a.dist < b.dist end)
        return found
    end

    -- ── Fire danh sách prompts (bypass hold/LOS) ─────────────────────
    local function firePrompts(list)
        if type(fireproximityprompt) ~= "function" then
            print("[NC] ⚠️ fireproximityprompt không tồn tại!")
            return 0
        end
        local n = 0
        for _, p in ipairs(list) do
            pcall(fireproximityprompt, p.prompt)
            print(string.format("[NC] 🔥 Fire prompt: '%s' dist=%.1f", p.text, p.dist))
            n = n + 1
            task.wait(0.06)
        end
        return n
    end

    -- ── Tìm RemoteFunction/Event fallback (BossRoomEnter, DungeonEnter…) ─
    local enterRemotes = {}
    pcall(function()
        local keys = {"enter","boss","join","dungeon","arena","rift"}
        for _, v in ipairs(RS:GetDescendants()) do
            if v:IsA("RemoteFunction") or v:IsA("RemoteEvent") then
                local nm = v.Name:lower()
                for _, k in ipairs(keys) do
                    if nm:find(k) then
                        table.insert(enterRemotes, v)
                        print("[NC] 📡 Remote tìm thấy:", v.Name, v.ClassName)
                        break
                    end
                end
            end
        end
    end)

    -- ── Thử toàn bộ chiến lược remote join ──────────────────────────
    local function tryRemoteJoin()
        -- Chiến lược A: CreateTeam → StartDungeon (solo)
        local ok1 = pcall(function() VU2.DoRequest(DS2.ClientCreateTeam, arenaId) end)
        rStat.Text = "👥 CreateTeam="..(ok1 and "OK" or "fail")
        print("[NC] CreateTeam ok=", ok1)
        task.wait(0.7)
        local ok2 = pcall(function() VU2.DoRequest(DS2.ClientStartDungeon, arenaId) end)
        rStat.Text = "▶ Start="..(ok2 and "OK" or "fail")
        print("[NC] StartDungeon ok=", ok2)
        task.wait(1.3)
        if checkEntered(arenaId) then return true end

        -- Chiến lược B: JoinTeam → StartDungeon
        local ok3 = pcall(function() VU2.DoRequest(DS2.ClientJoinTeam, arenaId) end)
        rStat.Text = "🤝 JoinTeam="..(ok3 and "OK" or "fail")
        print("[NC] JoinTeam ok=", ok3)
        task.wait(0.7)
        local ok4 = pcall(function() VU2.DoRequest(DS2.ClientStartDungeon, arenaId) end)
        rStat.Text = "▶ Start2="..(ok4 and "OK" or "fail")
        task.wait(1.3)
        if checkEntered(arenaId) then return true end

        -- Chiến lược C: Remote fallback scan
        for _, rf in ipairs(enterRemotes) do
            if rf:IsA("RemoteFunction") then
                local ok, res = pcall(function() return rf:InvokeServer(arenaId) end)
                rStat.Text = "📡 "..rf.Name.."="..tostring(res)
                print("[NC] InvokeServer", rf.Name, "=>", res)
                task.wait(0.9)
                if checkEntered(arenaId) then return true end
            elseif rf:IsA("RemoteEvent") then
                pcall(function() rf:FireServer(arenaId) end)
                print("[NC] FireServer", rf.Name)
                task.wait(0.9)
                if checkEntered(arenaId) then return true end
            end
        end

        return checkEntered(arenaId)
    end

    -- ── Các offset TP để đứng đúng trigger zone ──────────────────────
    local offsets = {
        Vector3.new( 0, 3,  0),  -- center
        Vector3.new( 0, 3,  3),  -- trước portal
        Vector3.new( 3, 3,  0),  -- bên phải
        Vector3.new(-3, 3,  0),  -- bên trái
        Vector3.new( 0, 1,  0),  -- thấp hơn (dính sàn)
        Vector3.new( 0, 3, -3),  -- sau portal
    }

    -- ── Main retry loop (3 lần, mỗi lần đổi vị trí) ─────────────────
    for attempt = 1, 3 do
        local off = offsets[((attempt - 1) % #offsets) + 1]
        root.CFrame = CFrame.new(pos + off)
        task.wait(1.1)

        local dist = (root.Position - pos).Magnitude
        rStat.Text = string.format("📍 [%d/3] dist=%.1f | Scan...", attempt, dist)
        print(string.format("[NC] Attempt %d | TP offset %s | dist=%.1f", attempt, tostring(off), dist))

        -- Scan prompts (bán kính 25 studs)
        local prompts = scanPrompts(pos, 25)
        rStat.Text = string.format("🔑 [%d/3] %d prompt | Fire...", attempt, #prompts)
        print(string.format("[NC] Tìm thấy %d prompt trong bán kính 25", #prompts))

        -- Fire prompts từ workspace scan
        local fired = firePrompts(prompts)

        -- Fire thêm: trực tiếp từ portal model
        if portal then
            for _, desc in ipairs(portal:GetDescendants()) do
                if desc:IsA("ProximityPrompt") and type(fireproximityprompt) == "function" then
                    pcall(fireproximityprompt, desc)
                    print("[NC] 🔥 Fire từ portal model:", desc.ActionText)
                    task.wait(0.06)
                end
            end
        end

        task.wait(0.8)
        rStat.Text = string.format("🌀 [%d/3] Fired=%d | Join...", attempt, fired)

        if tryRemoteJoin() then
            rStat.Text = "✅  Vào Rift thành công!"
            print("[NC] ✅ joinRift SUCCESS arenaId=", arenaId)
            return true
        end

        rStat.Text = string.format("⚠️ [%d/3] Chưa vào, thử vị trí khác...", attempt)
        print(string.format("[NC] Attempt %d thất bại, tiếp tục...", attempt))
        task.wait(1.2)
    end

    rStat.Text = "❌  Không Join được Rift sau 3 lần!"
    print("[NC] ❌ joinRift FAILED arenaId=", arenaId)
    return false
end
local function waitRiftEnd()local done=false;local conn=player.PlayerGui.ChildAdded:Connect(function(c)if c.Name=="CatchDoGui"then done=true end end);local t=0;while not done and t<600 do task.wait(1);t=t+1 end;pcall(function()conn:Disconnect()end);return done end
local function riftLoop()
    if riftRunning then rStat.Text="⏳  Đang chạy...";return end
    if not next(selRifts)then rStat.Text="⚠️  Chọn Rift trước!";return end
    riftRunning=true;rStat.Text="🌀  Bắt đầu..."
    while riftRunning do
        local bestRift,_=getBestRift();if not bestRift then rStat.Text="🌐  Hop server...";doHop();task.wait(10);continue end
        rStat.Text="🎯  "..bestRift.name.." "..diffStar[bestRift.diff]
        if not joinRift(bestRift.id)then rStat.Text="❌  Thất bại! Hop...";task.wait(2);doHop();task.wait(10);continue end
        rStat.Text="⚔️  Trong Rift: "..bestRift.name
        if waitRiftEnd()then rStat.Text="🏆  Xong! Chờ "..RDEL.."s...";task.wait(RDEL)end
        if not riftRunning then break end
    end
    rStat.Text="⏹  Đã dừng";riftRunning=false
end
rBtn.MouseButton1Click:Connect(function()task.spawn(riftLoop)end)
task.spawn(function()task.wait(5);if FL then applyLag()end;if AR then task.wait(2);task.spawn(riftLoop)end end)
print("✅ NGUYEN CUTO v8.0 - Ready!")
end)
if not ok_init then warn("❌ NC Error: "..tostring(err_init))end