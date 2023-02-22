using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShowTask : Task
{
    public GameObject taskStep;

    // Start is called before the first frame update
    public override void StartTask()
    {
        base.StartTask();
        taskStep.SetActive(true);
    }

    public override void EndTask()
    {
        base.EndTask();
        taskStep.SetActive(false);
    }

}
