using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShowControllerHint : Task
{
    public GameObject rightControllerHint;
    public GameObject leftControllerHint;

    // have an early activated dialogue
    public override void StartTask()
    {
        base.StartTask();
        rightControllerHint.SetActive(true);
        leftControllerHint.SetActive(true);
        PlayerPrefs.SetString("ShowControllerHint", "Done");
    }

    public override void EndTask() // Can have status to check if boots are activated early
    {
        // Check status and Change dialogue piece to early activated dialogue
        rightControllerHint.SetActive(false);
        leftControllerHint.SetActive(false);
        base.EndTask();
    }
}
