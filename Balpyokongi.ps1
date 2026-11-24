Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$ErrorActionPreference = 'Stop'
$dataDir = Join-Path $env:LOCALAPPDATA 'Balpyokongi'
$dataFile = Join-Path $dataDir 'counts.json'
if (-not (Test-Path $dataDir)) { New-Item -ItemType Directory -Path $dataDir -Force | Out-Null }
$students = @(1..11) + @(31..42)
$counts = @{}
foreach ($id in $students) { $counts[[string]$id] = 0 }
if (Test-Path $dataFile) {
    try {
        $saved = Get-Content -LiteralPath $dataFile -Raw -Encoding UTF8 | ConvertFrom-Json
        foreach ($id in $students) {
            $key = [string]$id
            if ($null -ne $saved.$key -and [int]$saved.$key -ge 0) { $counts[$key] = [int]$saved.$key }
        }
    } catch { }
}

$pink = [System.Drawing.Color]::FromArgb(255, 238, 246)
$deepPink = [System.Drawing.Color]::FromArgb(220, 91, 145)
$softPink = [System.Drawing.Color]::FromArgb(255, 224, 237)
$ink = [System.Drawing.Color]::FromArgb(91, 63, 78)
$muted = [System.Drawing.Color]::FromArgb(145, 112, 129)
$white = [System.Drawing.Color]::White
$font = New-Object System.Drawing.Font('맑은 고딕', 10)
$fontBold = New-Object System.Drawing.Font('맑은 고딕', 10, [System.Drawing.FontStyle]::Bold)
$fontTitle = New-Object System.Drawing.Font('맑은 고딕', 22, [System.Drawing.FontStyle]::Bold)

function Save-Counts {
    $counts | ConvertTo-Json | Set-Content -LiteralPath $dataFile -Encoding UTF8
}
function Get-Total { $sum = 0; foreach ($n in $counts.Values) { $sum += [int]$n }; return $sum }

$form = New-Object System.Windows.Forms.Form
$form.Text = '발표콩이'
$form.Size = New-Object System.Drawing.Size(900, 760)
$form.MinimumSize = New-Object System.Drawing.Size(720, 600)
$form.StartPosition = 'CenterScreen'
$form.BackColor = $pink
$form.Font = $font
$form.ForeColor = $ink
$form.AutoScaleMode = 'Dpi'

$header = New-Object System.Windows.Forms.Panel
$header.Dock = 'Top'; $header.Height = 142; $header.BackColor = $pink
$form.Controls.Add($header)

$title = New-Object System.Windows.Forms.Label
$title.Text = '🐰 발표콩이'; $title.Font = $fontTitle; $title.ForeColor = $deepPink
$title.AutoSize = $true; $title.Location = New-Object System.Drawing.Point(24, 16)
$header.Controls.Add($title)
$subtitle = New-Object System.Windows.Forms.Label
$subtitle.Text = '오늘도 씩씩하게 발표해요!  ·  학생 1–11번, 31–42번'
$subtitle.AutoSize = $true; $subtitle.ForeColor = $muted
$subtitle.Location = New-Object System.Drawing.Point(29, 64)
$header.Controls.Add($subtitle)
$summary = New-Object System.Windows.Forms.Label
$summary.Text = '전체 발표  ' + (Get-Total) + '회'
$summary.Font = $fontBold; $summary.ForeColor = $deepPink; $summary.AutoSize = $true
$summary.Location = New-Object System.Drawing.Point(29, 96)
$header.Controls.Add($summary)

$exitButton = New-Object System.Windows.Forms.Button
$exitButton.Text = '완전히 종료'; $exitButton.Size = New-Object System.Drawing.Size(116, 38)
$exitButton.Location = New-Object System.Drawing.Point(748, 24)
$exitButton.Anchor = 'Top,Right'; $exitButton.FlatStyle = 'Flat'
$exitButton.FlatAppearance.BorderSize = 0; $exitButton.BackColor = $deepPink
$exitButton.ForeColor = $white; $exitButton.Font = $fontBold
$header.Controls.Add($exitButton)

$flow = New-Object System.Windows.Forms.FlowLayoutPanel
$flow.Dock = 'Fill'; $flow.AutoScroll = $true; $flow.WrapContents = $true
$flow.FlowDirection = 'LeftToRight'; $flow.Padding = New-Object System.Windows.Forms.Padding(18, 8, 18, 12)
$flow.BackColor = $pink
$form.Controls.Add($flow)
$flow.BringToFront()

$cards = @{}
foreach ($id in $students) {
    $card = New-Object System.Windows.Forms.Panel
    $card.Size = New-Object System.Drawing.Size(264, 126)
    $card.Margin = New-Object System.Windows.Forms.Padding(8)
    $card.BackColor = $white
    $card.BorderStyle = 'FixedSingle'
    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = "학생 $id번"; $lbl.Font = $fontBold; $lbl.ForeColor = $ink
    $lbl.AutoSize = $true; $lbl.Location = New-Object System.Drawing.Point(16, 14)
    $card.Controls.Add($lbl)
    $number = New-Object System.Windows.Forms.Label
    $number.Text = [string]$counts[[string]$id] + '회'; $number.Font = New-Object System.Drawing.Font('맑은 고딕', 20, [System.Drawing.FontStyle]::Bold)
    $number.ForeColor = $deepPink; $number.AutoSize = $true; $number.Location = New-Object System.Drawing.Point(16, 48)
    $card.Controls.Add($number)
    $minus = New-Object System.Windows.Forms.Button
    $minus.Text = '−'; $minus.Size = New-Object System.Drawing.Size(44, 38); $minus.Location = New-Object System.Drawing.Point(138, 70)
    $minus.FlatStyle = 'Flat'; $minus.FlatAppearance.BorderSize = 0; $minus.BackColor = $softPink
    $minus.ForeColor = $deepPink; $minus.Font = New-Object System.Drawing.Font('맑은 고딕', 16, [System.Drawing.FontStyle]::Bold)
    $plus = New-Object System.Windows.Forms.Button
    $plus.Text = '+  발표'; $plus.Size = New-Object System.Drawing.Size(78, 38); $plus.Location = New-Object System.Drawing.Point(188, 70)
    $plus.FlatStyle = 'Flat'; $plus.FlatAppearance.BorderSize = 0; $plus.BackColor = $deepPink
    $plus.ForeColor = $white; $plus.Font = New-Object System.Drawing.Font('맑은 고딕', 9, [System.Drawing.FontStyle]::Bold)
    $card.Controls.Add($minus); $card.Controls.Add($plus)
    $cards[[string]$id] = $number
    $sid = [string]$id
    $plus.Add_Click({
        $script:counts[$sid] = [int]$script:counts[$sid] + 1
        $script:cards[$sid].Text = [string]$script:counts[$sid] + '회'
        $script:summary.Text = '전체 발표  ' + (Get-Total) + '회'
        Save-Counts
    }.GetNewClosure())
    $minus.Add_Click({
        if ([int]$script:counts[$sid] -gt 0) {
            $script:counts[$sid] = [int]$script:counts[$sid] - 1
            $script:cards[$sid].Text = [string]$script:counts[$sid] + '회'
            $script:summary.Text = '전체 발표  ' + (Get-Total) + '회'
            Save-Counts
        }
    }.GetNewClosure())
    $flow.Controls.Add($card)
}

$notify = New-Object System.Windows.Forms.NotifyIcon
$notify.Text = '발표콩이 · 발표 횟수 기록'
$notify.Icon = [System.Drawing.SystemIcons]::Application
$menu = New-Object System.Windows.Forms.ContextMenuStrip
$showItem = $menu.Items.Add('창 열기')
$exitItem = $menu.Items.Add('완전히 종료')
$notify.ContextMenuStrip = $menu
$notify.Add_DoubleClick({ $form.Show(); $form.WindowState = 'Normal'; $form.Activate() })
$showItem.Add_Click({ $form.Show(); $form.WindowState = 'Normal'; $form.Activate() })
$exitItem.Add_Click({ $script:allowExit = $true; $form.Close() })
$allowExit = $false
$form.Add_FormClosing({
    if (-not $script:allowExit) {
        $_.Cancel = $true
        $form.Hide()
        $notify.Visible = $true
        $notify.ShowBalloonTip(1800, '발표콩이가 기다릴게요 🐰', '시스템 트레이에서 다시 열 수 있어요.', [System.Windows.Forms.ToolTipIcon]::Info)
    }
})
$exitButton.Add_Click({ $script:allowExit = $true; $notify.Visible = $false; $notify.Dispose(); $form.Close() })
$form.Add_Shown({ $notify.Visible = $true })
$form.Add_FormClosed({ Save-Counts; $notify.Visible = $false; $notify.Dispose() })
[void]$form.ShowDialog()
