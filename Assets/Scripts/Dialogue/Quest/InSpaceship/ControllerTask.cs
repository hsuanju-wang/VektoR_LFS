using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ControllerTask : Quest
{
    public bool isTaskStart = false;
    public bool isTaskEnd = false;

    public bool triggerEndTask = false;// For Debug without controller in Inspector

    public GameObject tutorialSample;
    public GameObject animationObj;
 /*   public override void StartQuest()
    {
        base.StartQuest();
        isTaskStart = true;
        if (animationObj != null)
        {
            animationObj.SetActive(true);
        }

        if (tutorialSample != null)
        {
            tutorialSample.SetActive(true);
        }

    }

    private void Update()
    {
        // For Debug
        if (triggerEndTask && !isTaskEnd)
        {
            EndQuest();
            isTaskEnd = true;
        }
    }
    public override void EndQuest()
    {
        base.EndQuest();
        isTaskEnd = true;
        if (animationObj != null)
        {
            animationObj.SetActive(false);
        }
    }*/


}
