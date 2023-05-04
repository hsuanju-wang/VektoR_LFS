using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TriggerAnim : Quest
{
    public bool isStarted = false;
    public bool isEnd = false;

    public bool triggerEndTask = false;// For Debug without controller in Inspector

    public GameObject animationObj;
    public override void StartQuest()
    {
        base.StartQuest();
        isStarted = true;
        if (animationObj != null)
        {
            animationObj.SetActive(true);
        }
    }

    private void Update()
    {
        // For Debug
        if (triggerEndTask && !isEnd)
        {
            EndQuest();
            isEnd = true;
        }
    }
    public override void EndQuest()
    {
        base.EndQuest();
        isEnd = true;
        if (animationObj != null)
        {
            animationObj.SetActive(false);
        }
    }
}
