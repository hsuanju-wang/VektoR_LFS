using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShowTask : Quest
{
    public GameObject taskStep;
    public bool isStepShowed;

    public override void StartQuest()
    {
        base.StartQuest();
        if (!isStepShowed)
        {
            taskStep.SetActive(true);
        }
    }

    public override void EndQuest()
    {
        base.EndQuest();
        taskStep.GetComponent<ParticleSystem>().Stop();
    }

}
