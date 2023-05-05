using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShowControllerHint : Quest
{
    public GameObject dialoguePanel;
    public GameObject rightControllerHint;
    public GameObject errorSuit;

    public override void StartQuest()
    {
        base.StartQuest();
        dialoguePanel.SetActive(false);
        errorSuit.SetActive(true);
        rightControllerHint.SetActive(true);
        base.EndQuest();
    }
}
