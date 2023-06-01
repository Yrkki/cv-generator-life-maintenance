# $taskPaths = "\", "\Jorich\Maintenance\", "\Jorich\Server\"
# Foreach ($taskPath IN $taskPaths)
# {
#     $currentTasks = Get-ScheduledTask -TaskPath $taskPath
#     Foreach ($currentTask IN $currentTasks)
#     {
#         If ($currentTask.Settings.Priority -lt 7)
#         {
#             $currentTask, $currentTask.Settings.Priority
#         }
#     }
# }

$taskNames = "LifeSpan℠ Autoscaler", "LifeSpan℠ Wrangler", "Patch CV Generator services", "Maintenance", "Monitor"
# $taskNames = "Monitor"
Foreach ($taskName IN $taskNames)
{
    $currentTask = Get-ScheduledTask -TaskName $taskName
    If ($currentTask.Settings.Priority -lt 7)
    {
        $currentTask.TaskPath, $currentTask, $currentTask.Settings.Priority
    }
}
Foreach ($taskName IN $taskNames)
{
    $currentTask = Get-ScheduledTask -TaskName $taskName
    If ($currentTask.Settings.Priority -lt 7)
    {
        $settings = New-ScheduledTaskSettingsSet
        $settings.Priority = 7
        Set-ScheduledTask -TaskPath $currentTask.TaskPath -TaskName $taskName -Trigger $currentTask.Triggers -Action $currentTask.Actions -Settings $settings
    }
}
Foreach ($taskName IN $taskNames)
{
    $currentTask = Get-ScheduledTask -TaskName $taskName
#     If ($currentTask.Settings.Priority -lt 7)
#     {
        $currentTask.TaskPath, $currentTask, $currentTask.Settings.Priority
#     }
}
# $currentTask = Get-ScheduledTask -TaskName $taskName 
# $settings = New-ScheduledTaskSettingsSet
# $settings.Priority = 4
# Set-ScheduledTask -TaskName $taskName -Trigger $currentTask.Triggers -Action $currentTask.Actions -Settings $settings -User "user" -Password "pass"
