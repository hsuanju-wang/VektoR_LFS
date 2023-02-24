using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ControllerTask : Task
{
    public bool isTaskStart = false;
    public bool isTaskEnd = false;

    public GameObject animationObj;
    public override void StartTask()
    {
        base.StartTask();
        isTaskStart = true;
        if (animationObj != null)
        {
            animationObj.SetActive(true);
        }
        
    }
    public override void EndTask()
    {
        base.EndTask();
        isTaskEnd = true;

    }
}
