using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ControllerTask : Task
{
    public bool isTaskStart = false;
    public bool isTaskEnd = false;
    public override void StartTask()
    {
        base.StartTask();
        isTaskStart = true;
    }
    public override void EndTask()
    {
        base.EndTask();
        isTaskEnd = true;

    }
}
