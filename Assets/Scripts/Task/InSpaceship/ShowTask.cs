using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShowTask : Task
{
    public GameObject taskStep;
    public bool isStepShowed;

    public override void StartTask()
    {
        base.StartTask();
        if (!isStepShowed)
        {
            taskStep.SetActive(true);
        }
    }

    public override void EndTask()
    {
        base.EndTask();
        taskStep.GetComponent<ParticleSystem>().Stop();
    }

}
