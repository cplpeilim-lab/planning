@echo off
REM Starts the Planner at http://localhost:8080 (needed for Google Calendar sign-in).
REM Keep this window open while you use the planner. Close it to stop.
cd /d "%~dp0"
title Planner - http://localhost:8080
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$root = (Get-Location).Path;" ^
  "$l = New-Object Net.HttpListener; $l.Prefixes.Add('http://localhost:8080/');" ^
  "try { $l.Start() } catch { Write-Host 'Port 8080 is busy - the planner may already be running.'; Start-Process 'http://localhost:8080/planner.html'; Start-Sleep 3; exit };" ^
  "Write-Host 'Planner running at http://localhost:8080/planner.html'; Write-Host 'Keep this window open. Close it to stop.';" ^
  "Start-Process 'http://localhost:8080/planner.html';" ^
  "while ($l.IsListening) { $c = $l.GetContext(); $p = [Uri]::UnescapeDataString($c.Request.Url.AbsolutePath.TrimStart('/')); if ($p -eq '') { $p = 'planner.html' };" ^
  "  $f = [IO.Path]::GetFullPath((Join-Path $root $p));" ^
  "  if ($f.StartsWith($root) -and (Test-Path $f -PathType Leaf)) { $b = [IO.File]::ReadAllBytes($f); if ($f -like '*.html') { $c.Response.ContentType = 'text/html; charset=utf-8' }; $c.Response.OutputStream.Write($b, 0, $b.Length) } else { $c.Response.StatusCode = 404 };" ^
  "  $c.Response.Close() }"
